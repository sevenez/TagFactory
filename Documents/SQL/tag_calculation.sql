-- 标签计算SQL
-- 用于将原始数据转换为标签值
USE tagfactory;

-- 1. 用户标签计算
-- 1.1 用户基础标签计算
-- 性别识别
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_BAS_GENDER', 
    gender 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 年龄段
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_BAS_AGE_BIN', 
    CASE 
        WHEN age <= 24 THEN 'Z世代' 
        WHEN age BETWEEN 25 AND 35 THEN '青年' 
        WHEN age BETWEEN 36 AND 50 THEN '中年' 
        WHEN age > 50 THEN '银发' 
        ELSE '未知' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 学历水平
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_BAS_EDU', 
    CASE 
        WHEN education IN ('本科', '硕士', '博士') THEN '高知人群' 
        ELSE '基础人群' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 地域分布
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_BAS_REGION', 
    CASE 
        WHEN province IN ('北京市', '上海市', '广州市', '深圳市') THEN '一线城市' 
        WHEN province IN ('江苏省', '浙江省', '上海市') THEN '江浙沪' 
        ELSE '其他' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 入会时长
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_BAS_TENURE', 
    CASE 
        WHEN DATEDIFF(NOW(), register_time) < 7 THEN '新注册' 
        WHEN DATEDIFF(NOW(), register_time) < 30 THEN '月度新人' 
        ELSE '老用户' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 1.2 用户统计标签计算
-- 消费能力
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_STA_MONETARY', 
    CASE 
        WHEN total_consume > 10000 THEN '高消费' 
        WHEN total_consume > 5000 THEN '中消费' 
        ELSE '低消费' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 购买频次
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_STA_FREQ', 
    CASE 
        WHEN consume_months = 0 THEN '单次客' 
        WHEN consume_months > 5 THEN '忠诚客' 
        ELSE '复购客' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 客单价等级
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_STA_ATV', 
    CASE 
        WHEN consume_months > 0 AND (total_consume / consume_months) > 3000 THEN '高净值' 
        ELSE '价格敏感' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 1.3 用户衍生标签计算
-- 用户价值(RFM)
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_DRV_RFM', 
    CASE 
        WHEN total_consume > 10000 AND consume_months > 5 AND DATEDIFF(NOW(), last_active_time) < 30 THEN '重要价值用户' 
        WHEN total_consume > 10000 AND consume_months <= 5 THEN '潜力用户' 
        WHEN total_consume <= 10000 AND consume_months > 5 THEN '重要保持用户' 
        ELSE '一般用户' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 数码偏好
INSERT INTO tag_relation_customer (customer_id, tag_code, tag_value) 
SELECT 
    customer_id, 
    'C_DRV_PREF', 
    CASE 
        WHEN gender = '男' AND age < 35 AND total_consume > 10000 THEN '极客' 
        WHEN gender = '女' AND age >= 30 THEN '家庭用户' 
        ELSE '普通用户' 
    END 
FROM customer_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 2. 商品标签计算
-- 2.1 商品基础标签计算
-- 所属品类
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_BAS_CAT', 
    category 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 品牌阵营
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_BAS_BRAND', 
    CASE 
        WHEN brand_name = '苹果' THEN '苹果' 
        WHEN brand_name IN ('华为', '荣耀') THEN '华为' 
        WHEN brand_name IN ('小米', 'Redmi') THEN '小米' 
        ELSE '其它' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 硬件规格
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_BAS_SPEC', 
    CONCAT(
        CASE 
            WHEN JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.storage')) LIKE '%512G%' OR JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.storage')) LIKE '%1T%' THEN '大内存, ' 
            ELSE '' 
        END,
        CASE 
            WHEN JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.network')) LIKE '%5G%' THEN '5G支持, ' 
            ELSE '' 
        END,
        CASE 
            WHEN JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.screen')) LIKE '%120Hz%' OR JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.screen')) LIKE '%144Hz%' THEN '高刷屏' 
            ELSE '' 
        END
    ) 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 价格区间
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_BAS_PRICE_TIER', 
    CASE 
        WHEN price < 1000 THEN '百元机' 
        WHEN price BETWEEN 1000 AND 4000 THEN '千元机' 
        WHEN price BETWEEN 4000 AND 8000 THEN '旗舰机' 
        ELSE '奢华机' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 产地/保质
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_BAS_SOURCE', 
    CASE 
        WHEN brand_name IN ('华为', '小米', '荣耀', 'Redmi', 'OPPO', 'vivo') THEN '国产' 
        ELSE '进口' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 2.2 商品统计标签计算
-- 折扣力度
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_STA_DISCOUNT', 
    CASE 
        WHEN original_price = price THEN '原价卖' 
        WHEN discount_rate < 80 THEN '骨折价' 
        ELSE '微降' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 转化能力
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_STA_CONV', 
    CASE 
        WHEN buy_customer_count > 0 THEN '高转化' 
        ELSE '低转化' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 物流属性
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_STA_LOGISTIC', 
    CASE 
        WHEN product_weight > 10 THEN '大件商品' 
        ELSE '轻小件' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 2.3 商品衍生标签计算
-- 生命周期
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_DRV_LIFECYCLE', 
    CASE 
        WHEN DATEDIFF(NOW(), create_time) <= 30 THEN '新品上市' 
        WHEN DATEDIFF(NOW(), create_time) <= 90 THEN '当季热推' 
        ELSE '清仓长尾' 
    END 
FROM product_info 
WHERE status = 1 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 性价比指数
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_DRV_CP_RATIO', 
    CASE 
        WHEN price < 2000 AND JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.storage')) LIKE '%256G%' THEN '超高性价比' 
        WHEN price > 8000 THEN '品牌溢价' 
        ELSE '普通性价比' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 人群定位
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_DRV_TARGET', 
    CASE 
        WHEN product_name LIKE '%商务%' OR (product_name LIKE '%黑%' AND price > 4000) THEN '商务风' 
        WHEN product_name LIKE '%电竞%' OR JSON_UNQUOTE(JSON_EXTRACT(spec_params, '$.screen')) LIKE '%144Hz%' THEN '电竞风' 
        ELSE '大众风' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 售后无忧
INSERT INTO tag_relation_product (product_id, tag_code, tag_value) 
SELECT 
    product_id, 
    'P_DRV_SERVICE', 
    CASE 
        WHEN is_free_shipping = 1 AND after_sales_policy LIKE '%七天无理由%' THEN '1' 
        ELSE '0' 
    END 
FROM product_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 3. 商家标签计算
-- 3.1 商家基础标签计算
-- 经营模式
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_BAS_MODE', 
    CASE 
        WHEN is_self_operated = 1 THEN '平台自营' 
        WHEN seller_name LIKE '%旗舰%' THEN '品牌旗舰' 
        ELSE '普通店' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 所在地区
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_BAS_CITY', 
    CASE 
        WHEN city IN ('上海', '杭州', '南京', '苏州') THEN '江浙沪商家' 
        WHEN city IN ('深圳', '广州', '东莞') THEN '珠三角商家' 
        ELSE '其他地区商家' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 老字号
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_BAS_AGE', 
    CASE 
        WHEN DATEDIFF(NOW(), establish_time) > 1825 THEN '5年老店' 
        ELSE '新店开张' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 3.2 商家统计标签计算
-- 信誉评级
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_STA_CREDIT', 
    CASE 
        WHEN seller_rating > 4.8 THEN '金牌商家' 
        WHEN seller_rating > 4.5 THEN '银牌商家' 
        WHEN seller_rating > 4.0 THEN '铜牌商家' 
        ELSE '高危商家' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 口碑表现
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_STA_PRAISE', 
    CASE 
        WHEN praise_rate = 100 THEN '零差评' 
        WHEN praise_rate > 98 THEN '好评如潮' 
        WHEN praise_rate > 95 THEN '口碑良好' 
        ELSE '争议多' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 资本实力
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_STA_CAPITAL', 
    CASE 
        WHEN registered_capital > 1000 THEN '雄厚' 
        ELSE '小微企业' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 3.3 商家衍生标签计算
-- 主要潜力
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_DRV_POTENTIAL', 
    CASE 
        WHEN seller_rating > 4.8 AND praise_rate > 98 THEN '潜力股' 
        ELSE '稳定发展' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 风险等级
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_DRV_RISK', 
    CASE 
        WHEN seller_rating < 4.0 OR praise_rate < 90 THEN '高风险' 
        ELSE '低风险' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);

-- 主营类目
INSERT INTO tag_relation_seller (seller_id, tag_code, tag_value) 
SELECT 
    seller_id, 
    'S_DRV_MAIN_CATEGORY', 
    CASE 
        WHEN seller_type LIKE '%电子%' THEN '数码专营' 
        ELSE '综合商家' 
    END 
FROM seller_info 
ON DUPLICATE KEY UPDATE tag_value = VALUES(tag_value);