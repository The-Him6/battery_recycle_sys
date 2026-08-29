/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80407 (8.4.7)
 Source Host           : localhost:3306
 Source Schema         : battery_recycle_system_1

 Target Server Type    : MySQL
 Target Server Version : 80407 (8.4.7)
 File Encoding         : 65001

 Date: 29/08/2026 13:47:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for battery_type
-- ----------------------------
DROP TABLE IF EXISTS `battery_type`;
CREATE TABLE `battery_type`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '电池种类ID',
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '电池种类名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '种类描述',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标地址',
  `identification_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '如何识别该类型电池的指南',
  `points` int NOT NULL DEFAULT 0 COMMENT '回收积分（每个电池可获得的积分）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_type_name`(`type_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '电池种类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of battery_type
-- ----------------------------
INSERT INTO `battery_type` VALUES (1, '普通干电池', '1/2/5/7号碱性电池和碳性电池', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/a028474a-a082-4246-98fd-298105586c3b.png', '标注：1号、2号、5号、7号\n或：D、C、AA、AAA\n常见于遥控器、老式手电筒等', 10, 1, '2026-02-10 12:32:25', '2026-03-09 11:04:14');
INSERT INTO `battery_type` VALUES (2, '纽扣电池', '小型纽扣电池，小孔投放，防儿童误触', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/322643e0-02c0-449d-b537-9d0376f44514.png', '标注：CR2032、LR44等\n特征：圆形扁平状\n常见于手表、主板、车钥匙等', 5, 1, '2026-02-10 12:32:25', '2026-03-02 21:04:11');
INSERT INTO `battery_type` VALUES (3, '充电电池', '可充电电池，包含锂电池和镍氢电池', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/c8f12be4-9d2d-4953-8adc-97759c31a15b.png', '标注：带\"充电\"字样\n或：Li-ion、Ni-MH\n常见于手机、玩具车、充电宝等', 15, 1, '2026-02-10 12:32:25', '2026-03-02 21:04:50');
INSERT INTO `battery_type` VALUES (4, '大型电池', '儿童电动车铅酸电池等大型电池，需人工辅助', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/e5e1d786-1a76-4cd5-82de-2465984a343b.png', '标注：铅酸、12V等\n特征：体积较大\n常见于电动自行车，电动三轮车等', 50, 1, '2026-02-10 12:32:25', '2026-03-02 21:05:37');
INSERT INTO `battery_type` VALUES (5, '其他电池', '无法明确归类但可参与回收的其他废电池，回收时按重量折算，100克计5分', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-04-19/3bd4b5ae-d1c9-4055-b927-e5205c4bb012.png', '无法准确归类时可选择该项', 5, 1, '2026-04-17 18:30:00', '2026-05-07 22:52:33');

-- ----------------------------
-- Table structure for exchange_product
-- ----------------------------
DROP TABLE IF EXISTS `exchange_product`;
CREATE TABLE `exchange_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌',
  `battery_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '电池型号（5号/7号）',
  `points_required` int NOT NULL DEFAULT 1000 COMMENT '所需积分',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存数量',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品图片',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品描述',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_brand`(`brand` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '可兑换电池商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exchange_product
-- ----------------------------
INSERT INTO `exchange_product` VALUES (1, '南孚5号碱性电池', '南孚', '5号', 1000, 97, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/2cd6dadd-cabb-41c4-a6c3-f333d6b97bbc.png', '南孚聚能环5号碱性电池，持久耐用', 1, '2026-02-10 12:32:25', '2026-03-21 15:26:30');
INSERT INTO `exchange_product` VALUES (2, '南孚7号碱性电池', '南孚', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/8a3f65b5-be6f-4451-abc2-a6882e01cc38.png', '南孚聚能环7号碱性电池，持久耐用', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:06');
INSERT INTO `exchange_product` VALUES (3, '酷态科5号碱性电池', '酷态科', '5号', 1000, 99, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/f7c4f4c9-41f6-4166-b096-9e6a2552eade.png', '酷态科5号碱性电池，性价比高', 1, '2026-02-10 12:32:25', '2026-03-09 11:02:14');
INSERT INTO `exchange_product` VALUES (4, '酷态科7号碱性电池', '酷态科', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/e80511d1-5602-4f63-8a87-daba55da2fa2.png', '酷态科7号碱性电池，性价比高', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:39');
INSERT INTO `exchange_product` VALUES (7, '双鹿5号碱性电池', '双鹿', '5号', 1000, 99, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/1b6b44a7-25e0-4ff7-bb78-c9996e2e0ce4.png', '双鹿5号碱性电池，国产品牌', 1, '2026-02-10 12:32:25', '2026-05-13 19:14:46');
INSERT INTO `exchange_product` VALUES (8, '双鹿7号碱性电池', '双鹿', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/ec663f9c-a725-4edb-bfe4-de029fbe4097.png', '双鹿7号碱性电池，国产品牌', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:24');
INSERT INTO `exchange_product` VALUES (9, '京东京造5号碱性电池', '京东京造', '5号', 1000, 0, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/244aa6ff-57a5-4320-b4f1-afca235f4dad.png', '京东京造5号碱性电池，品质之选', 1, '2026-02-10 12:32:25', '2026-05-13 22:58:03');
INSERT INTO `exchange_product` VALUES (10, '京东京造7号碱性电池', '京东京造', '7号', 1000, 97, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/c29beadd-f36c-41d1-9dbb-cf9660172327.png', '京东京造7号碱性电池，品质之选', 1, '2026-02-10 12:32:25', '2026-06-14 13:57:46');

-- ----------------------------
-- Table structure for exchange_record
-- ----------------------------
DROP TABLE IF EXISTS `exchange_record`;
CREATE TABLE `exchange_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '兑换记录ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `points_used` int NOT NULL COMMENT '使用积分',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '兑换数量',
  `exchange_status` tinyint NOT NULL DEFAULT 0 COMMENT '兑换状态：0-待发货，1-已发货，2-已完成',
  `shipping_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `exchange_type` tinyint NOT NULL DEFAULT 0 COMMENT '兑换类型：0-积分兑换，1-秒杀券兑换',
  `coupon_id` bigint NULL DEFAULT NULL COMMENT '使用的秒杀券ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_product_id`(`product_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_coupon_id`(`coupon_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分兑换记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exchange_record
-- ----------------------------

-- ----------------------------
-- Table structure for recycle_detail
-- ----------------------------
DROP TABLE IF EXISTS `recycle_detail`;
CREATE TABLE `recycle_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `battery_type_id` bigint NOT NULL COMMENT '电池种类ID',
  `battery_count` int NOT NULL DEFAULT 0 COMMENT '电池数量',
  `points` int NOT NULL DEFAULT 0 COMMENT '获得积分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_battery_type_id_count`(`battery_type_id` ASC, `battery_count` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99950 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '回收明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recycle_detail
-- ----------------------------
INSERT INTO `recycle_detail` VALUES (1, 1, 4, 1, 50, '2023-11-04 12:58:20');
INSERT INTO `recycle_detail` VALUES (2, 1, 5, 17, 17, '2023-11-04 12:58:20');
INSERT INTO `recycle_detail` VALUES (3, 1, 1, 23, 230, '2023-11-04 12:58:20');
INSERT INTO `recycle_detail` VALUES (4, 2, 1, 36, 360, '2024-03-04 17:15:24');
INSERT INTO `recycle_detail` VALUES (5, 2, 3, 9, 135, '2024-03-04 17:15:24');
INSERT INTO `recycle_detail` VALUES (6, 2, 4, 3, 150, '2024-03-04 17:15:24');
INSERT INTO `recycle_detail` VALUES (7, 3, 4, 9, 450, '2025-10-06 13:17:54');
INSERT INTO `recycle_detail` VALUES (8, 3, 1, 15, 150, '2025-10-06 13:17:54');
INSERT INTO `recycle_detail` VALUES (9, 3, 2, 27, 135, '2025-10-06 13:17:54');
INSERT INTO `recycle_detail` VALUES (10, 4, 4, 1, 50, '2023-06-22 17:22:01');
INSERT INTO `recycle_detail` VALUES (11, 5, 1, 26, 260, '2024-10-03 14:10:46');
INSERT INTO `recycle_detail` VALUES (12, 6, 5, 12, 12, '2026-02-09 10:53:52');
INSERT INTO `recycle_detail` VALUES (13, 6, 3, 5, 75, '2026-02-09 10:53:52');
INSERT INTO `recycle_detail` VALUES (14, 6, 1, 41, 410, '2026-02-09 10:53:52');
INSERT INTO `recycle_detail` VALUES (15, 7, 4, 7, 350, '2024-02-23 15:19:24');
INSERT INTO `recycle_detail` VALUES (16, 7, 5, 38, 38, '2024-02-23 15:19:24');
INSERT INTO `recycle_detail` VALUES (17, 8, 3, 3, 45, '2026-01-30 14:24:05');
INSERT INTO `recycle_detail` VALUES (18, 8, 1, 12, 120, '2026-01-30 14:24:05');
INSERT INTO `recycle_detail` VALUES (19, 9, 3, 3, 45, '2023-12-13 11:58:45');
INSERT INTO `recycle_detail` VALUES (20, 9, 2, 30, 150, '2023-12-13 11:58:45');
INSERT INTO `recycle_detail` VALUES (21, 10, 1, 17, 170, '2025-11-15 11:03:17');
INSERT INTO `recycle_detail` VALUES (22, 10, 2, 15, 75, '2025-11-15 11:03:17');
INSERT INTO `recycle_detail` VALUES (23, 11, 5, 28, 28, '2026-01-01 11:42:31');
INSERT INTO `recycle_detail` VALUES (24, 11, 4, 8, 400, '2026-01-01 11:42:31');
INSERT INTO `recycle_detail` VALUES (25, 12, 1, 38, 380, '2026-04-11 17:59:02');
INSERT INTO `recycle_detail` VALUES (26, 13, 2, 28, 140, '2022-08-05 11:52:18');
INSERT INTO `recycle_detail` VALUES (27, 13, 4, 7, 350, '2022-08-05 11:52:18');
INSERT INTO `recycle_detail` VALUES (28, 14, 2, 21, 105, '2023-04-06 16:24:29');
INSERT INTO `recycle_detail` VALUES (29, 15, 2, 9, 45, '2026-03-06 08:27:06');
INSERT INTO `recycle_detail` VALUES (30, 16, 2, 29, 145, '2023-03-04 11:15:13');
INSERT INTO `recycle_detail` VALUES (31, 16, 1, 24, 240, '2023-03-04 11:15:13');
INSERT INTO `recycle_detail` VALUES (32, 16, 3, 14, 210, '2023-03-04 11:15:13');
INSERT INTO `recycle_detail` VALUES (33, 17, 1, 23, 230, '2025-01-05 15:29:20');
INSERT INTO `recycle_detail` VALUES (34, 18, 2, 22, 110, '2022-09-24 14:27:26');
INSERT INTO `recycle_detail` VALUES (35, 18, 4, 8, 400, '2022-09-24 14:27:26');
INSERT INTO `recycle_detail` VALUES (36, 18, 1, 40, 400, '2022-09-24 14:27:26');
INSERT INTO `recycle_detail` VALUES (37, 19, 5, 23, 23, '2026-02-23 14:50:14');
INSERT INTO `recycle_detail` VALUES (38, 19, 1, 30, 300, '2026-02-23 14:50:14');
INSERT INTO `recycle_detail` VALUES (39, 20, 3, 4, 60, '2025-02-04 16:54:00');
INSERT INTO `recycle_detail` VALUES (40, 20, 2, 27, 135, '2025-02-04 16:54:00');
INSERT INTO `recycle_detail` VALUES (41, 20, 5, 14, 14, '2025-02-04 16:54:00');
INSERT INTO `recycle_detail` VALUES (42, 21, 2, 9, 45, '2026-02-21 12:59:27');
INSERT INTO `recycle_detail` VALUES (43, 22, 5, 29, 29, '2024-07-12 13:55:06');
INSERT INTO `recycle_detail` VALUES (44, 22, 3, 23, 345, '2024-07-12 13:55:06');
INSERT INTO `recycle_detail` VALUES (45, 22, 4, 2, 100, '2024-07-12 13:55:06');
INSERT INTO `recycle_detail` VALUES (46, 23, 1, 40, 400, '2024-03-20 15:55:28');
INSERT INTO `recycle_detail` VALUES (47, 24, 4, 1, 50, '2022-10-22 09:47:27');
INSERT INTO `recycle_detail` VALUES (48, 25, 5, 25, 25, '2024-04-05 11:53:28');
INSERT INTO `recycle_detail` VALUES (49, 25, 1, 43, 430, '2024-04-05 11:53:28');
INSERT INTO `recycle_detail` VALUES (50, 25, 2, 7, 35, '2024-04-05 11:53:28');
INSERT INTO `recycle_detail` VALUES (51, 26, 2, 10, 50, '2024-02-16 11:10:54');
INSERT INTO `recycle_detail` VALUES (52, 26, 5, 3, 3, '2024-02-16 11:10:54');
INSERT INTO `recycle_detail` VALUES (53, 26, 1, 13, 130, '2024-02-16 11:10:54');
INSERT INTO `recycle_detail` VALUES (54, 27, 3, 23, 345, '2024-12-07 14:38:07');
INSERT INTO `recycle_detail` VALUES (55, 28, 4, 8, 400, '2024-01-25 11:41:17');
INSERT INTO `recycle_detail` VALUES (56, 29, 2, 20, 100, '2025-12-28 11:39:16');
INSERT INTO `recycle_detail` VALUES (57, 30, 1, 16, 160, '2024-02-14 09:13:45');
INSERT INTO `recycle_detail` VALUES (58, 31, 3, 17, 255, '2025-09-29 09:18:12');
INSERT INTO `recycle_detail` VALUES (59, 32, 2, 26, 130, '2024-11-19 10:30:51');
INSERT INTO `recycle_detail` VALUES (60, 32, 3, 14, 210, '2024-11-19 10:30:51');
INSERT INTO `recycle_detail` VALUES (61, 33, 1, 20, 200, '2026-04-01 11:58:59');
INSERT INTO `recycle_detail` VALUES (62, 33, 4, 3, 150, '2026-04-01 11:58:59');
INSERT INTO `recycle_detail` VALUES (63, 34, 1, 31, 310, '2025-01-31 11:27:16');
INSERT INTO `recycle_detail` VALUES (64, 35, 3, 21, 315, '2025-02-02 08:07:23');
INSERT INTO `recycle_detail` VALUES (65, 35, 5, 9, 9, '2025-02-02 08:07:23');
INSERT INTO `recycle_detail` VALUES (66, 36, 1, 21, 210, '2024-12-08 11:58:48');
INSERT INTO `recycle_detail` VALUES (67, 37, 5, 1, 1, '2026-04-01 12:36:43');
INSERT INTO `recycle_detail` VALUES (68, 38, 5, 3, 3, '2023-12-18 09:52:53');
INSERT INTO `recycle_detail` VALUES (69, 38, 3, 20, 300, '2023-12-18 09:52:53');
INSERT INTO `recycle_detail` VALUES (70, 38, 4, 1, 50, '2023-12-18 09:52:53');
INSERT INTO `recycle_detail` VALUES (71, 39, 5, 18, 18, '2026-02-03 14:21:48');
INSERT INTO `recycle_detail` VALUES (72, 40, 3, 4, 60, '2022-09-08 09:17:01');
INSERT INTO `recycle_detail` VALUES (73, 40, 2, 27, 135, '2022-09-08 09:17:01');
INSERT INTO `recycle_detail` VALUES (74, 41, 4, 10, 500, '2025-08-06 15:46:44');
INSERT INTO `recycle_detail` VALUES (75, 42, 3, 23, 345, '2026-03-24 16:05:50');
INSERT INTO `recycle_detail` VALUES (76, 42, 1, 32, 320, '2026-03-24 16:05:50');
INSERT INTO `recycle_detail` VALUES (77, 43, 4, 6, 300, '2024-06-18 15:19:24');
INSERT INTO `recycle_detail` VALUES (78, 44, 1, 29, 290, '2026-03-15 16:09:16');
INSERT INTO `recycle_detail` VALUES (79, 45, 4, 4, 200, '2023-12-13 08:27:08');
INSERT INTO `recycle_detail` VALUES (80, 45, 2, 9, 45, '2023-12-13 08:27:08');
INSERT INTO `recycle_detail` VALUES (81, 45, 3, 20, 300, '2023-12-13 08:27:08');
INSERT INTO `recycle_detail` VALUES (82, 46, 1, 22, 220, '2023-12-05 17:52:34');
INSERT INTO `recycle_detail` VALUES (83, 46, 3, 19, 285, '2023-12-05 17:52:34');
INSERT INTO `recycle_detail` VALUES (84, 46, 4, 8, 400, '2023-12-05 17:52:34');
INSERT INTO `recycle_detail` VALUES (85, 47, 1, 15, 150, '2024-02-19 14:46:58');
INSERT INTO `recycle_detail` VALUES (86, 48, 4, 10, 500, '2024-08-18 17:42:48');
INSERT INTO `recycle_detail` VALUES (87, 49, 4, 4, 200, '2024-06-01 08:46:51');
INSERT INTO `recycle_detail` VALUES (88, 49, 3, 14, 210, '2024-06-01 08:46:51');
INSERT INTO `recycle_detail` VALUES (89, 50, 2, 4, 20, '2024-03-30 14:33:50');
INSERT INTO `recycle_detail` VALUES (90, 50, 3, 4, 60, '2024-03-30 14:33:50');
INSERT INTO `recycle_detail` VALUES (91, 50, 4, 10, 500, '2024-03-30 14:33:50');
INSERT INTO `recycle_detail` VALUES (92, 51, 3, 6, 90, '2025-08-09 09:09:11');
INSERT INTO `recycle_detail` VALUES (93, 51, 1, 28, 280, '2025-08-09 09:09:11');
INSERT INTO `recycle_detail` VALUES (94, 52, 1, 24, 240, '2024-07-05 10:39:33');
INSERT INTO `recycle_detail` VALUES (95, 52, 3, 13, 195, '2024-07-05 10:39:33');
INSERT INTO `recycle_detail` VALUES (96, 52, 2, 17, 85, '2024-07-05 10:39:33');
INSERT INTO `recycle_detail` VALUES (97, 53, 1, 18, 180, '2025-03-01 13:00:33');
INSERT INTO `recycle_detail` VALUES (98, 53, 4, 6, 300, '2025-03-01 13:00:33');
INSERT INTO `recycle_detail` VALUES (99, 54, 1, 14, 140, '2024-08-04 14:21:54');
INSERT INTO `recycle_detail` VALUES (100, 54, 3, 14, 210, '2024-08-04 14:21:54');
INSERT INTO `recycle_detail` VALUES (101, 54, 2, 28, 140, '2024-08-04 14:21:54');
INSERT INTO `recycle_detail` VALUES (102, 55, 5, 15, 15, '2025-06-12 15:31:20');
INSERT INTO `recycle_detail` VALUES (103, 56, 4, 7, 350, '2024-02-03 17:37:09');
INSERT INTO `recycle_detail` VALUES (104, 56, 3, 10, 150, '2024-02-03 17:37:09');
INSERT INTO `recycle_detail` VALUES (105, 57, 1, 38, 380, '2024-10-17 17:13:23');
INSERT INTO `recycle_detail` VALUES (106, 57, 3, 3, 45, '2024-10-17 17:13:23');
INSERT INTO `recycle_detail` VALUES (107, 58, 4, 8, 400, '2025-07-22 16:44:05');
INSERT INTO `recycle_detail` VALUES (108, 58, 3, 24, 360, '2025-07-22 16:44:05');
INSERT INTO `recycle_detail` VALUES (109, 59, 3, 24, 360, '2026-04-10 17:06:37');
INSERT INTO `recycle_detail` VALUES (110, 60, 2, 28, 140, '2025-10-25 15:11:46');
INSERT INTO `recycle_detail` VALUES (111, 60, 1, 10, 100, '2025-10-25 15:11:46');
INSERT INTO `recycle_detail` VALUES (112, 60, 5, 21, 21, '2025-10-25 15:11:46');
INSERT INTO `recycle_detail` VALUES (113, 61, 2, 6, 30, '2024-02-20 16:42:03');
INSERT INTO `recycle_detail` VALUES (114, 61, 1, 17, 170, '2024-02-20 16:42:03');
INSERT INTO `recycle_detail` VALUES (115, 61, 4, 4, 200, '2024-02-20 16:42:03');
INSERT INTO `recycle_detail` VALUES (116, 62, 3, 21, 315, '2023-08-15 15:04:00');
INSERT INTO `recycle_detail` VALUES (117, 62, 1, 25, 250, '2023-08-15 15:04:00');
INSERT INTO `recycle_detail` VALUES (118, 63, 1, 38, 380, '2024-01-12 17:51:20');
INSERT INTO `recycle_detail` VALUES (119, 64, 4, 1, 50, '2022-09-03 17:33:51');
INSERT INTO `recycle_detail` VALUES (120, 64, 1, 19, 190, '2022-09-03 17:33:51');
INSERT INTO `recycle_detail` VALUES (121, 64, 5, 32, 32, '2022-09-03 17:33:51');
INSERT INTO `recycle_detail` VALUES (122, 65, 1, 39, 390, '2025-03-18 11:09:44');
INSERT INTO `recycle_detail` VALUES (123, 66, 4, 3, 150, '2025-06-13 17:14:27');
INSERT INTO `recycle_detail` VALUES (124, 66, 1, 36, 360, '2025-06-13 17:14:27');
INSERT INTO `recycle_detail` VALUES (125, 66, 3, 11, 165, '2025-06-13 17:14:27');
INSERT INTO `recycle_detail` VALUES (126, 67, 4, 6, 300, '2026-04-09 16:41:48');
INSERT INTO `recycle_detail` VALUES (127, 67, 1, 38, 380, '2026-04-09 16:41:48');
INSERT INTO `recycle_detail` VALUES (128, 67, 3, 24, 360, '2026-04-09 16:41:48');
INSERT INTO `recycle_detail` VALUES (129, 68, 5, 17, 17, '2025-01-29 11:17:34');
INSERT INTO `recycle_detail` VALUES (130, 69, 4, 2, 100, '2024-09-04 12:58:41');
INSERT INTO `recycle_detail` VALUES (131, 69, 2, 24, 120, '2024-09-04 12:58:41');
INSERT INTO `recycle_detail` VALUES (132, 69, 1, 41, 410, '2024-09-04 12:58:41');
INSERT INTO `recycle_detail` VALUES (133, 70, 4, 1, 50, '2024-05-11 14:19:37');
INSERT INTO `recycle_detail` VALUES (134, 70, 3, 26, 390, '2024-05-11 14:19:37');
INSERT INTO `recycle_detail` VALUES (135, 71, 1, 28, 280, '2025-01-29 08:07:22');
INSERT INTO `recycle_detail` VALUES (136, 72, 4, 5, 250, '2024-12-08 10:12:24');
INSERT INTO `recycle_detail` VALUES (137, 73, 3, 14, 210, '2026-04-12 15:51:03');
INSERT INTO `recycle_detail` VALUES (138, 73, 4, 10, 500, '2026-04-12 15:51:03');
INSERT INTO `recycle_detail` VALUES (139, 74, 2, 8, 40, '2025-09-28 09:19:19');
INSERT INTO `recycle_detail` VALUES (140, 75, 1, 28, 280, '2025-05-20 17:33:58');
INSERT INTO `recycle_detail` VALUES (141, 76, 2, 9, 45, '2025-04-17 15:50:59');
INSERT INTO `recycle_detail` VALUES (142, 76, 4, 4, 200, '2025-04-17 15:50:59');
INSERT INTO `recycle_detail` VALUES (143, 77, 1, 21, 210, '2022-10-29 11:37:05');
INSERT INTO `recycle_detail` VALUES (144, 77, 5, 12, 12, '2022-10-29 11:37:05');
INSERT INTO `recycle_detail` VALUES (145, 77, 4, 8, 400, '2022-10-29 11:37:05');
INSERT INTO `recycle_detail` VALUES (146, 78, 3, 9, 135, '2026-03-03 17:08:46');
INSERT INTO `recycle_detail` VALUES (147, 78, 2, 20, 100, '2026-03-03 17:08:46');
INSERT INTO `recycle_detail` VALUES (148, 78, 4, 4, 200, '2026-03-03 17:08:46');
INSERT INTO `recycle_detail` VALUES (149, 79, 3, 9, 135, '2022-06-10 10:54:54');
INSERT INTO `recycle_detail` VALUES (150, 79, 4, 7, 350, '2022-06-10 10:54:54');
INSERT INTO `recycle_detail` VALUES (151, 80, 5, 31, 31, '2024-10-01 14:14:05');
INSERT INTO `recycle_detail` VALUES (152, 80, 1, 27, 270, '2024-10-01 14:14:05');
INSERT INTO `recycle_detail` VALUES (153, 81, 4, 2, 100, '2023-05-03 10:59:23');
INSERT INTO `recycle_detail` VALUES (154, 81, 3, 20, 300, '2023-05-03 10:59:23');
INSERT INTO `recycle_detail` VALUES (155, 82, 4, 5, 250, '2026-01-20 11:21:39');
INSERT INTO `recycle_detail` VALUES (156, 83, 1, 40, 400, '2025-07-09 16:48:26');
INSERT INTO `recycle_detail` VALUES (157, 83, 2, 18, 90, '2025-07-09 16:48:26');
INSERT INTO `recycle_detail` VALUES (158, 84, 1, 25, 250, '2024-04-16 11:58:47');
INSERT INTO `recycle_detail` VALUES (159, 84, 2, 29, 145, '2024-04-16 11:58:47');
INSERT INTO `recycle_detail` VALUES (160, 84, 4, 7, 350, '2024-04-16 11:58:47');
INSERT INTO `recycle_detail` VALUES (161, 85, 1, 38, 380, '2024-06-21 13:20:03');
INSERT INTO `recycle_detail` VALUES (162, 85, 2, 4, 20, '2024-06-21 13:20:03');
INSERT INTO `recycle_detail` VALUES (163, 85, 4, 6, 300, '2024-06-21 13:20:03');
INSERT INTO `recycle_detail` VALUES (164, 86, 1, 39, 390, '2024-07-09 14:37:10');
INSERT INTO `recycle_detail` VALUES (165, 86, 3, 9, 135, '2024-07-09 14:37:10');
INSERT INTO `recycle_detail` VALUES (166, 87, 4, 7, 350, '2023-07-01 17:13:19');
INSERT INTO `recycle_detail` VALUES (167, 88, 2, 30, 150, '2025-10-27 14:57:42');
INSERT INTO `recycle_detail` VALUES (168, 89, 2, 26, 130, '2026-04-05 14:50:06');
INSERT INTO `recycle_detail` VALUES (169, 89, 4, 5, 250, '2026-04-05 14:50:06');
INSERT INTO `recycle_detail` VALUES (170, 89, 1, 43, 430, '2026-04-05 14:50:06');
INSERT INTO `recycle_detail` VALUES (171, 90, 2, 30, 150, '2024-12-16 14:10:02');
INSERT INTO `recycle_detail` VALUES (172, 90, 1, 38, 380, '2024-12-16 14:10:02');
INSERT INTO `recycle_detail` VALUES (173, 91, 1, 27, 270, '2025-01-10 16:07:08');
INSERT INTO `recycle_detail` VALUES (174, 92, 1, 14, 140, '2024-03-10 09:10:27');
INSERT INTO `recycle_detail` VALUES (175, 92, 3, 26, 390, '2024-03-10 09:10:27');
INSERT INTO `recycle_detail` VALUES (176, 92, 4, 5, 250, '2024-03-10 09:10:27');
INSERT INTO `recycle_detail` VALUES (177, 93, 4, 4, 200, '2025-07-04 16:37:38');
INSERT INTO `recycle_detail` VALUES (178, 93, 1, 24, 240, '2025-07-04 16:37:38');
INSERT INTO `recycle_detail` VALUES (179, 93, 3, 4, 60, '2025-07-04 16:37:38');
INSERT INTO `recycle_detail` VALUES (180, 94, 1, 27, 270, '2023-10-23 13:20:03');
INSERT INTO `recycle_detail` VALUES (181, 95, 2, 7, 35, '2024-12-29 14:05:37');
INSERT INTO `recycle_detail` VALUES (182, 95, 1, 10, 100, '2024-12-29 14:05:37');
INSERT INTO `recycle_detail` VALUES (183, 95, 3, 16, 240, '2024-12-29 14:05:37');
INSERT INTO `recycle_detail` VALUES (184, 96, 4, 9, 450, '2026-01-03 12:22:24');
INSERT INTO `recycle_detail` VALUES (185, 96, 1, 41, 410, '2026-01-03 12:22:24');
INSERT INTO `recycle_detail` VALUES (186, 97, 3, 8, 120, '2026-03-04 11:45:52');
INSERT INTO `recycle_detail` VALUES (187, 97, 1, 29, 290, '2026-03-04 11:45:52');
INSERT INTO `recycle_detail` VALUES (188, 97, 2, 18, 90, '2026-03-04 11:45:52');
INSERT INTO `recycle_detail` VALUES (189, 98, 4, 2, 100, '2024-01-06 15:44:24');
INSERT INTO `recycle_detail` VALUES (190, 98, 1, 11, 110, '2024-01-06 15:44:24');
INSERT INTO `recycle_detail` VALUES (191, 98, 3, 16, 240, '2024-01-06 15:44:24');
INSERT INTO `recycle_detail` VALUES (192, 99, 4, 10, 500, '2024-04-22 09:38:50');
INSERT INTO `recycle_detail` VALUES (193, 99, 2, 12, 60, '2024-04-22 09:38:50');
INSERT INTO `recycle_detail` VALUES (194, 99, 1, 20, 200, '2024-04-22 09:38:50');
INSERT INTO `recycle_detail` VALUES (195, 100, 4, 9, 450, '2026-02-11 11:25:11');
INSERT INTO `recycle_detail` VALUES (196, 100, 1, 31, 310, '2026-02-11 11:25:11');
INSERT INTO `recycle_detail` VALUES (197, 100, 3, 18, 270, '2026-02-11 11:25:11');
INSERT INTO `recycle_detail` VALUES (198, 101, 1, 9, 90, '2023-12-18 11:48:02');
INSERT INTO `recycle_detail` VALUES (199, 102, 2, 13, 65, '2024-06-24 12:54:09');
INSERT INTO `recycle_detail` VALUES (200, 102, 1, 29, 290, '2024-06-24 12:54:09');
INSERT INTO `recycle_detail` VALUES (201, 103, 1, 16, 160, '2025-01-23 09:36:32');
INSERT INTO `recycle_detail` VALUES (202, 103, 4, 6, 300, '2025-01-23 09:36:32');
INSERT INTO `recycle_detail` VALUES (203, 104, 5, 8, 8, '2024-09-23 09:42:00');
INSERT INTO `recycle_detail` VALUES (204, 104, 1, 36, 360, '2024-09-23 09:42:00');
INSERT INTO `recycle_detail` VALUES (205, 105, 4, 3, 150, '2023-08-16 14:32:40');
INSERT INTO `recycle_detail` VALUES (206, 105, 5, 39, 39, '2023-08-16 14:32:40');
INSERT INTO `recycle_detail` VALUES (207, 105, 1, 14, 140, '2023-08-16 14:32:40');
INSERT INTO `recycle_detail` VALUES (208, 106, 4, 8, 400, '2024-02-20 09:18:08');
INSERT INTO `recycle_detail` VALUES (209, 106, 1, 20, 200, '2024-02-20 09:18:08');
INSERT INTO `recycle_detail` VALUES (210, 106, 2, 23, 115, '2024-02-20 09:18:08');
INSERT INTO `recycle_detail` VALUES (211, 107, 3, 22, 330, '2026-01-04 14:05:34');
INSERT INTO `recycle_detail` VALUES (212, 107, 2, 27, 135, '2026-01-04 14:05:34');
INSERT INTO `recycle_detail` VALUES (213, 108, 1, 40, 400, '2026-01-07 12:06:11');
INSERT INTO `recycle_detail` VALUES (214, 109, 1, 12, 120, '2026-03-31 13:20:57');
INSERT INTO `recycle_detail` VALUES (215, 109, 4, 5, 250, '2026-03-31 13:20:57');
INSERT INTO `recycle_detail` VALUES (216, 109, 5, 14, 14, '2026-03-31 13:20:57');
INSERT INTO `recycle_detail` VALUES (217, 110, 3, 6, 90, '2026-02-27 17:14:18');
INSERT INTO `recycle_detail` VALUES (218, 110, 4, 6, 300, '2026-02-27 17:14:18');
INSERT INTO `recycle_detail` VALUES (219, 111, 4, 9, 450, '2025-01-31 10:11:07');
INSERT INTO `recycle_detail` VALUES (220, 111, 2, 30, 150, '2025-01-31 10:11:07');
INSERT INTO `recycle_detail` VALUES (221, 112, 2, 8, 40, '2024-10-14 08:59:44');
INSERT INTO `recycle_detail` VALUES (222, 113, 4, 3, 150, '2023-02-03 16:43:14');
INSERT INTO `recycle_detail` VALUES (223, 113, 1, 24, 240, '2023-02-03 16:43:14');
INSERT INTO `recycle_detail` VALUES (224, 114, 3, 7, 105, '2024-10-25 14:01:02');
INSERT INTO `recycle_detail` VALUES (225, 114, 5, 11, 11, '2024-10-25 14:01:02');
INSERT INTO `recycle_detail` VALUES (226, 114, 2, 13, 65, '2024-10-25 14:01:02');
INSERT INTO `recycle_detail` VALUES (227, 115, 3, 21, 315, '2023-12-01 15:14:50');
INSERT INTO `recycle_detail` VALUES (228, 115, 4, 2, 100, '2023-12-01 15:14:50');
INSERT INTO `recycle_detail` VALUES (229, 116, 3, 7, 105, '2026-01-06 13:21:16');
INSERT INTO `recycle_detail` VALUES (230, 117, 1, 43, 430, '2026-02-28 15:18:11');
INSERT INTO `recycle_detail` VALUES (231, 118, 3, 3, 45, '2024-08-06 08:30:23');
INSERT INTO `recycle_detail` VALUES (232, 119, 2, 31, 155, '2023-02-03 16:47:31');
INSERT INTO `recycle_detail` VALUES (233, 119, 4, 2, 100, '2023-02-03 16:47:31');
INSERT INTO `recycle_detail` VALUES (234, 119, 1, 12, 120, '2023-02-03 16:47:31');
INSERT INTO `recycle_detail` VALUES (235, 120, 2, 30, 150, '2023-02-16 17:35:58');
INSERT INTO `recycle_detail` VALUES (236, 121, 2, 26, 130, '2022-07-03 13:29:42');
INSERT INTO `recycle_detail` VALUES (237, 121, 3, 6, 90, '2022-07-03 13:29:42');
INSERT INTO `recycle_detail` VALUES (238, 121, 1, 31, 310, '2022-07-03 13:29:42');
INSERT INTO `recycle_detail` VALUES (239, 122, 4, 8, 400, '2022-08-08 13:44:03');
INSERT INTO `recycle_detail` VALUES (240, 123, 4, 7, 350, '2023-02-28 12:40:07');
INSERT INTO `recycle_detail` VALUES (241, 124, 2, 31, 155, '2023-10-18 12:03:48');
INSERT INTO `recycle_detail` VALUES (242, 124, 3, 24, 360, '2023-10-18 12:03:48');
INSERT INTO `recycle_detail` VALUES (243, 125, 1, 22, 220, '2022-06-14 09:26:48');
INSERT INTO `recycle_detail` VALUES (244, 125, 3, 6, 90, '2022-06-14 09:26:48');
INSERT INTO `recycle_detail` VALUES (245, 125, 5, 14, 14, '2022-06-14 09:26:48');
INSERT INTO `recycle_detail` VALUES (246, 126, 2, 26, 130, '2024-05-30 15:44:20');
INSERT INTO `recycle_detail` VALUES (247, 127, 1, 28, 280, '2024-06-10 09:37:33');
INSERT INTO `recycle_detail` VALUES (248, 127, 3, 10, 150, '2024-06-10 09:37:33');
INSERT INTO `recycle_detail` VALUES (249, 128, 1, 36, 360, '2026-02-26 14:55:30');
INSERT INTO `recycle_detail` VALUES (250, 129, 4, 4, 200, '2024-09-15 11:34:50');

-- ----------------------------
-- Table structure for recycle_order
-- ----------------------------
DROP TABLE IF EXISTS `recycle_order`;
CREATE TABLE `recycle_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_count` int NOT NULL DEFAULT 0 COMMENT '回收电池总数量',
  `total_points` int NOT NULL DEFAULT 0 COMMENT '获得总积分',
  `recycle_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '回收地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `order_status` tinyint NOT NULL DEFAULT 0 COMMENT '订单状态：0-待处理，1-处理中，2-已完成，3-已取消',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `detail_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '订单明细快照(JSON)，订单完成时写入明细表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_number`(`order_number` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_status`(`order_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50011 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '回收订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recycle_order
-- ----------------------------
INSERT INTO `recycle_order` VALUES (1, 'BR20231104-U107-001', 107, 41, 297, '安徽省亳州市谯城区希夷大道201号', '13665145236', 2, NULL, NULL, '2023-11-04 12:58:20', '2023-11-04 20:58:20');
INSERT INTO `recycle_order` VALUES (2, 'BR20240304-U045-001', 45, 48, 645, '安徽省阜阳市颍泉区颍州南路905号', '13243851571', 2, NULL, NULL, '2024-03-04 17:15:24', '2024-03-06 18:15:24');
INSERT INTO `recycle_order` VALUES (3, 'BR20251006-U111-001', 111, 51, 735, '安徽省阜阳市颍州区清河东路658号', '13650077575', 2, '大型电池需上门搬运', NULL, '2025-10-06 13:17:54', '2025-10-08 17:17:54');
INSERT INTO `recycle_order` VALUES (4, 'BR20230622-U173-001', 173, 1, 50, '安徽省合肥市庐阳区徽州大道159号', '13591438149', 2, NULL, NULL, '2023-06-22 17:22:01', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (5, 'BR20241003-U144-001', 144, 26, 260, '安徽省亳州市谯城区希夷大道608号', '13627205323', 2, '工作日白天可上门', NULL, '2024-10-03 14:10:46', '2024-10-05 15:10:46');
INSERT INTO `recycle_order` VALUES (6, 'BR20260209-U177-001', 177, 58, 497, '安徽省阜阳市颍东区淮河路346号', '13453121366', 2, '工作日白天可上门', NULL, '2026-02-09 10:53:52', '2026-02-11 21:53:52');
INSERT INTO `recycle_order` VALUES (7, 'BR20240223-U022-001', 22, 45, 388, '安徽省亳州市涡阳县希夷大道225号', '13979221980', 2, '工作日白天可上门', NULL, '2024-02-23 15:19:24', '2024-02-25 21:19:24');
INSERT INTO `recycle_order` VALUES (8, 'BR20260130-U009-001', 9, 15, 165, '安徽省合肥市包河区阜阳北路481号', '13395628459', 2, NULL, NULL, '2026-01-30 14:24:05', '2026-02-02 06:24:05');
INSERT INTO `recycle_order` VALUES (9, 'BR20231213-U034-001', 34, 33, 195, '安徽省合肥市瑶海区潜山路656号', '13540739319', 2, NULL, NULL, '2023-12-13 11:58:45', '2023-12-14 23:58:45');
INSERT INTO `recycle_order` VALUES (10, 'BR20251115-U169-001', 169, 32, 245, '安徽省阜阳市颍州区清河东路287号', '13839871750', 2, NULL, NULL, '2025-11-15 11:03:17', '2025-11-17 22:03:17');
INSERT INTO `recycle_order` VALUES (11, 'BR20260101-U028-001', 28, 36, 428, '安徽省池州市贵池区长江南路593号', '13085867208', 2, NULL, NULL, '2026-01-01 11:42:31', '2026-01-02 01:42:31');
INSERT INTO `recycle_order` VALUES (12, 'BR20260411-U098-001', 98, 38, 380, '安徽省池州市贵池区长江南路529号', '13745555826', 2, '大型电池需上门搬运', NULL, '2026-04-11 17:59:02', '2026-04-12 16:59:02');
INSERT INTO `recycle_order` VALUES (13, 'BR20220805-U037-001', 37, 35, 490, '安徽省亳州市谯城区药都路976号', '13460580606', 2, '大型电池需上门搬运', NULL, '2022-08-05 11:52:18', '2022-08-07 23:52:18');
INSERT INTO `recycle_order` VALUES (14, 'BR20230406-U111-001', 111, 21, 105, '安徽省铜陵市铜官区长江西路526号', '13923664968', 2, '电池已分类打包', NULL, '2023-04-06 16:24:29', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (15, 'BR20260306-U033-001', 33, 9, 45, '安徽省六安市叶集区梅山南路468号', '13236870303', 2, NULL, NULL, '2026-03-06 08:27:06', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (16, 'BR20230304-U186-001', 186, 67, 595, '安徽省宿州市砀山县汴河中路930号', '13119476268', 2, NULL, NULL, '2023-03-04 11:15:13', '2023-03-06 09:15:13');
INSERT INTO `recycle_order` VALUES (17, 'BR20250105-U167-001', 167, 23, 230, '安徽省宿州市灵璧县汴河中路180号', '13789610701', 2, NULL, NULL, '2025-01-05 15:29:20', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (18, 'BR20220924-U176-001', 176, 70, 910, '安徽省宿州市灵璧县淮海北路830号', '13369305011', 2, '工作日白天可上门', NULL, '2022-09-24 14:27:26', '2022-09-26 18:27:26');
INSERT INTO `recycle_order` VALUES (19, 'BR20260223-U047-001', 47, 53, 323, '安徽省合肥市蜀山区望江西路911号', '13267890822', 2, NULL, NULL, '2026-02-23 14:50:14', '2026-02-26 05:50:14');
INSERT INTO `recycle_order` VALUES (20, 'BR20250204-U126-001', 126, 45, 209, '安徽省合肥市瑶海区望江西路115号', '13545153216', 2, NULL, NULL, '2025-02-04 16:54:00', '2025-02-07 01:54:00');
INSERT INTO `recycle_order` VALUES (21, 'BR20260221-U042-001', 42, 9, 45, '安徽省宿州市灵璧县人民路278号', '13510077390', 2, NULL, NULL, '2026-02-21 12:59:27', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (22, 'BR20240712-U077-001', 77, 54, 474, '安徽省合肥市庐阳区潜山路249号', '13293492557', 2, NULL, NULL, '2024-07-12 13:55:06', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (23, 'BR20240320-U172-001', 172, 40, 400, '安徽省六安市叶集区长安路529号', '13608357325', 2, NULL, NULL, '2024-03-20 15:55:28', '2024-03-22 06:55:28');
INSERT INTO `recycle_order` VALUES (24, 'BR20221022-U177-001', 177, 1, 50, '安徽省亳州市谯城区药都路994号', '13098770402', 2, NULL, NULL, '2022-10-22 09:47:27', '2022-10-22 17:47:27');
INSERT INTO `recycle_order` VALUES (25, 'BR20240405-U163-001', 163, 75, 490, '安徽省六安市金安区解放南路538号', '13411753994', 2, NULL, NULL, '2024-04-05 11:53:28', '2024-04-06 12:53:28');
INSERT INTO `recycle_order` VALUES (26, 'BR20240216-U098-001', 98, 26, 183, '安徽省亳州市涡阳县魏武大道890号', '13141082082', 2, '请提前电话联系', NULL, '2024-02-16 11:10:54', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (27, 'BR20241207-U161-001', 161, 23, 345, '安徽省合肥市蜀山区徽州大道951号', '13790809330', 2, '请提前电话联系', NULL, '2024-12-07 14:38:07', '2024-12-08 02:38:07');
INSERT INTO `recycle_order` VALUES (28, 'BR20240125-U005-001', 5, 8, 400, '安徽省合肥市蜀山区潜山路952号', '13192564016', 2, '请提前电话联系', NULL, '2024-01-25 11:41:17', '2024-01-27 04:41:17');
INSERT INTO `recycle_order` VALUES (29, 'BR20251228-U165-001', 165, 20, 100, '安徽省宿州市灵璧县淮海北路892号', '13795727738', 2, '大型电池需上门搬运', NULL, '2025-12-28 11:39:16', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (30, 'BR20240214-U106-001', 106, 16, 160, '安徽省亳州市蒙城县药都路823号', '13738965314', 2, '大型电池需上门搬运', NULL, '2024-02-14 09:13:45', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (31, 'BR20250929-U108-001', 108, 17, 255, '安徽省合肥市包河区望江西路109号', '13561647762', 2, NULL, NULL, '2025-09-29 09:18:12', '2025-09-29 11:18:12');
INSERT INTO `recycle_order` VALUES (32, 'BR20241119-U188-001', 188, 40, 340, '安徽省阜阳市颍州区淮河路400号', '13068199162', 2, '大型电池需上门搬运', NULL, '2024-11-19 10:30:51', '2024-11-21 11:30:51');
INSERT INTO `recycle_order` VALUES (33, 'BR20260401-U089-001', 89, 23, 350, '安徽省阜阳市颍州区人民西路871号', '13556880663', 2, '电池已分类打包', NULL, '2026-04-01 11:58:59', '2026-04-02 20:58:59');
INSERT INTO `recycle_order` VALUES (34, 'BR20250131-U191-001', 191, 31, 310, '安徽省宿州市灵璧县汴河中路212号', '13235611526', 2, NULL, NULL, '2025-01-31 11:27:16', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (35, 'BR20250202-U154-001', 154, 30, 324, '安徽省黄山市屯溪区新安北路579号', '13566252567', 2, '电池已分类打包', NULL, '2025-02-02 08:07:23', '2025-02-03 14:07:23');
INSERT INTO `recycle_order` VALUES (36, 'BR20241208-U196-001', 196, 21, 210, '安徽省合肥市瑶海区徽州大道317号', '13074090221', 2, NULL, NULL, '2024-12-08 11:58:48', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (37, 'BR20260401-U186-001', 186, 1, 1, '安徽省宿州市埇桥区汴河中路820号', '13787948709', 2, NULL, NULL, '2026-04-01 12:36:43', '2026-04-01 15:36:43');
INSERT INTO `recycle_order` VALUES (38, 'BR20231218-U190-001', 190, 24, 353, '安徽省六安市裕安区梅山南路190号', '13016240144', 2, NULL, NULL, '2023-12-18 09:52:53', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (39, 'BR20260203-U152-001', 152, 18, 18, '安徽省淮南市田家庵区朝阳中路177号', '13838836411', 2, NULL, NULL, '2026-02-03 14:21:48', '2026-02-04 10:21:48');
INSERT INTO `recycle_order` VALUES (40, 'BR20220908-U042-001', 42, 31, 195, '安徽省阜阳市颍州区清河东路557号', '13285988281', 2, NULL, NULL, '2022-09-08 09:17:01', '2022-09-08 13:17:01');
INSERT INTO `recycle_order` VALUES (41, 'BR20250806-U179-001', 179, 10, 500, '安徽省宿州市灵璧县银河一路823号', '13188548749', 2, NULL, NULL, '2025-08-06 15:46:44', '2025-08-07 19:46:44');
INSERT INTO `recycle_order` VALUES (42, 'BR20260324-U019-001', 19, 55, 665, '安徽省阜阳市颍东区清河东路108号', '13392697126', 2, NULL, NULL, '2026-03-24 16:05:50', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (43, 'BR20240618-U007-001', 7, 6, 300, '安徽省宿州市埇桥区人民路232号', '13932798602', 2, '电池已分类打包', NULL, '2024-06-18 15:19:24', '2024-06-21 06:19:24');
INSERT INTO `recycle_order` VALUES (44, 'BR20260315-U015-001', 15, 29, 290, '安徽省六安市裕安区梅山南路653号', '13923532743', 2, NULL, NULL, '2026-03-15 16:09:16', '2026-03-16 20:09:16');
INSERT INTO `recycle_order` VALUES (45, 'BR20231213-U138-001', 138, 33, 545, '安徽省亳州市蒙城县药都路933号', '13029948774', 2, '大型电池需上门搬运', NULL, '2023-12-13 08:27:08', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (46, 'BR20231205-U184-001', 184, 49, 905, '安徽省合肥市蜀山区望江西路944号', '13674768452', 2, NULL, NULL, '2023-12-05 17:52:34', '2023-12-07 07:52:34');
INSERT INTO `recycle_order` VALUES (47, 'BR20240219-U099-001', 99, 15, 150, '安徽省阜阳市颍泉区人民西路643号', '13640972484', 2, '大型电池需上门搬运', NULL, '2024-02-19 14:46:58', '2024-02-21 23:46:58');
INSERT INTO `recycle_order` VALUES (48, 'BR20240818-U177-001', 177, 10, 500, '安徽省合肥市包河区长江西路570号', '13403624772', 2, '工作日白天可上门', NULL, '2024-08-18 17:42:48', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (49, 'BR20240601-U182-001', 182, 18, 410, '安徽省合肥市瑶海区长江西路258号', '13774106066', 2, '大型电池需上门搬运', NULL, '2024-06-01 08:46:51', '2024-06-03 16:46:51');
INSERT INTO `recycle_order` VALUES (50, 'BR20240330-U053-001', 53, 18, 580, '安徽省亳州市谯城区希夷大道644号', '13857066070', 2, '工作日白天可上门', NULL, '2024-03-30 14:33:50', '2024-04-01 00:33:50');
INSERT INTO `recycle_order` VALUES (51, 'BR20250809-U102-001', 102, 34, 370, '安徽省阜阳市颍州区清河东路420号', '13536817865', 2, NULL, NULL, '2025-08-09 09:09:11', '2025-08-10 01:09:11');
INSERT INTO `recycle_order` VALUES (52, 'BR20240705-U108-001', 108, 54, 520, '安徽省阜阳市颍州区淮河路328号', '13713861145', 2, NULL, NULL, '2024-07-05 10:39:33', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (53, 'BR20250301-U109-001', 109, 24, 480, '安徽省合肥市蜀山区潜山路676号', '13319949574', 2, NULL, NULL, '2025-03-01 13:00:33', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (54, 'BR20240804-U023-001', 23, 56, 490, '安徽省合肥市瑶海区阜阳北路806号', '13662348156', 2, NULL, NULL, '2024-08-04 14:21:54', '2024-08-07 05:21:54');
INSERT INTO `recycle_order` VALUES (55, 'BR20250612-U163-001', 163, 15, 15, '安徽省马鞍山市花山区湖北东路812号', '13907122567', 2, '电池已分类打包', NULL, '2025-06-12 15:31:20', '2025-06-13 00:31:20');
INSERT INTO `recycle_order` VALUES (56, 'BR20240203-U031-001', 31, 17, 500, '安徽省阜阳市颍州区颍州南路772号', '13348872811', 2, NULL, NULL, '2024-02-03 17:37:09', '2024-02-05 15:37:09');
INSERT INTO `recycle_order` VALUES (57, 'BR20241017-U042-001', 42, 41, 425, '安徽省宿州市砀山县淮海北路136号', '13956868718', 2, NULL, NULL, '2024-10-17 17:13:23', '2024-10-19 07:13:23');
INSERT INTO `recycle_order` VALUES (58, 'BR20250722-U015-001', 15, 32, 760, '安徽省合肥市瑶海区阜阳北路607号', '13093962674', 2, NULL, NULL, '2025-07-22 16:44:05', '2025-07-24 04:44:05');
INSERT INTO `recycle_order` VALUES (59, 'BR20260410-U080-001', 80, 24, 360, '安徽省宿州市埇桥区汴河中路115号', '13649552709', 2, '电池已分类打包', NULL, '2026-04-10 17:06:37', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (60, 'BR20251025-U059-001', 59, 59, 261, '安徽省亳州市蒙城县魏武大道343号', '13170972029', 2, '请提前电话联系', NULL, '2025-10-25 15:11:46', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (61, 'BR20240220-U121-001', 121, 27, 400, '安徽省合肥市蜀山区潜山路142号', '13710706823', 2, '工作日白天可上门', NULL, '2024-02-20 16:42:03', '2024-02-22 13:42:03');
INSERT INTO `recycle_order` VALUES (62, 'BR20230815-U199-001', 199, 46, 565, '安徽省六安市裕安区长安路272号', '13433454177', 2, NULL, NULL, '2023-08-15 15:04:00', '2023-08-18 12:04:00');
INSERT INTO `recycle_order` VALUES (63, 'BR20240112-U004-001', 4, 38, 380, '安徽省亳州市谯城区魏武大道547号', '13211291222', 2, NULL, NULL, '2024-01-12 17:51:20', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (64, 'BR20220903-U156-001', 156, 52, 272, '安徽省合肥市包河区潜山路682号', '13426825668', 2, '电池已分类打包', NULL, '2022-09-03 17:33:51', '2022-09-04 07:33:51');
INSERT INTO `recycle_order` VALUES (65, 'BR20250318-U025-001', 25, 39, 390, '安徽省亳州市涡阳县药都路990号', '13637704855', 2, '电池已分类打包', NULL, '2025-03-18 11:09:44', '2025-03-19 21:09:44');
INSERT INTO `recycle_order` VALUES (66, 'BR20250613-U052-001', 52, 50, 675, '安徽省安庆市迎江区皖江大道166号', '13543832731', 2, '工作日白天可上门', NULL, '2025-06-13 17:14:27', '2025-06-14 07:14:27');
INSERT INTO `recycle_order` VALUES (67, 'BR20260409-U119-001', 119, 68, 1040, '安徽省合肥市包河区长江西路514号', '13991917196', 2, NULL, NULL, '2026-04-09 16:41:48', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (68, 'BR20250129-U089-001', 89, 17, 17, '安徽省阜阳市颍泉区清河东路266号', '13674862363', 2, NULL, NULL, '2025-01-29 11:17:34', '2025-01-30 09:17:34');
INSERT INTO `recycle_order` VALUES (69, 'BR20240904-U011-001', 11, 67, 630, '安徽省宿州市灵璧县淮海北路867号', '13074034668', 2, NULL, NULL, '2024-09-04 12:58:41', '2024-09-06 23:58:41');
INSERT INTO `recycle_order` VALUES (70, 'BR20240511-U141-001', 141, 27, 440, '安徽省合肥市蜀山区徽州大道105号', '13161163982', 2, NULL, NULL, '2024-05-11 14:19:37', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (71, 'BR20250129-U111-001', 111, 28, 280, '安徽省合肥市瑶海区阜阳北路228号', '13145172232', 2, '大型电池需上门搬运', NULL, '2025-01-29 08:07:22', '2025-01-31 20:07:22');
INSERT INTO `recycle_order` VALUES (72, 'BR20241208-U134-001', 134, 5, 250, '安徽省安庆市迎江区皖江大道914号', '13859202296', 2, NULL, NULL, '2024-12-08 10:12:24', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (73, 'BR20260412-U019-001', 19, 24, 710, '安徽省合肥市瑶海区阜阳北路505号', '13960465049', 2, '工作日白天可上门', NULL, '2026-04-12 15:51:03', '2026-04-13 12:51:03');
INSERT INTO `recycle_order` VALUES (74, 'BR20250928-U108-001', 108, 8, 40, '安徽省合肥市瑶海区阜阳北路328号', '13685574818', 2, NULL, NULL, '2025-09-28 09:19:19', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (75, 'BR20250520-U086-001', 86, 28, 280, '安徽省六安市叶集区长安路328号', '13674401011', 2, NULL, NULL, '2025-05-20 17:33:58', '2025-05-23 06:33:58');
INSERT INTO `recycle_order` VALUES (76, 'BR20250417-U045-001', 45, 13, 245, '安徽省阜阳市颍州区颍州南路275号', '13749779919', 2, '电池已分类打包', NULL, '2025-04-17 15:50:59', '2025-04-18 04:50:59');
INSERT INTO `recycle_order` VALUES (77, 'BR20221029-U087-001', 87, 41, 622, '安徽省宿州市灵璧县银河一路534号', '13547804174', 2, '大型电池需上门搬运', NULL, '2022-10-29 11:37:05', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (78, 'BR20260303-U081-001', 81, 33, 435, '安徽省宣城市宣州区昭亭南路699号', '13542838880', 2, NULL, NULL, '2026-03-03 17:08:46', '2026-03-06 16:08:46');
INSERT INTO `recycle_order` VALUES (79, 'BR20220610-U075-001', 75, 16, 485, '安徽省宿州市灵璧县银河一路934号', '13744666953', 2, NULL, NULL, '2022-06-10 10:54:54', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (80, 'BR20241001-U122-001', 122, 58, 301, '安徽省合肥市蜀山区望江西路267号', '13381295231', 2, '大型电池需上门搬运', NULL, '2024-10-01 14:14:05', '2024-10-02 01:14:05');
INSERT INTO `recycle_order` VALUES (81, 'BR20230503-U124-001', 124, 22, 400, '安徽省亳州市蒙城县药都路212号', '13833119325', 2, NULL, NULL, '2023-05-03 10:59:23', '2023-05-03 11:59:23');
INSERT INTO `recycle_order` VALUES (82, 'BR20260120-U042-001', 42, 5, 250, '安徽省宿州市埇桥区淮海北路544号', '13846810795', 2, NULL, NULL, '2026-01-20 11:21:39', '2026-01-22 19:21:39');
INSERT INTO `recycle_order` VALUES (83, 'BR20250709-U164-001', 164, 58, 490, '安徽省阜阳市颍东区清河东路631号', '13557967846', 2, '请提前电话联系', NULL, '2025-07-09 16:48:26', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (84, 'BR20240416-U138-001', 138, 61, 745, '安徽省合肥市包河区潜山路697号', '13348995525', 2, NULL, NULL, '2024-04-16 11:58:47', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (85, 'BR20240621-U196-001', 196, 48, 700, '安徽省亳州市谯城区魏武大道871号', '13809971534', 2, '工作日白天可上门', NULL, '2024-06-21 13:20:03', '2024-06-22 15:20:03');
INSERT INTO `recycle_order` VALUES (86, 'BR20240709-U105-001', 105, 48, 525, '安徽省阜阳市颍泉区清河东路500号', '13730019577', 2, '大型电池需上门搬运', NULL, '2024-07-09 14:37:10', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (87, 'BR20230701-U098-001', 98, 7, 350, '安徽省阜阳市颍泉区颍州南路524号', '13872772273', 2, NULL, NULL, '2023-07-01 17:13:19', '2023-07-03 22:13:19');
INSERT INTO `recycle_order` VALUES (88, 'BR20251027-U009-001', 9, 30, 150, '安徽省阜阳市颍东区颍州南路728号', '13036904036', 2, '请提前电话联系', NULL, '2025-10-27 14:57:42', '2025-10-29 05:57:42');
INSERT INTO `recycle_order` VALUES (89, 'BR20260405-U134-001', 134, 74, 810, '安徽省合肥市包河区徽州大道262号', '13066459833', 2, NULL, NULL, '2026-04-05 14:50:06', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (90, 'BR20241216-U198-001', 198, 68, 530, '安徽省亳州市谯城区芍花路555号', '13682288871', 2, NULL, NULL, '2024-12-16 14:10:02', '2024-12-17 08:10:02');
INSERT INTO `recycle_order` VALUES (91, 'BR20250110-U116-001', 116, 27, 270, '安徽省合肥市包河区徽州大道146号', '13626869152', 2, NULL, NULL, '2025-01-10 16:07:08', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (92, 'BR20240310-U066-001', 66, 45, 780, '安徽省宿州市埇桥区汴河中路543号', '13101564090', 2, '请提前电话联系', NULL, '2024-03-10 09:10:27', '2024-03-12 16:10:27');
INSERT INTO `recycle_order` VALUES (93, 'BR20250704-U147-001', 147, 32, 500, '安徽省宿州市灵璧县汴河中路439号', '13344043723', 2, NULL, NULL, '2025-07-04 16:37:38', '2025-07-06 16:37:38');
INSERT INTO `recycle_order` VALUES (94, 'BR20231023-U096-001', 96, 27, 270, '安徽省合肥市包河区望江西路789号', '13385813018', 2, NULL, NULL, '2023-10-23 13:20:03', '2023-10-24 19:20:03');
INSERT INTO `recycle_order` VALUES (95, 'BR20241229-U075-001', 75, 33, 375, '安徽省合肥市瑶海区潜山路794号', '13193514708', 2, NULL, NULL, '2024-12-29 14:05:37', '2024-12-29 22:05:37');
INSERT INTO `recycle_order` VALUES (96, 'BR20260103-U153-001', 153, 50, 860, '安徽省合肥市瑶海区潜山路442号', '13093501127', 2, '大型电池需上门搬运', NULL, '2026-01-03 12:22:24', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (97, 'BR20260304-U043-001', 43, 55, 500, '安徽省合肥市瑶海区徽州大道865号', '13480497302', 2, NULL, NULL, '2026-03-04 11:45:52', '2026-03-05 15:45:52');
INSERT INTO `recycle_order` VALUES (98, 'BR20240106-U066-001', 66, 29, 450, '安徽省六安市叶集区皖西大道516号', '13087836251', 2, '请提前电话联系', NULL, '2024-01-06 15:44:24', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (99, 'BR20240422-U045-001', 45, 42, 760, '安徽省合肥市蜀山区长江西路532号', '13593621118', 2, NULL, NULL, '2024-04-22 09:38:50', '2024-04-25 07:38:50');
INSERT INTO `recycle_order` VALUES (100, 'BR20260211-U007-001', 7, 58, 1030, '安徽省六安市叶集区解放南路592号', '13904330088', 2, NULL, NULL, '2026-02-11 11:25:11', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (101, 'BR20231218-U181-001', 181, 9, 90, '安徽省宿州市砀山县人民路373号', '13265560058', 2, '工作日白天可上门', NULL, '2023-12-18 11:48:02', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (102, 'BR20240624-U134-001', 134, 42, 355, '安徽省蚌埠市龙子湖区东海大道511号', '13974340611', 2, NULL, NULL, '2024-06-24 12:54:09', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (103, 'BR20250123-U016-001', 16, 22, 460, '安徽省合肥市庐阳区阜阳北路970号', '13589384189', 2, '请提前电话联系', NULL, '2025-01-23 09:36:32', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (104, 'BR20240923-U010-001', 10, 44, 368, '安徽省宿州市埇桥区银河一路270号', '13563083621', 2, '电池已分类打包', NULL, '2024-09-23 09:42:00', '2024-09-25 11:42:00');
INSERT INTO `recycle_order` VALUES (105, 'BR20230816-U089-001', 89, 56, 329, '安徽省合肥市庐阳区阜阳北路921号', '13074146371', 2, NULL, NULL, '2023-08-16 14:32:40', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (106, 'BR20240220-U163-001', 163, 51, 715, '安徽省合肥市包河区潜山路664号', '13328827054', 2, NULL, NULL, '2024-02-20 09:18:08', '2024-02-21 13:18:08');
INSERT INTO `recycle_order` VALUES (107, 'BR20260104-U166-001', 166, 49, 465, '安徽省合肥市瑶海区望江西路860号', '13739789479', 2, '电池已分类打包', NULL, '2026-01-04 14:05:34', '2026-01-07 06:05:34');
INSERT INTO `recycle_order` VALUES (108, 'BR20260107-U032-001', 32, 40, 400, '安徽省阜阳市颍东区颍州南路492号', '13853982156', 2, NULL, NULL, '2026-01-07 12:06:11', '2026-01-09 00:06:11');
INSERT INTO `recycle_order` VALUES (109, 'BR20260331-U018-001', 18, 31, 384, '安徽省六安市叶集区长安路352号', '13733380139', 2, NULL, NULL, '2026-03-31 13:20:57', '2026-04-03 12:20:57');
INSERT INTO `recycle_order` VALUES (110, 'BR20260227-U114-001', 114, 12, 390, '安徽省阜阳市颍东区人民西路358号', '13816420073', 2, '电池已分类打包', NULL, '2026-02-27 17:14:18', '2026-03-01 03:14:18');
INSERT INTO `recycle_order` VALUES (111, 'BR20250131-U094-001', 94, 39, 600, '安徽省合肥市庐阳区阜阳北路831号', '13668830156', 2, NULL, NULL, '2025-01-31 10:11:07', '2025-02-01 01:11:07');
INSERT INTO `recycle_order` VALUES (112, 'BR20241014-U004-001', 4, 8, 40, '安徽省宿州市埇桥区汴河中路632号', '13815927418', 2, '大型电池需上门搬运', NULL, '2024-10-14 08:59:44', '2024-10-15 08:59:44');
INSERT INTO `recycle_order` VALUES (113, 'BR20230203-U038-001', 38, 27, 390, '安徽省阜阳市颍泉区颍州南路657号', '13806186792', 2, '电池已分类打包', NULL, '2023-02-03 16:43:14', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (114, 'BR20241025-U059-001', 59, 31, 181, '安徽省宿州市砀山县银河一路468号', '13627949191', 2, NULL, NULL, '2024-10-25 14:01:02', '2024-10-26 23:01:02');
INSERT INTO `recycle_order` VALUES (115, 'BR20231201-U033-001', 33, 23, 415, '安徽省亳州市谯城区希夷大道651号', '13895866987', 2, NULL, NULL, '2023-12-01 15:14:50', '2023-12-04 03:14:50');
INSERT INTO `recycle_order` VALUES (116, 'BR20260106-U129-001', 129, 7, 105, '安徽省合肥市包河区阜阳北路310号', '13674180685', 2, NULL, NULL, '2026-01-06 13:21:16', '2026-01-06 21:21:16');
INSERT INTO `recycle_order` VALUES (117, 'BR20260228-U152-001', 152, 43, 430, '安徽省宿州市埇桥区汴河中路201号', '13174235942', 2, NULL, NULL, '2026-02-28 15:18:11', '2026-03-02 13:18:11');
INSERT INTO `recycle_order` VALUES (118, 'BR20240806-U166-001', 166, 3, 45, '安徽省合肥市庐阳区徽州大道594号', '13881582899', 2, NULL, NULL, '2024-08-06 08:30:23', '2024-08-08 07:30:23');
INSERT INTO `recycle_order` VALUES (119, 'BR20230203-U092-001', 92, 45, 375, '安徽省六安市叶集区梅山南路903号', '13972098720', 2, '电池已分类打包', NULL, '2023-02-03 16:47:31', '2023-02-04 14:47:31');
INSERT INTO `recycle_order` VALUES (120, 'BR20230216-U082-001', 82, 30, 150, '安徽省合肥市包河区望江西路481号', '13657062441', 2, '请提前电话联系', NULL, '2023-02-16 17:35:58', '2023-02-17 20:35:58');
INSERT INTO `recycle_order` VALUES (121, 'BR20220703-U082-001', 82, 63, 530, '安徽省滁州市琅琊区丰乐大道917号', '13204226839', 2, '大型电池需上门搬运', NULL, '2022-07-03 13:29:42', '2022-07-05 07:29:42');
INSERT INTO `recycle_order` VALUES (122, 'BR20220808-U037-001', 37, 8, 400, '安徽省合肥市瑶海区长江西路561号', '13669793222', 2, NULL, NULL, '2022-08-08 13:44:03', '2022-08-09 23:44:03');
INSERT INTO `recycle_order` VALUES (123, 'BR20230228-U097-001', 97, 7, 350, '安徽省六安市金安区长安路921号', '13999290195', 2, '电池已分类打包', NULL, '2023-02-28 12:40:07', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (124, 'BR20231018-U144-001', 144, 55, 515, '安徽省阜阳市颍东区淮河路678号', '13504301655', 2, NULL, NULL, '2023-10-18 12:03:48', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (125, 'BR20220614-U106-001', 106, 42, 324, '安徽省合肥市包河区长江西路215号', '13303398073', 2, '请提前电话联系', NULL, '2022-06-14 09:26:48', '2022-06-17 01:26:48');
INSERT INTO `recycle_order` VALUES (126, 'BR20240530-U117-001', 117, 26, 130, '安徽省六安市裕安区解放南路915号', '13486430608', 2, NULL, NULL, '2024-05-30 15:44:20', '2024-06-01 21:44:20');
INSERT INTO `recycle_order` VALUES (127, 'BR20240610-U166-001', 166, 38, 430, '安徽省六安市裕安区梅山南路239号', '13542062640', 2, '电池已分类打包', NULL, '2024-06-10 09:37:33', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (128, 'BR20260226-U081-001', 81, 36, 360, '安徽省宿州市砀山县人民路974号', '13443955950', 2, '大型电池需上门搬运', NULL, '2026-02-26 14:55:30', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (129, 'BR20240915-U161-001', 161, 23, 390, '安徽省合肥市蜀山区潜山路731号', '13548148866', 2, NULL, NULL, '2024-09-15 11:34:50', '2024-09-18 00:34:50');
INSERT INTO `recycle_order` VALUES (130, 'BR20241019-U088-001', 88, 28, 280, '安徽省合肥市包河区长江西路533号', '13285771408', 2, NULL, NULL, '2024-10-19 09:32:09', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (131, 'BR20230428-U115-001', 115, 28, 280, '安徽省亳州市蒙城县魏武大道891号', '13867260778', 2, NULL, NULL, '2023-04-28 10:15:32', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (132, 'BR20251107-U154-001', 154, 43, 430, '安徽省宿州市灵璧县银河一路330号', '13276297401', 2, NULL, NULL, '2025-11-07 14:30:40', '2025-11-10 06:30:40');
INSERT INTO `recycle_order` VALUES (133, 'BR20250131-U020-001', 20, 46, 590, '安徽省六安市叶集区梅山南路143号', '13436083055', 2, '请提前电话联系', NULL, '2025-01-31 15:27:02', '2025-01-31 21:27:02');
INSERT INTO `recycle_order` VALUES (134, 'BR20230411-U034-001', 34, 52, 367, '安徽省宿州市灵璧县人民路394号', '13800914167', 2, '请提前电话联系', NULL, '2023-04-11 08:29:15', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (135, 'BR20230807-U074-001', 74, 43, 388, '安徽省亳州市谯城区希夷大道660号', '13238536416', 2, '大型电池需上门搬运', NULL, '2023-08-07 14:22:59', '2023-08-08 10:22:59');
INSERT INTO `recycle_order` VALUES (136, 'BR20250414-U181-001', 181, 29, 290, '安徽省宿州市埇桥区人民路806号', '13357998678', 2, '工作日白天可上门', NULL, '2025-04-14 13:47:24', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (137, 'BR20250407-U143-001', 143, 53, 705, '安徽省黄山市屯溪区新安北路698号', '13167428110', 2, NULL, NULL, '2025-04-07 15:48:52', '2025-04-10 07:48:52');
INSERT INTO `recycle_order` VALUES (138, 'BR20241121-U047-001', 47, 61, 658, '安徽省阜阳市颍东区人民西路928号', '13891536636', 2, NULL, NULL, '2024-11-21 12:48:33', '2024-11-22 11:48:33');
INSERT INTO `recycle_order` VALUES (139, 'BR20220620-U066-001', 66, 79, 490, '安徽省合肥市庐阳区潜山路923号', '13837635961', 2, '工作日白天可上门', NULL, '2022-06-20 12:46:38', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (140, 'BR20250214-U084-001', 84, 9, 450, '安徽省合肥市蜀山区阜阳北路900号', '13973649414', 2, '电池已分类打包', NULL, '2025-02-14 13:07:09', '2025-02-16 09:07:09');
INSERT INTO `recycle_order` VALUES (141, 'BR20250525-U070-001', 70, 25, 250, '安徽省阜阳市颍泉区人民西路184号', '13025154038', 2, NULL, NULL, '2025-05-25 08:58:48', '2025-05-27 20:58:48');
INSERT INTO `recycle_order` VALUES (142, 'BR20250604-U198-001', 198, 14, 210, '安徽省阜阳市颍泉区人民西路243号', '13432207067', 2, NULL, NULL, '2025-06-04 15:27:04', '2025-06-06 13:27:04');
INSERT INTO `recycle_order` VALUES (143, 'BR20250215-U059-001', 59, 9, 130, '安徽省宿州市砀山县淮海北路384号', '13009733574', 2, '请提前电话联系', NULL, '2025-02-15 09:33:15', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (144, 'BR20230927-U069-001', 69, 35, 350, '安徽省亳州市蒙城县希夷大道726号', '13569974710', 2, NULL, NULL, '2023-09-27 11:18:36', '2023-09-28 03:18:36');
INSERT INTO `recycle_order` VALUES (145, 'BR20260224-U181-001', 181, 57, 393, '安徽省阜阳市颍东区淮河路915号', '13961386773', 2, '请提前电话联系', NULL, '2026-02-24 08:30:32', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (146, 'BR20221122-U045-001', 45, 39, 435, '安徽省合肥市庐阳区阜阳北路172号', '13166767927', 2, NULL, NULL, '2022-11-22 16:46:18', '2022-11-23 03:46:18');
INSERT INTO `recycle_order` VALUES (147, 'BR20260104-U030-001', 30, 40, 500, '安徽省六安市叶集区长安路462号', '13211405291', 2, NULL, NULL, '2026-01-04 12:09:26', '2026-01-05 15:09:26');
INSERT INTO `recycle_order` VALUES (148, 'BR20260131-U136-001', 136, 26, 425, '安徽省宿州市砀山县汴河中路414号', '13441710679', 2, '电池已分类打包', NULL, '2026-01-31 15:58:35', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (149, 'BR20250116-U187-001', 187, 39, 790, '安徽省亳州市涡阳县芍花路929号', '13438672281', 2, '工作日白天可上门', NULL, '2025-01-16 14:53:36', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (150, 'BR20241028-U047-001', 47, 7, 350, '安徽省宿州市砀山县汴河中路314号', '13038194343', 2, '工作日白天可上门', NULL, '2024-10-28 10:33:09', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (151, 'BR20240809-U016-001', 16, 20, 200, '安徽省六安市金安区解放南路952号', '13829559603', 2, '大型电池需上门搬运', NULL, '2024-08-09 08:32:28', '2024-08-11 22:32:28');
INSERT INTO `recycle_order` VALUES (152, 'BR20241130-U045-001', 45, 47, 258, '安徽省宿州市埇桥区淮海北路323号', '13382406493', 2, '电池已分类打包', NULL, '2024-11-30 14:31:37', '2024-11-30 14:31:37');
INSERT INTO `recycle_order` VALUES (153, 'BR20250827-U090-001', 90, 25, 270, '安徽省合肥市庐阳区阜阳北路982号', '13414562918', 2, '请提前电话联系', NULL, '2025-08-27 08:22:40', '2025-08-30 03:22:40');
INSERT INTO `recycle_order` VALUES (154, 'BR20251206-U150-001', 150, 48, 720, '安徽省亳州市蒙城县药都路657号', '13549743294', 2, NULL, NULL, '2025-12-06 08:17:22', '2025-12-06 19:17:22');
INSERT INTO `recycle_order` VALUES (155, 'BR20250901-U070-001', 70, 56, 455, '安徽省阜阳市颍州区颍州南路894号', '13299078322', 2, NULL, NULL, '2025-09-01 12:11:38', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (156, 'BR20251207-U096-001', 96, 34, 380, '安徽省宿州市埇桥区银河一路676号', '13136564669', 2, NULL, NULL, '2025-12-07 12:28:01', '2025-12-09 00:28:01');
INSERT INTO `recycle_order` VALUES (157, 'BR20260125-U141-001', 141, 45, 331, '安徽省宿州市埇桥区人民路826号', '13766639011', 2, '工作日白天可上门', NULL, '2026-01-25 11:55:39', '2026-01-26 10:55:39');
INSERT INTO `recycle_order` VALUES (158, 'BR20260403-U093-001', 93, 11, 340, '安徽省阜阳市颍州区颍州南路375号', '13231278985', 2, '电池已分类打包', NULL, '2026-04-03 12:28:09', '2026-04-05 09:28:09');
INSERT INTO `recycle_order` VALUES (159, 'BR20250208-U199-001', 199, 46, 880, '安徽省阜阳市颍州区清河东路973号', '13840175091', 2, '大型电池需上门搬运', NULL, '2025-02-08 09:16:01', '2025-02-09 14:16:01');
INSERT INTO `recycle_order` VALUES (160, 'BR20260203-U009-001', 9, 39, 39, '安徽省六安市裕安区梅山南路264号', '13726250333', 2, '请提前电话联系', NULL, '2026-02-03 16:12:33', '2026-02-04 01:12:33');
INSERT INTO `recycle_order` VALUES (161, 'BR20251228-U007-001', 7, 28, 469, '安徽省宿州市灵璧县汴河中路649号', '13494543927', 2, NULL, NULL, '2025-12-28 17:40:35', '2025-12-31 15:40:35');
INSERT INTO `recycle_order` VALUES (162, 'BR20220620-U117-001', 117, 16, 240, '安徽省亳州市蒙城县芍花路104号', '13694584467', 2, '工作日白天可上门', NULL, '2022-06-20 12:52:06', '2022-06-23 06:52:06');
INSERT INTO `recycle_order` VALUES (163, 'BR20260402-U047-001', 47, 48, 426, '安徽省合肥市庐阳区望江西路843号', '13091790931', 2, NULL, NULL, '2026-04-02 13:57:18', '2026-04-04 23:57:18');
INSERT INTO `recycle_order` VALUES (164, 'BR20250918-U055-001', 55, 11, 11, '安徽省阜阳市颍州区清河东路217号', '13142986481', 2, '大型电池需上门搬运', NULL, '2025-09-18 14:14:12', '2025-09-20 00:14:12');
INSERT INTO `recycle_order` VALUES (165, 'BR20250413-U182-001', 182, 10, 500, '安徽省阜阳市颍州区人民西路860号', '13353928189', 2, '电池已分类打包', NULL, '2025-04-13 15:04:02', '2025-04-14 07:04:02');
INSERT INTO `recycle_order` VALUES (166, 'BR20240911-U051-001', 51, 53, 462, '安徽省六安市金安区解放南路634号', '13897914174', 2, NULL, NULL, '2024-09-11 14:05:34', '2024-09-12 14:05:34');
INSERT INTO `recycle_order` VALUES (167, 'BR20251031-U092-001', 92, 28, 600, '安徽省阜阳市颍东区颍州南路579号', '13699962363', 2, NULL, NULL, '2025-10-31 12:45:28', '2025-11-02 09:45:28');
INSERT INTO `recycle_order` VALUES (168, 'BR20250308-U003-001', 3, 31, 390, '安徽省宿州市埇桥区银河一路920号', '13646860810', 2, '工作日白天可上门', NULL, '2025-03-08 12:45:25', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (169, 'BR20230913-U146-001', 146, 12, 180, '安徽省阜阳市颍东区人民西路318号', '13394734294', 2, '电池已分类打包', NULL, '2023-09-13 08:14:00', '2023-09-14 11:14:00');
INSERT INTO `recycle_order` VALUES (170, 'BR20250826-U050-001', 50, 44, 650, '安徽省阜阳市颍东区淮河路573号', '13942191368', 2, '请提前电话联系', NULL, '2025-08-26 17:58:53', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (171, 'BR20250126-U197-001', 197, 18, 90, '安徽省合肥市包河区望江西路996号', '13412148452', 2, '请提前电话联系', NULL, '2025-01-26 10:12:09', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (172, 'BR20221004-U010-001', 10, 2, 100, '安徽省六安市金安区长安路121号', '13750786108', 2, NULL, NULL, '2022-10-04 16:25:35', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (173, 'BR20221123-U028-001', 28, 18, 180, '安徽省合肥市庐阳区徽州大道304号', '13340284018', 2, '请提前电话联系', NULL, '2022-11-23 17:12:14', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (174, 'BR20250602-U134-001', 134, 18, 180, '安徽省亳州市谯城区药都路841号', '13342669264', 2, '电池已分类打包', NULL, '2025-06-02 14:08:38', '2025-06-05 09:08:38');
INSERT INTO `recycle_order` VALUES (175, 'BR20250402-U098-001', 98, 11, 230, '安徽省六安市金安区解放南路266号', '13195295608', 2, '工作日白天可上门', NULL, '2025-04-02 16:23:28', '2025-04-05 09:23:28');
INSERT INTO `recycle_order` VALUES (176, 'BR20250525-U063-001', 63, 10, 500, '安徽省阜阳市颍州区人民西路321号', '13675306081', 2, NULL, NULL, '2025-05-25 12:17:59', '2025-05-28 07:17:59');
INSERT INTO `recycle_order` VALUES (177, 'BR20260404-U180-001', 180, 46, 525, '安徽省六安市金安区皖西大道757号', '13607896175', 2, NULL, NULL, '2026-04-04 13:13:23', '2026-04-04 19:13:23');
INSERT INTO `recycle_order` VALUES (178, 'BR20240627-U124-001', 124, 28, 380, '安徽省六安市叶集区皖西大道997号', '13877900922', 2, '大型电池需上门搬运', NULL, '2024-06-27 11:23:50', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (179, 'BR20221116-U174-001', 174, 52, 885, '安徽省阜阳市颍州区清河东路811号', '13492329612', 2, '请提前电话联系', NULL, '2022-11-16 15:36:41', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (180, 'BR20251219-U146-001', 146, 69, 541, '安徽省合肥市包河区阜阳北路463号', '13719134022', 2, '大型电池需上门搬运', NULL, '2025-12-19 08:20:35', '2025-12-20 09:20:35');
INSERT INTO `recycle_order` VALUES (181, 'BR20241030-U177-001', 177, 22, 220, '安徽省合肥市瑶海区徽州大道197号', '13675326985', 2, '请提前电话联系', NULL, '2024-10-30 08:36:56', '2024-11-02 04:36:56');
INSERT INTO `recycle_order` VALUES (182, 'BR20251106-U169-001', 169, 15, 525, '安徽省宿州市灵璧县淮海北路430号', '13641751956', 2, '请提前电话联系', NULL, '2025-11-06 14:34:59', '2025-11-07 04:34:59');
INSERT INTO `recycle_order` VALUES (183, 'BR20250629-U061-001', 61, 9, 450, '安徽省阜阳市颍东区人民西路488号', '13887317060', 2, '请提前电话联系', NULL, '2025-06-29 08:33:45', '2025-07-02 07:33:45');
INSERT INTO `recycle_order` VALUES (184, 'BR20240912-U068-001', 68, 24, 640, '安徽省阜阳市颍东区颍州南路570号', '13517271969', 2, '请提前电话联系', NULL, '2024-09-12 12:19:08', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (185, 'BR20250314-U143-001', 143, 13, 210, '安徽省宿州市埇桥区银河一路740号', '13102528333', 2, '大型电池需上门搬运', NULL, '2025-03-14 14:47:54', '2025-03-16 09:47:54');
INSERT INTO `recycle_order` VALUES (186, 'BR20251204-U145-001', 145, 62, 725, '安徽省宿州市砀山县银河一路949号', '13672087539', 2, NULL, NULL, '2025-12-04 11:06:24', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (187, 'BR20250514-U021-001', 21, 34, 355, '安徽省合肥市包河区潜山路576号', '13752793591', 2, '电池已分类打包', NULL, '2025-05-14 11:36:59', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (188, 'BR20240304-U009-001', 9, 41, 610, '安徽省阜阳市颍州区人民西路908号', '13131610620', 2, NULL, NULL, '2024-03-04 14:50:09', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (189, 'BR20240917-U012-001', 12, 23, 340, '安徽省合肥市庐阳区潜山路992号', '13061109561', 2, '大型电池需上门搬运', NULL, '2024-09-17 08:58:46', '2024-09-18 19:58:46');
INSERT INTO `recycle_order` VALUES (190, 'BR20230904-U176-001', 176, 23, 205, '安徽省宿州市埇桥区汴河中路719号', '13952009117', 2, NULL, NULL, '2023-09-04 14:21:45', '2023-09-04 20:21:45');
INSERT INTO `recycle_order` VALUES (191, 'BR20240209-U188-001', 188, 30, 300, '安徽省合肥市庐阳区潜山路755号', '13687468625', 2, '电池已分类打包', NULL, '2024-02-09 15:15:10', '2024-02-10 15:15:10');
INSERT INTO `recycle_order` VALUES (192, 'BR20260119-U061-001', 61, 36, 600, '安徽省宿州市砀山县银河一路856号', '13868354529', 2, NULL, NULL, '2026-01-19 11:15:14', '2026-01-20 22:15:14');
INSERT INTO `recycle_order` VALUES (193, 'BR20260329-U168-001', 168, 30, 320, '安徽省六安市叶集区长安路989号', '13418490862', 2, '请提前电话联系', NULL, '2026-03-29 12:02:44', '2026-03-30 13:02:44');
INSERT INTO `recycle_order` VALUES (194, 'BR20250826-U123-001', 123, 14, 197, '安徽省阜阳市颍东区人民西路592号', '13416142622', 2, '工作日白天可上门', NULL, '2025-08-26 08:12:58', '2025-08-27 05:12:58');
INSERT INTO `recycle_order` VALUES (195, 'BR20240130-U120-001', 120, 34, 380, '安徽省六安市叶集区长安路976号', '13372099249', 2, NULL, NULL, '2024-01-30 10:50:35', '2024-02-01 14:50:35');
INSERT INTO `recycle_order` VALUES (196, 'BR20241123-U091-001', 91, 25, 125, '安徽省阜阳市颍泉区清河东路287号', '13601478295', 2, '大型电池需上门搬运', NULL, '2024-11-23 10:25:25', '2024-11-25 04:25:25');
INSERT INTO `recycle_order` VALUES (197, 'BR20250712-U029-001', 29, 53, 377, '安徽省阜阳市颍泉区淮河路997号', '13018434903', 2, '请提前电话联系', NULL, '2025-07-12 14:38:14', '2025-07-13 14:38:14');
INSERT INTO `recycle_order` VALUES (198, 'BR20240830-U153-001', 153, 45, 625, '安徽省宿州市灵璧县淮海北路623号', '13843927292', 2, '工作日白天可上门', NULL, '2024-08-30 10:29:32', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (199, 'BR20260405-U138-001', 138, 5, 75, '安徽省宿州市灵璧县银河一路551号', '13217844269', 2, NULL, NULL, '2026-04-05 12:28:04', '2026-04-07 14:28:04');
INSERT INTO `recycle_order` VALUES (200, 'BR20240309-U007-001', 7, 18, 90, '安徽省六安市裕安区长安路904号', '13846960040', 2, NULL, NULL, '2024-03-09 09:14:42', '2024-03-10 04:14:42');
INSERT INTO `recycle_order` VALUES (201, 'BR20250215-U050-001', 50, 38, 515, '安徽省亳州市蒙城县魏武大道689号', '13027625593', 2, '电池已分类打包', NULL, '2025-02-15 10:59:06', '2025-02-15 11:59:06');
INSERT INTO `recycle_order` VALUES (202, 'BR20251203-U097-001', 97, 46, 397, '安徽省合肥市瑶海区潜山路117号', '13170157602', 2, NULL, NULL, '2025-12-03 10:21:07', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (203, 'BR20230830-U110-001', 110, 30, 150, '安徽省合肥市庐阳区阜阳北路474号', '13652074991', 2, '请提前电话联系', NULL, '2023-08-30 13:59:09', '2023-08-31 22:59:09');
INSERT INTO `recycle_order` VALUES (204, 'BR20240918-U110-001', 110, 53, 595, '安徽省阜阳市颍泉区淮河路811号', '13119245536', 2, '电池已分类打包', NULL, '2024-09-18 11:23:03', '2024-09-20 11:23:03');
INSERT INTO `recycle_order` VALUES (205, 'BR20250124-U171-001', 171, 19, 190, '安徽省合肥市瑶海区阜阳北路602号', '13294821170', 2, NULL, NULL, '2025-01-24 16:06:57', '2025-01-25 07:06:57');
INSERT INTO `recycle_order` VALUES (206, 'BR20231212-U025-001', 25, 56, 655, '安徽省阜阳市颍东区颍州南路957号', '13726896444', 2, NULL, NULL, '2023-12-12 11:02:06', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (207, 'BR20250601-U081-001', 81, 55, 670, '安徽省亳州市涡阳县药都路759号', '13889056405', 2, '电池已分类打包', NULL, '2025-06-01 15:32:28', '2025-06-03 17:32:28');
INSERT INTO `recycle_order` VALUES (208, 'BR20251114-U035-001', 35, 23, 230, '安徽省阜阳市颍泉区人民西路299号', '13472995328', 2, NULL, NULL, '2025-11-14 17:17:32', '2025-11-15 05:17:32');
INSERT INTO `recycle_order` VALUES (209, 'BR20240208-U015-001', 15, 23, 345, '安徽省合肥市瑶海区望江西路132号', '13579577882', 2, NULL, NULL, '2024-02-08 17:30:39', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (210, 'BR20231018-U121-001', 121, 83, 820, '安徽省阜阳市颍东区人民西路848号', '13474161636', 2, NULL, NULL, '2023-10-18 10:38:36', '2023-10-19 14:38:36');
INSERT INTO `recycle_order` VALUES (211, 'BR20241112-U138-001', 138, 49, 765, '安徽省阜阳市颍州区淮河路776号', '13686371199', 2, '电池已分类打包', NULL, '2024-11-12 08:51:59', '2024-11-15 04:51:59');
INSERT INTO `recycle_order` VALUES (212, 'BR20260412-U193-001', 193, 11, 110, '安徽省合肥市瑶海区阜阳北路345号', '13686716953', 2, NULL, NULL, '2026-04-12 16:28:47', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (213, 'BR20251224-U192-001', 192, 21, 160, '安徽省阜阳市颍泉区颍州南路488号', '13858677605', 2, NULL, NULL, '2025-12-24 16:30:51', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (214, 'BR20220920-U148-001', 148, 41, 383, '安徽省六安市裕安区皖西大道348号', '13803617596', 2, '电池已分类打包', NULL, '2022-09-20 11:14:09', '2022-09-22 08:14:09');
INSERT INTO `recycle_order` VALUES (215, 'BR20260313-U014-001', 14, 6, 300, '安徽省合肥市蜀山区徽州大道340号', '13182622556', 2, '请提前电话联系', NULL, '2026-03-13 14:06:42', '2026-03-15 12:06:42');
INSERT INTO `recycle_order` VALUES (216, 'BR20251129-U017-001', 17, 33, 356, '安徽省阜阳市颍州区人民西路219号', '13765057598', 2, '工作日白天可上门', NULL, '2025-11-29 16:25:37', '2025-11-30 18:25:37');
INSERT INTO `recycle_order` VALUES (217, 'BR20230212-U061-001', 61, 16, 240, '安徽省合肥市庐阳区阜阳北路434号', '13128013141', 2, NULL, NULL, '2023-02-12 16:57:11', '2023-02-15 10:57:11');
INSERT INTO `recycle_order` VALUES (218, 'BR20260217-U183-001', 183, 39, 390, '安徽省合肥市瑶海区阜阳北路841号', '13563924024', 2, '大型电池需上门搬运', NULL, '2026-02-17 15:13:57', '2026-02-19 19:13:57');
INSERT INTO `recycle_order` VALUES (219, 'BR20221223-U127-001', 127, 19, 95, '安徽省合肥市包河区徽州大道613号', '13032540263', 2, '工作日白天可上门', NULL, '2022-12-23 15:42:25', '2022-12-25 11:42:25');
INSERT INTO `recycle_order` VALUES (220, 'BR20240112-U048-001', 48, 35, 630, '安徽省阜阳市颍州区颍州南路405号', '13301463878', 2, '工作日白天可上门', NULL, '2024-01-12 08:03:10', '2024-01-14 17:03:10');
INSERT INTO `recycle_order` VALUES (221, 'BR20230623-U037-001', 37, 17, 445, '安徽省合肥市庐阳区阜阳北路715号', '13767164280', 2, NULL, NULL, '2023-06-23 16:48:32', '2023-06-25 13:48:32');
INSERT INTO `recycle_order` VALUES (222, 'BR20251015-U134-001', 134, 38, 380, '安徽省合肥市庐阳区长江西路829号', '13784639970', 2, '工作日白天可上门', NULL, '2025-10-15 11:14:14', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (223, 'BR20221031-U119-001', 119, 16, 160, '安徽省宿州市砀山县银河一路242号', '13880740828', 2, NULL, NULL, '2022-10-31 13:35:18', '2022-11-01 23:35:18');
INSERT INTO `recycle_order` VALUES (224, 'BR20251016-U130-001', 130, 55, 626, '安徽省六安市裕安区长安路384号', '13254277376', 2, '大型电池需上门搬运', NULL, '2025-10-16 08:43:35', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (225, 'BR20240811-U043-001', 43, 28, 445, '安徽省亳州市蒙城县魏武大道243号', '13603248552', 2, NULL, NULL, '2024-08-11 10:14:33', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (226, 'BR20220729-U143-001', 143, 68, 810, '安徽省六安市叶集区解放南路913号', '13741535027', 2, NULL, NULL, '2022-07-29 10:34:00', '2022-08-01 03:34:00');
INSERT INTO `recycle_order` VALUES (227, 'BR20260305-U009-001', 9, 21, 210, '安徽省亳州市谯城区魏武大道321号', '13541596076', 2, NULL, NULL, '2026-03-05 11:59:53', '2026-03-06 06:59:53');
INSERT INTO `recycle_order` VALUES (228, 'BR20230311-U051-001', 51, 55, 415, '安徽省合肥市瑶海区阜阳北路113号', '13304611032', 2, '工作日白天可上门', NULL, '2023-03-11 11:11:53', '2023-03-13 03:11:53');
INSERT INTO `recycle_order` VALUES (229, 'BR20230915-U048-001', 48, 49, 420, '安徽省亳州市谯城区药都路972号', '13085724067', 2, NULL, NULL, '2023-09-15 10:19:43', '2023-09-16 22:19:43');
INSERT INTO `recycle_order` VALUES (230, 'BR20240809-U056-001', 56, 6, 30, '安徽省合肥市瑶海区长江西路127号', '13793947847', 2, NULL, NULL, '2024-08-09 15:58:37', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (231, 'BR20240927-U111-001', 111, 75, 700, '安徽省宿州市砀山县淮海北路760号', '13084771674', 2, '电池已分类打包', NULL, '2024-09-27 12:48:50', '2024-09-28 07:48:50');
INSERT INTO `recycle_order` VALUES (232, 'BR20250101-U069-001', 69, 70, 581, '安徽省合肥市瑶海区长江西路648号', '13991389418', 2, '请提前电话联系', NULL, '2025-01-01 11:34:57', '2025-01-02 14:34:57');
INSERT INTO `recycle_order` VALUES (233, 'BR20260329-U176-001', 176, 54, 650, '安徽省合肥市瑶海区徽州大道592号', '13864212377', 2, NULL, NULL, '2026-03-29 09:11:34', '2026-03-29 11:11:34');
INSERT INTO `recycle_order` VALUES (234, 'BR20260209-U173-001', 173, 49, 610, '安徽省阜阳市颍东区人民西路614号', '13161646098', 2, '请提前电话联系', NULL, '2026-02-09 09:38:45', '2026-02-10 00:38:45');
INSERT INTO `recycle_order` VALUES (235, 'BR20251113-U158-001', 158, 14, 140, '安徽省亳州市蒙城县希夷大道744号', '13047281441', 2, '请提前电话联系', NULL, '2025-11-13 10:30:54', '2025-11-14 07:30:54');
INSERT INTO `recycle_order` VALUES (236, 'BR20260322-U155-001', 155, 54, 510, '安徽省合肥市瑶海区望江西路441号', '13320407759', 2, '工作日白天可上门', NULL, '2026-03-22 17:39:18', '2026-03-25 12:39:18');
INSERT INTO `recycle_order` VALUES (237, 'BR20260408-U127-001', 127, 21, 315, '安徽省亳州市蒙城县芍花路205号', '13455502648', 2, NULL, NULL, '2026-04-08 15:57:36', '2026-04-09 10:57:36');
INSERT INTO `recycle_order` VALUES (238, 'BR20230917-U170-001', 170, 11, 235, '安徽省六安市叶集区皖西大道337号', '13253307791', 2, '工作日白天可上门', NULL, '2023-09-17 10:00:20', '2023-09-19 02:00:20');
INSERT INTO `recycle_order` VALUES (239, 'BR20241029-U041-001', 41, 13, 130, '安徽省合肥市蜀山区阜阳北路233号', '13106521715', 2, '请提前电话联系', NULL, '2024-10-29 10:39:34', '2024-11-01 00:39:34');
INSERT INTO `recycle_order` VALUES (240, 'BR20260322-U017-001', 17, 36, 36, '安徽省合肥市庐阳区望江西路622号', '13770690077', 2, '请提前电话联系', NULL, '2026-03-22 09:33:17', '2026-03-24 11:33:17');
INSERT INTO `recycle_order` VALUES (241, 'BR20260106-U199-001', 199, 9, 450, '安徽省亳州市蒙城县希夷大道491号', '13478664068', 2, '请提前电话联系', NULL, '2026-01-06 15:39:01', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (242, 'BR20250104-U044-001', 44, 75, 1120, '安徽省阜阳市颍泉区淮河路978号', '13195709180', 2, '请提前电话联系', NULL, '2025-01-04 09:40:58', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (243, 'BR20240323-U164-001', 164, 40, 530, '安徽省阜阳市颍东区清河东路339号', '13664546827', 2, NULL, NULL, '2024-03-23 15:08:26', '2024-03-24 04:08:26');
INSERT INTO `recycle_order` VALUES (244, 'BR20240703-U015-001', 15, 81, 459, '安徽省合肥市包河区徽州大道827号', '13027924307', 2, NULL, NULL, '2024-07-03 10:52:34', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (245, 'BR20260224-U151-001', 151, 49, 139, '安徽省合肥市蜀山区阜阳北路665号', '13457555820', 2, '工作日白天可上门', NULL, '2026-02-24 17:02:29', '2026-04-20 10:24:17');
INSERT INTO `recycle_order` VALUES (246, 'BR20260415-U056-001', 56, 57, 495, '安徽省宿州市砀山县银河一路306号', '13866053840', 2, NULL, NULL, '2026-04-15 11:56:33', '2026-04-16 23:56:33');
INSERT INTO `recycle_order` VALUES (247, 'BR20240404-U097-001', 97, 74, 550, '安徽省阜阳市颍泉区清河东路929号', '13522742460', 2, NULL, NULL, '2024-04-04 10:19:59', '2024-04-07 08:19:59');
INSERT INTO `recycle_order` VALUES (248, 'BR20250512-U105-001', 105, 16, 506, '安徽省合肥市蜀山区望江西路671号', '13681754011', 2, NULL, NULL, '2025-05-12 16:58:26', '2025-05-14 19:58:26');
INSERT INTO `recycle_order` VALUES (249, 'BR20231102-U155-001', 155, 32, 420, '安徽省六安市金安区长安路474号', '13490739817', 2, '电池已分类打包', NULL, '2023-11-02 13:28:33', '2023-11-05 00:28:33');
INSERT INTO `recycle_order` VALUES (250, 'BR20260204-U069-001', 69, 24, 360, '安徽省六安市金安区解放南路832号', '13561662796', 2, '大型电池需上门搬运', NULL, '2026-02-04 15:47:41', '2026-02-06 02:47:41');

-- ----------------------------
-- Table structure for seckill_activity
-- ----------------------------
DROP TABLE IF EXISTS `seckill_activity`;
CREATE TABLE `seckill_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动标题',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '活动说明',
  `stock` int NOT NULL DEFAULT 100 COMMENT '秒杀券库存',
  `sold` int NOT NULL DEFAULT 0 COMMENT '已售数量',
  `points_cost` int NOT NULL DEFAULT 500 COMMENT '秒杀所需积分',
  `start_time` datetime NOT NULL COMMENT '秒杀开始时间',
  `end_time` datetime NOT NULL COMMENT '秒杀结束时间',
  `coupon_start_time` datetime NOT NULL COMMENT '优惠券生效时间',
  `coupon_end_time` datetime NOT NULL COMMENT '优惠券过期时间',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-草稿，1-上架，2-下架，3-结束',
  `create_admin_id` bigint NOT NULL COMMENT '创建管理员ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_time`(`status` ASC, `start_time` ASC, `end_time` ASC) USING BTREE,
  INDEX `idx_create_admin`(`create_admin_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '秒杀活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seckill_activity
-- ----------------------------
INSERT INTO `seckill_activity` VALUES (1, '周末电池秒杀券', '一个用户仅可抢一张，抢到后第二天开始七天有效期，可兑换商城中任意商品', 100, 0, 500, '2026-06-10 00:00:00', '2026-06-11 00:00:00', '2026-06-12 00:00:00', '2026-06-18 00:00:00', 2, 1, '2026-06-10 18:56:07', '2026-07-28 10:40:09');

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `activity_id` bigint NULL DEFAULT NULL COMMENT '关联秒杀活动ID',
  `popup_start_time` datetime NOT NULL COMMENT '弹窗开始时间',
  `popup_end_time` datetime NOT NULL COMMENT '弹窗结束时间',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-草稿，1-已发布，2-已撤回',
  `create_admin_id` bigint NOT NULL COMMENT '创建管理员ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_time`(`status` ASC, `popup_start_time` ASC, `popup_end_time` ASC) USING BTREE,
  INDEX `idx_activity_id`(`activity_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统弹窗公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_notice
-- ----------------------------
INSERT INTO `system_notice` VALUES (1, '秒杀活动', '今天有个活动，100张券，抢完即止', 1, '2026-06-10 00:00:00', '2026-06-11 00:00:00', 1, 1, '2026-06-10 18:54:22', '2026-06-10 18:54:30');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像地址',
  `role` tinyint NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 206 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', '13800000000', 'admin@battery.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/2026-04-19/0a9caaa9-499c-4e6b-8c5e-d981065ee124.jpg', 1, 1, '2022-06-01 08:00:00', '2026-04-19 10:02:49');
INSERT INTO `user` VALUES (2, 'user001', 'e10adc3949ba59abbe56e057f20f883e', '用户001', '13100000001', 'user001@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-06-01 09:00:00', '2022-06-01 09:00:00');
INSERT INTO `user` VALUES (3, 'user002', 'e10adc3949ba59abbe56e057f20f883e', '用户002', '13100000002', 'user002@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-06-04 09:00:00', '2022-06-04 09:00:00');
INSERT INTO `user` VALUES (4, 'user003', 'e10adc3949ba59abbe56e057f20f883e', '用户003', '13100000003', 'user003@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-06-07 09:00:00', '2022-06-07 09:00:00');
INSERT INTO `user` VALUES (5, 'user004', 'e10adc3949ba59abbe56e057f20f883e', '用户004', '13100000004', 'user004@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-06-10 09:00:00', '2022-06-10 09:00:00');
INSERT INTO `user` VALUES (6, 'user005', 'e10adc3949ba59abbe56e057f20f883e', '用户005', '13100000005', 'user005@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-06-13 09:00:00', '2022-06-13 09:00:00');
INSERT INTO `user` VALUES (7, 'user006', 'e10adc3949ba59abbe56e057f20f883e', '用户006', '13100000006', 'user006@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-06-16 09:00:00', '2022-06-16 09:00:00');
INSERT INTO `user` VALUES (8, 'user007', 'e10adc3949ba59abbe56e057f20f883e', '用户007', '13100000007', 'user007@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-06-19 09:00:00', '2022-06-19 09:00:00');
INSERT INTO `user` VALUES (9, 'user008', 'e10adc3949ba59abbe56e057f20f883e', '用户008', '13100000008', 'user008@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-06-22 09:00:00', '2022-06-22 09:00:00');
INSERT INTO `user` VALUES (10, 'user009', 'e10adc3949ba59abbe56e057f20f883e', '用户009', '13100000009', 'user009@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-06-25 09:00:00', '2022-06-25 09:00:00');
INSERT INTO `user` VALUES (11, 'user010', 'e10adc3949ba59abbe56e057f20f883e', '用户010', '13100000010', 'user010@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-06-28 09:00:00', '2022-06-28 09:00:00');
INSERT INTO `user` VALUES (12, 'user011', 'e10adc3949ba59abbe56e057f20f883e', '用户011', '13100000011', 'user011@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-07-01 09:00:00', '2022-07-01 09:00:00');
INSERT INTO `user` VALUES (13, 'user012', 'e10adc3949ba59abbe56e057f20f883e', '用户012', '13100000012', 'user012@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-07-04 09:00:00', '2022-07-04 09:00:00');
INSERT INTO `user` VALUES (14, 'user013', 'e10adc3949ba59abbe56e057f20f883e', '用户013', '13100000013', 'user013@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-07-07 09:00:00', '2022-07-07 09:00:00');
INSERT INTO `user` VALUES (15, 'user014', 'e10adc3949ba59abbe56e057f20f883e', '用户014', '13100000014', 'user014@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-07-10 09:00:00', '2022-07-10 09:00:00');
INSERT INTO `user` VALUES (16, 'user015', 'e10adc3949ba59abbe56e057f20f883e', '用户015', '13100000015', 'user015@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-07-13 09:00:00', '2022-07-13 09:00:00');
INSERT INTO `user` VALUES (17, 'user016', 'e10adc3949ba59abbe56e057f20f883e', '用户016', '13100000016', 'user016@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-07-16 09:00:00', '2022-07-16 09:00:00');
INSERT INTO `user` VALUES (18, 'user017', 'e10adc3949ba59abbe56e057f20f883e', '用户017', '13100000017', 'user017@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-07-19 09:00:00', '2022-07-19 09:00:00');
INSERT INTO `user` VALUES (19, 'user018', 'e10adc3949ba59abbe56e057f20f883e', '用户018', '13100000018', 'user018@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-07-22 09:00:00', '2022-07-22 09:00:00');
INSERT INTO `user` VALUES (20, 'user019', 'e10adc3949ba59abbe56e057f20f883e', '用户019', '13100000019', 'user019@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-07-25 09:00:00', '2022-07-25 09:00:00');
INSERT INTO `user` VALUES (21, 'user020', 'e10adc3949ba59abbe56e057f20f883e', '用户020', '13100000020', 'user020@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-07-28 09:00:00', '2022-07-28 09:00:00');
INSERT INTO `user` VALUES (22, 'user021', 'e10adc3949ba59abbe56e057f20f883e', '用户021', '13100000021', 'user021@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-07-31 09:00:00', '2022-07-31 09:00:00');
INSERT INTO `user` VALUES (23, 'user022', 'e10adc3949ba59abbe56e057f20f883e', '用户022', '13100000022', 'user022@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-08-03 09:00:00', '2022-08-03 09:00:00');
INSERT INTO `user` VALUES (24, 'user023', 'e10adc3949ba59abbe56e057f20f883e', '用户023', '13100000023', 'user023@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-08-06 09:00:00', '2022-08-06 09:00:00');
INSERT INTO `user` VALUES (25, 'user024', 'e10adc3949ba59abbe56e057f20f883e', '用户024', '13100000024', 'user024@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-08-09 09:00:00', '2022-08-09 09:00:00');
INSERT INTO `user` VALUES (26, 'user025', 'e10adc3949ba59abbe56e057f20f883e', '用户025', '13100000025', 'user025@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-08-12 09:00:00', '2022-08-12 09:00:00');
INSERT INTO `user` VALUES (27, 'user026', 'e10adc3949ba59abbe56e057f20f883e', '用户026', '13100000026', 'user026@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-08-15 09:00:00', '2022-08-15 09:00:00');
INSERT INTO `user` VALUES (28, 'user027', 'e10adc3949ba59abbe56e057f20f883e', '用户027', '13100000027', 'user027@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-08-18 09:00:00', '2022-08-18 09:00:00');
INSERT INTO `user` VALUES (29, 'user028', 'e10adc3949ba59abbe56e057f20f883e', '用户028', '13100000028', 'user028@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-08-21 09:00:00', '2022-08-21 09:00:00');
INSERT INTO `user` VALUES (30, 'user029', 'e10adc3949ba59abbe56e057f20f883e', '用户029', '13100000029', 'user029@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-08-24 09:00:00', '2022-08-24 09:00:00');
INSERT INTO `user` VALUES (31, 'user030', 'e10adc3949ba59abbe56e057f20f883e', '用户030', '13100000030', 'user030@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-08-27 09:00:00', '2022-08-27 09:00:00');
INSERT INTO `user` VALUES (32, 'user031', 'e10adc3949ba59abbe56e057f20f883e', '用户031', '13100000031', 'user031@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-08-30 09:00:00', '2022-08-30 09:00:00');
INSERT INTO `user` VALUES (33, 'user032', 'e10adc3949ba59abbe56e057f20f883e', '用户032', '13100000032', 'user032@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-09-02 09:00:00', '2022-09-02 09:00:00');
INSERT INTO `user` VALUES (34, 'user033', 'e10adc3949ba59abbe56e057f20f883e', '用户033', '13100000033', 'user033@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-09-05 09:00:00', '2022-09-05 09:00:00');
INSERT INTO `user` VALUES (35, 'user034', 'e10adc3949ba59abbe56e057f20f883e', '用户034', '13100000034', 'user034@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-09-08 09:00:00', '2022-09-08 09:00:00');
INSERT INTO `user` VALUES (36, 'user035', 'e10adc3949ba59abbe56e057f20f883e', '用户035', '13100000035', 'user035@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-09-11 09:00:00', '2022-09-11 09:00:00');
INSERT INTO `user` VALUES (37, 'user036', 'e10adc3949ba59abbe56e057f20f883e', '用户036', '13100000036', 'user036@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-09-14 09:00:00', '2022-09-14 09:00:00');
INSERT INTO `user` VALUES (38, 'user037', 'e10adc3949ba59abbe56e057f20f883e', '用户037', '13100000037', 'user037@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-09-17 09:00:00', '2022-09-17 09:00:00');
INSERT INTO `user` VALUES (39, 'user038', 'e10adc3949ba59abbe56e057f20f883e', '用户038', '13100000038', 'user038@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-09-20 09:00:00', '2022-09-20 09:00:00');
INSERT INTO `user` VALUES (40, 'user039', 'e10adc3949ba59abbe56e057f20f883e', '用户039', '13100000039', 'user039@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-09-23 09:00:00', '2022-09-23 09:00:00');
INSERT INTO `user` VALUES (41, 'user040', 'e10adc3949ba59abbe56e057f20f883e', '用户040', '13100000040', 'user040@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-09-26 09:00:00', '2022-09-26 09:00:00');
INSERT INTO `user` VALUES (42, 'user041', 'e10adc3949ba59abbe56e057f20f883e', '用户041', '13100000041', 'user041@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-09-29 09:00:00', '2022-09-29 09:00:00');
INSERT INTO `user` VALUES (43, 'user042', 'e10adc3949ba59abbe56e057f20f883e', '用户042', '13100000042', 'user042@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-10-02 09:00:00', '2022-10-02 09:00:00');
INSERT INTO `user` VALUES (44, 'user043', 'e10adc3949ba59abbe56e057f20f883e', '用户043', '13100000043', 'user043@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-10-05 09:00:00', '2022-10-05 09:00:00');
INSERT INTO `user` VALUES (45, 'user044', 'e10adc3949ba59abbe56e057f20f883e', '用户044', '13100000044', 'user044@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-10-08 09:00:00', '2022-10-08 09:00:00');
INSERT INTO `user` VALUES (46, 'user045', 'e10adc3949ba59abbe56e057f20f883e', '用户045', '13100000045', 'user045@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-10-11 09:00:00', '2022-10-11 09:00:00');
INSERT INTO `user` VALUES (47, 'user046', 'e10adc3949ba59abbe56e057f20f883e', '用户046', '13100000046', 'user046@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-10-14 09:00:00', '2022-10-14 09:00:00');
INSERT INTO `user` VALUES (48, 'user047', 'e10adc3949ba59abbe56e057f20f883e', '用户047', '13100000047', 'user047@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-10-17 09:00:00', '2022-10-17 09:00:00');
INSERT INTO `user` VALUES (49, 'user048', 'e10adc3949ba59abbe56e057f20f883e', '用户048', '13100000048', 'user048@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-10-20 09:00:00', '2022-10-20 09:00:00');
INSERT INTO `user` VALUES (50, 'user049', 'e10adc3949ba59abbe56e057f20f883e', '用户049', '13100000049', 'user049@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-10-23 09:00:00', '2022-10-23 09:00:00');
INSERT INTO `user` VALUES (51, 'user050', 'e10adc3949ba59abbe56e057f20f883e', '用户050', '13100000050', 'user050@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-10-26 09:00:00', '2022-10-26 09:00:00');
INSERT INTO `user` VALUES (52, 'user051', 'e10adc3949ba59abbe56e057f20f883e', '用户051', '13100000051', 'user051@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-10-29 09:00:00', '2022-10-29 09:00:00');
INSERT INTO `user` VALUES (53, 'user052', 'e10adc3949ba59abbe56e057f20f883e', '用户052', '13100000052', 'user052@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-11-01 09:00:00', '2022-11-01 09:00:00');
INSERT INTO `user` VALUES (54, 'user053', 'e10adc3949ba59abbe56e057f20f883e', '用户053', '13100000053', 'user053@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-11-04 09:00:00', '2022-11-04 09:00:00');
INSERT INTO `user` VALUES (55, 'user054', 'e10adc3949ba59abbe56e057f20f883e', '用户054', '13100000054', 'user054@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-11-07 09:00:00', '2022-11-07 09:00:00');
INSERT INTO `user` VALUES (56, 'user055', 'e10adc3949ba59abbe56e057f20f883e', '用户055', '13100000055', 'user055@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-11-10 09:00:00', '2022-11-10 09:00:00');
INSERT INTO `user` VALUES (57, 'user056', 'e10adc3949ba59abbe56e057f20f883e', '用户056', '13100000056', 'user056@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-11-13 09:00:00', '2022-11-13 09:00:00');
INSERT INTO `user` VALUES (58, 'user057', 'e10adc3949ba59abbe56e057f20f883e', '用户057', '13100000057', 'user057@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-11-16 09:00:00', '2022-11-16 09:00:00');
INSERT INTO `user` VALUES (59, 'user058', 'e10adc3949ba59abbe56e057f20f883e', '用户058', '13100000058', 'user058@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-11-19 09:00:00', '2022-11-19 09:00:00');
INSERT INTO `user` VALUES (60, 'user059', 'e10adc3949ba59abbe56e057f20f883e', '用户059', '13100000059', 'user059@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-11-22 09:00:00', '2022-11-22 09:00:00');
INSERT INTO `user` VALUES (61, 'user060', 'e10adc3949ba59abbe56e057f20f883e', '用户060', '13100000060', 'user060@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-11-25 09:00:00', '2022-11-25 09:00:00');
INSERT INTO `user` VALUES (62, 'user061', 'e10adc3949ba59abbe56e057f20f883e', '用户061', '13100000061', 'user061@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2022-11-28 09:00:00', '2022-11-28 09:00:00');
INSERT INTO `user` VALUES (63, 'user062', 'e10adc3949ba59abbe56e057f20f883e', '用户062', '13100000062', 'user062@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2022-12-01 09:00:00', '2022-12-01 09:00:00');
INSERT INTO `user` VALUES (64, 'user063', 'e10adc3949ba59abbe56e057f20f883e', '用户063', '13100000063', 'user063@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2022-12-04 09:00:00', '2022-12-04 09:00:00');
INSERT INTO `user` VALUES (65, 'user064', 'e10adc3949ba59abbe56e057f20f883e', '用户064', '13100000064', 'user064@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2022-12-07 09:00:00', '2022-12-07 09:00:00');
INSERT INTO `user` VALUES (66, 'user065', 'e10adc3949ba59abbe56e057f20f883e', '用户065', '13100000065', 'user065@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2022-12-10 09:00:00', '2022-12-10 09:00:00');
INSERT INTO `user` VALUES (67, 'user066', 'e10adc3949ba59abbe56e057f20f883e', '用户066', '13100000066', 'user066@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2022-12-13 09:00:00', '2022-12-13 09:00:00');
INSERT INTO `user` VALUES (68, 'user067', 'e10adc3949ba59abbe56e057f20f883e', '用户067', '13100000067', 'user067@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2022-12-16 09:00:00', '2022-12-16 09:00:00');
INSERT INTO `user` VALUES (69, 'user068', 'e10adc3949ba59abbe56e057f20f883e', '用户068', '13100000068', 'user068@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2022-12-19 09:00:00', '2022-12-19 09:00:00');
INSERT INTO `user` VALUES (70, 'user069', 'e10adc3949ba59abbe56e057f20f883e', '用户069', '13100000069', 'user069@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2022-12-22 09:00:00', '2022-12-22 09:00:00');
INSERT INTO `user` VALUES (71, 'user070', 'e10adc3949ba59abbe56e057f20f883e', '用户070', '13100000070', 'user070@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2022-12-25 09:00:00', '2022-12-25 09:00:00');
INSERT INTO `user` VALUES (72, 'user071', 'e10adc3949ba59abbe56e057f20f883e', '用户071', '13100000071', 'user071@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2022-12-28 09:00:00', '2022-12-28 09:00:00');
INSERT INTO `user` VALUES (73, 'user072', 'e10adc3949ba59abbe56e057f20f883e', '用户072', '13100000072', 'user072@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2022-12-31 09:00:00', '2022-12-31 09:00:00');
INSERT INTO `user` VALUES (74, 'user073', 'e10adc3949ba59abbe56e057f20f883e', '用户073', '13100000073', 'user073@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-01-03 09:00:00', '2023-01-03 09:00:00');
INSERT INTO `user` VALUES (75, 'user074', 'e10adc3949ba59abbe56e057f20f883e', '用户074', '13100000074', 'user074@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-01-06 09:00:00', '2023-01-06 09:00:00');
INSERT INTO `user` VALUES (76, 'user075', 'e10adc3949ba59abbe56e057f20f883e', '用户075', '13100000075', 'user075@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-01-09 09:00:00', '2023-01-09 09:00:00');
INSERT INTO `user` VALUES (77, 'user076', 'e10adc3949ba59abbe56e057f20f883e', '用户076', '13100000076', 'user076@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-01-12 09:00:00', '2023-01-12 09:00:00');
INSERT INTO `user` VALUES (78, 'user077', 'e10adc3949ba59abbe56e057f20f883e', '用户077', '13100000077', 'user077@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-01-15 09:00:00', '2023-01-15 09:00:00');
INSERT INTO `user` VALUES (79, 'user078', 'e10adc3949ba59abbe56e057f20f883e', '用户078', '13100000078', 'user078@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-01-18 09:00:00', '2023-01-18 09:00:00');
INSERT INTO `user` VALUES (80, 'user079', 'e10adc3949ba59abbe56e057f20f883e', '用户079', '13100000079', 'user079@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-01-21 09:00:00', '2023-01-21 09:00:00');
INSERT INTO `user` VALUES (81, 'user080', 'e10adc3949ba59abbe56e057f20f883e', '用户080', '13100000080', 'user080@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-01-24 09:00:00', '2023-01-24 09:00:00');
INSERT INTO `user` VALUES (82, 'user081', 'e10adc3949ba59abbe56e057f20f883e', '用户081', '13100000081', 'user081@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-01-27 09:00:00', '2023-01-27 09:00:00');
INSERT INTO `user` VALUES (83, 'user082', 'e10adc3949ba59abbe56e057f20f883e', '用户082', '13100000082', 'user082@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-01-30 09:00:00', '2023-01-30 09:00:00');
INSERT INTO `user` VALUES (84, 'user083', 'e10adc3949ba59abbe56e057f20f883e', '用户083', '13100000083', 'user083@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-02-02 09:00:00', '2023-02-02 09:00:00');
INSERT INTO `user` VALUES (85, 'user084', 'e10adc3949ba59abbe56e057f20f883e', '用户084', '13100000084', 'user084@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-02-05 09:00:00', '2023-02-05 09:00:00');
INSERT INTO `user` VALUES (86, 'user085', 'e10adc3949ba59abbe56e057f20f883e', '用户085', '13100000085', 'user085@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-02-08 09:00:00', '2023-02-08 09:00:00');
INSERT INTO `user` VALUES (87, 'user086', 'e10adc3949ba59abbe56e057f20f883e', '用户086', '13100000086', 'user086@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-02-11 09:00:00', '2023-02-11 09:00:00');
INSERT INTO `user` VALUES (88, 'user087', 'e10adc3949ba59abbe56e057f20f883e', '用户087', '13100000087', 'user087@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-02-14 09:00:00', '2023-02-14 09:00:00');
INSERT INTO `user` VALUES (89, 'user088', 'e10adc3949ba59abbe56e057f20f883e', '用户088', '13100000088', 'user088@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-02-17 09:00:00', '2023-02-17 09:00:00');
INSERT INTO `user` VALUES (90, 'user089', 'e10adc3949ba59abbe56e057f20f883e', '用户089', '13100000089', 'user089@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-02-20 09:00:00', '2023-02-20 09:00:00');
INSERT INTO `user` VALUES (91, 'user090', 'e10adc3949ba59abbe56e057f20f883e', '用户090', '13100000090', 'user090@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-02-23 09:00:00', '2023-02-23 09:00:00');
INSERT INTO `user` VALUES (92, 'user091', 'e10adc3949ba59abbe56e057f20f883e', '用户091', '13100000091', 'user091@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-02-26 09:00:00', '2023-02-26 09:00:00');
INSERT INTO `user` VALUES (93, 'user092', 'e10adc3949ba59abbe56e057f20f883e', '用户092', '13100000092', 'user092@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-03-01 09:00:00', '2023-03-01 09:00:00');
INSERT INTO `user` VALUES (94, 'user093', 'e10adc3949ba59abbe56e057f20f883e', '用户093', '13100000093', 'user093@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-03-04 09:00:00', '2023-03-04 09:00:00');
INSERT INTO `user` VALUES (95, 'user094', 'e10adc3949ba59abbe56e057f20f883e', '用户094', '13100000094', 'user094@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-03-07 09:00:00', '2023-03-07 09:00:00');
INSERT INTO `user` VALUES (96, 'user095', 'e10adc3949ba59abbe56e057f20f883e', '用户095', '13100000095', 'user095@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-03-10 09:00:00', '2023-03-10 09:00:00');
INSERT INTO `user` VALUES (97, 'user096', 'e10adc3949ba59abbe56e057f20f883e', '用户096', '13100000096', 'user096@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-03-13 09:00:00', '2023-03-13 09:00:00');
INSERT INTO `user` VALUES (98, 'user097', 'e10adc3949ba59abbe56e057f20f883e', '用户097', '13100000097', 'user097@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-03-16 09:00:00', '2023-03-16 09:00:00');
INSERT INTO `user` VALUES (99, 'user098', 'e10adc3949ba59abbe56e057f20f883e', '用户098', '13100000098', 'user098@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-03-19 09:00:00', '2023-03-19 09:00:00');
INSERT INTO `user` VALUES (100, 'user099', 'e10adc3949ba59abbe56e057f20f883e', '用户099', '13100000099', 'user099@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-03-22 09:00:00', '2023-03-22 09:00:00');
INSERT INTO `user` VALUES (101, 'user100', 'e10adc3949ba59abbe56e057f20f883e', '用户100', '13100000100', 'user100@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-03-25 09:00:00', '2023-03-25 09:00:00');
INSERT INTO `user` VALUES (102, 'user101', 'e10adc3949ba59abbe56e057f20f883e', '用户101', '13100000101', 'user101@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-03-28 09:00:00', '2023-03-28 09:00:00');
INSERT INTO `user` VALUES (103, 'user102', 'e10adc3949ba59abbe56e057f20f883e', '用户102', '13100000102', 'user102@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-03-31 09:00:00', '2023-03-31 09:00:00');
INSERT INTO `user` VALUES (104, 'user103', 'e10adc3949ba59abbe56e057f20f883e', '用户103', '13100000103', 'user103@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-04-03 09:00:00', '2023-04-03 09:00:00');
INSERT INTO `user` VALUES (105, 'user104', 'e10adc3949ba59abbe56e057f20f883e', '用户104', '13100000104', 'user104@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-04-06 09:00:00', '2023-04-06 09:00:00');
INSERT INTO `user` VALUES (106, 'user105', 'e10adc3949ba59abbe56e057f20f883e', '用户105', '13100000105', 'user105@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-04-09 09:00:00', '2023-04-09 09:00:00');
INSERT INTO `user` VALUES (107, 'user106', 'e10adc3949ba59abbe56e057f20f883e', '用户106', '13100000106', 'user106@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-04-12 09:00:00', '2023-04-12 09:00:00');
INSERT INTO `user` VALUES (108, 'user107', 'e10adc3949ba59abbe56e057f20f883e', '用户107', '13100000107', 'user107@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-04-15 09:00:00', '2023-04-15 09:00:00');
INSERT INTO `user` VALUES (109, 'user108', 'e10adc3949ba59abbe56e057f20f883e', '用户108', '13100000108', 'user108@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-04-18 09:00:00', '2023-04-18 09:00:00');
INSERT INTO `user` VALUES (110, 'user109', 'e10adc3949ba59abbe56e057f20f883e', '用户109', '13100000109', 'user109@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-04-21 09:00:00', '2023-04-21 09:00:00');
INSERT INTO `user` VALUES (111, 'user110', 'e10adc3949ba59abbe56e057f20f883e', '用户110', '13100000110', 'user110@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-04-24 09:00:00', '2023-04-24 09:00:00');
INSERT INTO `user` VALUES (112, 'user111', 'e10adc3949ba59abbe56e057f20f883e', '用户111', '13100000111', 'user111@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-04-27 09:00:00', '2023-04-27 09:00:00');
INSERT INTO `user` VALUES (113, 'user112', 'e10adc3949ba59abbe56e057f20f883e', '用户112', '13100000112', 'user112@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-04-30 09:00:00', '2023-04-30 09:00:00');
INSERT INTO `user` VALUES (114, 'user113', 'e10adc3949ba59abbe56e057f20f883e', '用户113', '13100000113', 'user113@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-05-03 09:00:00', '2023-05-03 09:00:00');
INSERT INTO `user` VALUES (115, 'user114', 'e10adc3949ba59abbe56e057f20f883e', '用户114', '13100000114', 'user114@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-05-06 09:00:00', '2023-05-06 09:00:00');
INSERT INTO `user` VALUES (116, 'user115', 'e10adc3949ba59abbe56e057f20f883e', '用户115', '13100000115', 'user115@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-05-09 09:00:00', '2023-05-09 09:00:00');
INSERT INTO `user` VALUES (117, 'user116', 'e10adc3949ba59abbe56e057f20f883e', '用户116', '13100000116', 'user116@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-05-12 09:00:00', '2023-05-12 09:00:00');
INSERT INTO `user` VALUES (118, 'user117', 'e10adc3949ba59abbe56e057f20f883e', '用户117', '13100000117', 'user117@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-05-15 09:00:00', '2023-05-15 09:00:00');
INSERT INTO `user` VALUES (119, 'user118', 'e10adc3949ba59abbe56e057f20f883e', '用户118', '13100000118', 'user118@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-05-18 09:00:00', '2023-05-18 09:00:00');
INSERT INTO `user` VALUES (120, 'user119', 'e10adc3949ba59abbe56e057f20f883e', '用户119', '13100000119', 'user119@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-05-21 09:00:00', '2023-05-21 09:00:00');
INSERT INTO `user` VALUES (121, 'user120', 'e10adc3949ba59abbe56e057f20f883e', '用户120', '13100000120', 'user120@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-05-24 09:00:00', '2023-05-24 09:00:00');
INSERT INTO `user` VALUES (122, 'user121', 'e10adc3949ba59abbe56e057f20f883e', '用户121', '13100000121', 'user121@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-05-27 09:00:00', '2023-05-27 09:00:00');
INSERT INTO `user` VALUES (123, 'user122', 'e10adc3949ba59abbe56e057f20f883e', '用户122', '13100000122', 'user122@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-05-30 09:00:00', '2023-05-30 09:00:00');
INSERT INTO `user` VALUES (124, 'user123', 'e10adc3949ba59abbe56e057f20f883e', '用户123', '13100000123', 'user123@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-06-02 09:00:00', '2023-06-02 09:00:00');
INSERT INTO `user` VALUES (125, 'user124', 'e10adc3949ba59abbe56e057f20f883e', '用户124', '13100000124', 'user124@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-06-05 09:00:00', '2023-06-05 09:00:00');
INSERT INTO `user` VALUES (126, 'user125', 'e10adc3949ba59abbe56e057f20f883e', '用户125', '13100000125', 'user125@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-06-08 09:00:00', '2023-06-08 09:00:00');
INSERT INTO `user` VALUES (127, 'user126', 'e10adc3949ba59abbe56e057f20f883e', '用户126', '13100000126', 'user126@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-06-11 09:00:00', '2023-06-11 09:00:00');
INSERT INTO `user` VALUES (128, 'user127', 'e10adc3949ba59abbe56e057f20f883e', '用户127', '13100000127', 'user127@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-06-14 09:00:00', '2023-06-14 09:00:00');
INSERT INTO `user` VALUES (129, 'user128', 'e10adc3949ba59abbe56e057f20f883e', '用户128', '13100000128', 'user128@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-06-17 09:00:00', '2023-06-17 09:00:00');
INSERT INTO `user` VALUES (130, 'user129', 'e10adc3949ba59abbe56e057f20f883e', '用户129', '13100000129', 'user129@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-06-20 09:00:00', '2023-06-20 09:00:00');
INSERT INTO `user` VALUES (131, 'user130', 'e10adc3949ba59abbe56e057f20f883e', '用户130', '13100000130', 'user130@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-06-23 09:00:00', '2023-06-23 09:00:00');
INSERT INTO `user` VALUES (132, 'user131', 'e10adc3949ba59abbe56e057f20f883e', '用户131', '13100000131', 'user131@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-06-26 09:00:00', '2023-06-26 09:00:00');
INSERT INTO `user` VALUES (133, 'user132', 'e10adc3949ba59abbe56e057f20f883e', '用户132', '13100000132', 'user132@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-06-29 09:00:00', '2023-06-29 09:00:00');
INSERT INTO `user` VALUES (134, 'user133', 'e10adc3949ba59abbe56e057f20f883e', '用户133', '13100000133', 'user133@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-07-02 09:00:00', '2023-07-02 09:00:00');
INSERT INTO `user` VALUES (135, 'user134', 'e10adc3949ba59abbe56e057f20f883e', '用户134', '13100000134', 'user134@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-07-05 09:00:00', '2023-07-05 09:00:00');
INSERT INTO `user` VALUES (136, 'user135', 'e10adc3949ba59abbe56e057f20f883e', '用户135', '13100000135', 'user135@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-07-08 09:00:00', '2023-07-08 09:00:00');
INSERT INTO `user` VALUES (137, 'user136', 'e10adc3949ba59abbe56e057f20f883e', '用户136', '13100000136', 'user136@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-07-11 09:00:00', '2023-07-11 09:00:00');
INSERT INTO `user` VALUES (138, 'user137', 'e10adc3949ba59abbe56e057f20f883e', '用户137', '13100000137', 'user137@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-07-14 09:00:00', '2023-07-14 09:00:00');
INSERT INTO `user` VALUES (139, 'user138', 'e10adc3949ba59abbe56e057f20f883e', '用户138', '13100000138', 'user138@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-07-17 09:00:00', '2023-07-17 09:00:00');
INSERT INTO `user` VALUES (140, 'user139', 'e10adc3949ba59abbe56e057f20f883e', '用户139', '13100000139', 'user139@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-07-20 09:00:00', '2023-07-20 09:00:00');
INSERT INTO `user` VALUES (141, 'user140', 'e10adc3949ba59abbe56e057f20f883e', '用户140', '13100000140', 'user140@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-07-23 09:00:00', '2023-07-23 09:00:00');
INSERT INTO `user` VALUES (142, 'user141', 'e10adc3949ba59abbe56e057f20f883e', '用户141', '13100000141', 'user141@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-07-26 09:00:00', '2023-07-26 09:00:00');
INSERT INTO `user` VALUES (143, 'user142', 'e10adc3949ba59abbe56e057f20f883e', '用户142', '13100000142', 'user142@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-07-29 09:00:00', '2023-07-29 09:00:00');
INSERT INTO `user` VALUES (144, 'user143', 'e10adc3949ba59abbe56e057f20f883e', '用户143', '13100000143', 'user143@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-08-01 09:00:00', '2023-08-01 09:00:00');
INSERT INTO `user` VALUES (145, 'user144', 'e10adc3949ba59abbe56e057f20f883e', '用户144', '13100000144', 'user144@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-08-04 09:00:00', '2023-08-04 09:00:00');
INSERT INTO `user` VALUES (146, 'user145', 'e10adc3949ba59abbe56e057f20f883e', '用户145', '13100000145', 'user145@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-08-07 09:00:00', '2023-08-07 09:00:00');
INSERT INTO `user` VALUES (147, 'user146', 'e10adc3949ba59abbe56e057f20f883e', '用户146', '13100000146', 'user146@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-08-10 09:00:00', '2023-08-10 09:00:00');
INSERT INTO `user` VALUES (148, 'user147', 'e10adc3949ba59abbe56e057f20f883e', '用户147', '13100000147', 'user147@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-08-13 09:00:00', '2023-08-13 09:00:00');
INSERT INTO `user` VALUES (149, 'user148', 'e10adc3949ba59abbe56e057f20f883e', '用户148', '13100000148', 'user148@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-08-16 09:00:00', '2023-08-16 09:00:00');
INSERT INTO `user` VALUES (150, 'user149', 'e10adc3949ba59abbe56e057f20f883e', '用户149', '13100000149', 'user149@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-08-19 09:00:00', '2023-08-19 09:00:00');
INSERT INTO `user` VALUES (151, 'user150', 'e10adc3949ba59abbe56e057f20f883e', '用户150', '13100000150', 'user150@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-08-22 09:00:00', '2023-08-22 09:00:00');
INSERT INTO `user` VALUES (152, 'user151', 'e10adc3949ba59abbe56e057f20f883e', '用户151', '13100000151', 'user151@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-08-25 09:00:00', '2023-08-25 09:00:00');
INSERT INTO `user` VALUES (153, 'user152', 'e10adc3949ba59abbe56e057f20f883e', '用户152', '13100000152', 'user152@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-08-28 09:00:00', '2023-08-28 09:00:00');
INSERT INTO `user` VALUES (154, 'user153', 'e10adc3949ba59abbe56e057f20f883e', '用户153', '13100000153', 'user153@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-08-31 09:00:00', '2023-08-31 09:00:00');
INSERT INTO `user` VALUES (155, 'user154', 'e10adc3949ba59abbe56e057f20f883e', '用户154', '13100000154', 'user154@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-09-03 09:00:00', '2023-09-03 09:00:00');
INSERT INTO `user` VALUES (156, 'user155', 'e10adc3949ba59abbe56e057f20f883e', '用户155', '13100000155', 'user155@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-09-06 09:00:00', '2023-09-06 09:00:00');
INSERT INTO `user` VALUES (157, 'user156', 'e10adc3949ba59abbe56e057f20f883e', '用户156', '13100000156', 'user156@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-09-09 09:00:00', '2023-09-09 09:00:00');
INSERT INTO `user` VALUES (158, 'user157', 'e10adc3949ba59abbe56e057f20f883e', '用户157', '13100000157', 'user157@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-09-12 09:00:00', '2023-09-12 09:00:00');
INSERT INTO `user` VALUES (159, 'user158', 'e10adc3949ba59abbe56e057f20f883e', '用户158', '13100000158', 'user158@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-09-15 09:00:00', '2023-09-15 09:00:00');
INSERT INTO `user` VALUES (160, 'user159', 'e10adc3949ba59abbe56e057f20f883e', '用户159', '13100000159', 'user159@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-09-18 09:00:00', '2023-09-18 09:00:00');
INSERT INTO `user` VALUES (161, 'user160', 'e10adc3949ba59abbe56e057f20f883e', '用户160', '13100000160', 'user160@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-09-21 09:00:00', '2023-09-21 09:00:00');
INSERT INTO `user` VALUES (162, 'user161', 'e10adc3949ba59abbe56e057f20f883e', '用户161', '13100000161', 'user161@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-09-24 09:00:00', '2023-09-24 09:00:00');
INSERT INTO `user` VALUES (163, 'user162', 'e10adc3949ba59abbe56e057f20f883e', '用户162', '13100000162', 'user162@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-09-27 09:00:00', '2023-09-27 09:00:00');
INSERT INTO `user` VALUES (164, 'user163', 'e10adc3949ba59abbe56e057f20f883e', '用户163', '13100000163', 'user163@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-09-30 09:00:00', '2023-09-30 09:00:00');
INSERT INTO `user` VALUES (165, 'user164', 'e10adc3949ba59abbe56e057f20f883e', '用户164', '13100000164', 'user164@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-10-03 09:00:00', '2023-10-03 09:00:00');
INSERT INTO `user` VALUES (166, 'user165', 'e10adc3949ba59abbe56e057f20f883e', '用户165', '13100000165', 'user165@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-10-06 09:00:00', '2023-10-06 09:00:00');
INSERT INTO `user` VALUES (167, 'user166', 'e10adc3949ba59abbe56e057f20f883e', '用户166', '13100000166', 'user166@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-10-09 09:00:00', '2023-10-09 09:00:00');
INSERT INTO `user` VALUES (168, 'user167', 'e10adc3949ba59abbe56e057f20f883e', '用户167', '13100000167', 'user167@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-10-12 09:00:00', '2023-10-12 09:00:00');
INSERT INTO `user` VALUES (169, 'user168', 'e10adc3949ba59abbe56e057f20f883e', '用户168', '13100000168', 'user168@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-10-15 09:00:00', '2023-10-15 09:00:00');
INSERT INTO `user` VALUES (170, 'user169', 'e10adc3949ba59abbe56e057f20f883e', '用户169', '13100000169', 'user169@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-10-18 09:00:00', '2023-10-18 09:00:00');
INSERT INTO `user` VALUES (171, 'user170', 'e10adc3949ba59abbe56e057f20f883e', '用户170', '13100000170', 'user170@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-10-21 09:00:00', '2023-10-21 09:00:00');
INSERT INTO `user` VALUES (172, 'user171', 'e10adc3949ba59abbe56e057f20f883e', '用户171', '13100000171', 'user171@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-10-24 09:00:00', '2023-10-24 09:00:00');
INSERT INTO `user` VALUES (173, 'user172', 'e10adc3949ba59abbe56e057f20f883e', '用户172', '13100000172', 'user172@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-10-27 09:00:00', '2023-10-27 09:00:00');
INSERT INTO `user` VALUES (174, 'user173', 'e10adc3949ba59abbe56e057f20f883e', '用户173', '13100000173', 'user173@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-10-30 09:00:00', '2023-10-30 09:00:00');
INSERT INTO `user` VALUES (175, 'user174', 'e10adc3949ba59abbe56e057f20f883e', '用户174', '13100000174', 'user174@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-11-02 09:00:00', '2023-11-02 09:00:00');
INSERT INTO `user` VALUES (176, 'user175', 'e10adc3949ba59abbe56e057f20f883e', '用户175', '13100000175', 'user175@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-11-05 09:00:00', '2023-11-05 09:00:00');
INSERT INTO `user` VALUES (177, 'user176', 'e10adc3949ba59abbe56e057f20f883e', '用户176', '13100000176', 'user176@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-11-08 09:00:00', '2023-11-08 09:00:00');
INSERT INTO `user` VALUES (178, 'user177', 'e10adc3949ba59abbe56e057f20f883e', '用户177', '13100000177', 'user177@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-11-11 09:00:00', '2023-11-11 09:00:00');
INSERT INTO `user` VALUES (179, 'user178', 'e10adc3949ba59abbe56e057f20f883e', '用户178', '13100000178', 'user178@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-11-14 09:00:00', '2023-11-14 09:00:00');
INSERT INTO `user` VALUES (180, 'user179', 'e10adc3949ba59abbe56e057f20f883e', '用户179', '13100000179', 'user179@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-11-17 09:00:00', '2023-11-17 09:00:00');
INSERT INTO `user` VALUES (181, 'user180', 'e10adc3949ba59abbe56e057f20f883e', '用户180', '13100000180', 'user180@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-11-20 09:00:00', '2023-11-20 09:00:00');
INSERT INTO `user` VALUES (182, 'user181', 'e10adc3949ba59abbe56e057f20f883e', '用户181', '13100000181', 'user181@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-11-23 09:00:00', '2023-11-23 09:00:00');
INSERT INTO `user` VALUES (183, 'user182', 'e10adc3949ba59abbe56e057f20f883e', '用户182', '13100000182', 'user182@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2023-11-26 09:00:00', '2023-11-26 09:00:00');
INSERT INTO `user` VALUES (184, 'user183', 'e10adc3949ba59abbe56e057f20f883e', '用户183', '13100000183', 'user183@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2023-11-29 09:00:00', '2023-11-29 09:00:00');
INSERT INTO `user` VALUES (185, 'user184', 'e10adc3949ba59abbe56e057f20f883e', '用户184', '13100000184', 'user184@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2023-12-02 09:00:00', '2023-12-02 09:00:00');
INSERT INTO `user` VALUES (186, 'user185', 'e10adc3949ba59abbe56e057f20f883e', '用户185', '13100000185', 'user185@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2023-12-05 09:00:00', '2023-12-05 09:00:00');
INSERT INTO `user` VALUES (187, 'user186', 'e10adc3949ba59abbe56e057f20f883e', '用户186', '13100000186', 'user186@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2023-12-08 09:00:00', '2023-12-08 09:00:00');
INSERT INTO `user` VALUES (188, 'user187', 'e10adc3949ba59abbe56e057f20f883e', '用户187', '13100000187', 'user187@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-07.png', 0, 1, '2023-12-11 09:00:00', '2023-12-11 09:00:00');
INSERT INTO `user` VALUES (189, 'user188', 'e10adc3949ba59abbe56e057f20f883e', '用户188', '13100000188', 'user188@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-08.png', 0, 1, '2023-12-14 09:00:00', '2023-12-14 09:00:00');
INSERT INTO `user` VALUES (190, 'user189', 'e10adc3949ba59abbe56e057f20f883e', '用户189', '13100000189', 'user189@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-09.png', 0, 1, '2023-12-17 09:00:00', '2023-12-17 09:00:00');
INSERT INTO `user` VALUES (191, 'user190', 'e10adc3949ba59abbe56e057f20f883e', '用户190', '13100000190', 'user190@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-10.png', 0, 1, '2023-12-20 09:00:00', '2023-12-20 09:00:00');
INSERT INTO `user` VALUES (192, 'user191', 'e10adc3949ba59abbe56e057f20f883e', '用户191', '13100000191', 'user191@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-11.png', 0, 1, '2023-12-23 09:00:00', '2023-12-23 09:00:00');
INSERT INTO `user` VALUES (193, 'user192', 'e10adc3949ba59abbe56e057f20f883e', '用户192', '13100000192', 'user192@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-12.png', 0, 1, '2023-12-26 09:00:00', '2023-12-26 09:00:00');
INSERT INTO `user` VALUES (194, 'user193', 'e10adc3949ba59abbe56e057f20f883e', '用户193', '13100000193', 'user193@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-01.png', 0, 1, '2023-12-29 09:00:00', '2023-12-29 09:00:00');
INSERT INTO `user` VALUES (195, 'user194', 'e10adc3949ba59abbe56e057f20f883e', '用户194', '13100000194', 'user194@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-02.png', 0, 1, '2024-01-01 09:00:00', '2024-01-01 09:00:00');
INSERT INTO `user` VALUES (196, 'user195', 'e10adc3949ba59abbe56e057f20f883e', '用户195', '13100000195', 'user195@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-03.png', 0, 1, '2024-01-04 09:00:00', '2024-01-04 09:00:00');
INSERT INTO `user` VALUES (197, 'user196', 'e10adc3949ba59abbe56e057f20f883e', '用户196', '13100000196', 'user196@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-04.png', 0, 1, '2024-01-07 09:00:00', '2024-01-07 09:00:00');
INSERT INTO `user` VALUES (198, 'user197', 'e10adc3949ba59abbe56e057f20f883e', '用户197', '13100000197', 'user197@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-05.png', 0, 1, '2024-01-10 09:00:00', '2024-01-10 09:00:00');
INSERT INTO `user` VALUES (199, 'user198', 'e10adc3949ba59abbe56e057f20f883e', '用户198', '13100000198', 'user198@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-06.png', 0, 1, '2024-01-13 09:00:00', '2024-01-13 09:00:00');
INSERT INTO `user` VALUES (200, 'user199', 'e10adc3949ba59abbe56e057f20f883e', '用户199', '13100000199', 'user199@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/2026-04-20/ae6d37b3-349a-4e43-919a-34309cd44c3f.jpg', 0, 1, '2024-01-16 09:00:00', '2026-04-20 08:27:06');
INSERT INTO `user` VALUES (201, 'user200', 'e10adc3949ba59abbe56e057f20f883e', '用户200', '13100000200', 'user200@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/2026-06-05/9de50fc8-09ee-4362-b588-1b58151dcf57.jpg', 0, 1, '2024-01-19 09:00:00', '2026-08-11 22:00:24');
INSERT INTO `user` VALUES (202, 'user201', 'e10adc3949ba59abbe56e057f20f883e', '用户201', '13100000201', 'user201@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/2026-04-19/76de0500-2900-4eca-a641-5ab62cc0483b.jpg', 0, 1, '2026-04-19 10:03:52', '2026-04-20 14:51:01');
INSERT INTO `user` VALUES (203, 'user202', 'e10adc3949ba59abbe56e057f20f883e', '用户202', '13100000202', 'user202@example.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/2026-05-13/4cc44448-373f-4975-a915-84a9a2be1f9b.jpg', 0, 1, '2026-05-13 19:11:20', '2026-05-13 19:16:25');
INSERT INTO `user` VALUES (205, 'user203', 'e10adc3949ba59abbe56e057f20f883e', 'aa', '13100000203', NULL, NULL, 0, 1, '2026-07-09 14:52:09', '2026-07-09 14:52:09');

-- ----------------------------
-- Table structure for user_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `user_notice_read`;
CREATE TABLE `user_notice_read`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `read_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '已读时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_notice_user`(`notice_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户公告已读表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_notice_read
-- ----------------------------
INSERT INTO `user_notice_read` VALUES (1, 1, 201, '2026-06-10 18:54:34');
INSERT INTO `user_notice_read` VALUES (2, 1, 202, '2026-06-10 19:10:36');

-- ----------------------------
-- Table structure for user_points
-- ----------------------------
DROP TABLE IF EXISTS `user_points`;
CREATE TABLE `user_points`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_points` int NOT NULL DEFAULT 0 COMMENT '总积分',
  `available_points` int NOT NULL DEFAULT 0 COMMENT '可用积分',
  `used_points` int NOT NULL DEFAULT 0 COMMENT '已使用积分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 258 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户积分表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_points
-- ----------------------------
INSERT INTO `user_points` VALUES (1, 1, 0, 0, 0, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (2, 2, 66300, 66038, 262, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (3, 3, 73444, 71420, 2024, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (4, 4, 66027, 61689, 4338, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (5, 5, 66176, 65560, 616, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (6, 6, 64566, 64500, 66, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (7, 7, 70517, 67036, 3481, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (8, 8, 61062, 58852, 2210, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (9, 9, 59375, 58770, 605, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (10, 10, 80530, 79133, 1397, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (11, 11, 64630, 64459, 171, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (12, 12, 75905, 74240, 1665, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (13, 13, 68303, 65493, 2810, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (14, 14, 79919, 75863, 4056, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (15, 15, 71999, 70147, 1852, '2026-04-19 09:37:24', '2026-04-20 08:22:02');
INSERT INTO `user_points` VALUES (16, 16, 67417, 65326, 2091, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (17, 17, 61339, 56437, 4902, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (18, 18, 54509, 51274, 3235, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (19, 19, 72857, 71388, 1469, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (20, 20, 80061, 77418, 2643, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (21, 21, 69589, 65782, 3807, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (22, 22, 69563, 68457, 1106, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (23, 23, 73433, 69321, 4112, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (24, 24, 61366, 59126, 2240, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (25, 25, 68398, 64531, 3867, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (26, 26, 58240, 55625, 2615, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (27, 27, 51647, 50171, 1476, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (28, 28, 62878, 58344, 4534, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (29, 29, 60304, 57063, 3241, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (30, 30, 61941, 59335, 2606, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (31, 31, 70189, 66882, 3307, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (32, 32, 68245, 64529, 3716, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (33, 33, 67298, 63636, 3662, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (34, 34, 69000, 66841, 2159, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (35, 35, 65582, 60769, 4813, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (36, 36, 68331, 65745, 2586, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (37, 37, 74747, 71255, 3492, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (38, 38, 65089, 60387, 4702, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (39, 39, 71550, 68516, 3034, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (40, 40, 71470, 70405, 1065, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (41, 41, 76242, 75017, 1225, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (42, 42, 63470, 60539, 2931, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (43, 43, 64211, 63233, 978, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (44, 44, 58635, 57537, 1098, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (45, 45, 79418, 76862, 2556, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (46, 46, 60215, 55729, 4486, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (47, 47, 63610, 58845, 4765, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (48, 48, 59828, 59461, 367, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (49, 49, 71234, 68695, 2539, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (50, 50, 59233, 57638, 1595, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (51, 51, 61277, 60917, 360, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (52, 52, 65237, 63222, 2015, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (53, 53, 73410, 69415, 3995, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (54, 54, 73390, 69460, 3930, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (55, 55, 81549, 78883, 2666, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (56, 56, 68133, 66593, 1540, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (57, 57, 59035, 54333, 4702, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (58, 58, 62687, 58796, 3891, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (59, 59, 69327, 68977, 350, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (60, 60, 69949, 69870, 79, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (61, 61, 56647, 52302, 4345, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (62, 62, 64011, 62523, 1488, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (63, 63, 79724, 75318, 4406, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (64, 64, 72951, 70385, 2566, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (65, 65, 64291, 59679, 4612, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (66, 66, 72482, 72120, 362, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (67, 67, 71349, 68374, 2975, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (68, 68, 61783, 57991, 3792, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (69, 69, 62665, 62633, 32, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (70, 70, 73610, 69824, 3786, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (71, 71, 63557, 59721, 3836, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (72, 72, 71613, 68794, 2819, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (73, 73, 67084, 64493, 2591, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (74, 74, 66227, 61732, 4495, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (75, 75, 77037, 72331, 4706, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (76, 76, 69191, 69148, 43, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (77, 77, 77835, 76736, 1099, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (78, 78, 80519, 80154, 365, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (79, 79, 63232, 59702, 3530, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (80, 80, 67204, 65647, 1557, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (81, 81, 69500, 67307, 2193, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (82, 82, 60666, 59372, 1294, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (83, 83, 74560, 69668, 4892, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (84, 84, 69065, 68486, 579, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (85, 85, 68728, 65508, 3220, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (86, 86, 80532, 76169, 4363, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (87, 87, 67621, 65465, 2156, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (88, 88, 76118, 73426, 2692, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (89, 89, 78530, 76539, 1991, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (90, 90, 71798, 69919, 1879, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (91, 91, 75613, 72190, 3423, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (92, 92, 71502, 70024, 1478, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (93, 93, 69423, 67302, 2121, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (94, 94, 74362, 73191, 1171, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (95, 95, 75417, 70924, 4493, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (96, 96, 64833, 60878, 3955, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (97, 97, 62014, 60721, 1293, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (98, 98, 59499, 54896, 4603, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (99, 99, 73723, 69586, 4137, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (100, 100, 81017, 79142, 1875, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (101, 101, 72639, 70674, 1965, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (102, 102, 72261, 68060, 4201, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (103, 103, 68513, 68403, 110, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (104, 104, 66368, 63422, 2946, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (105, 105, 72165, 67762, 4403, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (106, 106, 69754, 66579, 3175, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (107, 107, 66820, 64155, 2665, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (108, 108, 70884, 67080, 3804, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (109, 109, 73482, 72456, 1026, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (110, 110, 60253, 56536, 3717, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (111, 111, 67511, 67004, 507, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (112, 112, 68515, 67130, 1385, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (113, 113, 64034, 63631, 403, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (114, 114, 60085, 57223, 2862, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (115, 115, 73093, 69993, 3100, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (116, 116, 71953, 70039, 1914, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (117, 117, 58678, 58409, 269, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (118, 118, 63769, 63162, 607, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (119, 119, 76156, 73930, 2226, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (120, 120, 63687, 59376, 4311, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (121, 121, 62424, 57548, 4876, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (122, 122, 70496, 69047, 1449, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (123, 123, 67626, 65010, 2616, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (124, 124, 64690, 60955, 3735, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (125, 125, 65403, 64577, 826, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (126, 126, 70458, 67533, 2925, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (127, 127, 66247, 64097, 2150, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (128, 128, 66727, 64752, 1975, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (129, 129, 71422, 67997, 3425, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (130, 130, 81459, 80259, 1200, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (131, 131, 78959, 78235, 724, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (132, 132, 65237, 65214, 23, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (133, 133, 67100, 64157, 2943, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (134, 134, 70627, 65981, 4646, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (135, 135, 62405, 58002, 4403, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (136, 136, 75067, 71989, 3078, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (137, 137, 70733, 68551, 2182, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (138, 138, 68836, 67162, 1674, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (139, 139, 82478, 80651, 1827, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (140, 140, 63597, 59483, 4114, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (141, 141, 76314, 76225, 89, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (142, 142, 67044, 63942, 3102, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (143, 143, 61866, 61623, 243, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (144, 144, 67288, 65376, 1912, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (145, 145, 59976, 56146, 3830, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (146, 146, 70967, 67554, 3413, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (147, 147, 59072, 58495, 577, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (148, 148, 57083, 54438, 2645, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (149, 149, 68615, 67119, 1496, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (150, 150, 66061, 61516, 4545, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (151, 151, 62095, 58859, 3236, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (152, 152, 61709, 59163, 2546, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (153, 153, 66111, 63086, 3025, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (154, 154, 74885, 72399, 2486, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (155, 155, 60974, 57619, 3355, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (156, 156, 61234, 56917, 4317, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (157, 157, 69855, 68333, 1522, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (158, 158, 67142, 62481, 4661, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (159, 159, 70953, 67216, 3737, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (160, 160, 71867, 67163, 4704, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (161, 161, 76835, 74525, 2310, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (162, 162, 72456, 70018, 2438, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (163, 163, 77646, 77384, 262, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (164, 164, 70996, 66999, 3997, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (165, 165, 60916, 56718, 4198, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (166, 166, 81707, 77706, 4001, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (167, 167, 76672, 74260, 2412, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (168, 168, 69450, 69392, 58, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (169, 169, 66623, 63569, 3054, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (170, 170, 76377, 76282, 95, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (171, 171, 71858, 70545, 1313, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (172, 172, 70649, 69367, 1282, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (173, 173, 80063, 77591, 2472, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (174, 174, 69774, 66262, 3512, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (175, 175, 72072, 71927, 145, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (176, 176, 61639, 61447, 192, '2026-04-19 09:37:24', '2026-04-20 08:22:05');
INSERT INTO `user_points` VALUES (177, 177, 65008, 64484, 524, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (178, 178, 58486, 56440, 2046, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (179, 179, 71265, 67608, 3657, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (180, 180, 71983, 69837, 2146, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (181, 181, 80701, 75941, 4760, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (182, 182, 85269, 82906, 2363, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (183, 183, 64113, 61578, 2535, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (184, 184, 74623, 74034, 589, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (185, 185, 68752, 68413, 339, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (186, 186, 63301, 58373, 4928, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (187, 187, 70709, 67084, 3625, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (188, 188, 56752, 53412, 3340, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (189, 189, 74899, 74072, 827, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (190, 190, 68932, 64817, 4115, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (191, 191, 65867, 62773, 3094, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (192, 192, 67796, 64671, 3125, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (193, 193, 63492, 62149, 1343, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (194, 194, 68771, 66431, 2340, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (195, 195, 72649, 69978, 2671, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (196, 196, 65435, 64100, 1335, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (197, 197, 63155, 59491, 3664, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (198, 198, 85099, 80785, 4314, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (199, 199, 67291, 66713, 578, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (200, 200, 59118, 54169, 4949, '2026-04-19 09:37:24', '2026-04-19 09:37:24');
INSERT INTO `user_points` VALUES (201, 201, 68336, 64824, 3512, '2026-04-19 09:37:24', '2026-06-10 18:56:39');
INSERT INTO `user_points` VALUES (256, 202, 2865, 1865, 1000, '2026-04-19 16:53:52', '2026-05-11 21:32:08');
INSERT INTO `user_points` VALUES (257, 203, 4950, 1950, 3000, '2026-05-13 19:12:05', '2026-05-15 09:05:41');

-- ----------------------------
-- Table structure for user_seckill_coupon
-- ----------------------------
DROP TABLE IF EXISTS `user_seckill_coupon`;
CREATE TABLE `user_seckill_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户券ID',
  `activity_id` bigint NOT NULL COMMENT '秒杀活动ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-未使用，1-已使用，2-已过期',
  `effective_time` datetime NOT NULL COMMENT '生效时间',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `used_product_id` bigint NULL DEFAULT NULL COMMENT '使用时兑换的商品ID',
  `used_exchange_record_id` bigint NULL DEFAULT NULL COMMENT '使用时生成的兑换记录ID',
  `used_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_activity_user`(`activity_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_user_status`(`user_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_expire_time`(`expire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户秒杀券表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_seckill_coupon
-- ----------------------------
INSERT INTO `user_seckill_coupon` VALUES (1, 1, 201, 1, '2026-06-12 00:00:00', '2026-06-18 00:00:00', 10, 5, '2026-06-14 13:57:46', '2026-06-10 18:56:39', '2026-06-14 13:57:46');

-- ----------------------------
-- View structure for view_order_detail
-- ----------------------------
DROP VIEW IF EXISTS `view_order_detail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_order_detail` AS select `ro`.`id` AS `order_id`,`ro`.`order_number` AS `order_number`,`ro`.`user_id` AS `user_id`,`u`.`username` AS `username`,`u`.`nickname` AS `nickname`,`ro`.`total_count` AS `total_count`,`ro`.`total_points` AS `total_points`,`ro`.`recycle_address` AS `recycle_address`,`ro`.`contact_phone` AS `contact_phone`,`ro`.`order_status` AS `order_status`,`ro`.`remark` AS `remark`,`ro`.`create_time` AS `create_time`,`ro`.`update_time` AS `update_time` from (`recycle_order` `ro` left join `user` `u` on((`ro`.`user_id` = `u`.`id`)));

-- ----------------------------
-- View structure for view_recycle_detail
-- ----------------------------
DROP VIEW IF EXISTS `view_recycle_detail`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_recycle_detail` AS select `rd`.`id` AS `detail_id`,`rd`.`order_id` AS `order_id`,`ro`.`order_number` AS `order_number`,`rd`.`battery_type_id` AS `battery_type_id`,`bt`.`type_name` AS `battery_type_name`,`rd`.`battery_count` AS `battery_count`,`rd`.`points` AS `points`,`rd`.`create_time` AS `create_time` from ((`recycle_detail` `rd` left join `recycle_order` `ro` on((`rd`.`order_id` = `ro`.`id`))) left join `battery_type` `bt` on((`rd`.`battery_type_id` = `bt`.`id`)));

SET FOREIGN_KEY_CHECKS = 1;
