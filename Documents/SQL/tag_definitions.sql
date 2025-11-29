-- 标签定义初始化SQL
USE tagfactory;

-- 1. 客户标签定义
-- 1.1 客户基础标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('C_BAS_GENDER', '性别识别', '基础', 'CUSTOMER', 'ENUM', 'REALTIME'),
('C_BAS_AGE_BIN', '年龄段', '基础', 'CUSTOMER', 'ENUM', 'REALTIME'),
('C_BAS_EDU', '学历水平', '基础', 'CUSTOMER', 'ENUM', 'REALTIME'),
('C_BAS_REGION', '地域分布', '基础', 'CUSTOMER', 'ENUM', 'REALTIME'),
('C_BAS_TENURE', '入会时长', '基础', 'CUSTOMER', 'ENUM', 'DAILY');

-- 1.2 客户统计标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('C_STA_MONETARY', '消费能力', '统计', 'CUSTOMER', 'ENUM', 'DAILY'),
('C_STA_FREQ', '购买频次', '统计', 'CUSTOMER', 'ENUM', 'DAILY'),
('C_STA_ATV', '客单价等级', '统计', 'CUSTOMER', 'ENUM', 'DAILY');

-- 1.3 客户衍生标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('C_DRV_RFM', '客户价值(RFM)', '衍生', 'CUSTOMER', 'ENUM', 'DAILY'),
('C_DRV_PREF', '数码偏好', '衍生', 'CUSTOMER', 'ENUM', 'DAILY');

-- 2. 商品标签定义
-- 2.1 商品基础标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('P_BAS_CAT', '所属品类', '基础', 'PRODUCT', 'ENUM', 'REALTIME'),
('P_BAS_BRAND', '品牌阵营', '基础', 'PRODUCT', 'ENUM', 'REALTIME'),
('P_BAS_SPEC', '硬件规格', '基础', 'PRODUCT', 'STRING', 'REALTIME'),
('P_BAS_PRICE_TIER', '价格区间', '基础', 'PRODUCT', 'ENUM', 'REALTIME'),
('P_BAS_SOURCE', '产地/保质', '基础', 'PRODUCT', 'ENUM', 'REALTIME');

-- 2.2 商品统计标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('P_STA_DISCOUNT', '折扣力度', '统计', 'PRODUCT', 'ENUM', 'DAILY'),
('P_STA_CONV', '转化能力', '统计', 'PRODUCT', 'ENUM', 'DAILY'),
('P_STA_LOGISTIC', '物流属性', '统计', 'PRODUCT', 'ENUM', 'REALTIME');

-- 2.3 商品衍生标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('P_DRV_LIFECYCLE', '生命周期', '衍生', 'PRODUCT', 'ENUM', 'DAILY'),
('P_DRV_CP_RATIO', '性价比指数', '衍生', 'PRODUCT', 'ENUM', 'DAILY'),
('P_DRV_TARGET', '人群定位', '衍生', 'PRODUCT', 'ENUM', 'DAILY'),
('P_DRV_SERVICE', '售后无忧', '衍生', 'PRODUCT', 'BOOLEAN', 'REALTIME');

-- 3. 商家标签定义
-- 3.1 商家基础标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('S_BAS_MODE', '经营模式', '基础', 'SELLER', 'ENUM', 'REALTIME'),
('S_BAS_CITY', '所在地区', '基础', 'SELLER', 'ENUM', 'REALTIME'),
('S_BAS_AGE', '老字号', '基础', 'SELLER', 'ENUM', 'REALTIME');

-- 3.2 商家统计标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('S_STA_CREDIT', '信誉评级', '统计', 'SELLER', 'ENUM', 'DAILY'),
('S_STA_PRAISE', '口碑表现', '统计', 'SELLER', 'ENUM', 'DAILY'),
('S_STA_CAPITAL', '资本实力', '统计', 'SELLER', 'ENUM', 'REALTIME');

-- 3.3 商家衍生标签
INSERT INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency) VALUES
('S_DRV_POTENTIAL', '主要潜力', '衍生', 'SELLER', 'ENUM', 'DAILY'),
('S_DRV_RISK', '风险等级', '衍生', 'SELLER', 'ENUM', 'DAILY'),
('S_DRV_MAIN_CATEGORY', '主营类目', '衍生', 'SELLER', 'ENUM', 'DAILY');