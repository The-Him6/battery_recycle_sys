package com.battery.recycle.mq.consumer;

import com.battery.recycle.constant.RabbitMqConstants;
import com.battery.recycle.constant.RedisConstants;
import com.battery.recycle.exception.BusinessException;
import com.battery.recycle.mq.message.SeckillCouponMessage;
import com.battery.recycle.service.SeckillActivityService;
import com.rabbitmq.client.Channel;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import jakarta.annotation.Resource;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * 秒杀发券RabbitMQ消费者。
 */
@Slf4j
@Component
@ConditionalOnProperty(name = "seckill.mq.type", havingValue = "rabbitmq", matchIfMissing = true)
public class SeckillCouponConsumer {

    @Resource
    private RedissonClient redissonClient;

    @Resource
    private RabbitTemplate rabbitTemplate;

    @Resource
    private SeckillActivityService seckillActivityService;

    /**
     * 消费秒杀发券消息，成功后手动ACK，系统异常进入重试或死信。
     */
    @RabbitListener(queues = RabbitMqConstants.SECKILL_COUPON_QUEUE)
    public void handleSeckillCouponMessage(SeckillCouponMessage payload, Message message, Channel channel)
            throws IOException {
        long deliveryTag = message.getMessageProperties().getDeliveryTag();
        try {
            handleBusiness(payload);
            channel.basicAck(deliveryTag, false);
        } catch (BusinessException e) {
            // 积分不足等业务失败不再重试，直接补偿Redis预扣库存并ACK。
            log.warn("秒杀发券业务失败，准备补偿Redis：payload={}, reason={}", payload, e.getMessage());
            seckillActivityService.compensateRedis(payload.getActivityId(), payload.getUserId());
            channel.basicAck(deliveryTag, false);
        } catch (Exception e) {
            handleSystemException(payload, message, channel, deliveryTag, e);
        }
    }

    /**
     * 加用户级分布式锁后执行发券事务。
     */
    private void handleBusiness(SeckillCouponMessage payload) throws InterruptedException {
        RLock lock = redissonClient.getLock(RedisConstants.LOCK_SECKILL_USER_KEY + payload.getUserId());
        boolean locked = false;
        try {
            locked = lock.tryLock(1, 10, TimeUnit.SECONDS);
            if (!locked) {
                throw new IllegalStateException("用户秒杀发券正在处理中");
            }
            seckillActivityService.handleSeckillMessage(payload.getActivityId(), payload.getUserId());
        } finally {
            if (locked && lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }

    /**
     * 系统异常先重试，超过重试上限后进入死信队列并补偿Redis。
     */
    private void handleSystemException(SeckillCouponMessage payload, Message message, Channel channel,
            long deliveryTag, Exception e) throws IOException {
        Long retryCount = getRetryCount(message);
        if (retryCount >= RabbitMqConstants.SECKILL_MAX_RETRY_COUNT) {
            log.error("秒杀发券超过最大重试次数，进入死信队列并补偿Redis：payload={}", payload, e);
            seckillActivityService.compensateRedis(payload.getActivityId(), payload.getUserId());
            rabbitTemplate.convertAndSend(
                    RabbitMqConstants.SECKILL_DEAD_EXCHANGE,
                    RabbitMqConstants.SECKILL_DEAD_ROUTING_KEY,
                    payload
            );
            channel.basicAck(deliveryTag, false);
            return;
        }

        log.warn("秒杀发券系统异常，准备进入重试队列：payload={}, retryCount={}", payload, retryCount, e);
        channel.basicNack(deliveryTag, false, false);
    }

    /**
     * 从RabbitMQ的x-death头中读取主队列失败次数。
     */
    @SuppressWarnings("unchecked")
    private Long getRetryCount(Message message) {
        Object xDeathHeader = message.getMessageProperties().getHeaders().get("x-death");
        if (!(xDeathHeader instanceof List<?> xDeathList)) {
            return 0L;
        }
        for (Object item : xDeathList) {
            if (!(item instanceof Map<?, ?> xDeath)) {
                continue;
            }
            Object queue = xDeath.get("queue");
            Object count = xDeath.get("count");
            if (RabbitMqConstants.SECKILL_COUPON_QUEUE.equals(queue) && count instanceof Long retryCount) {
                return retryCount;
            }
        }
        return 0L;
    }
}
