import pymysql

# 测试用户权限和数据操作
def test_user_permissions():
    config = {
        'host': 'localhost',
        'port': 3306,
        'user': 'root',
        'password': 'root',
        'database': 'tagfactory',
        'charset': 'utf8mb4'
    }
    
    try:
        print("数据库用户权限测试")
        print("=" * 50)
        
        # 连接数据库
        connection = pymysql.connect(**config)
        print("✓ 成功连接到tagfactory数据库")
        
        with connection.cursor() as cursor:
            # 1. 检查当前用户
            cursor.execute("SELECT USER(), CURRENT_USER()")
            users = cursor.fetchone()
            print(f"\n当前登录用户: {users[0]}")
            print(f"权限授予用户: {users[1]}")
            
            # 2. 检查用户权限
            cursor.execute("SHOW GRANTS FOR CURRENT_USER()")
            grants = cursor.fetchall()
            print("\n用户权限列表:")
            for grant in grants:
                print(f"  {grant[0]}")
            
            # 3. 测试数据读取权限（查询各表数据量）
            tables = ['customer_info', 'seller_info', 'product_info']
            print("\n测试数据读取权限:")
            for table in tables:
                try:
                    cursor.execute(f"SELECT COUNT(*) FROM {table}")
                    count = cursor.fetchone()[0]
                    print(f"  ✓ 表 {table}: 成功读取 {count} 条记录")
                    
                    # 读取表的前3条数据（验证数据可见性）
                    cursor.execute(f"SELECT * FROM {table} LIMIT 3")
                    rows = cursor.fetchall()
                    print(f"     前3条记录字段数: {len(rows[0]) if rows else 0}")
                    if rows:
                        print(f"     第一条记录示例: {str(rows[0])[:100]}...")
                except Exception as e:
                    print(f"  ✗ 表 {table}: 读取失败 - {str(e)}")
            
            # 4. 检查表结构（确保表定义完整）
            print("\n检查表结构完整性:")
            for table in tables:
                try:
                    cursor.execute(f"DESCRIBE {table}")
                    columns = cursor.fetchall()
                    print(f"  ✓ 表 {table}: 包含 {len(columns)} 个字段")
                    # 显示前5个字段信息
                    for col in columns[:5]:
                        print(f"     - {col[0]} ({col[1]})")
                except Exception as e:
                    print(f"  ✗ 表 {table}: 结构检查失败 - {str(e)}")
            
        connection.close()
        print("\n" + "=" * 50)
        print("权限测试完成")
        
    except Exception as e:
        print(f"✗ 权限测试失败: {str(e)}")

if __name__ == "__main__":
    test_user_permissions()
