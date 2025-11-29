import pymysql
from pymysql.cursors import DictCursor

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4'
}

def check_test_data():
    """检查测试数据是否插入成功"""
    try:
        conn = pymysql.connect(**DB_CONFIG, cursorclass=DictCursor)
        print("✅ 数据库连接成功")
        
        with conn.cursor() as cursor:
            # 检查客户表数据
            cursor.execute("SELECT * FROM customer_info")
            customers = cursor.fetchall()
            print(f"\n📋 客户表数据 ({len(customers)} 条):")
            for customer in customers:
                print(f"  - ID: {customer['customer_id']}, Phone: {customer['phone']}, Gender: {customer['gender']}")
            
            # 检查标签定义表数据
            cursor.execute("SELECT * FROM tag_definition")
            tags = cursor.fetchall()
            print(f"\n🏷️  标签定义表数据 ({len(tags)} 条):")
            for tag in tags:
                print(f"  - Code: {tag['tag_code']}, Name: {tag['tag_name']}, Layer: {tag['tag_layer']}")
            
            # 检查客户标签关系表数据
            cursor.execute("SELECT * FROM tag_relation_customer")
            customer_tags = cursor.fetchall()
            print(f"\n🔗 客户标签关系表数据 ({len(customer_tags)} 条):")
            for tag in customer_tags:
                print(f"  - Customer: {tag['customer_id']}, Tag: {tag['tag_code']}, Value: {tag['tag_value']}")
            
            # 测试查询客户画像的SQL
            user_id = "U1234567890123456"
            print(f"\n🔍 测试查询客户 {user_id} 的画像:")
            
            # 测试基本信息查询
            cursor.execute("""
            SELECT c.customer_id, c.phone, c.register_time, c.last_active_time, c.gender, c.age, c.education, c.province, c.total_consume, c.consume_months
            FROM customer_info c
            WHERE c.is_deleted = 0 AND c.customer_id = %s
            """, (user_id,))
            basic_info = cursor.fetchone()
            print(f"  基本信息: {basic_info}")
            
            # 测试标签查询
            cursor.execute("""
            SELECT td.tag_code, td.tag_name, td.tag_layer, trc.tag_value
            FROM tag_relation_customer trc
            JOIN tag_definition td ON trc.tag_code = td.tag_code
            WHERE trc.customer_id = %s AND td.status = 1
            """, (user_id,))
            tags = cursor.fetchall()
            print(f"  标签信息: {tags}")
            
    except Exception as e:
        print(f"❌ 检查数据失败: {e}")
    finally:
        conn.close()
        print("\n✅ 数据库连接已关闭")

if __name__ == "__main__":
    check_test_data()