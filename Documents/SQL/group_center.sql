-- 创建群体中心相关表
USE tagfactory;

-- 导入数据顺序说明：
-- 1. 首先导入 group_definition 表数据
-- 2. 然后导入 group_tag_relation 表数据
-- 3. 最后导入 group_entity_relation 表数据

-- 处理重复数据的方法：
-- 1. 方法一：删除现有数据后重新导入
--    DELETE FROM group_entity_relation;
--    DELETE FROM group_tag_relation;
--    DELETE FROM group_definition;

-- 2. 方法二：使用 REPLACE INTO 或 INSERT IGNORE 语句导入
--    REPLACE INTO group_definition (...) VALUES (...);
--    或
--    INSERT IGNORE INTO group_definition (...) VALUES (...);

-- 3. 方法三：先禁用外键约束，导入完成后再启用
--    SET FOREIGN_KEY_CHECKS = 0;
--    导入数据语句...
--    SET FOREIGN_KEY_CHECKS = 1;

-- 解决 group_id 不匹配问题（重要）：
-- 当导入 group_definition 表后，group_id 是自增生成的，可能与 CSV 文件中预期的 group_id 不一致
-- 此时需要使用以下方法来更新 group_tag_relation 和 group_entity_relation 表中的 group_id：

-- 步骤1：创建临时表存储 CSV 文件中的数据（不含外键约束）
CREATE TABLE IF NOT EXISTS temp_group_tag_relation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  group_code VARCHAR(50) NOT NULL,
  tag_code VARCHAR(50) NOT NULL,
  tag_value VARCHAR(255) NOT NULL,
  operator ENUM('AND', 'OR') DEFAULT 'AND'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS temp_group_entity_relation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  group_code VARCHAR(50) NOT NULL,
  entity_id CHAR(17) NOT NULL,
  entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 步骤2：导入 CSV 数据到临时表（使用 LOAD DATA 或其他方式）
-- LOAD DATA INFILE 'path/to/group_tag_relation.csv' INTO TABLE temp_group_tag_relation ...;
-- LOAD DATA INFILE 'path/to/group_entity_relation.csv' INTO TABLE temp_group_entity_relation ...;

-- 步骤3：通过 group_code 关联，将数据插入到正式表
INSERT INTO group_tag_relation (group_id, tag_code, tag_value, operator)
SELECT g.group_id, t.tag_code, t.tag_value, t.operator
FROM temp_group_tag_relation t
JOIN group_definition g ON t.group_code = g.group_code;

INSERT INTO group_entity_relation (group_id, entity_id, entity_type)
SELECT g.group_id, t.entity_id, t.entity_type
FROM temp_group_entity_relation t
JOIN group_definition g ON t.group_code = g.group_code;

-- 步骤4：删除临时表
DROP TABLE IF EXISTS temp_group_tag_relation;
DROP TABLE IF EXISTS temp_group_entity_relation;

-- 步骤5：更新 group_definition 表中的 entity_count 字段
UPDATE group_definition g
SET entity_count = (
  SELECT COUNT(*) FROM group_entity_relation WHERE group_id = g.group_id
);

-- 1. 群体定义表 (Group Definition)
-- 存储群体的基本信息和元数据
CREATE TABLE IF NOT EXISTS group_definition (
  group_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '群体ID',
  group_code VARCHAR(50) NOT NULL UNIQUE COMMENT '群体编码（如 HIGH_VALUE_USER, HOT_PRODUCT）',
  group_name VARCHAR(50) NOT NULL COMMENT '群体显示名（如 高价值用户, 热销商品）',
  entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER') NOT NULL COMMENT '群体归属实体类型',
  create_method ENUM('RULE', 'BEHAVIOR', 'IMPORT') NOT NULL DEFAULT 'RULE' COMMENT '创建方式',
  status TINYINT(1) DEFAULT 1 COMMENT '状态（1-启用 0-停用）',
  entity_count INT DEFAULT 0 COMMENT '群体包含实体数量',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  creator VARCHAR(50) DEFAULT 'system' COMMENT '创建人',
  description VARCHAR(255) COMMENT '群体描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群体定义元数据表';

-- 2. 群体标签关系表 (Group Tag Relation)
-- 存储群体与标签的关联关系，确保同一群体内的标签类型一致
CREATE TABLE IF NOT EXISTS group_tag_relation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  group_id INT NOT NULL COMMENT '关联 group_definition.group_id',
  tag_code VARCHAR(50) NOT NULL COMMENT '关联 tag_definition.tag_code',
  tag_value VARCHAR(255) NOT NULL COMMENT '标签值（如 "男", "高价值", "0.85"）',
  operator ENUM('AND', 'OR') DEFAULT 'AND' COMMENT '标签间逻辑关系',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  -- 联合索引保证一个群体对一个标签值组合只有一个记录
  UNIQUE KEY uk_group_tag_value (group_id, tag_code, tag_value),
  -- 外键约束
  FOREIGN KEY (group_id) REFERENCES group_definition(group_id) ON DELETE CASCADE,
  FOREIGN KEY (tag_code) REFERENCES tag_definition(tag_code) ON DELETE CASCADE,
  -- 索引优化查询
  INDEX idx_group_id (group_id),
  INDEX idx_tag_code (tag_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群体标签关系表';

-- 3. 群体实体关系表 (Group Entity Relation)
-- 存储群体与实体的关联关系，优化查询性能
CREATE TABLE IF NOT EXISTS group_entity_relation (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
  group_id INT NOT NULL COMMENT '关联 group_definition.group_id',
  entity_id CHAR(17) NOT NULL COMMENT '实体ID（如U1234567890123456, P1234567890123456, S1234567890123456）',
  entity_type ENUM('CUSTOMER', 'PRODUCT', 'SELLER') NOT NULL COMMENT '实体类型',
  add_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  -- 联合索引保证一个实体对一个群体只有一个记录
  UNIQUE KEY uk_group_entity (group_id, entity_id),
  -- 外键约束
  FOREIGN KEY (group_id) REFERENCES group_definition(group_id) ON DELETE CASCADE,
  -- 索引优化查询
  INDEX idx_group_id (group_id),
  INDEX idx_entity_id (entity_id),
  INDEX idx_entity_type (entity_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='群体实体关系表';

-- 4. 触发器：确保同一群体内的标签类型一致
DELIMITER //
CREATE TRIGGER trg_group_tag_relation_before_insert
BEFORE INSERT ON group_tag_relation
FOR EACH ROW
BEGIN
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
END //
DELIMITER ;

-- 5. 触发器：确保同一群体内的标签类型一致（更新时）
DELIMITER //
CREATE TRIGGER trg_group_tag_relation_before_update
BEFORE UPDATE ON group_tag_relation
FOR EACH ROW
BEGIN
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
END //
DELIMITER ;

-- 6. 索引优化：为常用查询添加联合索引
-- 优化按实体类型和状态查询群体
CREATE INDEX idx_group_entity_type_status ON group_definition(entity_type, status);

-- 优化按群体ID和实体类型查询群体实体关系
CREATE INDEX idx_group_entity_type ON group_entity_relation(group_id, entity_type);
