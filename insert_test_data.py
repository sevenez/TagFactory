import pymysql
from datetime import datetime

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4'
}

def create_connection():
    """创建数据库连接"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        print("✅ 数据库连接成功")
        return conn
    except Exception as e:
        print(f"❌ 数据库连接失败: {e}")
        return None

def insert_test_data():
    """插入测试数据"""
    conn = create_connection()
    if not conn:
        return
    
    try:
        with conn.cursor() as cursor:
            # 插入测试标签定义
            tag_definitions = [
                ("USER_GENDER", "性别", "基础", "CUSTOMER", "ENUM", "DAILY", 1),
                ("USER_AGE", "年龄段", "基础", "CUSTOMER", "ENUM", "DAILY", 1),
                ("USER_EDUCATION", "学历", "基础", "CUSTOMER", "ENUM", "DAILY", 1),
                ("USER_CONSUME", "累计消费", "统计", "CUSTOMER", "NUMBER", "DAILY", 1),
                ("USER_ACTIVE", "最近7天活跃", "行为", "CUSTOMER", "BOOLEAN", "DAILY", 1),
                ("USER_LOYALTY", "忠诚度", "衍生", "CUSTOMER", "STRING", "DAILY", 1)
            ]
            cursor.executemany(
                "INSERT IGNORE INTO tag_definition (tag_code, tag_name, tag_layer, entity_type, data_type, update_frequency, status) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                tag_definitions
            )
            
            # 插入测试用户
            customers = [
                ("U1234567890123456", "13800138001", datetime.now(), datetime.now(), "男", 28, "本科", "北京市", 1200.5, 8, 0),
                ("U1234567890123457", "13900139001", datetime.now(), datetime.now(), "女", 22, "大专", "上海市", 3500.0, 20, 0),
                ("U1234567890123458", "13700137001", datetime.now(), datetime.now(), "男", 35, "硕士", "广东省", 5800.0, 32, 0)
            ]
            cursor.executemany(
                "INSERT IGNORE INTO customer_info (customer_id, phone, last_active_time, register_time, gender, age, education, province, total_consume, consume_months, is_deleted) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                customers
            )
            
            # 插入测试客户标签
            customer_tags = [
                ("U1234567890123456", "USER_GENDER", "男", 1.0),
                ("U1234567890123456", "USER_AGE", "25-34", 1.0),
                ("U1234567890123456", "USER_EDUCATION", "本科", 1.0),
                ("U1234567890123456", "USER_CONSUME", "1200.5", 1.0),
                ("U1234567890123456", "USER_ACTIVE", "1", 1.0),
                ("U1234567890123456", "USER_LOYALTY", "中", 1.0),
                ("U1234567890123457", "USER_GENDER", "女", 1.0),
                ("U1234567890123457", "USER_AGE", "18-24", 1.0),
                ("U1234567890123457", "USER_EDUCATION", "大专", 1.0),
                ("U1234567890123457", "USER_CONSUME", "3500.0", 1.0),
                ("U1234567890123457", "USER_ACTIVE", "1", 1.0),
                ("U1234567890123457", "USER_LOYALTY", "高", 1.0),
                ("U1234567890123458", "USER_GENDER", "男", 1.0),
                ("U1234567890123458", "USER_AGE", "35-44", 1.0),
                ("U1234567890123458", "USER_EDUCATION", "硕士", 1.0),
                ("U1234567890123458", "USER_CONSUME", "5800.0", 1.0),
                ("U1234567890123458", "USER_ACTIVE", "1", 1.0),
                ("U1234567890123458", "USER_LOYALTY", "高", 1.0)
            ]
            cursor.executemany(
                "INSERT IGNORE INTO tag_relation_customer (customer_id, tag_code, tag_value, score) VALUES (%s, %s, %s, %s)",
                customer_tags
            )
            
            # 提交事务
            conn.commit()
            print("✅ 测试数据插入成功")
            
    except Exception as e:
        print(f"❌ 插入测试数据失败: {e}")
        conn.rollback()
    finally:
        conn.close()
        print("✅ 数据库连接已关闭")

if __name__ == "__main__":
    insert_test_data()
