import pymysql
import sys

# 测试函数
def test_connection(db_name):
    config = {
        'host': 'localhost',
        'port': 3306,
        'user': 'root',
        'password': 'root',
        'database': db_name,
        'charset': 'utf8mb4'
    }
    
    try:
        print(f"\n尝试连接到数据库: {db_name}")
        connection = pymysql.connect(**config)
        print(f"✓ 成功连接到数据库 {db_name}")
        
        # 尝试获取数据库中的表
        with connection.cursor() as cursor:
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            print(f"  数据库 {db_name} 中的表: {len(tables)} 个")
            for table in tables:
                print(f"  - {table[0]}")
        
        connection.close()
        return True
    except Exception as e:
        print(f"✗ 连接到数据库 {db_name} 失败: {str(e)}")
        return False

if __name__ == "__main__":
    print("数据库连接测试")
    print("=" * 50)
    
    # 测试配置中使用的数据库
    test_connection('tagfactory')
    
    # 测试SQL文件中定义的数据库
    test_connection('multi_ecommerce')
    
    # 测试连接MySQL服务器（不指定数据库）
    try:
        config = {
            'host': 'localhost',
            'port': 3306,
            'user': 'root',
            'password': 'root',
            'charset': 'utf8mb4'
        }
        print("\n尝试连接到MySQL服务器（不指定数据库）")
        connection = pymysql.connect(**config)
        print("✓ 成功连接到MySQL服务器")
        
        # 列出所有数据库
        with connection.cursor() as cursor:
            cursor.execute("SHOW DATABASES")
            databases = cursor.fetchall()
            print(f"  可用的数据库: {len(databases)} 个")
            for db in databases:
                print(f"  - {db[0]}")
        
        connection.close()
    except Exception as e:
        print(f"✗ 连接到MySQL服务器失败: {str(e)}")
