/*
 Navicat Premium Dump SQL

 Source Server         : local_MySQL
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : tagfactory

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 02/12/2025 08:50:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for approval_flow
-- ----------------------------
DROP TABLE IF EXISTS `approval_flow`;
CREATE TABLE `approval_flow`  (
  `flow_id` int NOT NULL AUTO_INCREMENT COMMENT '流程ID',
  `application_id` int NOT NULL COMMENT '申请ID，关联tag_application表',
  `current_step` int NULL DEFAULT 1 COMMENT '当前审批步骤',
  `total_steps` int NULL DEFAULT 1 COMMENT '总审批步骤',
  `flow_status` enum('PENDING','PROCESSING','COMPLETED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程状态',
  `final_result` enum('APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最终结果',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`flow_id`) USING BTREE,
  INDEX `application_id`(`application_id` ASC) USING BTREE,
  INDEX `idx_flow_status`(`flow_status` ASC) USING BTREE,
  CONSTRAINT `approval_flow_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `tag_application` (`application_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '审批流程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approval_flow
-- ----------------------------
INSERT INTO `approval_flow` VALUES (1, 1, 1, 1, 'PENDING', NULL, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (2, 2, 1, 1, 'PENDING', NULL, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (3, 3, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (4, 4, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (5, 5, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (6, 6, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (7, 7, 1, 1, 'COMPLETED', NULL, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (8, 8, 1, 1, 'COMPLETED', NULL, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_flow` VALUES (9, 1, 1, 1, 'PENDING', NULL, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (10, 2, 1, 1, 'PENDING', NULL, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (11, 3, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (12, 4, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (13, 5, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (14, 6, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (15, 7, 1, 1, 'COMPLETED', NULL, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (16, 8, 1, 1, 'COMPLETED', NULL, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_flow` VALUES (17, 1, 1, 1, 'PENDING', NULL, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (18, 2, 1, 1, 'PENDING', NULL, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (19, 3, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (20, 4, 1, 1, 'COMPLETED', 'APPROVED', '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (21, 5, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (22, 6, 1, 1, 'COMPLETED', 'REJECTED', '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (23, 7, 1, 1, 'COMPLETED', NULL, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_flow` VALUES (24, 8, 1, 1, 'COMPLETED', NULL, '2025-11-29 16:07:09', '2025-11-29 16:07:09');

-- ----------------------------
-- Table structure for approval_record
-- ----------------------------
DROP TABLE IF EXISTS `approval_record`;
CREATE TABLE `approval_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '审批记录ID',
  `application_id` int NOT NULL COMMENT '申请ID，关联tag_application表',
  `approver_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '审批人ID，关联system_user表',
  `approval_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '审批时间',
  `approval_status` enum('PENDING','APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '审批状态',
  `approval_opinion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审批意见',
  `approval_order` int NOT NULL COMMENT '审批顺序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_application_id`(`application_id` ASC) USING BTREE,
  INDEX `idx_approver_id`(`approver_id` ASC) USING BTREE,
  CONSTRAINT `approval_record_ibfk_1` FOREIGN KEY (`application_id`) REFERENCES `tag_application` (`application_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `approval_record_ibfk_2` FOREIGN KEY (`approver_id`) REFERENCES `system_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approval_record
-- ----------------------------
INSERT INTO `approval_record` VALUES (1, 1, 'USER005', '2025-11-29 15:32:34', 'PENDING', NULL, 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (2, 2, 'USER006', '2025-11-29 15:32:34', 'PENDING', NULL, 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (3, 3, 'USER005', '2023-01-10 10:00:00', 'APPROVED', '标签设计合理，同意通过', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (4, 4, 'USER006', '2023-01-11 14:30:00', 'APPROVED', '符合业务需求，同意通过', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (5, 5, 'USER005', '2023-01-12 09:15:00', 'REJECTED', '标签定义不清晰，需要修改', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (6, 6, 'USER006', '2023-01-13 16:45:00', 'REJECTED', '不符合标签设计规范，拒绝通过', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (7, 7, 'USER005', '2025-11-29 15:32:34', 'PENDING', NULL, 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (8, 8, 'USER006', '2025-11-29 15:32:34', 'PENDING', NULL, 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `approval_record` VALUES (9, 1, 'USER005', '2025-11-29 16:05:30', 'PENDING', NULL, 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (10, 2, 'USER006', '2025-11-29 16:05:30', 'PENDING', NULL, 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (11, 3, 'USER005', '2023-01-10 10:00:00', 'APPROVED', '标签设计合理，同意通过', 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (12, 4, 'USER006', '2023-01-11 14:30:00', 'APPROVED', '符合业务需求，同意通过', 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (13, 5, 'USER005', '2023-01-12 09:15:00', 'REJECTED', '标签定义不清晰，需要修改', 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (14, 6, 'USER006', '2023-01-13 16:45:00', 'REJECTED', '不符合标签设计规范，拒绝通过', 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (15, 7, 'USER005', '2025-11-29 16:05:30', 'PENDING', NULL, 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (16, 8, 'USER006', '2025-11-29 16:05:30', 'PENDING', NULL, 1, '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `approval_record` VALUES (17, 1, 'USER005', '2025-11-29 16:07:09', 'PENDING', NULL, 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (18, 2, 'USER006', '2025-11-29 16:07:09', 'PENDING', NULL, 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (19, 3, 'USER005', '2023-01-10 10:00:00', 'APPROVED', '标签设计合理，同意通过', 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (20, 4, 'USER006', '2023-01-11 14:30:00', 'APPROVED', '符合业务需求，同意通过', 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (21, 5, 'USER005', '2023-01-12 09:15:00', 'REJECTED', '标签定义不清晰，需要修改', 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (22, 6, 'USER006', '2023-01-13 16:45:00', 'REJECTED', '不符合标签设计规范，拒绝通过', 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (23, 7, 'USER005', '2025-11-29 16:07:09', 'PENDING', NULL, 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (24, 8, 'USER006', '2025-11-29 16:07:09', 'PENDING', NULL, 1, '2025-11-29 16:07:09', '2025-11-29 16:07:09');
INSERT INTO `approval_record` VALUES (25, 1, 'USER005', '2025-11-29 16:24:55', 'APPROVED', '标签审批通过', 1, '2025-11-29 16:24:55', '2025-11-29 16:24:55');
INSERT INTO `approval_record` VALUES (26, 2, 'USER005', '2025-11-29 16:25:34', 'REJECTED', 'test reject', 1, '2025-11-29 16:25:34', '2025-11-29 16:25:34');

-- ----------------------------
-- Table structure for customer_info
-- ----------------------------
DROP TABLE IF EXISTS `customer_info`;
CREATE TABLE `customer_info`  (
  `customer_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '客户ID（格式：U+16位数字，如U1234567890123456）',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号（11位数字）',
  `last_active_time` datetime NULL DEFAULT NULL COMMENT '最近活跃时间',
  `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `gender` enum('男','女','未知') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '未知' COMMENT '性别',
  `age` int NULL DEFAULT 0 COMMENT '年龄（0-120之间）',
  `education` enum('小学','初中','高中','大专','本科','硕士','博士','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '其他' COMMENT '学历',
  `province` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所在省份（如北京市、广东省）',
  `total_consume` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已消费金额（保留2位小数）',
  `consume_months` int NOT NULL DEFAULT 0 COMMENT '消费月数（累计消费的月份数）',
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除标记（0-未删除，1-已删除）',
  PRIMARY KEY (`customer_id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE COMMENT '手机号索引（优化查询速度）'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of customer_info
-- ----------------------------
INSERT INTO `customer_info` VALUES ('U0000000000000001', '13800138000', '2025-11-20 14:30:22', '2024-05-12 09:15:33', '男', 28, '本科', '广东省', 12599.90, 12, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000002', '13911223344', '2025-11-23 09:45:10', '2023-08-05 16:22:18', '女', 35, '硕士', '北京市', 28765.50, 24, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000003', '13755667788', '2025-11-18 16:20:35', '2025-01-20 11:08:45', '未知', 0, '其他', '上海市', 0.00, 0, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000004', '13699887766', '2025-11-24 10:12:58', '2024-03-18 14:55:22', '男', 42, '大专', '江苏省', 8999.30, 8, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000005', '13577889900', '2025-11-21 19:33:40', '2023-11-02 08:30:15', '女', 25, '高中', '浙江省', 5680.75, 6, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000006', '13422334455', '2025-11-19 11:28:17', '2024-07-25 15:42:38', '男', 31, '本科', '山东省', 15680.20, 15, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000007', '13366778899', '2025-11-17 13:10:05', '2025-02-14 10:18:52', '未知', 0, '其他', '四川省', 0.00, 0, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000008', '13288990011', '2025-11-22 17:55:33', '2024-09-08 16:33:27', '女', 29, '本科', '湖北省', 9876.40, 9, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000009', '13155667788', '2025-11-16 09:20:45', '2023-06-19 11:48:12', '男', 50, '大专', '河南省', 23450.80, 20, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000010', '13099887766', '2025-11-23 14:18:22', '2024-01-30 15:25:47', '女', 33, '硕士', '福建省', 18900.60, 18, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000011', '13811223344', '2025-11-20 16:40:15', '2025-03-05 10:02:33', '男', 27, '本科', '湖南省', 7654.30, 7, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000012', '13922334455', '2025-11-18 10:55:38', '2024-04-12 14:33:19', '未知', 0, '小学', '河北省', 0.00, 0, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000013', '13733445566', '2025-11-21 13:22:40', '2023-09-28 08:15:52', '女', 45, '博士', '陕西省', 32180.90, 26, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000014', '13644556677', '2025-11-24 08:40:12', '2024-06-15 11:28:37', '男', 38, '本科', '安徽省', 14560.50, 14, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000015', '13555667788', '2025-11-19 15:33:25', '2024-08-22 16:40:11', '女', 26, '高中', '黑龙江省', 4320.80, 4, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000016', '13466778899', '2025-11-17 14:18:50', '2025-04-10 09:35:22', '男', 34, '大专', '辽宁省', 11230.70, 11, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000017', '13377889900', '2025-11-22 11:05:18', '2023-12-05 13:20:47', '未知', 0, '其他', '吉林省', 0.00, 0, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000018', '13299001122', '2025-11-20 18:45:33', '2024-02-18 15:10:28', '女', 30, '本科', '广东省', 8765.90, 8, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000019', '13100112233', '2025-11-23 16:22:10', '2024-10-08 10:45:15', '男', 36, '硕士', '北京市', 21340.60, 19, 0);
INSERT INTO `customer_info` VALUES ('U0000000000000020', '13011223344', '2025-11-16 12:30:45', '2023-07-14 09:28:33', '女', 29, '本科', '上海市', 6543.20, 6, 0);
INSERT INTO `customer_info` VALUES ('U1234567890123456', '13800138001', '2025-11-28 00:49:40', '2025-11-28 00:49:40', '男', 28, '本科', '北京市', 1200.50, 8, 0);
INSERT INTO `customer_info` VALUES ('U1234567890123457', '13900139001', '2025-11-28 00:49:40', '2025-11-28 00:49:40', '女', 22, '大专', '上海市', 3500.00, 20, 0);
INSERT INTO `customer_info` VALUES ('U1234567890123458', '13700137001', '2025-11-28 00:49:40', '2025-11-28 00:49:40', '男', 35, '硕士', '广东省', 5800.00, 32, 0);

-- ----------------------------
-- Table structure for group_definition
-- ----------------------------
DROP TABLE IF EXISTS `group_definition`;
CREATE TABLE `group_definition`  (
  `group_id` int NOT NULL AUTO_INCREMENT COMMENT '群体ID',
  `group_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '群体编码（如 HIGH_VALUE_USER, HOT_PRODUCT）',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '群体显示名（如 高价值用户, 热销商品）',
  `entity_type` enum('CUSTOMER','PRODUCT','SELLER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '群体归属实体类型',
  `create_method` enum('RULE','BEHAVIOR','IMPORT') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'RULE' COMMENT '创建方式',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态（1-启用 0-停用）',
  `entity_count` int NULL DEFAULT 0 COMMENT '群体包含实体数量',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'system' COMMENT '创建人',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '群体描述',
  PRIMARY KEY (`group_id`) USING BTREE,
  UNIQUE INDEX `group_code`(`group_code` ASC) USING BTREE,
  INDEX `idx_group_entity_type_status`(`entity_type` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '群体定义元数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_definition
-- ----------------------------
INSERT INTO `group_definition` VALUES (41, 'HIGH_VALUE_USER', '高价值用户', 'CUSTOMER', 'RULE', 1, 9, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '消费金额大于10000元且消费频率大于每月2次的用户');
INSERT INTO `group_definition` VALUES (42, 'YOUNG_FEMALE_USER', '年轻女性用户', 'CUSTOMER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '年龄在18-25岁之间的女性用户');
INSERT INTO `group_definition` VALUES (43, 'ACTIVE_USER', '活跃用户', 'CUSTOMER', 'BEHAVIOR', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '最近30天活跃次数大于10次的用户');
INSERT INTO `group_definition` VALUES (44, 'NEW_USER', '新注册用户', 'CUSTOMER', 'IMPORT', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '最近7天注册的新用户');
INSERT INTO `group_definition` VALUES (45, 'HOT_PRODUCT', '热销商品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '月销量大于1000件的商品');
INSERT INTO `group_definition` VALUES (46, 'NEW_ARRIVAL_PRODUCT', '新品商品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '上市时间小于30天的商品');
INSERT INTO `group_definition` VALUES (47, 'DISCOUNT_PRODUCT', '优惠商品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '折扣率大于7折的商品');
INSERT INTO `group_definition` VALUES (48, 'HIGH_RATED_PRODUCT', '高评分商品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '评分大于4.5分的商品');
INSERT INTO `group_definition` VALUES (49, 'SELF_OPERATED_SELLER', '自营商家', 'SELLER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '平台自营的商家');
INSERT INTO `group_definition` VALUES (50, 'HIGH_PRAISE_SELLER', '高好评率商家', 'SELLER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '好评率大于98%的商家');
INSERT INTO `group_definition` VALUES (51, 'NEW_SELLER', '新入驻商家', 'SELLER', 'IMPORT', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '最近30天入驻的商家');
INSERT INTO `group_definition` VALUES (52, 'RISK_SELLER', '高风险商家', 'SELLER', 'RULE', 0, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '违规次数大于3次的商家');
INSERT INTO `group_definition` VALUES (53, 'MALE_TECH_USER', '男性科技用户', 'CUSTOMER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '男性且购买过电子产品的用户');
INSERT INTO `group_definition` VALUES (54, 'FREQUENT_BUYER', '频繁购买用户', 'CUSTOMER', 'BEHAVIOR', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '近6个月购买次数大于20次的用户');
INSERT INTO `group_definition` VALUES (55, 'PREMIUM_MEMBER', 'premium会员', 'CUSTOMER', 'IMPORT', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', 'premium会员用户');
INSERT INTO `group_definition` VALUES (56, 'POPULAR_CATEGORY_PRODUCT', '热门分类商品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '属于热门分类的商品');
INSERT INTO `group_definition` VALUES (57, 'FAST_DELIVERY_SELLER', '快速发货商家', 'SELLER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '承诺24小时内发货的商家');
INSERT INTO `group_definition` VALUES (58, 'LUXURY_PRODUCT', '奢侈品', 'PRODUCT', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '价格大于10000元的商品');
INSERT INTO `group_definition` VALUES (59, 'STUDENT_USER', '学生用户', 'CUSTOMER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '年龄在18-22岁之间的用户');
INSERT INTO `group_definition` VALUES (60, 'LOCAL_SELLER', '本地商家', 'SELLER', 'RULE', 1, 8, '2025-11-29 14:26:41', '2025-11-29 14:42:49', 'admin', '本地注册的商家');

-- ----------------------------
-- Table structure for group_entity_relation
-- ----------------------------
DROP TABLE IF EXISTS `group_entity_relation`;
CREATE TABLE `group_entity_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` int NOT NULL COMMENT '关联 group_definition.group_id',
  `entity_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实体ID（如U1234567890123456, P1234567890123456, S1234567890123456）',
  `entity_type` enum('CUSTOMER','PRODUCT','SELLER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实体类型',
  `add_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_entity`(`group_id` ASC, `entity_id` ASC) USING BTREE,
  INDEX `idx_group_id`(`group_id` ASC) USING BTREE,
  INDEX `idx_entity_id`(`entity_id` ASC) USING BTREE,
  INDEX `idx_entity_type`(`entity_type` ASC) USING BTREE,
  INDEX `idx_group_entity_type`(`group_id` ASC, `entity_type` ASC) USING BTREE,
  CONSTRAINT `group_entity_relation_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `group_definition` (`group_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 323 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '群体实体关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_entity_relation
-- ----------------------------
INSERT INTO `group_entity_relation` VALUES (162, 41, 'U1234567890123456', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (163, 41, 'U1234567890123457', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (164, 41, 'U1234567890123458', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (165, 41, 'U1234567890123459', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (166, 41, 'U1234567890123460', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (167, 42, 'U1234567890123461', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (168, 42, 'U1234567890123462', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (169, 42, 'U1234567890123463', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (170, 42, 'U1234567890123464', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (171, 42, 'U1234567890123465', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (172, 43, 'U1234567890123466', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (173, 43, 'U1234567890123467', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (174, 43, 'U1234567890123468', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (175, 43, 'U1234567890123469', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (176, 43, 'U1234567890123470', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (177, 44, 'U1234567890123471', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (178, 44, 'U1234567890123472', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (179, 44, 'U1234567890123473', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (180, 44, 'U1234567890123474', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (181, 44, 'U1234567890123475', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (182, 45, 'P1234567890123456', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (183, 45, 'P1234567890123457', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (184, 45, 'P1234567890123458', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (185, 45, 'P1234567890123459', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (186, 45, 'P1234567890123460', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (187, 46, 'P1234567890123461', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (188, 46, 'P1234567890123462', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (189, 46, 'P1234567890123463', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (190, 46, 'P1234567890123464', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (191, 46, 'P1234567890123465', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (192, 47, 'P1234567890123466', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (193, 47, 'P1234567890123467', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (194, 47, 'P1234567890123468', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (195, 47, 'P1234567890123469', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (196, 47, 'P1234567890123470', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (197, 48, 'P1234567890123471', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (198, 48, 'P1234567890123472', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (199, 48, 'P1234567890123473', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (200, 48, 'P1234567890123474', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (201, 48, 'P1234567890123475', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (202, 49, 'S1234567890123456', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (203, 49, 'S1234567890123457', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (204, 49, 'S1234567890123458', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (205, 49, 'S1234567890123459', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (206, 49, 'S1234567890123460', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (207, 50, 'S1234567890123461', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (208, 50, 'S1234567890123462', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (209, 50, 'S1234567890123463', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (210, 50, 'S1234567890123464', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (211, 50, 'S1234567890123465', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (212, 51, 'S1234567890123466', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (213, 51, 'S1234567890123467', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (214, 51, 'S1234567890123468', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (215, 51, 'S1234567890123469', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (216, 51, 'S1234567890123470', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (217, 52, 'S1234567890123471', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (218, 52, 'S1234567890123472', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (219, 52, 'S1234567890123473', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (220, 52, 'S1234567890123474', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (221, 52, 'S1234567890123475', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (222, 53, 'U1234567890123476', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (223, 53, 'U1234567890123477', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (224, 53, 'U1234567890123478', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (225, 53, 'U1234567890123479', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (226, 53, 'U1234567890123480', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (227, 54, 'U1234567890123481', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (228, 54, 'U1234567890123482', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (229, 54, 'U1234567890123483', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (230, 54, 'U1234567890123484', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (231, 54, 'U1234567890123485', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (232, 55, 'U1234567890123486', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (233, 55, 'U1234567890123487', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (234, 55, 'U1234567890123488', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (235, 55, 'U1234567890123489', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (236, 55, 'U1234567890123490', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (237, 56, 'P1234567890123476', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (238, 56, 'P1234567890123477', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (239, 56, 'P1234567890123478', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (240, 56, 'P1234567890123479', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (241, 56, 'P1234567890123480', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (242, 57, 'S1234567890123476', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (243, 57, 'S1234567890123477', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (244, 57, 'S1234567890123478', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (245, 57, 'S1234567890123479', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (246, 57, 'S1234567890123480', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (247, 58, 'P1234567890123481', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (248, 58, 'P1234567890123482', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (249, 58, 'P1234567890123483', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (250, 58, 'P1234567890123484', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (251, 58, 'P1234567890123485', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (252, 59, 'U1234567890123491', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (253, 59, 'U1234567890123492', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (254, 59, 'U1234567890123493', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (255, 59, 'U1234567890123494', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (256, 59, 'U1234567890123495', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (257, 60, 'S1234567890123481', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (258, 60, 'S1234567890123482', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (259, 60, 'S1234567890123483', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (260, 60, 'S1234567890123484', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (261, 60, 'S1234567890123485', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (262, 41, 'U1234567890123496', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (263, 41, 'U1234567890123497', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (264, 41, 'U1234567890123498', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (265, 42, 'U1234567890123499', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (266, 42, 'U1234567890123500', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (267, 43, 'U1234567890123501', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (268, 43, 'U1234567890123502', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (269, 44, 'U1234567890123503', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (270, 44, 'U1234567890123504', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (271, 45, 'P1234567890123486', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (272, 45, 'P1234567890123487', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (273, 46, 'P1234567890123488', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (274, 46, 'P1234567890123489', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (275, 47, 'P1234567890123490', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (276, 47, 'P1234567890123491', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (277, 48, 'P1234567890123492', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (278, 48, 'P1234567890123493', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (279, 49, 'S1234567890123486', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (280, 49, 'S1234567890123487', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (281, 50, 'S1234567890123488', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (282, 50, 'S1234567890123489', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (283, 51, 'S1234567890123490', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (284, 51, 'S1234567890123491', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (285, 52, 'S1234567890123492', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (286, 52, 'S1234567890123493', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (287, 53, 'U1234567890123505', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (288, 53, 'U1234567890123506', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (289, 54, 'U1234567890123507', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (290, 54, 'U1234567890123508', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (291, 55, 'U1234567890123509', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (292, 55, 'U1234567890123510', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (293, 56, 'P1234567890123494', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (294, 56, 'P1234567890123495', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (295, 57, 'S1234567890123494', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (296, 57, 'S1234567890123495', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (297, 58, 'P1234567890123496', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (298, 58, 'P1234567890123497', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (299, 59, 'U1234567890123511', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (300, 59, 'U1234567890123512', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (301, 60, 'S1234567890123496', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (302, 60, 'S1234567890123497', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (303, 41, 'U1234567890123513', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (304, 42, 'U1234567890123514', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (305, 43, 'U1234567890123515', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (306, 44, 'U1234567890123516', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (307, 45, 'P1234567890123498', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (308, 46, 'P1234567890123499', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (309, 47, 'P1234567890123500', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (310, 48, 'P1234567890123501', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (311, 49, 'S1234567890123498', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (312, 50, 'S1234567890123499', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (313, 51, 'S1234567890123500', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (314, 52, 'S1234567890123501', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (315, 53, 'U1234567890123517', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (316, 54, 'U1234567890123518', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (317, 55, 'U1234567890123519', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (318, 56, 'P1234567890123502', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (319, 57, 'S1234567890123502', 'SELLER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (320, 58, 'P1234567890123503', 'PRODUCT', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (321, 59, 'U1234567890123520', 'CUSTOMER', '2025-11-29 14:42:30');
INSERT INTO `group_entity_relation` VALUES (322, 60, 'S1234567890123503', 'SELLER', '2025-11-29 14:42:30');

-- ----------------------------
-- Table structure for group_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `group_tag_relation`;
CREATE TABLE `group_tag_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` int NOT NULL COMMENT '关联 group_definition.group_id',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 tag_definition.tag_code',
  `tag_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签值（如 \"男\", \"高价值\", \"0.85\"）',
  `operator` enum('AND','OR') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'AND' COMMENT '标签间逻辑关系',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_group_tag_value`(`group_id` ASC, `tag_code` ASC, `tag_value` ASC) USING BTREE,
  INDEX `idx_group_id`(`group_id` ASC) USING BTREE,
  INDEX `idx_tag_code`(`tag_code` ASC) USING BTREE,
  CONSTRAINT `group_tag_relation_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `group_definition` (`group_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `group_tag_relation_ibfk_2` FOREIGN KEY (`tag_code`) REFERENCES `tag_definition` (`tag_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '群体标签关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_tag_relation
-- ----------------------------
INSERT INTO `group_tag_relation` VALUES (81, 41, 'USER_CONSUME', '>10000', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (82, 41, 'USER_CONSUME_FREQUENCY', '>2', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (83, 42, 'USER_AGE', '18-25', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (84, 42, 'USER_GENDER', '女', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (85, 43, 'USER_ACTIVE_DAYS', '>30', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (86, 43, 'USER_ACTIVE_COUNT', '>10', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (87, 44, 'USER_REGISTER_DAYS', '<7', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (88, 45, 'PROD_MONTHLY_SALES', '>1000', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (89, 46, 'PROD_LAUNCH_DAYS', '<30', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (90, 47, 'PROD_DISCOUNT_RATE', '>0.7', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (91, 48, 'PROD_RATING', '>4.5', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (92, 49, 'SELLER_IS_SELF_OPERATED', '1', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (93, 50, 'SELLER_PRAISE_RATE', '>98', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (94, 51, 'SELLER_ESTABLISH_DAYS', '<30', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (95, 52, 'SELLER_VIOLATION_COUNT', '>3', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (96, 53, 'USER_GENDER', '男', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (97, 53, 'USER_PRODUCT_CATEGORY', '电子产品', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (98, 54, 'USER_BUY_COUNT_6MONTH', '>20', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (99, 55, 'USER_MEMBER_LEVEL', 'premium', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (100, 56, 'PROD_CATEGORY', '热门', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (101, 57, 'SELLER_SHIP_PROMISE', '24小时内', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (102, 58, 'PROD_PRICE', '>10000', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (103, 59, 'USER_AGE', '18-22', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (104, 60, 'SELLER_CITY', '本地', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (105, 41, 'USER_MEMBER_LEVEL', '高级', 'OR', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (106, 42, 'USER_INTEREST', '时尚', 'OR', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (107, 43, 'USER_LOGIN_COUNT', '>5', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (108, 45, 'PROD_STATUS', '上架', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (109, 46, 'PROD_IS_NEW', '1', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (110, 47, 'PROD_IS_DISCOUNT', '1', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (111, 48, 'PROD_COMMENT_COUNT', '>100', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (112, 49, 'SELLER_STATUS', '正常', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (113, 50, 'SELLER_RATING', '>4.5', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (114, 53, 'USER_AGE', '25-35', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (115, 54, 'USER_CONSUME_AMOUNT', '>5000', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (116, 56, 'PROD_SALES_VOLUME', '>500', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (117, 57, 'SELLER_DELIVERY_SPEED', '快', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (118, 58, 'PROD_BRAND', '奢侈品牌', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (119, 59, 'USER_EDUCATION', '大学', 'AND', '2025-11-29 14:42:30');
INSERT INTO `group_tag_relation` VALUES (120, 60, 'SELLER_BUSINESS_SCOPE', '本地服务', 'AND', '2025-11-29 14:42:30');

-- ----------------------------
-- Table structure for product_info
-- ----------------------------
DROP TABLE IF EXISTS `product_info`;
CREATE TABLE `product_info`  (
  `product_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品ID（格式：P+16位数字，如P1234567890123456）',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称（如iPhone 15 Pro 256G）',
  `brand_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌名称（如苹果、华为）',
  `category` enum('手机','平板电脑','智能手表','耳机音箱','充电设备','配件周边','潮流好物','官方定制','官方服务') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '电子产品分类（固定可选值）',
  `spec_params` json NULL COMMENT '规格参数（JSON格式，如{\"颜色\":[\"黑色\",\"白色\"],\"内存\":[\"256G\",\"512G\"]}）',
  `price` decimal(10, 2) NOT NULL COMMENT '商品现价（保留2位小数）',
  `original_price` decimal(10, 2) NOT NULL COMMENT '商品原价（保留2位小数）',
  `discount_rate` decimal(5, 2) NULL DEFAULT 100.00 COMMENT '折扣比例（0.00-100.00%）',
  `monthly_sales` int NOT NULL DEFAULT 0 COMMENT '月销售数量',
  `buy_customer_count` int NOT NULL DEFAULT 0 COMMENT '购买顾客数（累计）',
  `stock_quantity` int NOT NULL DEFAULT 0 COMMENT '库存数量（避免超卖）',
  `stock_status` enum('有货','缺货','预售','限购') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '有货' COMMENT '库存状态',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期（食品/美妆类必填）',
  `shelf_life` int NULL DEFAULT 0 COMMENT '保质期（单位：天，0表示无保质期）',
  `product_weight` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商品重量（单位：kg）',
  `product_volume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商品体积（单位：m³，用于物流计算）',
  `is_free_shipping` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否包邮（0-不包邮，1-包邮）',
  `after_sales_policy` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '七天无理由退换' COMMENT '售后政策',
  `product_tags` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品标签（多个标签用逗号分隔，如新品,热销,优惠）',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '商品状态（0-下架，1-上架）',
  `seller_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属商家ID（关联seller_info表）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商品创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商品信息更新时间',
  PRIMARY KEY (`product_id`) USING BTREE,
  INDEX `idx_seller_id`(`seller_id` ASC) USING BTREE COMMENT '商家ID索引（优化关联查询）',
  INDEX `idx_product_name`(`product_name` ASC) USING BTREE COMMENT '商品名称索引（优化搜索）',
  INDEX `idx_category`(`category` ASC) USING BTREE COMMENT '分类索引（按电子产品类别筛选）',
  INDEX `idx_brand`(`brand_name` ASC) USING BTREE COMMENT '品牌索引（按品牌筛选）',
  CONSTRAINT `product_info_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `seller_info` (`seller_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品信息表（电子产品专用）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_info
-- ----------------------------
INSERT INTO `product_info` VALUES ('P0000000000000001', 'iPhone 15 Pro 256G', '苹果', '手机', '{\"内存\": [\"256G\", \"512G\"], \"颜色\": [\"黑色\", \"白色\", \"蓝色\"], \"处理器\": [\"A17 Pro\"]}', 8999.00, 9999.00, 90.00, 1250, 3860, 156, '有货', '2025-08-15', 0, 0.18, 0.00, 1, '七天无理由退换', '新品,热销,5G', 1, 'S0000000000000002', '2025-08-20 00:00:00', '2025-11-24 10:30:00');
INSERT INTO `product_info` VALUES ('P0000000000000002', '华为Mate 60 Pro 512G', '华为', '手机', '{\"内存\": [\"256G\", \"512G\", \"1TB\"], \"颜色\": [\"曜石黑\", \"昆仑玻璃白\"], \"处理器\": [\"麒麟9000S\"]}', 7999.00, 8999.00, 88.89, 1560, 4280, 98, '有货', '2025-07-20', 0, 0.19, 0.00, 1, '七天无理由退换', '新品,国产,5G', 1, 'S0000000000000001', '2025-07-25 00:00:00', '2025-11-24 11:15:00');
INSERT INTO `product_info` VALUES ('P0000000000000003', '小米Pad 6 11英寸', '小米', '平板电脑', '{\"存储\": [\"128G\", \"256G\"], \"颜色\": [\"深空灰\", \"白色\"], \"处理器\": [\"骁龙870\"]}', 2299.00, 2499.00, 91.99, 890, 2350, 245, '有货', '2025-09-05', 0, 0.42, 0.00, 0, '七天无理由退换', '平板,学习,办公', 1, 'S0000000000000003', '2025-09-10 00:00:00', '2025-11-23 09:45:00');
INSERT INTO `product_info` VALUES ('P0000000000000004', 'Apple Watch Ultra 2', '苹果', '智能手表', '{\"续航\": [\"36小时\"], \"表带\": [\"高山回环表带\", \"海洋表带\"], \"颜色\": [\"钛金属原色\", \"蓝色钛金属\"]}', 6299.00, 6999.00, 89.99, 450, 1280, 67, '有货', '2025-06-18', 0, 0.12, 0.00, 0, '七天无理由退换', '智能穿戴,健康监测', 1, 'S0000000000000002', '2025-06-23 00:00:00', '2025-11-22 14:20:00');
INSERT INTO `product_info` VALUES ('P0000000000000005', '华为FreeBuds Pro 3', '华为', '耳机音箱', '{\"续航\": [\"30小时\"], \"降噪\": [\"主动降噪\"], \"颜色\": [\"陶瓷白\", \"曜石黑\"]}', 1299.00, 1499.00, 86.79, 1120, 3560, 189, '有货', '2025-08-25', 0, 0.05, 0.00, 1, '七天无理由退换', '无线耳机,降噪,长续航', 1, 'S0000000000000001', '2025-08-30 00:00:00', '2025-11-21 16:40:00');
INSERT INTO `product_info` VALUES ('P0000000000000006', '小米120W氮化镓充电器', '小米', '充电设备', '{\"功率\": [\"120W\"], \"接口\": [\"USB-C\"], \"颜色\": [\"黑色\", \"白色\"]}', 199.00, 249.00, 79.92, 2350, 6890, 320, '有货', '2025-09-12', 0, 0.35, 0.00, 0, '七天无理由退换', '快充,氮化镓,安全', 1, 'S0000000000000003', '2025-09-17 00:00:00', '2025-11-20 10:10:00');
INSERT INTO `product_info` VALUES ('P0000000000000007', 'iPhone 15 手机壳', '苹果', '配件周边', '{\"材质\": [\"硅胶\", \"钢化玻璃\"], \"防摔\": [\"2米防摔\"], \"颜色\": [\"透明\", \"黑色\", \"蓝色\"]}', 99.00, 129.00, 76.74, 1860, 5420, 450, '有货', '2025-10-01', 0, 0.03, 0.00, 1, '七天无理由退换', '配件,防摔,保护壳', 1, 'S0000000000000002', '2025-10-06 00:00:00', '2025-11-19 13:30:00');
INSERT INTO `product_info` VALUES ('P0000000000000008', '华为定制礼盒（Mate 60+耳机）', '华为', '官方定制', '{\"配置\": [\"Mate 60 256G\", \"FreeBuds 5i\"], \"颜色\": [\"黑色套装\", \"白色套装\"]}', 9299.00, 10299.00, 90.29, 180, 450, 36, '预售', '2025-11-01', 0, 0.85, 0.00, 1, '七天无理由退换', '定制,礼盒,套装', 1, 'S0000000000000001', '2025-11-06 00:00:00', '2025-11-18 09:20:00');
INSERT INTO `product_info` VALUES ('P0000000000000009', '苹果一年官方保修服务', '苹果', '官方服务', '{\"服务类型\": [\"一年保修\", \"两年保修\"], \"适用机型\": [\"iPhone\", \"iPad\", \"Watch\"]}', 799.00, 999.00, 79.98, 320, 890, 0, '有货', '1970-01-01', 0, 0.00, 0.00, 1, '官方售后保障', '服务,保修,官方', 1, 'S0000000000000002', '2025-05-10 00:00:00', '2025-11-17 15:45:00');
INSERT INTO `product_info` VALUES ('P0000000000000010', '荣耀Magic6 12+256G', '荣耀', '手机', '{\"内存\": [\"12+256G\", \"12+512G\"], \"颜色\": [\"亮黑色\", \"青海湖蓝\"], \"处理器\": [\"骁龙8 Gen3\"]}', 5299.00, 5799.00, 91.38, 980, 2750, 86, '有货', '2025-09-30', 0, 0.17, 0.00, 0, '七天无理由退换', '5G,拍照,长续航', 1, 'S0000000000000004', '2025-10-05 00:00:00', '2025-11-16 11:50:00');
INSERT INTO `product_info` VALUES ('P0000000000000011', 'OPPO Pad 2 12.1英寸', 'OPPO', '平板电脑', '{\"存储\": [\"8+256G\", \"12+512G\"], \"颜色\": [\"星云灰\", \"极光紫\"], \"处理器\": [\"天玑9000\"]}', 3499.00, 3799.00, 92.10, 650, 1890, 156, '有货', '2025-08-10', 0, 0.45, 0.00, 1, '七天无理由退换', '平板,高性能,办公', 1, 'S0000000000000005', '2025-08-15 00:00:00', '2025-11-15 14:25:00');
INSERT INTO `product_info` VALUES ('P0000000000000012', 'vivo WATCH 3', 'vivo', '智能手表', '{\"功能\": [\"血氧监测\", \"心电图\"], \"续航\": [\"14天\"], \"颜色\": [\"曜石黑\", \"冰川白\"]}', 1599.00, 1799.00, 88.99, 420, 1180, 78, '有货', '2025-07-15', 0, 0.11, 0.00, 0, '七天无理由退换', '智能穿戴,健康,长续航', 1, 'S0000000000000006', '2025-07-20 00:00:00', '2025-11-14 09:10:00');
INSERT INTO `product_info` VALUES ('P0000000000000013', '三星Galaxy Buds3 Pro', '三星', '耳机音箱', '{\"续航\": [\"28小时\"], \"降噪\": [\"360°音频\"], \"颜色\": [\"石墨黑\", \"白色\"]}', 1199.00, 1399.00, 85.71, 780, 2340, 125, '有货', '2025-09-08', 0, 0.05, 0.00, 1, '七天无理由退换', '无线耳机,降噪,高清音频', 1, 'S0000000000000007', '2025-09-13 00:00:00', '2025-11-13 16:35:00');
INSERT INTO `product_info` VALUES ('P0000000000000014', '一加100W快充头', '一加', '充电设备', '{\"兼容\": [\"PD协议\"], \"功率\": [\"100W\"], \"颜色\": [\"黑色\"]}', 179.00, 229.00, 78.17, 1560, 4280, 210, '有货', '2025-10-12', 0, 0.32, 0.00, 0, '七天无理由退换', '快充,兼容,安全', 1, 'S0000000000000008', '2025-10-17 00:00:00', '2025-11-12 11:20:00');
INSERT INTO `product_info` VALUES ('P0000000000000015', 'realme真我GT Neo5 手机膜', 'realme', '配件周边', '{\"材质\": [\"钢化膜\", \"水凝膜\"], \"贴合\": [\"全贴合\"], \"防刮\": [\"9H硬度\"]}', 59.00, 89.00, 66.29, 2150, 6540, 380, '有货', '2025-10-20', 0, 0.02, 0.00, 1, '七天无理由退换', '配件,防刮,贴膜', 1, 'S0000000000000009', '2025-10-25 00:00:00', '2025-11-11 15:40:00');
INSERT INTO `product_info` VALUES ('P0000000000000016', '传音Infinix定制背包', '传音', '官方定制', '{\"容量\": [\"20L\"], \"适用\": [\"笔记本\", \"平板\"], \"颜色\": [\"黑色\", \"蓝色\"]}', 199.00, 299.00, 66.56, 320, 890, 45, '限购', '2025-09-25', 0, 0.85, 0.00, 0, '七天无理由退换', '定制,背包,数码配件', 1, 'S0000000000000010', '2025-09-30 00:00:00', '2025-11-10 10:05:00');
INSERT INTO `product_info` VALUES ('P0000000000000017', '魅族手机维修服务（屏幕更换）', '魅族', '官方服务', '{\"服务类型\": [\"屏幕更换\", \"电池更换\"], \"适用机型\": [\"魅族18\", \"魅族19\", \"魅族20\"]}', 599.00, 799.00, 74.97, 180, 450, 0, '有货', '1970-01-01', 0, 0.00, 0.00, 1, '官方售后保障', '维修,服务,官方', 1, 'S0000000000000011', '2025-06-10 00:00:00', '2025-11-09 13:25:00');
INSERT INTO `product_info` VALUES ('P0000000000000018', '努比亚红魔8S Pro 16+512G', '努比亚', '手机', '{\"内存\": [\"16+512G\", \"16+1TB\"], \"颜色\": [\"暗影黑\", \"氘锋透明\"], \"处理器\": [\"骁龙8 Gen2\"]}', 6499.00, 6999.00, 92.86, 580, 1560, 32, '缺货', '2025-08-05', 0, 0.21, 0.00, 0, '七天无理由退换', '游戏手机,高性能,散热', 1, 'S0000000000000012', '2025-08-10 00:00:00', '2025-11-08 09:50:00');
INSERT INTO `product_info` VALUES ('P0000000000000019', '黑鲨游戏手柄3', '黑鲨', '配件周边', '{\"适配\": [\"黑鲨手机\", \"其他安卓手机\"], \"颜色\": [\"黑色\", \"红色\"], \"连接方式\": [\"蓝牙\", \"有线\"]}', 399.00, 499.00, 79.96, 420, 1180, 68, '有货', '2025-07-25', 0, 0.28, 0.00, 1, '七天无理由退换', '游戏配件,手柄,蓝牙', 1, 'S0000000000000014', '2025-07-30 00:00:00', '2025-11-07 16:15:00');
INSERT INTO `product_info` VALUES ('P0000000000000020', '摩托罗拉edge X40 12+256G', '摩托罗拉', '手机', '{\"内存\": [\"8+256G\", \"12+256G\"], \"颜色\": [\"墨黑\", \"晴雪\"], \"处理器\": [\"骁龙8 Gen2\"]}', 3299.00, 3599.00, 91.66, 750, 2040, 105, '有货', '2025-09-18', 0, 0.16, 0.00, 0, '七天无理由退换', '性价比,5G,长续航', 1, 'S0000000000000015', '2025-09-23 00:00:00', '2025-11-06 14:30:00');

-- ----------------------------
-- Table structure for seller_info
-- ----------------------------
DROP TABLE IF EXISTS `seller_info`;
CREATE TABLE `seller_info`  (
  `seller_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商家ID（格式：S+16位数字，如S1234567890123456）',
  `seller_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商家名称（如京东自营、淘宝旗舰店）',
  `seller_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商家类别（如电子产品、服装鞋帽、食品生鲜）',
  `credit_code` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '统一社会信用代码（18位）',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话（支持固定电话+手机号）',
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `business_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '经营地址（详细地址）',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所在城市（如深圳市、杭州市）',
  `establish_time` date NULL DEFAULT NULL COMMENT '商家成立时间',
  `registered_capital` decimal(12, 2) NULL DEFAULT 0.00 COMMENT '注册资本（单位：万元）',
  `is_self_operated` tinyint(1) NOT NULL DEFAULT 0 COMMENT '自营标识（0-第三方，1-平台自营）',
  `delivery_scope` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配送范围（如全国配送、江浙沪皖包邮）',
  `ship_promise` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货时间承诺（如48小时内发货）',
  `seller_rating` decimal(3, 2) NULL DEFAULT 4.50 COMMENT '商家评分（0.00-5.00分）',
  `praise_rate` decimal(5, 2) NULL DEFAULT 98.00 COMMENT '好评率（0.00-100.00%）',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '商家状态（0-禁用，1-正常营业）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商家创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商家信息更新时间',
  PRIMARY KEY (`seller_id`) USING BTREE,
  UNIQUE INDEX `credit_code`(`credit_code` ASC) USING BTREE,
  UNIQUE INDEX `contact_email`(`contact_email` ASC) USING BTREE,
  INDEX `idx_seller_name`(`seller_name` ASC) USING BTREE COMMENT '商家名称索引（优化查询速度）',
  INDEX `idx_credit_code`(`credit_code` ASC) USING BTREE COMMENT '统一社会信用代码索引（合规查询）',
  INDEX `idx_city`(`city` ASC) USING BTREE COMMENT '城市索引（按地区筛选商家）'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seller_info
-- ----------------------------
INSERT INTO `seller_info` VALUES ('S0000000000000001', '华为官方旗舰店', '电子产品', '91440300MA5G4X7Y3A', '4008308300', 'huawei@official.com', '深圳市南山区科技园南区1号', '深圳市', '2015-03-18', 5000.00, 1, '全国配送', '24小时内发货', 4.90, 99.80, 1, '2023-01-10 00:00:00', '2025-11-24 10:30:00');
INSERT INTO `seller_info` VALUES ('S0000000000000002', '苹果中国直营店', '电子产品', '91310115MA1G87X2Y9', '4006668800', 'apple@cnstore.com', '上海市浦东新区陆家嘴环路1388号', '上海市', '2016-05-22', 8000.00, 1, '全国配送', '48小时内发货', 4.85, 99.50, 1, '2023-02-15 00:00:00', '2025-11-24 11:15:00');
INSERT INTO `seller_info` VALUES ('S0000000000000003', '小米授权专卖店', '电子产品', '91110108MA01E2Y3X7', '4001005678', 'xiaomi@auth.com', '北京市海淀区清河中街68号', '北京市', '2017-08-09', 3000.00, 0, '全国配送', '72小时内发货', 4.75, 98.90, 1, '2023-03-20 00:00:00', '2025-11-23 09:45:00');
INSERT INTO `seller_info` VALUES ('S0000000000000004', '荣耀数码旗舰店', '电子产品', '91440106MA9X7Y6Z5E', '4008308888', 'honor@digital.com', '广州市天河区珠江新城冼村路8号', '广州市', '2018-01-15', 2500.00, 0, '全国配送', '48小时内发货', 4.80, 99.20, 1, '2023-04-25 00:00:00', '2025-11-22 14:20:00');
INSERT INTO `seller_info` VALUES ('S0000000000000005', 'OPPO官方直营店', '电子产品', '91330108MA3Y2X1Z0D', '4001666666', 'oppo@store.com', '杭州市西湖区文一西路969号', '杭州市', '2016-11-30', 4000.00, 1, '全国配送', '24小时内发货', 4.70, 98.70, 1, '2023-05-30 00:00:00', '2025-11-21 16:40:00');
INSERT INTO `seller_info` VALUES ('S0000000000000006', 'vivo授权体验店', '电子产品', '91420100MA7Z6Y5X4C', '4006789999', 'vivo@exp.com', '武汉市洪山区光谷大道70号', '武汉市', '2019-03-12', 1800.00, 0, '华中地区配送', '72小时内发货', 4.65, 98.50, 1, '2023-06-05 00:00:00', '2025-11-20 10:10:00');
INSERT INTO `seller_info` VALUES ('S0000000000000007', '三星数码专营店', '电子产品', '91120101MA2X3Y4Z5B', '4008105858', 'samsung@shop.com', '天津市和平区南京路189号', '天津市', '2017-04-18', 3500.00, 0, '全国配送', '48小时内发货', 4.60, 98.30, 1, '2023-07-10 00:00:00', '2025-11-19 13:30:00');
INSERT INTO `seller_info` VALUES ('S0000000000000008', '一加官方旗舰店', '电子产品', '91440300MA5Z6Y7X8A', '4008881111', 'oneplus@official.com', '深圳市宝安区新安街道海旺社区', '深圳市', '2018-06-22', 2000.00, 1, '全国配送', '24小时内发货', 4.90, 99.70, 1, '2023-08-15 00:00:00', '2025-11-18 09:20:00');
INSERT INTO `seller_info` VALUES ('S0000000000000009', 'realme真我专卖店', '电子产品', '91310117MA8X9Y0Z1F', '4008329999', 'realme@shop.com', '上海市闵行区沪闵路7866号', '上海市', '2020-01-08', 1500.00, 0, '华东地区配送', '72小时内发货', 4.75, 99.00, 1, '2023-09-20 00:00:00', '2025-11-17 15:45:00');
INSERT INTO `seller_info` VALUES ('S0000000000000010', '传音数码旗舰店', '电子产品', '91440113MA1Y2X3Z4E', '4008809999', 'itel@digital.com', '广州市番禺区番禺大道北555号', '广州市', '2019-08-16', 1200.00, 0, '全国配送', '48小时内发货', 4.60, 98.20, 1, '2023-10-25 00:00:00', '2025-11-16 11:50:00');
INSERT INTO `seller_info` VALUES ('S0000000000000011', '魅族官方直营店', '电子产品', '91330206MA4Z5Y6X7D', '4007883333', 'meizu@store.com', '宁波市鄞州区中山东路1888号', '宁波市', '2017-02-14', 2200.00, 1, '江浙沪皖配送', '24小时内发货', 4.80, 99.30, 1, '2023-11-30 00:00:00', '2025-11-15 14:25:00');
INSERT INTO `seller_info` VALUES ('S0000000000000012', '努比亚授权店', '电子产品', '91110105MA7X8Y9Z0C', '4006766666', 'nubia@auth.com', '北京市朝阳区朝阳北路101号', '北京市', '2018-11-05', 1600.00, 0, '全国配送', '72小时内发货', 4.55, 98.00, 1, '2023-12-05 00:00:00', '2025-11-14 09:10:00');
INSERT INTO `seller_info` VALUES ('S0000000000000013', '红魔游戏手机店', '电子产品', '91440300MA9Y0Z1X2B', '4008886666', 'redmagic@game.com', '深圳市龙岗区坂田街道稼先路', '深圳市', '2019-05-18', 1900.00, 0, '全国配送', '48小时内发货', 4.85, 99.40, 1, '2024-01-10 00:00:00', '2025-11-13 16:35:00');
INSERT INTO `seller_info` VALUES ('S0000000000000014', '黑鲨数码专营店', '电子产品', '91310114MA2X3Y4Z5A', '4000155555', 'blackshark@shop.com', '上海市徐汇区漕宝路38号', '上海市', '2020-03-22', 1700.00, 0, '全国配送', '48小时内发货', 4.70, 98.80, 1, '2024-02-15 00:00:00', '2025-11-12 11:20:00');
INSERT INTO `seller_info` VALUES ('S0000000000000015', '摩托罗拉官方店', '电子产品', '91420107MA5Z6Y7X8F', '4008100789', 'motorola@official.com', '武汉市江汉区解放大道690号', '武汉市', '2016-07-30', 3200.00, 1, '全国配送', '24小时内发货', 4.65, 98.60, 1, '2024-03-20 00:00:00', '2025-11-11 15:40:00');
INSERT INTO `seller_info` VALUES ('S0000000000000016', '联想数码旗舰店', '电子产品', '91110102MA8X9Y0Z1E', '4009993333', 'lenovo@digital.com', '北京市海淀区中关村大街1号', '北京市', '2015-10-12', 6000.00, 1, '全国配送', '24小时内发货', 4.75, 99.10, 1, '2024-04-25 00:00:00', '2025-11-10 10:05:00');
INSERT INTO `seller_info` VALUES ('S0000000000000017', '华硕授权专卖店', '电子产品', '91330105MA1Y2X3Z4D', '4006206655', 'asus@auth.com', '杭州市拱墅区武林广场1号', '杭州市', '2017-09-18', 2800.00, 0, '江浙沪配送', '72小时内发货', 4.60, 98.40, 1, '2024-05-30 00:00:00', '2025-11-09 13:25:00');
INSERT INTO `seller_info` VALUES ('S0000000000000018', '宏碁数码专营店', '电子产品', '91440104MA4Z5Y6X7C', '4007006666', 'acer@shop.com', '广州市越秀区北京路328号', '广州市', '2018-12-05', 2100.00, 0, '华南地区配送', '48小时内发货', 4.50, 97.90, 1, '2024-06-05 00:00:00', '2025-11-08 09:50:00');
INSERT INTO `seller_info` VALUES ('S0000000000000019', '微星游戏设备店', '电子产品', '91310112MA7X8Y9Z0B', '4008288888', 'msi@game.com', '上海市杨浦区邯郸路600号', '上海市', '2019-11-12', 2300.00, 0, '全国配送', '72小时内发货', 4.75, 99.20, 1, '2024-07-10 00:00:00', '2025-11-07 16:15:00');
INSERT INTO `seller_info` VALUES ('S0000000000000020', '雷蛇官方旗舰店', '电子产品', '91440300MA0Y1X2Z3A', '4000888888', 'razer@official.com', '深圳市南山区蛇口工业六路', '深圳市', '2020-04-18', 2600.00, 1, '全国配送', '24小时内发货', 4.90, 99.60, 1, '2024-08-15 00:00:00', '2025-11-06 14:30:00');

-- ----------------------------
-- Table structure for system_user
-- ----------------------------
DROP TABLE IF EXISTS `system_user`;
CREATE TABLE `system_user`  (
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（加密存储）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '真实姓名',
  `role` enum('ADMIN','OPERATOR','AUDITOR') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态（1-启用 0-停用）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_user
-- ----------------------------
INSERT INTO `system_user` VALUES ('USER001', 'admin1', 'password123', '管理员1', 'ADMIN', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `system_user` VALUES ('USER002', 'admin2', 'password123', '管理员2', 'ADMIN', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `system_user` VALUES ('USER003', 'operator1', 'password123', '操作员1', 'OPERATOR', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `system_user` VALUES ('USER004', 'operator2', 'password123', '操作员2', 'OPERATOR', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `system_user` VALUES ('USER005', 'auditor1', 'password123', '审批人1', 'AUDITOR', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `system_user` VALUES ('USER006', 'auditor2', 'password123', '审批人2', 'AUDITOR', 1, '2025-11-29 15:32:34', '2025-11-29 15:32:34');

-- ----------------------------
-- Table structure for tag_application
-- ----------------------------
DROP TABLE IF EXISTS `tag_application`;
CREATE TABLE `tag_application`  (
  `application_id` int NOT NULL AUTO_INCREMENT COMMENT '申请ID',
  `tag_id` int NOT NULL COMMENT '标签ID，关联tag_definition表',
  `applicant_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请人ID，关联system_user表',
  `application_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `application_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请理由',
  `application_status` enum('PENDING','APPROVED','REJECTED','WITHDRAWN') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请状态',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`application_id`) USING BTREE,
  INDEX `tag_id`(`tag_id` ASC) USING BTREE,
  INDEX `idx_application_status`(`application_status` ASC) USING BTREE,
  INDEX `idx_applicant_id`(`applicant_id` ASC) USING BTREE,
  CONSTRAINT `tag_application_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `tag_definition` (`tag_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tag_application_ibfk_2` FOREIGN KEY (`applicant_id`) REFERENCES `system_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag_application
-- ----------------------------
INSERT INTO `tag_application` VALUES (1, 101, 'USER003', '2025-11-29 15:32:34', '需要创建新的用户基础标签', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 16:35:57');
INSERT INTO `tag_application` VALUES (2, 102, 'USER004', '2025-11-29 15:32:34', '需要创建新的用户行为标签', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 16:36:10');
INSERT INTO `tag_application` VALUES (3, 103, 'USER003', '2025-11-29 15:32:34', '需要创建新的商品统计标签', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 16:36:20');
INSERT INTO `tag_application` VALUES (4, 104, 'USER004', '2025-11-29 15:32:34', '需要创建新的商家衍生标签', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 16:36:26');
INSERT INTO `tag_application` VALUES (5, 105, 'USER003', '2025-11-29 15:32:34', '需要创建新的用户基础标签', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 16:36:33');
INSERT INTO `tag_application` VALUES (6, 106, 'USER004', '2025-11-29 15:32:34', '需要创建新的商品行为标签', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 16:36:39');
INSERT INTO `tag_application` VALUES (7, 107, 'USER003', '2025-11-29 15:32:34', '需要创建新的商家统计标签', 'WITHDRAWN', '2025-11-29 15:32:34', '2025-11-29 16:36:43');
INSERT INTO `tag_application` VALUES (8, 8, 'USER004', '2025-11-29 15:32:34', '需要创建新的用户衍生标签', 'WITHDRAWN', '2025-11-29 15:32:34', '2025-11-29 15:32:34');
INSERT INTO `tag_application` VALUES (9, 101, 'USER003', '2025-11-29 16:05:30', '需要创建新的用户基础标签', 'PENDING', '2025-11-29 16:05:30', '2025-11-29 16:36:01');
INSERT INTO `tag_application` VALUES (10, 102, 'USER004', '2025-11-29 16:05:30', '需要创建新的用户行为标签', 'PENDING', '2025-11-29 16:05:30', '2025-11-29 16:36:12');
INSERT INTO `tag_application` VALUES (11, 103, 'USER003', '2025-11-29 16:05:30', '需要创建新的商品统计标签', 'APPROVED', '2025-11-29 16:05:30', '2025-11-29 16:36:22');
INSERT INTO `tag_application` VALUES (12, 104, 'USER004', '2025-11-29 16:05:30', '需要创建新的商家衍生标签', 'APPROVED', '2025-11-29 16:05:30', '2025-11-29 16:36:27');
INSERT INTO `tag_application` VALUES (13, 105, 'USER003', '2025-11-29 16:05:30', '需要创建新的用户基础标签', 'REJECTED', '2025-11-29 16:05:30', '2025-11-29 16:36:35');
INSERT INTO `tag_application` VALUES (14, 106, 'USER004', '2025-11-29 16:05:30', '需要创建新的商品行为标签', 'REJECTED', '2025-11-29 16:05:30', '2025-11-29 16:36:40');
INSERT INTO `tag_application` VALUES (15, 107, 'USER003', '2025-11-29 16:05:30', '需要创建新的商家统计标签', 'WITHDRAWN', '2025-11-29 16:05:30', '2025-11-29 16:36:45');
INSERT INTO `tag_application` VALUES (16, 8, 'USER004', '2025-11-29 16:05:30', '需要创建新的用户衍生标签', 'WITHDRAWN', '2025-11-29 16:05:30', '2025-11-29 16:05:30');
INSERT INTO `tag_application` VALUES (17, 101, 'USER003', '2025-11-29 16:07:09', '需要创建新的用户基础标签', 'PENDING', '2025-11-29 16:07:09', '2025-11-29 16:36:03');
INSERT INTO `tag_application` VALUES (18, 102, 'USER004', '2025-11-29 16:07:09', '需要创建新的用户行为标签', 'PENDING', '2025-11-29 16:07:09', '2025-11-29 16:36:15');
INSERT INTO `tag_application` VALUES (19, 103, 'USER003', '2025-11-29 16:07:09', '需要创建新的商品统计标签', 'APPROVED', '2025-11-29 16:07:09', '2025-11-29 16:36:24');
INSERT INTO `tag_application` VALUES (20, 104, 'USER004', '2025-11-29 16:07:09', '需要创建新的商家衍生标签', 'APPROVED', '2025-11-29 16:07:09', '2025-11-29 16:36:29');
INSERT INTO `tag_application` VALUES (21, 105, 'USER003', '2025-11-29 16:07:09', '需要创建新的用户基础标签', 'REJECTED', '2025-11-29 16:07:09', '2025-11-29 16:36:37');
INSERT INTO `tag_application` VALUES (22, 106, 'USER004', '2025-11-29 16:07:09', '需要创建新的商品行为标签', 'REJECTED', '2025-11-29 16:07:09', '2025-11-29 16:36:42');
INSERT INTO `tag_application` VALUES (23, 107, 'USER003', '2025-11-29 16:07:09', '需要创建新的商家统计标签', 'WITHDRAWN', '2025-11-29 16:07:09', '2025-11-29 16:36:46');
INSERT INTO `tag_application` VALUES (24, 8, 'USER004', '2025-11-29 16:07:09', '需要创建新的用户衍生标签', 'WITHDRAWN', '2025-11-29 16:07:09', '2025-11-29 16:07:09');

-- ----------------------------
-- Table structure for tag_definition
-- ----------------------------
DROP TABLE IF EXISTS `tag_definition`;
CREATE TABLE `tag_definition`  (
  `tag_id` int NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签编码（如 USER_GENDER, PROD_HOT）',
  `tag_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签显示名（如 性别, 热销商品）',
  `tag_layer` enum('基础','行为','统计','衍生') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签层级',
  `entity_type` enum('CUSTOMER','PRODUCT','SELLER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签归属实体',
  `data_type` enum('ENUM','BOOLEAN','NUMBER','STRING') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'STRING' COMMENT '值类型',
  `update_frequency` enum('REALTIME','DAILY','WEEKLY','MONTHLY') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'DAILY' COMMENT '更新频率',
  `status` enum('PENDING','APPROVED','REJECTED','DISABLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'PENDING' COMMENT '状态（PENDING-待审批 APPROVED-已通过 REJECTED-已拒绝 DISABLED-已停用）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`tag_id`) USING BTREE,
  UNIQUE INDEX `tag_code`(`tag_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 109 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '标签定义元数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag_definition
-- ----------------------------
INSERT INTO `tag_definition` VALUES (1, 'C_BAS_GENDER', '性别识别', '基础', 'CUSTOMER', 'ENUM', 'REALTIME', 'APPROVED', '2025-11-25 22:00:46', '2025-11-29 16:24:55');
INSERT INTO `tag_definition` VALUES (2, 'C_BAS_AGE_BIN', '年龄段', '基础', 'CUSTOMER', 'ENUM', 'REALTIME', 'REJECTED', '2025-11-25 22:00:46', '2025-11-29 16:25:34');
INSERT INTO `tag_definition` VALUES (3, 'C_BAS_EDU', '学历水平', '基础', 'CUSTOMER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (4, 'C_BAS_REGION', '地域分布', '基础', 'CUSTOMER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (5, 'C_BAS_TENURE', '入会时长', '基础', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (6, 'C_STA_MONETARY', '消费能力', '统计', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (7, 'C_STA_FREQ', '购买频次', '统计', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (8, 'C_STA_ATV', '客单价等级', '统计', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (9, 'C_DRV_RFM', '用户价值(RFM)', '衍生', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (10, 'C_DRV_PREF', '数码偏好', '衍生', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (11, 'P_BAS_CAT', '所属品类', '基础', 'PRODUCT', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (12, 'P_BAS_BRAND', '品牌阵营', '基础', 'PRODUCT', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (13, 'P_BAS_SPEC', '硬件规格', '基础', 'PRODUCT', 'STRING', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (14, 'P_BAS_PRICE_TIER', '价格区间', '基础', 'PRODUCT', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (15, 'P_BAS_SOURCE', '产地/保质', '基础', 'PRODUCT', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (16, 'P_STA_DISCOUNT', '折扣力度', '统计', 'PRODUCT', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (17, 'P_STA_CONV', '转化能力', '统计', 'PRODUCT', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (18, 'P_STA_LOGISTIC', '物流属性', '统计', 'PRODUCT', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (19, 'P_DRV_LIFECYCLE', '生命周期', '衍生', 'PRODUCT', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (20, 'P_DRV_CP_RATIO', '性价比指数', '衍生', 'PRODUCT', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (21, 'P_DRV_TARGET', '人群定位', '衍生', 'PRODUCT', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (22, 'P_DRV_SERVICE', '售后无忧', '衍生', 'PRODUCT', 'BOOLEAN', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (23, 'S_BAS_MODE', '经营模式', '基础', 'SELLER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (24, 'S_BAS_CITY', '所在地区', '基础', 'SELLER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (25, 'S_BAS_AGE', '老字号', '基础', 'SELLER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (26, 'S_STA_CREDIT', '信誉评级', '统计', 'SELLER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (27, 'S_STA_PRAISE', '口碑表现', '统计', 'SELLER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (28, 'S_STA_CAPITAL', '资本实力', '统计', 'SELLER', 'ENUM', 'REALTIME', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (29, 'S_DRV_POTENTIAL', '主要潜力', '衍生', 'SELLER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (30, 'S_DRV_RISK', '风险等级', '衍生', 'SELLER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (31, 'S_DRV_MAIN_CATEGORY', '主营类目', '衍生', 'SELLER', 'ENUM', 'DAILY', 'PENDING', '2025-11-25 22:00:46', '2025-11-25 22:00:46');
INSERT INTO `tag_definition` VALUES (32, 'USER_GENDER', '性别', '基础', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (33, 'USER_AGE', '年龄段', '基础', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (34, 'USER_EDUCATION', '学历', '基础', 'CUSTOMER', 'ENUM', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (35, 'USER_CONSUME', '累计消费', '统计', 'CUSTOMER', 'NUMBER', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (36, 'USER_ACTIVE', '最近7天活跃', '行为', 'CUSTOMER', 'BOOLEAN', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (37, 'USER_LOYALTY', '忠诚度', '衍生', 'CUSTOMER', 'STRING', 'DAILY', 'PENDING', '2025-11-28 00:49:39', '2025-11-28 00:49:39');
INSERT INTO `tag_definition` VALUES (101, 'TEST_TAG_001', '测试标签1', '基础', 'CUSTOMER', 'STRING', 'DAILY', 'PENDING', '2025-11-29 15:32:34', '2025-11-29 16:35:10');
INSERT INTO `tag_definition` VALUES (102, 'TEST_TAG_002', '测试标签2', '行为', 'CUSTOMER', 'BOOLEAN', 'DAILY', 'PENDING', '2025-11-29 15:32:34', '2025-11-29 16:35:12');
INSERT INTO `tag_definition` VALUES (103, 'TEST_TAG_003', '测试标签3', '统计', 'PRODUCT', 'NUMBER', 'DAILY', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 16:35:14');
INSERT INTO `tag_definition` VALUES (104, 'TEST_TAG_004', '测试标签4', '衍生', 'SELLER', 'STRING', 'DAILY', 'APPROVED', '2025-11-29 15:32:34', '2025-11-29 16:35:15');
INSERT INTO `tag_definition` VALUES (105, 'TEST_TAG_005', '测试标签5', '基础', 'CUSTOMER', 'STRING', 'DAILY', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 16:35:19');
INSERT INTO `tag_definition` VALUES (106, 'TEST_TAG_006', '测试标签6', '行为', 'PRODUCT', 'BOOLEAN', 'DAILY', 'REJECTED', '2025-11-29 15:32:34', '2025-11-29 16:35:22');
INSERT INTO `tag_definition` VALUES (107, 'TEST_TAG_007', '测试标签7', '统计', 'SELLER', 'NUMBER', 'DAILY', 'PENDING', '2025-11-29 15:32:34', '2025-11-29 16:35:24');
INSERT INTO `tag_definition` VALUES (108, 'TEST_TAG_008', '测试标签8', '衍生', 'CUSTOMER', 'STRING', 'DAILY', 'PENDING', '2025-11-29 15:32:34', '2025-11-29 16:41:46');

-- ----------------------------
-- Table structure for tag_relation_customer
-- ----------------------------
DROP TABLE IF EXISTS `tag_relation_customer`;
CREATE TABLE `tag_relation_customer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `customer_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 customer_info.customer_id',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 tag_definition.tag_code',
  `tag_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签值（如 \"男\", \"高价值\", \"0.85\"）',
  `score` decimal(5, 4) NULL DEFAULT 1.0000 COMMENT '标签权重/置信度（用于算法标签）',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_cust_tag`(`customer_id` ASC, `tag_code` ASC) USING BTREE,
  INDEX `idx_tag_value`(`tag_code` ASC, `tag_value` ASC) USING BTREE,
  CONSTRAINT `tag_relation_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer_info` (`customer_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tag_relation_customer_ibfk_2` FOREIGN KEY (`tag_code`) REFERENCES `tag_definition` (`tag_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 318 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户标签结果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag_relation_customer
-- ----------------------------
INSERT INTO `tag_relation_customer` VALUES (1, 'U0000000000000001', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (2, 'U0000000000000002', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (3, 'U0000000000000003', 'C_BAS_GENDER', '未知', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (4, 'U0000000000000004', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (5, 'U0000000000000005', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (6, 'U0000000000000006', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (7, 'U0000000000000007', 'C_BAS_GENDER', '未知', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (8, 'U0000000000000008', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (9, 'U0000000000000009', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (10, 'U0000000000000010', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (11, 'U0000000000000011', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (12, 'U0000000000000012', 'C_BAS_GENDER', '未知', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (13, 'U0000000000000013', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (14, 'U0000000000000014', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (15, 'U0000000000000015', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (16, 'U0000000000000016', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (17, 'U0000000000000017', 'C_BAS_GENDER', '未知', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (18, 'U0000000000000018', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (19, 'U0000000000000019', 'C_BAS_GENDER', '男', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (20, 'U0000000000000020', 'C_BAS_GENDER', '女', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (32, 'U0000000000000001', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (33, 'U0000000000000002', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (34, 'U0000000000000003', 'C_BAS_AGE_BIN', 'Z世代', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (35, 'U0000000000000004', 'C_BAS_AGE_BIN', '中年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (36, 'U0000000000000005', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (37, 'U0000000000000006', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (38, 'U0000000000000007', 'C_BAS_AGE_BIN', 'Z世代', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (39, 'U0000000000000008', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (40, 'U0000000000000009', 'C_BAS_AGE_BIN', '中年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (41, 'U0000000000000010', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (42, 'U0000000000000011', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (43, 'U0000000000000012', 'C_BAS_AGE_BIN', 'Z世代', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (44, 'U0000000000000013', 'C_BAS_AGE_BIN', '中年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (45, 'U0000000000000014', 'C_BAS_AGE_BIN', '中年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (46, 'U0000000000000015', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (47, 'U0000000000000016', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (48, 'U0000000000000017', 'C_BAS_AGE_BIN', 'Z世代', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (49, 'U0000000000000018', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (50, 'U0000000000000019', 'C_BAS_AGE_BIN', '中年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (51, 'U0000000000000020', 'C_BAS_AGE_BIN', '青年', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (63, 'U0000000000000001', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (64, 'U0000000000000002', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (65, 'U0000000000000003', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (66, 'U0000000000000004', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (67, 'U0000000000000005', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (68, 'U0000000000000006', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (69, 'U0000000000000007', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (70, 'U0000000000000008', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (71, 'U0000000000000009', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (72, 'U0000000000000010', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (73, 'U0000000000000011', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (74, 'U0000000000000012', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (75, 'U0000000000000013', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (76, 'U0000000000000014', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (77, 'U0000000000000015', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (78, 'U0000000000000016', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (79, 'U0000000000000017', 'C_BAS_EDU', '基础人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (80, 'U0000000000000018', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (81, 'U0000000000000019', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (82, 'U0000000000000020', 'C_BAS_EDU', '高知人群', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (94, 'U0000000000000001', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (95, 'U0000000000000002', 'C_BAS_REGION', '一线城市', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (96, 'U0000000000000003', 'C_BAS_REGION', '一线城市', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (97, 'U0000000000000004', 'C_BAS_REGION', '江浙沪', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (98, 'U0000000000000005', 'C_BAS_REGION', '江浙沪', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (99, 'U0000000000000006', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (100, 'U0000000000000007', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (101, 'U0000000000000008', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (102, 'U0000000000000009', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (103, 'U0000000000000010', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (104, 'U0000000000000011', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (105, 'U0000000000000012', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (106, 'U0000000000000013', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (107, 'U0000000000000014', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (108, 'U0000000000000015', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (109, 'U0000000000000016', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (110, 'U0000000000000017', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (111, 'U0000000000000018', 'C_BAS_REGION', '其他', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (112, 'U0000000000000019', 'C_BAS_REGION', '一线城市', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (113, 'U0000000000000020', 'C_BAS_REGION', '一线城市', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (125, 'U0000000000000001', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (126, 'U0000000000000002', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (127, 'U0000000000000003', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (128, 'U0000000000000004', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (129, 'U0000000000000005', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (130, 'U0000000000000006', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (131, 'U0000000000000007', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (132, 'U0000000000000008', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (133, 'U0000000000000009', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (134, 'U0000000000000010', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (135, 'U0000000000000011', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (136, 'U0000000000000012', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (137, 'U0000000000000013', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (138, 'U0000000000000014', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (139, 'U0000000000000015', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (140, 'U0000000000000016', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (141, 'U0000000000000017', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (142, 'U0000000000000018', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (143, 'U0000000000000019', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (144, 'U0000000000000020', 'C_BAS_TENURE', '老用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (156, 'U0000000000000001', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (157, 'U0000000000000002', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (158, 'U0000000000000003', 'C_STA_MONETARY', '低消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (159, 'U0000000000000004', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (160, 'U0000000000000005', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (161, 'U0000000000000006', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (162, 'U0000000000000007', 'C_STA_MONETARY', '低消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (163, 'U0000000000000008', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (164, 'U0000000000000009', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (165, 'U0000000000000010', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (166, 'U0000000000000011', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (167, 'U0000000000000012', 'C_STA_MONETARY', '低消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (168, 'U0000000000000013', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (169, 'U0000000000000014', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (170, 'U0000000000000015', 'C_STA_MONETARY', '低消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (171, 'U0000000000000016', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (172, 'U0000000000000017', 'C_STA_MONETARY', '低消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (173, 'U0000000000000018', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (174, 'U0000000000000019', 'C_STA_MONETARY', '高消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (175, 'U0000000000000020', 'C_STA_MONETARY', '中消费', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (187, 'U0000000000000001', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (188, 'U0000000000000002', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (189, 'U0000000000000003', 'C_STA_FREQ', '单次客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (190, 'U0000000000000004', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (191, 'U0000000000000005', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (192, 'U0000000000000006', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (193, 'U0000000000000007', 'C_STA_FREQ', '单次客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (194, 'U0000000000000008', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (195, 'U0000000000000009', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (196, 'U0000000000000010', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (197, 'U0000000000000011', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (198, 'U0000000000000012', 'C_STA_FREQ', '单次客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (199, 'U0000000000000013', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (200, 'U0000000000000014', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (201, 'U0000000000000015', 'C_STA_FREQ', '复购客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (202, 'U0000000000000016', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (203, 'U0000000000000017', 'C_STA_FREQ', '单次客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (204, 'U0000000000000018', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (205, 'U0000000000000019', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (206, 'U0000000000000020', 'C_STA_FREQ', '忠诚客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (218, 'U0000000000000001', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (219, 'U0000000000000002', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (220, 'U0000000000000003', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (221, 'U0000000000000004', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (222, 'U0000000000000005', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (223, 'U0000000000000006', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (224, 'U0000000000000007', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (225, 'U0000000000000008', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (226, 'U0000000000000009', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (227, 'U0000000000000010', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (228, 'U0000000000000011', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (229, 'U0000000000000012', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (230, 'U0000000000000013', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (231, 'U0000000000000014', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (232, 'U0000000000000015', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (233, 'U0000000000000016', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (234, 'U0000000000000017', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (235, 'U0000000000000018', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (236, 'U0000000000000019', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (237, 'U0000000000000020', 'C_STA_ATV', '价格敏感', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (249, 'U0000000000000001', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (250, 'U0000000000000002', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (251, 'U0000000000000003', 'C_DRV_RFM', '一般用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (252, 'U0000000000000004', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (253, 'U0000000000000005', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (254, 'U0000000000000006', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (255, 'U0000000000000007', 'C_DRV_RFM', '一般用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (256, 'U0000000000000008', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (257, 'U0000000000000009', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (258, 'U0000000000000010', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (259, 'U0000000000000011', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (260, 'U0000000000000012', 'C_DRV_RFM', '一般用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (261, 'U0000000000000013', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (262, 'U0000000000000014', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (263, 'U0000000000000015', 'C_DRV_RFM', '一般用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (264, 'U0000000000000016', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (265, 'U0000000000000017', 'C_DRV_RFM', '一般用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (266, 'U0000000000000018', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (267, 'U0000000000000019', 'C_DRV_RFM', '重要价值用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (268, 'U0000000000000020', 'C_DRV_RFM', '重要保持用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (280, 'U0000000000000001', 'C_DRV_PREF', '极客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (281, 'U0000000000000002', 'C_DRV_PREF', '家庭用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (282, 'U0000000000000003', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (283, 'U0000000000000004', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (284, 'U0000000000000005', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (285, 'U0000000000000006', 'C_DRV_PREF', '极客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (286, 'U0000000000000007', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (287, 'U0000000000000008', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (288, 'U0000000000000009', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (289, 'U0000000000000010', 'C_DRV_PREF', '家庭用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (290, 'U0000000000000011', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (291, 'U0000000000000012', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (292, 'U0000000000000013', 'C_DRV_PREF', '家庭用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (293, 'U0000000000000014', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (294, 'U0000000000000015', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (295, 'U0000000000000016', 'C_DRV_PREF', '极客', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (296, 'U0000000000000017', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (297, 'U0000000000000018', 'C_DRV_PREF', '家庭用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (298, 'U0000000000000019', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (299, 'U0000000000000020', 'C_DRV_PREF', '普通用户', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_customer` VALUES (300, 'U1234567890123456', 'USER_GENDER', '男', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (301, 'U1234567890123456', 'USER_AGE', '25-34', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (302, 'U1234567890123456', 'USER_EDUCATION', '本科', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (303, 'U1234567890123456', 'USER_CONSUME', '1200.5', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (304, 'U1234567890123456', 'USER_ACTIVE', '1', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (305, 'U1234567890123456', 'USER_LOYALTY', '中', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (306, 'U1234567890123457', 'USER_GENDER', '女', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (307, 'U1234567890123457', 'USER_AGE', '18-24', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (308, 'U1234567890123457', 'USER_EDUCATION', '大专', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (309, 'U1234567890123457', 'USER_CONSUME', '3500.0', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (310, 'U1234567890123457', 'USER_ACTIVE', '1', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (311, 'U1234567890123457', 'USER_LOYALTY', '高', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (312, 'U1234567890123458', 'USER_GENDER', '男', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (313, 'U1234567890123458', 'USER_AGE', '35-44', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (314, 'U1234567890123458', 'USER_EDUCATION', '硕士', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (315, 'U1234567890123458', 'USER_CONSUME', '5800.0', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (316, 'U1234567890123458', 'USER_ACTIVE', '1', 1.0000, '2025-11-28 00:49:39');
INSERT INTO `tag_relation_customer` VALUES (317, 'U1234567890123458', 'USER_LOYALTY', '高', 1.0000, '2025-11-28 00:49:39');

-- ----------------------------
-- Table structure for tag_relation_product
-- ----------------------------
DROP TABLE IF EXISTS `tag_relation_product`;
CREATE TABLE `tag_relation_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `product_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 product_info.product_id',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 tag_definition.tag_code',
  `tag_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签值（如 \"手机\", \"热销\", \"高性价比\"）',
  `score` decimal(5, 4) NULL DEFAULT 1.0000 COMMENT '标签权重/置信度（用于算法标签）',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_prod_tag`(`product_id` ASC, `tag_code` ASC) USING BTREE,
  INDEX `idx_tag_value`(`tag_code` ASC, `tag_value` ASC) USING BTREE,
  CONSTRAINT `tag_relation_product_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tag_relation_product_ibfk_2` FOREIGN KEY (`tag_code`) REFERENCES `tag_definition` (`tag_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 362 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品标签结果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag_relation_product
-- ----------------------------
INSERT INTO `tag_relation_product` VALUES (1, 'P0000000000000001', 'P_BAS_CAT', '手机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (2, 'P0000000000000002', 'P_BAS_CAT', '手机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (3, 'P0000000000000010', 'P_BAS_CAT', '手机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (4, 'P0000000000000018', 'P_BAS_CAT', '手机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (5, 'P0000000000000020', 'P_BAS_CAT', '手机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (6, 'P0000000000000003', 'P_BAS_CAT', '平板电脑', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (7, 'P0000000000000011', 'P_BAS_CAT', '平板电脑', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (8, 'P0000000000000004', 'P_BAS_CAT', '智能手表', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (9, 'P0000000000000012', 'P_BAS_CAT', '智能手表', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (10, 'P0000000000000005', 'P_BAS_CAT', '耳机音箱', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (11, 'P0000000000000013', 'P_BAS_CAT', '耳机音箱', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (12, 'P0000000000000006', 'P_BAS_CAT', '充电设备', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (13, 'P0000000000000014', 'P_BAS_CAT', '充电设备', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (14, 'P0000000000000007', 'P_BAS_CAT', '配件周边', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (15, 'P0000000000000015', 'P_BAS_CAT', '配件周边', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (16, 'P0000000000000019', 'P_BAS_CAT', '配件周边', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (17, 'P0000000000000008', 'P_BAS_CAT', '官方定制', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (18, 'P0000000000000016', 'P_BAS_CAT', '官方定制', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (19, 'P0000000000000009', 'P_BAS_CAT', '官方服务', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (20, 'P0000000000000017', 'P_BAS_CAT', '官方服务', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (32, 'P0000000000000011', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (33, 'P0000000000000015', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (34, 'P0000000000000012', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (35, 'P0000000000000014', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (36, 'P0000000000000013', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (37, 'P0000000000000016', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (38, 'P0000000000000018', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (39, 'P0000000000000002', 'P_BAS_BRAND', '华为', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (40, 'P0000000000000005', 'P_BAS_BRAND', '华为', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (41, 'P0000000000000008', 'P_BAS_BRAND', '华为', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (42, 'P0000000000000003', 'P_BAS_BRAND', '小米', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (43, 'P0000000000000006', 'P_BAS_BRAND', '小米', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (44, 'P0000000000000020', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (45, 'P0000000000000001', 'P_BAS_BRAND', '苹果', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (46, 'P0000000000000004', 'P_BAS_BRAND', '苹果', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (47, 'P0000000000000007', 'P_BAS_BRAND', '苹果', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (48, 'P0000000000000009', 'P_BAS_BRAND', '苹果', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (49, 'P0000000000000010', 'P_BAS_BRAND', '华为', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (50, 'P0000000000000017', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (51, 'P0000000000000019', 'P_BAS_BRAND', '其它', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (63, 'P0000000000000001', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (64, 'P0000000000000002', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (65, 'P0000000000000003', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (66, 'P0000000000000004', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (67, 'P0000000000000005', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (68, 'P0000000000000006', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (69, 'P0000000000000007', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (70, 'P0000000000000008', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (71, 'P0000000000000009', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (72, 'P0000000000000010', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (73, 'P0000000000000011', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (74, 'P0000000000000012', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (75, 'P0000000000000013', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (76, 'P0000000000000014', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (77, 'P0000000000000015', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (78, 'P0000000000000016', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (79, 'P0000000000000017', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (80, 'P0000000000000018', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (81, 'P0000000000000019', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (82, 'P0000000000000020', 'P_BAS_SPEC', '', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (94, 'P0000000000000001', 'P_BAS_PRICE_TIER', '奢华机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (95, 'P0000000000000002', 'P_BAS_PRICE_TIER', '旗舰机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (96, 'P0000000000000003', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (97, 'P0000000000000004', 'P_BAS_PRICE_TIER', '旗舰机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (98, 'P0000000000000005', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (99, 'P0000000000000006', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (100, 'P0000000000000007', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (101, 'P0000000000000008', 'P_BAS_PRICE_TIER', '奢华机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (102, 'P0000000000000009', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (103, 'P0000000000000010', 'P_BAS_PRICE_TIER', '旗舰机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (104, 'P0000000000000011', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (105, 'P0000000000000012', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (106, 'P0000000000000013', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (107, 'P0000000000000014', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (108, 'P0000000000000015', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (109, 'P0000000000000016', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (110, 'P0000000000000017', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (111, 'P0000000000000018', 'P_BAS_PRICE_TIER', '旗舰机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (112, 'P0000000000000019', 'P_BAS_PRICE_TIER', '百元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (113, 'P0000000000000020', 'P_BAS_PRICE_TIER', '千元机', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (125, 'P0000000000000011', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (126, 'P0000000000000015', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (127, 'P0000000000000012', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (128, 'P0000000000000014', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (129, 'P0000000000000013', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (130, 'P0000000000000016', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (131, 'P0000000000000018', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (132, 'P0000000000000002', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (133, 'P0000000000000005', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (134, 'P0000000000000008', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (135, 'P0000000000000003', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (136, 'P0000000000000006', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (137, 'P0000000000000020', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (138, 'P0000000000000001', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (139, 'P0000000000000004', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (140, 'P0000000000000007', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (141, 'P0000000000000009', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (142, 'P0000000000000010', 'P_BAS_SOURCE', '国产', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (143, 'P0000000000000017', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (144, 'P0000000000000019', 'P_BAS_SOURCE', '进口', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (156, 'P0000000000000001', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (157, 'P0000000000000002', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (158, 'P0000000000000003', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (159, 'P0000000000000004', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (160, 'P0000000000000005', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (161, 'P0000000000000006', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (162, 'P0000000000000007', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (163, 'P0000000000000008', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (164, 'P0000000000000009', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (165, 'P0000000000000010', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (166, 'P0000000000000011', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (167, 'P0000000000000012', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (168, 'P0000000000000013', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (169, 'P0000000000000014', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (170, 'P0000000000000015', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (171, 'P0000000000000016', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (172, 'P0000000000000017', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (173, 'P0000000000000018', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (174, 'P0000000000000019', 'P_STA_DISCOUNT', '骨折价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (175, 'P0000000000000020', 'P_STA_DISCOUNT', '微降', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (187, 'P0000000000000001', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (188, 'P0000000000000002', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (189, 'P0000000000000003', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (190, 'P0000000000000004', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (191, 'P0000000000000005', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (192, 'P0000000000000006', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (193, 'P0000000000000007', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (194, 'P0000000000000008', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (195, 'P0000000000000009', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (196, 'P0000000000000010', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (197, 'P0000000000000011', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (198, 'P0000000000000012', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (199, 'P0000000000000013', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (200, 'P0000000000000014', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (201, 'P0000000000000015', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (202, 'P0000000000000016', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (203, 'P0000000000000017', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (204, 'P0000000000000018', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (205, 'P0000000000000019', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (206, 'P0000000000000020', 'P_STA_CONV', '高转化', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (218, 'P0000000000000001', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (219, 'P0000000000000002', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (220, 'P0000000000000003', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (221, 'P0000000000000004', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (222, 'P0000000000000005', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (223, 'P0000000000000006', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (224, 'P0000000000000007', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (225, 'P0000000000000008', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (226, 'P0000000000000009', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (227, 'P0000000000000010', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (228, 'P0000000000000011', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (229, 'P0000000000000012', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (230, 'P0000000000000013', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (231, 'P0000000000000014', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (232, 'P0000000000000015', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (233, 'P0000000000000016', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (234, 'P0000000000000017', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (235, 'P0000000000000018', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (236, 'P0000000000000019', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (237, 'P0000000000000020', 'P_STA_LOGISTIC', '轻小件', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (249, 'P0000000000000001', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (250, 'P0000000000000002', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (251, 'P0000000000000003', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (252, 'P0000000000000004', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (253, 'P0000000000000005', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (254, 'P0000000000000006', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (255, 'P0000000000000007', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (256, 'P0000000000000008', 'P_DRV_LIFECYCLE', '新品上市', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (257, 'P0000000000000009', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (258, 'P0000000000000010', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (259, 'P0000000000000011', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (260, 'P0000000000000012', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (261, 'P0000000000000013', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (262, 'P0000000000000014', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (263, 'P0000000000000015', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (264, 'P0000000000000016', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (265, 'P0000000000000017', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (266, 'P0000000000000018', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (267, 'P0000000000000019', 'P_DRV_LIFECYCLE', '清仓长尾', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (268, 'P0000000000000020', 'P_DRV_LIFECYCLE', '当季热推', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (280, 'P0000000000000001', 'P_DRV_CP_RATIO', '品牌溢价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (281, 'P0000000000000002', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (282, 'P0000000000000003', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (283, 'P0000000000000004', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (284, 'P0000000000000005', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (285, 'P0000000000000006', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (286, 'P0000000000000007', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (287, 'P0000000000000008', 'P_DRV_CP_RATIO', '品牌溢价', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (288, 'P0000000000000009', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (289, 'P0000000000000010', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (290, 'P0000000000000011', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (291, 'P0000000000000012', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (292, 'P0000000000000013', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (293, 'P0000000000000014', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (294, 'P0000000000000015', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (295, 'P0000000000000016', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (296, 'P0000000000000017', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (297, 'P0000000000000018', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (298, 'P0000000000000019', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (299, 'P0000000000000020', 'P_DRV_CP_RATIO', '普通性价比', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (311, 'P0000000000000001', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (312, 'P0000000000000002', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (313, 'P0000000000000003', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (314, 'P0000000000000004', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (315, 'P0000000000000005', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (316, 'P0000000000000006', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (317, 'P0000000000000007', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (318, 'P0000000000000008', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (319, 'P0000000000000009', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (320, 'P0000000000000010', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (321, 'P0000000000000011', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (322, 'P0000000000000012', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (323, 'P0000000000000013', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (324, 'P0000000000000014', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (325, 'P0000000000000015', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (326, 'P0000000000000016', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (327, 'P0000000000000017', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (328, 'P0000000000000018', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (329, 'P0000000000000019', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (330, 'P0000000000000020', 'P_DRV_TARGET', '大众风', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (342, 'P0000000000000001', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (343, 'P0000000000000002', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (344, 'P0000000000000003', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (345, 'P0000000000000004', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (346, 'P0000000000000005', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (347, 'P0000000000000006', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (348, 'P0000000000000007', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (349, 'P0000000000000008', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (350, 'P0000000000000009', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (351, 'P0000000000000010', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (352, 'P0000000000000011', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (353, 'P0000000000000012', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (354, 'P0000000000000013', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (355, 'P0000000000000014', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (356, 'P0000000000000015', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (357, 'P0000000000000016', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (358, 'P0000000000000017', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (359, 'P0000000000000018', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (360, 'P0000000000000019', 'P_DRV_SERVICE', '1', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_product` VALUES (361, 'P0000000000000020', 'P_DRV_SERVICE', '0', 1.0000, '2025-11-25 22:00:59');

-- ----------------------------
-- Table structure for tag_relation_seller
-- ----------------------------
DROP TABLE IF EXISTS `tag_relation_seller`;
CREATE TABLE `tag_relation_seller`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `seller_id` char(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 seller_info.seller_id',
  `tag_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联 tag_definition.tag_code',
  `tag_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签值（如 \"平台自营\", \"金牌商家\", \"高风险\"）',
  `score` decimal(5, 4) NULL DEFAULT 1.0000 COMMENT '标签权重/置信度（用于算法标签）',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_seller_tag`(`seller_id` ASC, `tag_code` ASC) USING BTREE,
  INDEX `idx_tag_value`(`tag_code` ASC, `tag_value` ASC) USING BTREE,
  CONSTRAINT `tag_relation_seller_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `seller_info` (`seller_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `tag_relation_seller_ibfk_2` FOREIGN KEY (`tag_code`) REFERENCES `tag_definition` (`tag_code`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 269 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家标签结果表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tag_relation_seller
-- ----------------------------
INSERT INTO `tag_relation_seller` VALUES (1, 'S0000000000000001', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (2, 'S0000000000000002', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (3, 'S0000000000000003', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (4, 'S0000000000000004', 'S_BAS_MODE', '品牌旗舰', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (5, 'S0000000000000005', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (6, 'S0000000000000006', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (7, 'S0000000000000007', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (8, 'S0000000000000008', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (9, 'S0000000000000009', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (10, 'S0000000000000010', 'S_BAS_MODE', '品牌旗舰', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (11, 'S0000000000000011', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (12, 'S0000000000000012', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (13, 'S0000000000000013', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (14, 'S0000000000000014', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (15, 'S0000000000000015', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (16, 'S0000000000000016', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (17, 'S0000000000000017', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (18, 'S0000000000000018', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (19, 'S0000000000000019', 'S_BAS_MODE', '普通店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (20, 'S0000000000000020', 'S_BAS_MODE', '平台自营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (32, 'S0000000000000002', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (33, 'S0000000000000009', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (34, 'S0000000000000014', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (35, 'S0000000000000019', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (36, 'S0000000000000003', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (37, 'S0000000000000012', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (38, 'S0000000000000016', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (39, 'S0000000000000007', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (40, 'S0000000000000011', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (41, 'S0000000000000004', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (42, 'S0000000000000010', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (43, 'S0000000000000018', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (44, 'S0000000000000005', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (45, 'S0000000000000017', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (46, 'S0000000000000006', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (47, 'S0000000000000015', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (48, 'S0000000000000001', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (49, 'S0000000000000008', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (50, 'S0000000000000013', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (51, 'S0000000000000020', 'S_BAS_CITY', '其他地区商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (63, 'S0000000000000001', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (64, 'S0000000000000002', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (65, 'S0000000000000003', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (66, 'S0000000000000004', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (67, 'S0000000000000005', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (68, 'S0000000000000006', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (69, 'S0000000000000007', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (70, 'S0000000000000008', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (71, 'S0000000000000009', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (72, 'S0000000000000010', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (73, 'S0000000000000011', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (74, 'S0000000000000012', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (75, 'S0000000000000013', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (76, 'S0000000000000014', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (77, 'S0000000000000015', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (78, 'S0000000000000016', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (79, 'S0000000000000017', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (80, 'S0000000000000018', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (81, 'S0000000000000019', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (82, 'S0000000000000020', 'S_BAS_AGE', '5年老店', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (94, 'S0000000000000001', 'S_STA_CREDIT', '金牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (95, 'S0000000000000002', 'S_STA_CREDIT', '金牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (96, 'S0000000000000003', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (97, 'S0000000000000004', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (98, 'S0000000000000005', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (99, 'S0000000000000006', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (100, 'S0000000000000007', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (101, 'S0000000000000008', 'S_STA_CREDIT', '金牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (102, 'S0000000000000009', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (103, 'S0000000000000010', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (104, 'S0000000000000011', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (105, 'S0000000000000012', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (106, 'S0000000000000013', 'S_STA_CREDIT', '金牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (107, 'S0000000000000014', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (108, 'S0000000000000015', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (109, 'S0000000000000016', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (110, 'S0000000000000017', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (111, 'S0000000000000018', 'S_STA_CREDIT', '铜牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (112, 'S0000000000000019', 'S_STA_CREDIT', '银牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (113, 'S0000000000000020', 'S_STA_CREDIT', '金牌商家', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (125, 'S0000000000000001', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (126, 'S0000000000000002', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (127, 'S0000000000000003', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (128, 'S0000000000000004', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (129, 'S0000000000000005', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (130, 'S0000000000000006', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (131, 'S0000000000000007', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (132, 'S0000000000000008', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (133, 'S0000000000000009', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (134, 'S0000000000000010', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (135, 'S0000000000000011', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (136, 'S0000000000000012', 'S_STA_PRAISE', '口碑良好', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (137, 'S0000000000000013', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (138, 'S0000000000000014', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (139, 'S0000000000000015', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (140, 'S0000000000000016', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (141, 'S0000000000000017', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (142, 'S0000000000000018', 'S_STA_PRAISE', '口碑良好', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (143, 'S0000000000000019', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (144, 'S0000000000000020', 'S_STA_PRAISE', '好评如潮', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (156, 'S0000000000000001', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (157, 'S0000000000000002', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (158, 'S0000000000000003', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (159, 'S0000000000000004', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (160, 'S0000000000000005', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (161, 'S0000000000000006', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (162, 'S0000000000000007', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (163, 'S0000000000000008', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (164, 'S0000000000000009', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (165, 'S0000000000000010', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (166, 'S0000000000000011', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (167, 'S0000000000000012', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (168, 'S0000000000000013', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (169, 'S0000000000000014', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (170, 'S0000000000000015', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (171, 'S0000000000000016', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (172, 'S0000000000000017', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (173, 'S0000000000000018', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (174, 'S0000000000000019', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (175, 'S0000000000000020', 'S_STA_CAPITAL', '雄厚', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (187, 'S0000000000000001', 'S_DRV_POTENTIAL', '潜力股', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (188, 'S0000000000000002', 'S_DRV_POTENTIAL', '潜力股', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (189, 'S0000000000000003', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (190, 'S0000000000000004', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (191, 'S0000000000000005', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (192, 'S0000000000000006', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (193, 'S0000000000000007', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (194, 'S0000000000000008', 'S_DRV_POTENTIAL', '潜力股', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (195, 'S0000000000000009', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (196, 'S0000000000000010', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (197, 'S0000000000000011', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (198, 'S0000000000000012', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (199, 'S0000000000000013', 'S_DRV_POTENTIAL', '潜力股', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (200, 'S0000000000000014', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (201, 'S0000000000000015', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (202, 'S0000000000000016', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (203, 'S0000000000000017', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (204, 'S0000000000000018', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (205, 'S0000000000000019', 'S_DRV_POTENTIAL', '稳定发展', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (206, 'S0000000000000020', 'S_DRV_POTENTIAL', '潜力股', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (218, 'S0000000000000001', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (219, 'S0000000000000002', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (220, 'S0000000000000003', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (221, 'S0000000000000004', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (222, 'S0000000000000005', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (223, 'S0000000000000006', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (224, 'S0000000000000007', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (225, 'S0000000000000008', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (226, 'S0000000000000009', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (227, 'S0000000000000010', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (228, 'S0000000000000011', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (229, 'S0000000000000012', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (230, 'S0000000000000013', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (231, 'S0000000000000014', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (232, 'S0000000000000015', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (233, 'S0000000000000016', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (234, 'S0000000000000017', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (235, 'S0000000000000018', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (236, 'S0000000000000019', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (237, 'S0000000000000020', 'S_DRV_RISK', '低风险', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (249, 'S0000000000000001', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (250, 'S0000000000000002', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (251, 'S0000000000000003', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (252, 'S0000000000000004', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (253, 'S0000000000000005', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (254, 'S0000000000000006', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (255, 'S0000000000000007', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (256, 'S0000000000000008', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (257, 'S0000000000000009', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (258, 'S0000000000000010', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (259, 'S0000000000000011', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (260, 'S0000000000000012', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (261, 'S0000000000000013', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (262, 'S0000000000000014', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (263, 'S0000000000000015', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (264, 'S0000000000000016', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (265, 'S0000000000000017', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (266, 'S0000000000000018', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (267, 'S0000000000000019', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');
INSERT INTO `tag_relation_seller` VALUES (268, 'S0000000000000020', 'S_DRV_MAIN_CATEGORY', '数码专营', 1.0000, '2025-11-25 22:00:59');

-- ----------------------------
-- Triggers structure for table group_tag_relation
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_group_tag_relation_before_insert`;
delimiter ;;
CREATE TRIGGER `trg_group_tag_relation_before_insert` BEFORE INSERT ON `group_tag_relation` FOR EACH ROW BEGIN
  DECLARE v_group_entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER');
  DECLARE v_tag_entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER');
  
  -- 获取群体的实体类型
  SELECT entity_type INTO v_group_entity_type
  FROM group_definition
  WHERE group_id = NEW.group_id;
  
  -- 获取标签的实体类型
  SELECT entity_type INTO v_tag_entity_type
  FROM tag_definition
  WHERE tag_code = NEW.tag_code;
  
  -- 检查标签类型是否与群体实体类型一致
  IF v_group_entity_type != v_tag_entity_type THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '标签类型与群体实体类型不一致';
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table group_tag_relation
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_group_tag_relation_before_update`;
delimiter ;;
CREATE TRIGGER `trg_group_tag_relation_before_update` BEFORE UPDATE ON `group_tag_relation` FOR EACH ROW BEGIN
  DECLARE v_group_entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER');
  DECLARE v_tag_entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER');
  
  -- 获取群体的实体类型
  SELECT entity_type INTO v_group_entity_type
  FROM group_definition
  WHERE group_id = NEW.group_id;
  
  -- 获取标签的实体类型
  SELECT entity_type INTO v_tag_entity_type
  FROM tag_definition
  WHERE tag_code = NEW.tag_code;
  
  -- 检查标签类型是否与群体实体类型一致
  IF v_group_entity_type != v_tag_entity_type THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = '标签类型与群体实体类型不一致';
  END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
