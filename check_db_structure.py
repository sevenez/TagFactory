import pymysql
from pymysql.cursors import DictCursor

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4',
    'autocommit': True
}

def check_db_structure():
    """检查数据库结构和数据"""
    try:
        # 连接数据库
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor(DictCursor)
        print("✅ 数据库连接成功")
        
        # 检查customer_info表结构
        print("\n📋 检查customer_info表结构:")
        cursor.execute("DESCRIBE customer_info")
        structure = cursor.fetchall()
        for field in structure:
            print(f"  - {field['Field']}: {field['Type']} (NULL: {field['Null']}, Key: {field['Key']}, Default: {field['Default']})")
        
        # 检查customer_info表数据
        print("\n📋 检查customer_info表数据:")
        cursor.execute("SELECT customer_id, phone, is_deleted FROM customer_info LIMIT 10")
        customers = cursor.fetchall()
        for customer in customers:
            print(f"  - ID: {customer['customer_id']}, Phone: {customer['phone']}, IsDeleted: {customer['is_deleted']}")
        
        # 测试查询用户信息
        print("\n🔍 测试查询用户 U0000000000000001 的信息:")
        query = "SELECT * FROM customer_info WHERE customer_id = %s AND is_deleted = 0"
        cursor.execute(query, ("U0000000000000001",))
        user = cursor.fetchone()
        if user:
            print(f"  ✅ 查询成功: {user}")
        else:
            print(f"  ❌ 查询失败: 未找到用户 U0000000000000001")
            
            # 尝试查询所有未删除的用户
            cursor.execute("SELECT customer_id, phone FROM customer_info WHERE is_deleted = 0 LIMIT 5")
            active_users = cursor.fetchall()
            if active_users:
                print(f"  ✅ 查询到 {len(active_users)} 个未删除的用户:")
                for user in active_users:
                    print(f"    - ID: {user['customer_id']}, Phone: {user['phone']}")
            else:
                print("  ❌ 没有找到未删除的用户")
        
    except Exception as e:
        print(f"❌ 检查数据库结构失败: {e}")
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()

if __name__ == "__main__":
    check_db_structure()