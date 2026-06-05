-- ============================================
-- 智能化废电池回收系统模拟数据库（增强版）
-- 数据库名：battery_recycle_system_1
-- 说明：
-- 1. 保持与原库相同的核心表结构
-- 2. 新增“其他电池”类型，积分按重量计算：100克=1分（映射到battery_count的100克单位数）
-- 3. 生成 50000 条订单，时间范围 2022-06-01 ~ 2026-04-17
-- 4. 地址限定安徽省内，精确到路/号
-- 5. 订单趋势逐年增长
-- 6. 订单编号格式：BR + 日期 + - + 用户标识 + - + 当日序号
-- 7. 地区排行固定前五城市导向：合肥、阜阳、宿州、亳州、六安
-- ============================================

DROP DATABASE IF EXISTS battery_recycle_system_1;
CREATE DATABASE battery_recycle_system_1 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE battery_recycle_system_1;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` VARCHAR(255) DEFAULT NULL COMMENT '头像地址',
  `role` TINYINT NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

CREATE TABLE `battery_type` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '电池种类ID',
  `type_name` VARCHAR(50) NOT NULL COMMENT '电池种类名称',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '种类描述',
  `icon` VARCHAR(255) DEFAULT NULL COMMENT '图标地址',
  `identification_guide` TEXT COMMENT '如何识别该类型电池的指南',
  `points` INT NOT NULL DEFAULT 0 COMMENT '回收积分（每个电池可获得的积分）',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='电池种类表';

CREATE TABLE `recycle_order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_number` VARCHAR(50) NOT NULL COMMENT '订单编号',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `total_count` INT NOT NULL DEFAULT 0 COMMENT '回收电池总数量',
  `total_points` INT NOT NULL DEFAULT 0 COMMENT '获得总积分',
  `recycle_address` VARCHAR(255) DEFAULT NULL COMMENT '回收地址',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `order_status` TINYINT NOT NULL DEFAULT 0 COMMENT '订单状态：0-待处理，1-处理中，2-已完成，3-已取消',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_number` (`order_number`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status` (`order_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回收订单表';

CREATE TABLE `recycle_detail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `battery_type_id` BIGINT NOT NULL COMMENT '电池种类ID',
  `battery_count` INT NOT NULL DEFAULT 0 COMMENT '电池数量',
  `points` INT NOT NULL DEFAULT 0 COMMENT '获得积分',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_battery_type` (`battery_type_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='回收明细表';

CREATE TABLE `exchange_product` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `product_name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `brand` VARCHAR(50) NOT NULL COMMENT '品牌',
  `battery_model` VARCHAR(50) NOT NULL COMMENT '电池型号（5号/7号）',
  `points_required` INT NOT NULL DEFAULT 1000 COMMENT '所需积分',
  `stock` INT NOT NULL DEFAULT 0 COMMENT '库存数量',
  `image_url` VARCHAR(255) DEFAULT NULL COMMENT '商品图片',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '商品描述',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_brand` (`brand`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='可兑换电池商品表';

CREATE TABLE `exchange_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '兑换记录ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `product_id` BIGINT NOT NULL COMMENT '商品ID',
  `product_name` VARCHAR(100) NOT NULL COMMENT '商品名称',
  `points_used` INT NOT NULL COMMENT '使用积分',
  `quantity` INT NOT NULL DEFAULT 1 COMMENT '兑换数量',
  `exchange_status` TINYINT NOT NULL DEFAULT 0 COMMENT '兑换状态：0-待发货，1-已发货，2-已完成',
  `shipping_address` VARCHAR(255) DEFAULT NULL COMMENT '收货地址',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分兑换记录表';

CREATE TABLE `user_points` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `total_points` INT NOT NULL DEFAULT 0 COMMENT '总积分',
  `available_points` INT NOT NULL DEFAULT 0 COMMENT '可用积分',
  `used_points` INT NOT NULL DEFAULT 0 COMMENT '已使用积分',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户积分表';

INSERT INTO `user` (`username`, `password`, `nickname`, `phone`, `email`, `avatar`, `role`, `status`, `create_time`, `update_time`) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', '13800000000', 'admin@battery.com', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/default-admin.png', 1, 1, '2022-06-01 08:00:00', '2022-06-01 08:00:00');

DROP PROCEDURE IF EXISTS seed_users;
DELIMITER $$
CREATE PROCEDURE seed_users()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE create_dt DATETIME;
  WHILE i <= 200 DO
    SET create_dt = DATE_ADD('2022-06-01 09:00:00', INTERVAL (i - 1) * 3 DAY);
    INSERT INTO `user` (`username`, `password`, `nickname`, `phone`, `email`, `avatar`, `role`, `status`, `create_time`, `update_time`)
    VALUES (
      CONCAT('user', LPAD(i, 3, '0')),
      'e10adc3949ba59abbe56e057f20f883e',
      CONCAT('用户', LPAD(i, 3, '0')),
      CONCAT('13', LPAD(100000000 + i, 9, '0')),
      CONCAT('user', LPAD(i, 3, '0'), '@example.com'),
      CONCAT('https://thehim-java-web.oss-cn-beijing.aliyuncs.com/avatar/user-', LPAD((i - 1) % 12 + 1, 2, '0'), '.png'),
      0,
      1,
      create_dt,
      create_dt
    );
    SET i = i + 1;
  END WHILE;
END $$
DELIMITER ;
CALL seed_users();
DROP PROCEDURE IF EXISTS seed_users;

INSERT INTO `battery_type` (`id`, `type_name`, `description`, `icon`, `identification_guide`, `points`, `status`, `create_time`, `update_time`) VALUES
(1, '普通干电池', '1/2/5/7号碱性电池和碳性电池', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/a028474a-a082-4246-98fd-298105586c3b.png', '标注：1号、2号、5号、7号\n或：D、C、AA、AAA\n常见于遥控器、老式手电筒等', 10, 1, '2026-02-10 12:32:25', '2026-03-09 11:04:14'),
(2, '纽扣电池', '小型纽扣电池，小孔投放，防儿童误触', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/322643e0-02c0-449d-b537-9d0376f44514.png', '标注：CR2032、LR44等\n特征：圆形扁平状\n常见于手表、主板、车钥匙等', 5, 1, '2026-02-10 12:32:25', '2026-03-02 21:04:11'),
(3, '充电电池', '可充电电池，包含锂电池和镍氢电池', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/c8f12be4-9d2d-4953-8adc-97759c31a15b.png', '标注：带"充电"字样\n或：Li-ion、Ni-MH\n常见于手机、玩具车、充电宝等', 15, 1, '2026-02-10 12:32:25', '2026-03-02 21:04:50'),
(4, '大型电池', '儿童电动车铅酸电池等大型电池，需人工辅助', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/e5e1d786-1a76-4cd5-82de-2465984a343b.png', '标注：铅酸、12V等\n特征：体积较大\n常见于电动自行车，电动三轮车等', 50, 1, '2026-02-10 12:32:25', '2026-03-02 21:05:37'),
(5, '其他电池', '无法明确归类但可参与回收的其他废旧电池', 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/icon/2026-03-02/e5e1d786-1a76-4cd5-82de-2465984a343b.png', '无法准确归类时可选择该项，回收按重量折算，100克计1分', 0, 1, '2026-04-17 18:30:00', '2026-04-17 18:30:00');

INSERT INTO `exchange_product` VALUES (1, '南孚5号碱性电池', '南孚', '5号', 1000, 97, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/2cd6dadd-cabb-41c4-a6c3-f333d6b97bbc.png', '南孚聚能环5号碱性电池，持久耐用', 1, '2026-02-10 12:32:25', '2026-03-21 15:26:30');
INSERT INTO `exchange_product` VALUES (2, '南孚7号碱性电池', '南孚', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/8a3f65b5-be6f-4451-abc2-a6882e01cc38.png', '南孚聚能环7号碱性电池，持久耐用', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:06');
INSERT INTO `exchange_product` VALUES (3, '酷态科5号碱性电池', '酷态科', '5号', 1000, 99, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/f7c4f4c9-41f6-4166-b096-9e6a2552eade.png', '酷态科5号碱性电池，性价比高', 1, '2026-02-10 12:32:25', '2026-03-09 11:02:14');
INSERT INTO `exchange_product` VALUES (4, '酷态科7号碱性电池', '酷态科', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/e80511d1-5602-4f63-8a87-daba55da2fa2.png', '酷态科7号碱性电池，性价比高', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:39');
INSERT INTO `exchange_product` VALUES (7, '双鹿5号碱性电池', '双鹿', '5号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/1b6b44a7-25e0-4ff7-bb78-c9996e2e0ce4.png', '双鹿5号碱性电池，国产品牌', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:18');
INSERT INTO `exchange_product` VALUES (8, '双鹿7号碱性电池', '双鹿', '7号', 1000, 100, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/ec663f9c-a725-4edb-bfe4-de029fbe4097.png', '双鹿7号碱性电池，国产品牌', 1, '2026-02-10 12:32:25', '2026-03-02 16:13:24');
INSERT INTO `exchange_product` VALUES (9, '京东京造5号碱性电池', '京东京造', '5号', 1000, 99, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/244aa6ff-57a5-4320-b4f1-afca235f4dad.png', '京东京造5号碱性电池，品质之选', 1, '2026-02-10 12:32:25', '2026-03-09 11:05:16');
INSERT INTO `exchange_product` VALUES (10, '京东京造7号碱性电池', '京东京造', '7号', 1000, 99, 'https://thehim-java-web.oss-cn-beijing.aliyuncs.com/image_url/2026-03-02/c29beadd-f36c-41d1-9dbb-cf9660172327.png', '京东京造7号碱性电池，品质之选', 1, '2026-02-10 12:32:25', '2026-04-16 09:41:22');

DROP PROCEDURE IF EXISTS generate_simulation_orders;
DELIMITER $$
CREATE PROCEDURE generate_simulation_orders()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE order_target INT DEFAULT 50000;
  DECLARE v_user_id BIGINT;
  DECLARE v_order_date DATE;
  DECLARE v_order_time DATETIME;
  DECLARE v_day_seq INT;
  DECLARE v_user_code VARCHAR(20);
  DECLARE v_order_number VARCHAR(50);
  DECLARE v_status TINYINT;
  DECLARE v_address VARCHAR(255);
  DECLARE v_phone VARCHAR(20);
  DECLARE v_remark VARCHAR(255);
  DECLARE v_order_id BIGINT;
  DECLARE v_total_count INT DEFAULT 0;
  DECLARE v_total_points INT DEFAULT 0;
  DECLARE v_detail_count INT DEFAULT 0;
  DECLARE v_selected INT DEFAULT 0;
  DECLARE v_battery_type_id BIGINT;
  DECLARE v_battery_count INT;
  DECLARE v_detail_points INT;
  DECLARE v_pick DECIMAL(10,4);
  DECLARE v_main_city_idx INT;
  DECLARE v_other_city_idx INT;
  DECLARE v_city VARCHAR(20);
  DECLARE v_district VARCHAR(20);
  DECLARE v_road VARCHAR(50);

  DROP TEMPORARY TABLE IF EXISTS tmp_user_ids;
  CREATE TEMPORARY TABLE tmp_user_ids AS
  SELECT id FROM `user` WHERE role = 0 ORDER BY id;

  DROP TEMPORARY TABLE IF EXISTS tmp_selected_types;
  CREATE TEMPORARY TABLE tmp_selected_types (
    battery_type_id BIGINT PRIMARY KEY
  );

  WHILE i <= order_target DO
    SET v_pick = RAND();
    IF v_pick < 0.08 THEN
      SET v_order_date = DATE_ADD('2022-06-01', INTERVAL FLOOR(RAND() * 214) DAY);
    ELSEIF v_pick < 0.26 THEN
      SET v_order_date = DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 365) DAY);
    ELSEIF v_pick < 0.53 THEN
      SET v_order_date = DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND() * 366) DAY);
    ELSEIF v_pick < 0.83 THEN
      SET v_order_date = DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 365) DAY);
    ELSE
      SET v_order_date = DATE_ADD('2026-01-01', INTERVAL FLOOR(RAND() * 107) DAY);
    END IF;

    SET v_order_time = TIMESTAMP(v_order_date, MAKETIME(8 + FLOOR(RAND() * 10), FLOOR(RAND() * 60), FLOOR(RAND() * 60)));

    SELECT id INTO v_user_id FROM tmp_user_ids ORDER BY RAND() LIMIT 1;
    SET v_user_code = CONCAT('U', LPAD(v_user_id, 3, '0'));

    SELECT COUNT(*) + 1 INTO v_day_seq
    FROM recycle_order
    WHERE DATE(create_time) = v_order_date AND user_id = v_user_id;

    SET v_order_number = CONCAT('BR', DATE_FORMAT(v_order_date, '%Y%m%d'), '-', v_user_code, '-', LPAD(v_day_seq, 3, '0'));

    SET v_pick = RAND();
    IF v_pick < 0.70 THEN
      SET v_status = 2;
    ELSEIF v_pick < 0.86 THEN
      SET v_status = 1;
    ELSEIF v_pick < 0.95 THEN
      SET v_status = 0;
    ELSE
      SET v_status = 3;
    END IF;

    SET v_pick = RAND();
    IF v_pick < 0.32 THEN
      SET v_city = '合肥市';
    ELSEIF v_pick < 0.54 THEN
      SET v_city = '阜阳市';
    ELSEIF v_pick < 0.71 THEN
      SET v_city = '宿州市';
    ELSEIF v_pick < 0.85 THEN
      SET v_city = '亳州市';
    ELSEIF v_pick < 0.95 THEN
      SET v_city = '六安市';
    ELSE
      SET v_other_city_idx = FLOOR(RAND() * 11) + 1;
      SET v_city = CASE v_other_city_idx
        WHEN 1 THEN '芜湖市'
        WHEN 2 THEN '蚌埠市'
        WHEN 3 THEN '淮南市'
        WHEN 4 THEN '马鞍山市'
        WHEN 5 THEN '淮北市'
        WHEN 6 THEN '铜陵市'
        WHEN 7 THEN '安庆市'
        WHEN 8 THEN '黄山市'
        WHEN 9 THEN '滁州市'
        WHEN 10 THEN '池州市'
        ELSE '宣城市'
      END;
    END IF;

    SET v_district = CASE v_city
      WHEN '合肥市' THEN ELT(FLOOR(RAND() * 4) + 1, '蜀山区', '包河区', '庐阳区', '瑶海区')
      WHEN '阜阳市' THEN ELT(FLOOR(RAND() * 3) + 1, '颍州区', '颍泉区', '颍东区')
      WHEN '宿州市' THEN ELT(FLOOR(RAND() * 3) + 1, '埇桥区', '砀山县', '灵璧县')
      WHEN '亳州市' THEN ELT(FLOOR(RAND() * 3) + 1, '谯城区', '涡阳县', '蒙城县')
      WHEN '六安市' THEN ELT(FLOOR(RAND() * 3) + 1, '金安区', '裕安区', '叶集区')
      WHEN '芜湖市' THEN ELT(FLOOR(RAND() * 3) + 1, '镜湖区', '弋江区', '鸠江区')
      WHEN '蚌埠市' THEN ELT(FLOOR(RAND() * 2) + 1, '蚌山区', '龙子湖区')
      WHEN '淮南市' THEN '田家庵区'
      WHEN '马鞍山市' THEN '花山区'
      WHEN '淮北市' THEN '相山区'
      WHEN '铜陵市' THEN '铜官区'
      WHEN '安庆市' THEN '迎江区'
      WHEN '黄山市' THEN '屯溪区'
      WHEN '滁州市' THEN '琅琊区'
      WHEN '池州市' THEN '贵池区'
      ELSE '宣州区'
    END;

    SET v_road = CASE v_city
      WHEN '合肥市' THEN ELT(FLOOR(RAND() * 5) + 1, '望江西路', '徽州大道', '阜阳北路', '长江西路', '潜山路')
      WHEN '阜阳市' THEN ELT(FLOOR(RAND() * 4) + 1, '清河东路', '颍州南路', '淮河路', '人民西路')
      WHEN '宿州市' THEN ELT(FLOOR(RAND() * 4) + 1, '汴河中路', '银河一路', '淮海北路', '人民路')
      WHEN '亳州市' THEN ELT(FLOOR(RAND() * 4) + 1, '魏武大道', '芍花路', '希夷大道', '药都路')
      WHEN '六安市' THEN ELT(FLOOR(RAND() * 4) + 1, '皖西大道', '梅山南路', '解放南路', '长安路')
      WHEN '芜湖市' THEN ELT(FLOOR(RAND() * 3) + 1, '北京中路', '九华南路', '赤铸山路')
      WHEN '蚌埠市' THEN ELT(FLOOR(RAND() * 2) + 1, '东海大道', '解放路')
      WHEN '淮南市' THEN '朝阳中路'
      WHEN '马鞍山市' THEN '湖北东路'
      WHEN '淮北市' THEN '人民路'
      WHEN '铜陵市' THEN '长江西路'
      WHEN '安庆市' THEN '皖江大道'
      WHEN '黄山市' THEN '新安北路'
      WHEN '滁州市' THEN '丰乐大道'
      WHEN '池州市' THEN '长江南路'
      ELSE '昭亭南路'
    END;

    SET v_address = CONCAT('安徽省', v_city, v_district, v_road, FLOOR(RAND() * 900 + 100), '号');
    SET v_phone = CONCAT('13', LPAD(FLOOR(RAND() * 1000000000), 9, '0'));

    SET v_pick = RAND();
    IF v_pick < 0.15 THEN
      SET v_remark = '请提前电话联系';
    ELSEIF v_pick < 0.28 THEN
      SET v_remark = '电池已分类打包';
    ELSEIF v_pick < 0.40 THEN
      SET v_remark = '大型电池需上门搬运';
    ELSEIF v_pick < 0.50 THEN
      SET v_remark = '工作日白天可上门';
    ELSE
      SET v_remark = NULL;
    END IF;

    INSERT INTO recycle_order (
      order_number, user_id, total_count, total_points,
      recycle_address, contact_phone, order_status, remark,
      create_time, update_time
    ) VALUES (
      v_order_number, v_user_id, 0, 0,
      v_address, v_phone, v_status, v_remark,
      v_order_time, v_order_time
    );

    SET v_order_id = LAST_INSERT_ID();
    SET v_total_count = 0;
    SET v_total_points = 0;
    DELETE FROM tmp_selected_types;
    SET v_detail_count = FLOOR(RAND() * 3) + 1;
    SET v_selected = 0;

    WHILE v_selected < v_detail_count DO
      SET v_pick = RAND();
      IF v_pick < 0.35 THEN
        SET v_battery_type_id = 1;
        SET v_battery_count = FLOOR(RAND() * 36) + 8;
        SET v_detail_points = v_battery_count * 10;
      ELSEIF v_pick < 0.50 THEN
        SET v_battery_type_id = 2;
        SET v_battery_count = FLOOR(RAND() * 28) + 4;
        SET v_detail_points = v_battery_count * 5;
      ELSEIF v_pick < 0.70 THEN
        SET v_battery_type_id = 3;
        SET v_battery_count = FLOOR(RAND() * 24) + 3;
        SET v_detail_points = v_battery_count * 15;
      ELSEIF v_pick < 0.90 THEN
        SET v_battery_type_id = 4;
        SET v_battery_count = FLOOR(RAND() * 10) + 1;
        SET v_detail_points = v_battery_count * 50;
      ELSE
        SET v_battery_type_id = 5;
        SET v_battery_count = FLOOR(RAND() * 39) + 1;
        SET v_detail_points = v_battery_count;
      END IF;

      IF NOT EXISTS (SELECT 1 FROM tmp_selected_types WHERE battery_type_id = v_battery_type_id) THEN
        INSERT INTO tmp_selected_types (battery_type_id) VALUES (v_battery_type_id);
        INSERT INTO recycle_detail (order_id, battery_type_id, battery_count, points, create_time)
        VALUES (v_order_id, v_battery_type_id, v_battery_count, v_detail_points, v_order_time);
        SET v_total_count = v_total_count + v_battery_count;
        SET v_total_points = v_total_points + v_detail_points;
        SET v_selected = v_selected + 1;
      END IF;
    END WHILE;

    UPDATE recycle_order
    SET total_count = v_total_count,
        total_points = v_total_points,
        update_time = DATE_ADD(v_order_time, INTERVAL FLOOR(RAND() * 72) HOUR)
    WHERE id = v_order_id;

    SET i = i + 1;
  END WHILE;
END $$
DELIMITER ;

CALL generate_simulation_orders();
DROP PROCEDURE IF EXISTS generate_simulation_orders;

INSERT INTO user_points (user_id, total_points, available_points, used_points, create_time, update_time)
SELECT
  u.id AS user_id,
  COALESCE(SUM(CASE WHEN ro.order_status = 2 THEN ro.total_points ELSE 0 END), 0) AS total_points,
  GREATEST(
    COALESCE(SUM(CASE WHEN ro.order_status = 2 THEN ro.total_points ELSE 0 END), 0) - FLOOR(RAND() * 5000),
    0
  ) AS available_points,
  0 AS used_points,
  NOW(),
  NOW()
FROM `user` u
LEFT JOIN recycle_order ro ON ro.user_id = u.id
GROUP BY u.id;

UPDATE user_points
SET used_points = total_points - available_points
WHERE used_points = 0;

CREATE VIEW `view_order_detail` AS
SELECT 
  ro.id AS order_id,
  ro.order_number,
  ro.user_id,
  u.username,
  u.nickname,
  ro.total_count,
  ro.total_points,
  ro.recycle_address,
  ro.contact_phone,
  ro.order_status,
  ro.remark,
  ro.create_time,
  ro.update_time
FROM recycle_order ro
LEFT JOIN user u ON ro.user_id = u.id;

CREATE VIEW `view_recycle_detail` AS
SELECT 
  rd.id AS detail_id,
  rd.order_id,
  ro.order_number,
  rd.battery_type_id,
  bt.type_name AS battery_type_name,
  rd.battery_count,
  rd.points,
  rd.create_time
FROM recycle_detail rd
LEFT JOIN recycle_order ro ON rd.order_id = ro.id
LEFT JOIN battery_type bt ON rd.battery_type_id = bt.id;

SET FOREIGN_KEY_CHECKS = 1;
