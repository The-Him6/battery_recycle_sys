# 废电池回收与积分兑换系统

一个适合 Java Web 初学者学习的前后端分离项目，包含用户登录、电池回收下单、积分累计、积分商城兑换、后台管理、数据统计、系统公告和秒杀优惠券等功能。

项目从传统的 `Spring Boot + MyBatis + MySQL` 业务系统逐步升级，引入了 Redis、Redisson、RabbitMQ、Lua 脚本、ThreadLocal 用户上下文等内容，适合用来学习完整业务开发和常见后端优化思路。

## 技术栈

### 后端

- Java 17
- Spring Boot 3.2.5
- MyBatis
- MySQL
- Redis
- Redisson
- RabbitMQ
- JWT
- Maven

### 前端

- Vue 3
- Vue Router
- Pinia
- Axios
- Element Plus
- ECharts
- Vite

## 项目功能

### 用户端

- 用户注册、登录、退出登录
- 用户信息维护、头像上传、修改密码
- 电池回收下单
- 我的回收订单
- 积分查询
- 积分商城商品浏览
- 普通积分兑换商品
- 秒杀优惠券抢券
- 我的秒杀券
- 使用秒杀券兑换商品
- 系统公告弹窗与已读记录

### 管理端

- 用户管理
- 电池类型管理
- 回收订单管理
- 积分商品管理
- 兑换记录管理
- 数据概览
- 回收数据统计
- 秒杀活动管理
- 系统公告管理

## 项目亮点

### 1. JWT + Redis 登录态

登录成功后生成带 `jti` 的 JWT，并将 `jti` 写入 Redis。

每次请求会同时校验：

- JWT 是否有效
- Redis 中登录态是否存在

这样可以实现：

- 退出登录
- 主动失效
- Redis 登录态 1 小时滑动过期

### 2. ThreadLocal 用户上下文

登录拦截器校验通过后，会将当前登录用户信息写入 ThreadLocal。

业务代码中可以直接通过工具类获取当前用户：

```java
Long userId = AuthUtil.getUserId();
Integer role = AuthUtil.getRole();
AuthUtil.requireAdmin();
```

请求结束后会在拦截器中清理 ThreadLocal，避免线程复用导致用户信息串请求。

### 3. Redis 缓存封装

项目中整理了 Redis 缓存查询逻辑，复用缓存空值和互斥锁重建流程。

主要用于：

- 商品详情缓存
- 秒杀活动缓存

解决的问题：

- 缓存穿透：缓存空值
- 缓存击穿：Redisson 互斥锁

### 4. 秒杀优惠券模块

管理员可以创建秒杀活动，配置：

- 活动开始时间
- 活动结束时间
- 优惠券生效时间
- 优惠券过期时间
- 库存
- 消耗积分

活动上架时会把库存预热到 Redis。

用户抢券时使用 Lua 脚本在 Redis 中原子完成：

- 判断库存是否充足
- 判断用户是否重复抢券
- 预扣库存
- 记录已抢用户

### 5. RabbitMQ 异步发券

Redis 预扣成功后，后端发送 RabbitMQ 消息。

消费者异步完成：

- 扣减用户积分
- 更新活动已售数量
- 生成用户秒杀券

项目配置了：

- 生产者确认
- 手动 ACK
- 重试队列
- 死信队列
- Redis 补偿逻辑

适合学习 RabbitMQ 在单体项目中的异步削峰用法。

### 6. 管理员数据概览优化

管理员首页原本需要拉取用户、订单全量列表后由前端计算数量。

优化后改为后端聚合统计接口，只返回页面需要的数字，减少无效数据传输。

## 目录结构

```text
.
├── backend                         后端 Spring Boot 项目
│   ├── src/main/java/com/battery/recycle
│   │   ├── annotation              自定义注解
│   │   ├── aspect                  AOP 切面
│   │   ├── common                  通用返回结果、分页对象
│   │   ├── config                  配置类
│   │   ├── constant                常量类
│   │   ├── controller              控制层
│   │   ├── dto                     请求参数对象
│   │   ├── entity                  实体类
│   │   ├── exception               异常处理
│   │   ├── interceptor             登录拦截器
│   │   ├── mapper                  MyBatis Mapper 接口
│   │   ├── mq                      RabbitMQ 消息、生产者、消费者
│   │   ├── service                 业务层
│   │   ├── util                    工具类
│   │   └── vo                      返回视图对象
│   └── src/main/resources
│       ├── mapper                  MyBatis XML
│       ├── application.yml         后端配置
│       └── seckill_coupon.lua      秒杀 Lua 脚本
├── frontend                        前端 Vue 项目
│   ├── src/api                     接口封装
│   ├── src/layouts                 布局组件
│   ├── src/router                  路由
│   ├── src/utils                   Axios 封装
│   └── src/views                   页面
├── battery_recycle_system_1.sql    数据库脚本
└── README.md
```

## 环境要求

- JDK 17
- Maven 3.8+
- Node.js 18+
- MySQL 8.x
- Redis
- RabbitMQ

如果只是学习基础 CRUD，也可以先重点看 MySQL、Spring Boot、MyBatis 部分。  
如果要完整运行秒杀和登录功能，Redis 必须启动；如果要完整运行秒杀异步发券链路，RabbitMQ 也需要启动。

## 快速启动

### 1. 克隆项目

```bash
git clone https://github.com/The-Him6/battry_recycle-sys.git
cd battry_recycle-sys
```

### 2. 初始化数据库

创建数据库：

```sql
CREATE DATABASE battery_recycle_system_1 DEFAULT CHARACTER SET utf8mb4;
```

导入 SQL：

```bash
mysql -uroot -p battery_recycle_system_1 < battery_recycle_system_1.sql
```

### 3. 修改后端配置

配置文件位置：

```text
backend/src/main/resources/application.yml
```

需要根据本地环境修改：

- MySQL 地址、账号、密码
- Redis 地址、密码
- RabbitMQ 地址、账号、密码、虚拟主机
- OSS 配置

建议使用环境变量覆盖配置，避免把本地密码提交到仓库。

示例：

```bash
MYSQL_PASSWORD=你的MySQL密码
REDIS_HOST=你的Redis地址
REDIS_PASSWORD=你的Redis密码
RABBITMQ_HOST=你的RabbitMQ地址
RABBITMQ_USERNAME=你的RabbitMQ账号
RABBITMQ_PASSWORD=你的RabbitMQ密码
RABBITMQ_VIRTUAL_HOST=你的RabbitMQ虚拟主机
```

### 4. 启动后端

进入后端目录：

```bash
cd backend
```

编译：

```bash
mvn clean compile
```

启动：

```bash
mvn spring-boot:run
```

后端默认地址：

```text
http://localhost:8081/api
```

### 5. 启动前端

进入前端目录：

```bash
cd frontend
```

安装依赖：

```bash
npm install
```

启动开发环境：

```bash
npm run dev
```

前端默认地址：

```text
http://localhost:5173
```

前端开发环境已配置代理：

```text
/api -> http://localhost:8081
```

## 默认账号

数据库脚本中包含一个管理员账号：

```text
用户名：admin
密码：123456
```

如果登录失败，请检查数据库脚本是否完整导入。

## 适合初学者的学习路线

建议不要一上来就看 Redis 和 RabbitMQ，可以按下面顺序学习：

### 第一步：基础业务 CRUD

先看这些模块：

- 用户管理
- 电池类型管理
- 商品管理
- 回收订单管理

推荐阅读顺序：

```text
Controller -> Service -> Mapper -> Mapper.xml -> 数据库表
```

### 第二步：登录认证

重点文件：

```text
AuthController
AuthService
JwtUtil
LoginStateService
JwtInterceptor
UserHolder
AuthUtil
```

需要理解：

- JWT 怎么生成
- jti 是什么
- Redis 登录态怎么保存
- 退出登录为什么能让 Token 失效
- ThreadLocal 为什么要 remove

### 第三步：Redis 缓存

重点文件：

```text
CacheClient
RedissonConfig
ExchangeProductService
SeckillActivityService
```

需要理解：

- 缓存穿透
- 缓存击穿
- 缓存空值
- Redisson 互斥锁

### 第四步：秒杀 Lua

重点文件：

```text
seckill_coupon.lua
SeckillActivityService
RedisConstants
```

需要理解：

- 为什么库存要预热到 Redis
- Lua 为什么能保证原子性
- 如何防止超卖
- 如何防止同一用户重复抢券

### 第五步：RabbitMQ 异步发券

重点文件：

```text
RabbitMqConstants
RabbitMqConfig
SeckillCouponMessage
SeckillCouponProducer
SeckillCouponConsumer
SeckillActivityService.handleSeckillMessage
```

需要理解：

- 为什么单体项目也可以用 RabbitMQ
- 生产者确认解决什么问题
- 手动 ACK 为什么重要
- 重试队列怎么工作
- 死信队列有什么作用
- 消费失败后为什么要补偿 Redis

## 秒杀核心流程

```text
用户点击抢券
    |
    v
后端校验活动状态、时间、用户积分
    |
    v
执行 Redis Lua 脚本
    |
    |-- 库存不足：返回失败
    |-- 重复抢券：返回失败
    |-- 成功：Redis 预扣库存并记录用户
    v
发送 RabbitMQ 消息
    |
    v
消费者异步处理
    |
    |-- 扣减积分
    |-- 更新活动已售数量
    |-- 生成用户秒杀券
    v
手动 ACK
```

## 常见问题

### 1. 后端启动失败：8081 端口被占用

查看端口占用：

```bash
netstat -ano | findstr 8081
```

结束进程，或者修改：

```yaml
server:
  port: 8082
```

### 2. Redis 连接失败

检查：

- Redis 是否启动
- host 是否正确
- port 是否正确
- password 是否正确

### 3. RabbitMQ 连接失败

检查：

- RabbitMQ 是否启动
- 5672 端口是否可访问
- 账号密码是否正确
- virtual-host 是否存在
- 当前账号是否有该 virtual-host 的权限

### 4. 前端请求 404

检查：

- 后端是否启动在 8081
- 前端代理是否生效
- 请求路径是否以 `/api` 开头

## 说明

这个项目适合作为 Java Web 初学者的综合练习项目：

- 基础部分可以学习 Spring Boot + MyBatis + MySQL 分层开发。
- 进阶部分可以学习 Redis 缓存、Lua 秒杀、RabbitMQ 异步削峰。
