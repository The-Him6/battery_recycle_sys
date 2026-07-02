# 电池回收与积分兑换平台

一个基于 Spring Boot + Vue3 的前后端分离废电池回收积分激励平台。系统包含用户端和管理端，支持用户注册登录、电池回收下单、积分累计、积分商城兑换、秒杀优惠券、系统公告、后台管理和数据统计等功能。

## 技术栈

后端：

- Jdk 17
- Spring Boot 3.2.5
- MyBatis
- MySQL
- Redis
- Redisson
- RabbitMQ
- JWT
- Maven

前端：

- Vue 3
- Vue Router
- Pinia
- Axios
- Element Plus
- ECharts
- Vite

## 功能模块

用户端：

- 用户注册、登录、退出登录
- 用户信息维护、头像上传、修改密码
- 电池回收下单和回收订单查询
- 积分查询和积分商品兑换
- 秒杀优惠券抢券、查询和使用
- 系统公告查看和已读记录

管理端：

- 用户管理
- 电池类型管理
- 回收订单管理
- 积分商品管理
- 兑换记录管理
- 秒杀活动管理
- 系统公告管理
- 数据概览和回收数据统计

## 核心流程

### 登录认证流程

用户登录成功后，后端生成带 `jti` 的 JWT，并将登录态写入 Redis。后续请求会同时校验 JWT 有效性和 Redis 登录态，实现退出登录、主动失效和登录态滑动过期。

### 积分兑换流程

用户提交兑换请求后，系统校验商品状态、库存和用户积分，扣减积分并生成兑换记录。后台可以维护积分商品和查询兑换记录。

### 秒杀抢券流程

管理员上架秒杀活动时，系统将活动库存预热到 Redis。用户抢券时，后端先校验活动状态和用户资格，再通过 Lua 脚本在 Redis 中原子完成库存校验、重复抢券判断和库存预扣。预扣成功后，系统通过 RabbitMQ 异步完成扣减积分、更新已售数量和生成用户秒杀券。

## 环境要求

- JDK 17
- Maven 3.8+
- Node.js 18+
- MySQL 8.x
- Redis
- RabbitMQ

## 快速启动

### 1. 克隆项目

```bash
git clone https://github.com/The-Him6/battery_recycle_sys.git
cd battery_recycle_sys
```

### 2. 初始化数据库

创建数据库：

```sql
CREATE DATABASE battery_recycle_system_1 DEFAULT CHARACTER SET utf8mb4;
```

导入数据库脚本：

```bash
mysql -uroot -p battery_recycle_system_1 < battery_recycle_system_1.sql
```

### 3. 修改后端配置

配置文件位置：

```text
backend/src/main/resources/application.yml
```

根据本地环境修改以下配置：

- MySQL 地址、账号、密码
- Redis 地址、端口、密码
- RabbitMQ 地址、账号、密码、虚拟主机
- OSS 配置

### 4. 启动后端

进入后端目录：

```bash
cd backend
```

编译项目：

```bash
mvn clean compile
```

启动服务：

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

数据库脚本中包含管理员账号：

```text
用户名：admin
密码：123456
```

## 目录结构

```text
.
├── backend                         后端 Spring Boot 项目
│   ├── src/main/java/com/battery/recycle
│   │   ├── config                  配置类
│   │   ├── controller              控制层
│   │   ├── dto                     请求参数对象
│   │   ├── entity                  实体类
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
│   ├── src/stores                  Pinia 状态管理
│   ├── src/utils                   Axios 封装
│   └── src/views                   页面
├── battery_recycle_system_1.sql    数据库脚本
└── README.md
```

## 常见问题

### 后端启动失败

检查 JDK 版本、MySQL 配置、Redis 配置、RabbitMQ 配置，以及 `8081` 端口是否被占用。

### 前端请求失败

检查后端服务是否启动、前端代理是否生效、请求路径是否以 `/api` 开头。

### 秒杀功能无法正常使用

秒杀模块依赖 Redis 和 RabbitMQ。请确认 Redis、RabbitMQ 已启动，并检查后端配置中的连接地址、账号、密码和虚拟主机。
