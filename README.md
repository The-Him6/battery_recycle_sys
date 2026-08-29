# 绿源回收积分平台

基于 Spring Boot 3 + Vue 3 构建的废电池回收积分管理系统，支持用户提交回收订单、累计环保积分、兑换绿色商品及秒杀优惠券等功能。

## 技术栈

### 后端

| 技术 | 说明 |
|---|---|
| **Spring Boot 3.2** | 基础框架，JDK 17 |
| **MyBatis + PageHelper** | 数据持久化与分页 |
| **MySQL 8.0** | 关系型数据库 |
| **Redis** | 登录态缓存、秒杀库存预扣 |
| **RabbitMQ** | 秒杀异步发券消息队列 |
| **Redisson** | 分布式锁（秒杀防重） |
| **JWT (jjwt 0.12)** | 登录认证 Token |
| **阿里云 OSS** | 头像/商品图片/电池图标存储 |
| **Knife4j** | OpenAPI 3 接口文档与在线测试 |
| **Lombok** | 代码简化 |

### 前端

| 技术 | 说明 |
|---|---|
| **Vue 3** | 前端框架 |
| **Vite 5** | 构建工具 |
| **Element Plus** | UI 组件库 |
| **ECharts 5** | 数据统计图表 |
| **Axios** | HTTP 请求 |
| **Pinia** | 状态管理 |
| **Vue Router 4** | 路由管理 |

## 环境要求

| 组件 | 版本要求 | 备注 |
|---|---|---|
| **JDK** | 17+ | 后端运行环境 |
| **Node.js** | 18+ | 前端构建运行 |
| **MySQL** | 8.0+ | 数据库 |
| **Redis** | 6.x+ | 缓存与秒杀 |
| **RabbitMQ** | 3.x+ | 消息队列 |
| **Maven** | 3.8+ | 后端构建 |

## 快速启动

### 1. 数据库

```sql
source backend/db/battery_recycle_system_1.sql
```

### 2. 后端

```bash
cd backend
mvn spring-boot:run
```

默认端口 `8080`，上下文路径 `/api`。

### 3. 前端

```bash
cd frontend
npm install
npm run dev
```

默认端口 `3000`，开发环境 `/api` 请求代理到 `localhost:8080`。

## 配置说明

所有配置项通过环境变量注入，默认值适用于本地开发：

| 环境变量 | 默认值 | 说明 |
|---|---|---|
| `MYSQL_HOST` | localhost | 数据库地址 |
| `MYSQL_PORT` | 3306 | 数据库端口 |
| `MYSQL_DATABASE` | battery_recycle_system_1 | 数据库名 |
| `MYSQL_USERNAME` | root | 数据库用户名 |
| `MYSQL_PASSWORD` | 123456 | 数据库密码 |
| `REDIS_HOST` | 192.168.150.102 | Redis 地址 |
| `REDIS_PORT` | 6379 | Redis 端口 |
| `REDIS_PASSWORD` | 123456 | Redis 密码 |
| `RABBITMQ_HOST` | 192.168.150.102 | MQ 地址 |
| `RABBITMQ_PORT` | 5672 | MQ 端口 |
| `RABBITMQ_USERNAME` | thehim | MQ 用户名 |
| `RABBITMQ_PASSWORD` | 123 | MQ 密码 |
| `RABBITMQ_VIRTUAL_HOST` | /thehim | MQ 虚拟主机 |
| `OSS_ENDPOINT` | https://oss-cn-beijing.aliyuncs.com | OSS 地域节点 |
| `OSS_ACCESS_KEY_ID` | - | OSS 访问 Key |
| `OSS_ACCESS_KEY_SECRET` | - | OSS 访问密钥 |
| `OSS_BUCKET_NAME` | - | OSS 存储桶名 |

## 接口文档

启动后端后访问：
- Knife4j（推荐）：`http://localhost:8080/api/doc.html`
- Swagger UI：`http://localhost:8080/api/swagger-ui.html`

## 默认账号

- 管理员：`admin` / `123456`（数据库脚本已预设）
- 普通用户：注册页面自行注册
