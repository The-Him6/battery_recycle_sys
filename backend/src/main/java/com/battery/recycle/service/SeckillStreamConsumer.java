package com.battery.recycle.service;

import com.battery.recycle.constant.RedisConstants;
import com.battery.recycle.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.data.redis.connection.stream.Consumer;
import org.springframework.data.redis.connection.stream.MapRecord;
import org.springframework.data.redis.connection.stream.ReadOffset;
import org.springframework.data.redis.connection.stream.StreamOffset;
import org.springframework.data.redis.connection.stream.StreamReadOptions;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.StreamOperations;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.annotation.Resource;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * 秒杀Stream消费者
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "seckill.mq.type", havingValue = "redis-stream")
public class SeckillStreamConsumer {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Resource
    private RedissonClient redissonClient;

    @Resource
    private SeckillActivityService seckillActivityService;

    /**
     * 单线程消费秒杀消息，避免本地并发过高，跨进程并发由Redisson用户锁处理
     */
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    /**
     * 当前消费者名称
     */
    private final String consumerName = "c-" + UUID.randomUUID();

    /**
     * 应用启动后创建消费组并开始消费Stream
     */
    @PostConstruct
    public void init() {
        createConsumerGroup();
        executor.submit(this::consume);
    }

    /**
     * 应用关闭时停止消费线程
     */
    @PreDestroy
    public void destroy() {
        executor.shutdownNow();
    }

    /**
     * 创建Redis Stream消费组，已存在时忽略异常
     */
    private void createConsumerGroup() {
        try {
            StreamOperations<String, Object, Object> ops = stringRedisTemplate.opsForStream();
            if (!Boolean.TRUE.equals(stringRedisTemplate.hasKey(RedisConstants.SECKILL_STREAM_KEY))) {
                ops.add(RedisConstants.SECKILL_STREAM_KEY, Map.of("init", "1"));
            }
            ops.createGroup(RedisConstants.SECKILL_STREAM_KEY, ReadOffset.latest(), RedisConstants.SECKILL_CONSUMER_GROUP);
        } catch (Exception e) {
            log.debug("秒杀消费组已存在或创建失败，继续启动消费者：{}", e.getMessage());
        }
    }

    /**
     * 循环消费新消息
     */
    private void consume() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                List<MapRecord<String, Object, Object>> records = stringRedisTemplate.opsForStream().read(
                        Consumer.from(RedisConstants.SECKILL_CONSUMER_GROUP, consumerName),
                        StreamReadOptions.empty().count(1).block(Duration.ofSeconds(2)),
                        StreamOffset.create(RedisConstants.SECKILL_STREAM_KEY, ReadOffset.lastConsumed())
                );
                if (records == null || records.isEmpty()) {
                    continue;
                }
                MapRecord<String, Object, Object> record = records.get(0);
                handleRecord(record);
                stringRedisTemplate.opsForStream().acknowledge(
                        RedisConstants.SECKILL_STREAM_KEY,
                        RedisConstants.SECKILL_CONSUMER_GROUP,
                        record.getId()
                );
            } catch (Exception e) {
                log.error("秒杀消息消费异常", e);
                handlePendingList();
            }
        }
    }

    /**
     * 处理pending-list中未ACK的异常消息
     */
    private void handlePendingList() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                List<MapRecord<String, Object, Object>> records = stringRedisTemplate.opsForStream().read(
                        Consumer.from(RedisConstants.SECKILL_CONSUMER_GROUP, consumerName),
                        StreamReadOptions.empty().count(1),
                        StreamOffset.create(RedisConstants.SECKILL_STREAM_KEY, ReadOffset.from("0"))
                );
                if (records == null || records.isEmpty()) {
                    break;
                }
                MapRecord<String, Object, Object> record = records.get(0);
                handleRecord(record);
                stringRedisTemplate.opsForStream().acknowledge(
                        RedisConstants.SECKILL_STREAM_KEY,
                        RedisConstants.SECKILL_CONSUMER_GROUP,
                        record.getId()
                );
            } catch (Exception e) {
                log.error("处理秒杀pending-list异常", e);
                sleepQuietly();
            }
        }
    }

    /**
     * 处理单条秒杀消息
     */
    private void handleRecord(MapRecord<String, Object, Object> record) {
        Map<Object, Object> value = record.getValue();
        Long activityId = Long.valueOf(value.get("activityId").toString());
        Long userId = Long.valueOf(value.get("userId").toString());
        RLock lock = redissonClient.getLock(RedisConstants.LOCK_SECKILL_USER_KEY + userId);
        boolean locked = false;
        try {
            locked = lock.tryLock(1, 10, TimeUnit.SECONDS);
            if (!locked) {
                throw new IllegalStateException("用户正在处理秒杀请求");
            }
            seckillActivityService.handleSeckillMessage(activityId, userId);
        } catch (BusinessException e) {
            // 积分不足、库存不足等业务失败需要补偿Redis，并让外层ACK，避免pending-list反复重试
            log.warn("秒杀业务处理失败，准备补偿Redis：activityId={}, userId={}, reason={}", activityId, userId, e.getMessage());
            seckillActivityService.compensateRedis(activityId, userId);
        } catch (Exception e) {
            // 数据库或网络等系统异常交给pending-list重试，不立即补偿，避免重试期间库存被提前释放
            throw new IllegalStateException(e);
        } finally {
            if (locked && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    /**
     * pending-list重试失败时短暂休眠，避免空转
     */
    private void sleepQuietly() {
        try {
            Thread.sleep(50);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
