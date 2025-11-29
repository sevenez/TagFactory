-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS tagfactory DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

-- 使用数据库
USE tagfactory;

-- 1. 系统用户表（system_user）
CREATE TABLE IF NOT EXISTS system_user (
  user_id VARCHAR(50) PRIMARY KEY COMMENT '用户ID',
  username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  password VARCHAR(255) NOT NULL COMMENT '密码（加密存储）',
  real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
  role ENUM('ADMIN', 'OPERATOR', 'AUDITOR') NOT NULL COMMENT '角色',
  status TINYINT(1) DEFAULT 1 COMMENT '状态（1-启用 0-停用）',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- 2. 标签申请表（tag_application）
CREATE TABLE IF NOT EXISTS tag_application (
  application_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '申请ID',
  tag_id INT NOT NULL COMMENT '标签ID，关联tag_definition表',
  applicant_id VARCHAR(50) NOT NULL COMMENT '申请人ID，关联system_user表',
  application_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  application_reason TEXT NOT NULL COMMENT '申请理由',
  application_status ENUM('PENDING', 'APPROVED', 'REJECTED', 'WITHDRAWN') NOT NULL COMMENT '申请状态',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (tag_id) REFERENCES tag_definition(tag_id) ON DELETE CASCADE,
  FOREIGN KEY (applicant_id) REFERENCES system_user(user_id) ON DELETE CASCADE,
  INDEX idx_application_status (application_status),
  INDEX idx_applicant_id (applicant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签申请表';

-- 3. 审批流程表（approval_flow）
CREATE TABLE IF NOT EXISTS approval_flow (
  flow_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '流程ID',
  application_id INT NOT NULL COMMENT '申请ID，关联tag_application表',
  current_step INT DEFAULT 1 COMMENT '当前审批步骤',
  total_steps INT DEFAULT 1 COMMENT '总审批步骤',
  flow_status ENUM('PENDING', 'PROCESSING', 'COMPLETED') NOT NULL COMMENT '流程状态',
  final_result ENUM('APPROVED', 'REJECTED') DEFAULT NULL COMMENT '最终结果',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (application_id) REFERENCES tag_application(application_id) ON DELETE CASCADE,
  INDEX idx_flow_status (flow_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审批流程表';

-- 4. 审批记录表（approval_record）
CREATE TABLE IF NOT EXISTS approval_record (
  record_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '审批记录ID',
  application_id INT NOT NULL COMMENT '申请ID，关联tag_application表',
  approver_id VARCHAR(50) NOT NULL COMMENT '审批人ID，关联system_user表',
  approval_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '审批时间',
  approval_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL COMMENT '审批状态',
  approval_opinion TEXT COMMENT '审批意见',
  approval_order INT NOT NULL COMMENT '审批顺序',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  FOREIGN KEY (application_id) REFERENCES tag_application(application_id) ON DELETE CASCADE,
  FOREIGN KEY (approver_id) REFERENCES system_user(user_id) ON DELETE CASCADE,
  INDEX idx_application_id (application_id),
  INDEX idx_approver_id (approver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审批记录表';

-- 5. 扩展标签定义表的status字段
ALTER TABLE tag_definition 
MODIFY COLUMN status ENUM('PENDING', 'APPROVED', 'REJECTED', 'DISABLED') DEFAULT 'PENDING' COMMENT '状态（PENDING-待审批 APPROVED-已通过 REJECTED-已拒绝 DISABLED-已停用）';

-- 插入模拟数据

-- 1. 系统用户数据
INSERT IGNORE INTO system_user (user_id, username, password, real_name, role, status) VALUES
('USER001', 'admin1', 'password123', '管理员1', 'ADMIN', 1),
('USER002', 'admin2', 'password123', '管理员2', 'ADMIN', 1),
('USER003', 'operator1', 'password123', '操作员1', 'OPERATOR', 1),
('USER004', 'operator2', 'password123', '操作员2', 'OPERATOR', 1),
('USER005', 'auditor1', 'password123', '审批人1', 'AUDITOR', 1),
('USER006', 'auditor2', 'password123', '审批人2', 'AUDITOR', 1);

-- 2. 先插入一些标签定义数据，用于测试
INSERT IGNORE INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency, status) VALUES
('TEST_TAG_001', '测试标签1', '基础', 'CUSTOMER', 'STRING', 'DAILY', 'PENDING'),
('TEST_TAG_002', '测试标签2', '行为', 'CUSTOMER', 'BOOLEAN', 'DAILY', 'PENDING'),
('TEST_TAG_003', '测试标签3', '统计', 'PRODUCT', 'NUMBER', 'DAILY', 'APPROVED'),
('TEST_TAG_004', '测试标签4', '衍生', 'SELLER', 'STRING', 'DAILY', 'APPROVED'),
('TEST_TAG_005', '测试标签5', '基础', 'CUSTOMER', 'STRING', 'DAILY', 'REJECTED'),
('TEST_TAG_006', '测试标签6', '行为', 'PRODUCT', 'BOOLEAN', 'DAILY', 'REJECTED'),
('TEST_TAG_007', '测试标签7', '统计', 'SELLER', 'NUMBER', 'DAILY', 'PENDING'),
('TEST_TAG_008', '测试标签8', '衍生', 'CUSTOMER', 'STRING', 'DAILY', 'PENDING');

-- 3. 标签申请数据
-- 待审批状态（PENDING）
INSERT IGNORE INTO tag_application (tag_id, applicant_id, application_reason, application_status) VALUES
(1, 'USER003', '需要创建新的用户基础标签', 'PENDING'),
(2, 'USER004', '需要创建新的用户行为标签', 'PENDING');

-- 已通过状态（APPROVED）
INSERT IGNORE INTO tag_application (tag_id, applicant_id, application_reason, application_status) VALUES
(3, 'USER003', '需要创建新的商品统计标签', 'APPROVED'),
(4, 'USER004', '需要创建新的商家衍生标签', 'APPROVED');

-- 已拒绝状态（REJECTED）
INSERT IGNORE INTO tag_application (tag_id, applicant_id, application_reason, application_status) VALUES
(5, 'USER003', '需要创建新的用户基础标签', 'REJECTED'),
(6, 'USER004', '需要创建新的商品行为标签', 'REJECTED');

-- 已撤回状态（WITHDRAWN）
INSERT IGNORE INTO tag_application (tag_id, applicant_id, application_reason, application_status) VALUES
(7, 'USER003', '需要创建新的商家统计标签', 'WITHDRAWN'),
(8, 'USER004', '需要创建新的用户衍生标签', 'WITHDRAWN');

-- 4. 审批流程数据
-- 待审批状态
INSERT IGNORE INTO approval_flow (application_id, current_step, total_steps, flow_status) VALUES
(1, 1, 1, 'PENDING'),
(2, 1, 1, 'PENDING');

-- 已通过状态
INSERT IGNORE INTO approval_flow (application_id, current_step, total_steps, flow_status, final_result) VALUES
(3, 1, 1, 'COMPLETED', 'APPROVED'),
(4, 1, 1, 'COMPLETED', 'APPROVED');

-- 已拒绝状态
INSERT IGNORE INTO approval_flow (application_id, current_step, total_steps, flow_status, final_result) VALUES
(5, 1, 1, 'COMPLETED', 'REJECTED'),
(6, 1, 1, 'COMPLETED', 'REJECTED');

-- 已撤回状态
INSERT IGNORE INTO approval_flow (application_id, current_step, total_steps, flow_status) VALUES
(7, 1, 1, 'COMPLETED'),
(8, 1, 1, 'COMPLETED');

-- 5. 审批记录数据
-- 待审批状态
INSERT IGNORE INTO approval_record (application_id, approver_id, approval_status, approval_order) VALUES
(1, 'USER005', 'PENDING', 1),
(2, 'USER006', 'PENDING', 1);

-- 已通过状态
INSERT IGNORE INTO approval_record (application_id, approver_id, approval_time, approval_status, approval_opinion, approval_order) VALUES
(3, 'USER005', '2023-01-10 10:00:00', 'APPROVED', '标签设计合理，同意通过', 1),
(4, 'USER006', '2023-01-11 14:30:00', 'APPROVED', '符合业务需求，同意通过', 1);

-- 已拒绝状态
INSERT IGNORE INTO approval_record (application_id, approver_id, approval_time, approval_status, approval_opinion, approval_order) VALUES
(5, 'USER005', '2023-01-12 09:15:00', 'REJECTED', '标签定义不清晰，需要修改', 1),
(6, 'USER006', '2023-01-13 16:45:00', 'REJECTED', '不符合标签设计规范，拒绝通过', 1);

-- 已撤回状态
INSERT IGNORE INTO approval_record (application_id, approver_id, approval_status, approval_order) VALUES
(7, 'USER005', 'PENDING', 1),
(8, 'USER006', 'PENDING', 1);
