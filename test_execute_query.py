from backend.database import execute_query

# 测试查询用户信息
def test_query_user():
    """测试查询用户信息"""
    try:
        # 构建查询条件
        query = """
        SELECT c.customer_id, c.phone, c.register_time, c.last_active_time, c.gender, c.age, c.education, c.province, c.total_consume, c.consume_months
        FROM customer_info c
        WHERE c.is_deleted = 0 AND c.customer_id = %s
        """
        user_id = "U0000000000000001"
        
        print(f"正在查询用户 {user_id} 的信息...")
        user_result = execute_query(query, (user_id,), fetch_one=True)
        
        if user_result:
            print(f"✅ 查询成功: {user_result}")
        else:
            print(f"❌ 查询失败: 未找到用户 {user_id}")
            
            # 尝试查询所有用户，看看是否能获取到数据
            print("\n正在查询所有用户信息...")
            all_users_query = "SELECT customer_id, phone FROM customer_info WHERE is_deleted = 0 LIMIT 5"
            all_users = execute_query(all_users_query, fetch_all=True)
            if all_users:
                print(f"✅ 查询到 {len(all_users)} 个用户:")
                for user in all_users:
                    print(f"  - ID: {user['customer_id']}, Phone: {user['phone']}")
            else:
                print("❌ 无法查询到任何用户信息")
    except Exception as e:
        print(f"❌ 查询过程中发生错误: {e}")

if __name__ == "__main__":
    test_query_user()