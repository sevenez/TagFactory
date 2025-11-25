-- 创建标签系统相关表
USE tagfactory;

-- 1. 标签定义表 (Tag Definitions)
-- 管理所有的标签元数据，定义"有哪些标签"
CREATE TABLE IF NOT EXISTS tag_definition (
  tag_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '标签ID',
  tag_code VARCHAR(50) NOT NULL UNIQUE COMMENT '标签编码（如 USER_GENDER, PROD_HOT）',
  tag_name VARCHAR(50) NOT NULL COMMENT '标签显示名（如 性别, 热销商品）',
  tag_layer ENUM('基础', '行为', '统计', '衍生') NOT NULL COMMENT '标签层级',
  entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER') NOT NULL COMMENT '标签归属实体',
  data_type ENUM('ENUM', 'BOOLEAN', 'NUMBER', 'STRING') DEFAULT 'STRING' COMMENT '值类型',
  update_frequency ENUM('REALTIME', 'DAILY', 'WEEKLY', 'MONTHLY') DEFAULT 'DAILY' COMMENT '更新频率',
  status TINYINT(1) DEFAULT 1 COMMENT '状态（1-启用 0-停用）',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签定义元数据表';

-- 2. 用户标签关系表 (Customer Tag Relation)
-- 存储用户身上的标签结果
CREATE TABLE IF NOT EXISTS tag_relation_customer (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  customer_id CHAR(17) NOT NULL COMMENT '关联 customer_info.customer_id',
  tag_code VARCHAR(50) NOT NULL COMMENT '关联 tag_definition.tag_code',
  tag_value VARCHAR(255) NOT NULL COMMENT '标签值（如 "男", "高价值", "0.85"）',
  score DECIMAL(5,4) DEFAULT 1.0 COMMENT '标签权重/置信度（用于算法标签）',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  -- 联合索引保证一个用户对一个标签只有一个值
  UNIQUE KEY uk_cust_tag (customer_id, tag_code),
  -- 便于筛选：找所有"高价值"用户
  INDEX idx_tag_value (tag_code, tag_value),
  -- 外键约束
  FOREIGN KEY (customer_id) REFERENCES customer_info(customer_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_code) REFERENCES tag_definition(tag_code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签结果表';

-- 3. 商品标签关系表 (Product Tag Relation)
-- 存储商品身上的标签结果
CREATE TABLE IF NOT EXISTS tag_relation_product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  product_id CHAR(17) NOT NULL COMMENT '关联 product_info.product_id',
  tag_code VARCHAR(50) NOT NULL COMMENT '关联 tag_definition.tag_code',
  tag_value VARCHAR(255) NOT NULL COMMENT '标签值（如 "手机", "热销", "高性价比"）',
  score DECIMAL(5,4) DEFAULT 1.0 COMMENT '标签权重/置信度（用于算法标签）',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  -- 联合索引保证一个商品对一个标签只有一个值
  UNIQUE KEY uk_prod_tag (product_id, tag_code),
  -- 便于筛选：找所有"热销"商品
  INDEX idx_tag_value (tag_code, tag_value),
  -- 外键约束
  FOREIGN KEY (product_id) REFERENCES product_info(product_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_code) REFERENCES tag_definition(tag_code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品标签结果表';

-- 4. 商家标签关系表 (Seller Tag Relation)
-- 存储商家身上的标签结果
CREATE TABLE IF NOT EXISTS tag_relation_seller (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  seller_id CHAR(17) NOT NULL COMMENT '关联 seller_info.seller_id',
  tag_code VARCHAR(50) NOT NULL COMMENT '关联 tag_definition.tag_code',
  tag_value VARCHAR(255) NOT NULL COMMENT '标签值（如 "平台自营", "金牌商家", "高风险"）',
  score DECIMAL(5,4) DEFAULT 1.0 COMMENT '标签权重/置信度（用于算法标签）',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  -- 联合索引保证一个商家对一个标签只有一个值
  UNIQUE KEY uk_seller_tag (seller_id, tag_code),
  -- 便于筛选：找所有"金牌商家"
  INDEX idx_tag_value (tag_code, tag_value),
  -- 外键约束
  FOREIGN KEY (seller_id) REFERENCES seller_info(seller_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_code) REFERENCES tag_definition(tag_code) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家标签结果表';