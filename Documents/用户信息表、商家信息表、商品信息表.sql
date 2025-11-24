-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS multi_ecommerce DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_general_ci;

-- 使用数据库
USE multi_ecommerce;

-- 1. 用户信息表（保持原有设计不变）
CREATE TABLE IF NOT EXISTS user_info (
    user_id CHAR(17) PRIMARY KEY COMMENT '用户ID（格式：U+16位数字，如U1234567890123456）',
    phone CHAR(11) NOT NULL UNIQUE COMMENT '手机号（11位数字）',
    last_active_time DATETIME COMMENT '最近活跃时间',
    register_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    gender ENUM('男', '女', '未知') NOT NULL DEFAULT '未知' COMMENT '性别',
    age INT DEFAULT 0 COMMENT '年龄（0-120之间）',
    education ENUM('小学', '初中', '高中', '大专', '本科', '硕士', '博士', '其他') DEFAULT '其他' COMMENT '学历',
    province VARCHAR(20) COMMENT '所在省份（如北京市、广东省）',
    total_consume DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '已消费金额（保留2位小数）',
    consume_months INT NOT NULL DEFAULT 0 COMMENT '消费月数（累计消费的月份数）',
    is_deleted TINYINT(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除标记（0-未删除，1-已删除）',
    INDEX idx_phone (phone) COMMENT '手机号索引（优化查询速度）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 2. 商家信息表（保持原有设计不变）
CREATE TABLE IF NOT EXISTS seller_info (
    seller_id CHAR(17) PRIMARY KEY COMMENT '商家ID（格式：S+16位数字，如S1234567890123456）',
    seller_name VARCHAR(100) NOT NULL COMMENT '商家名称（如京东自营、淘宝旗舰店）',
    seller_type VARCHAR(50) COMMENT '商家类别（如电子产品、服装鞋帽、食品生鲜）',
    credit_code VARCHAR(18) NOT NULL UNIQUE COMMENT '统一社会信用代码（18位）',
    contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话（支持固定电话+手机号）',
    contact_email VARCHAR(100) UNIQUE COMMENT '联系邮箱',
    business_address VARCHAR(200) COMMENT '经营地址（详细地址）',
    city VARCHAR(50) COMMENT '所在城市（如深圳市、杭州市）',
    establish_time DATE COMMENT '商家成立时间',
    registered_capital DECIMAL(12, 2) DEFAULT 0.00 COMMENT '注册资本（单位：万元）',
    is_self_operated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '自营标识（0-第三方，1-平台自营）',
    delivery_scope VARCHAR(200) COMMENT '配送范围（如全国配送、江浙沪皖包邮）',
    ship_promise VARCHAR(50) COMMENT '发货时间承诺（如48小时内发货）',
    seller_rating DECIMAL(3, 2) DEFAULT 4.50 COMMENT '商家评分（0.00-5.00分）',
    praise_rate DECIMAL(5, 2) DEFAULT 98.00 COMMENT '好评率（0.00-100.00%）',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '商家状态（0-禁用，1-正常营业）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商家创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商家信息更新时间',
    INDEX idx_seller_name (seller_name) COMMENT '商家名称索引（优化查询速度）',
    INDEX idx_credit_code (credit_code) COMMENT '统一社会信用代码索引（合规查询）',
    INDEX idx_city (city) COMMENT '城市索引（按地区筛选商家）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家信息表';

-- 3. 商品信息表（重点修改：删除二级分类，新增电子产品专属分类）
CREATE TABLE IF NOT EXISTS product_info (
    product_id CHAR(17) PRIMARY KEY COMMENT '商品ID（格式：P+16位数字，如P1234567890123456）',
    product_name VARCHAR(200) NOT NULL COMMENT '商品名称（如iPhone 15 Pro 256G）',
    brand_name VARCHAR(100) COMMENT '品牌名称（如苹果、华为）',
    category ENUM('手机', '平板电脑', '智能手表', '耳机音箱', '充电设备', '配件周边', '潮流好物', '官方定制', '官方服务') NOT NULL COMMENT '电子产品分类（固定可选值）',
    spec_params JSON COMMENT '规格参数（JSON格式，如{"颜色":["黑色","白色"],"内存":["256G","512G"]}）',
    price DECIMAL(10, 2) NOT NULL COMMENT '商品现价（保留2位小数）',
    original_price DECIMAL(10, 2) NOT NULL COMMENT '商品原价（保留2位小数）',
    discount_rate DECIMAL(5, 2) DEFAULT 100.00 COMMENT '折扣比例（0.00-100.00%）',
    monthly_sales INT NOT NULL DEFAULT 0 COMMENT '月销售数量',
    buy_user_count INT NOT NULL DEFAULT 0 COMMENT '购买用户数（累计）',
    stock_quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量（避免超卖）',
    stock_status ENUM('有货', '缺货', '预售', '限购') DEFAULT '有货' COMMENT '库存状态',
    main_image_url VARCHAR(255) COMMENT '商品主图URL',
    detail_image_urls JSON COMMENT '详情图URL集合（JSON数组格式）',
    production_date DATE COMMENT '生产日期（食品/美妆类必填）',
    shelf_life INT DEFAULT 0 COMMENT '保质期（单位：天，0表示无保质期）',
    product_weight DECIMAL(10, 2) DEFAULT 0.00 COMMENT '商品重量（单位：kg）',
    product_volume DECIMAL(10, 2) DEFAULT 0.00 COMMENT '商品体积（单位：m³，用于物流计算）',
    is_free_shipping TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否包邮（0-不包邮，1-包邮）',
    after_sales_policy VARCHAR(200) DEFAULT '七天无理由退换' COMMENT '售后政策',
    product_tags VARCHAR(100) COMMENT '商品标签（多个标签用逗号分隔，如新品,热销,优惠）',
    status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '商品状态（0-下架，1-上架）',
    seller_id CHAR(17) NOT NULL COMMENT '所属商家ID（关联seller_info表）',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '商品创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '商品信息更新时间',
    -- 外键约束（用户要求暂不考虑外部约束时可注释此行）
    FOREIGN KEY (seller_id) REFERENCES seller_info(seller_id) ON DELETE CASCADE,
    INDEX idx_seller_id (seller_id) COMMENT '商家ID索引（优化关联查询）',
    INDEX idx_product_name (product_name) COMMENT '商品名称索引（优化搜索）',
    INDEX idx_category (category) COMMENT '分类索引（按电子产品类别筛选）', -- 新增分类索引
    INDEX idx_brand (brand_name) COMMENT '品牌索引（按品牌筛选）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品信息表（电子产品专用）';