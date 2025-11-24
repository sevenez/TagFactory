import sys
import os

# 添加项目路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database import execute_query

def test_statistics_queries():
    """测试统计查询语句"""
    print("🔍 测试统计查询语句...")
    
    queries = [
        ("客户总数统计", "SELECT COUNT(*) FROM customer_info WHERE is_deleted = 0"),
        ("商家总数统计", "SELECT COUNT(*) FROM seller_info WHERE status = 1"),
        ("商品总数统计", "SELECT COUNT(*) FROM product_info WHERE status = 1"),
        ("客户总数（无条件）", "SELECT COUNT(*) FROM customer_info"),
        ("商家总数（无条件）", "SELECT COUNT(*) FROM seller_info"),
        ("商品总数（无条件）", "SELECT COUNT(*) FROM product_info"),
    ]
    
    for desc, query in queries:
        try:
            result = execute_query(query, fetch_one=True)
            if result and isinstance(result, tuple):
                count = result[0]
            elif result and isinstance(result, dict):
                # 如果返回字典格式
                count = list(result.values())[0]
            else:
                count = 0
            
            print(f"✅ {desc}: {count}")
            
        except Exception as e:
            print(f"❌ {desc} 失败: {e}")
    
    # 测试查询结果格式
    print("\n🔍 检查查询返回格式...")
    try:
        result = execute_query("SELECT COUNT(*) FROM customer_info WHERE is_deleted = 0", fetch_one=True)
        print(f"查询结果类型: {type(result)}")
        print(f"查询结果内容: {result}")
        
        if isinstance(result, tuple):
            print(f"✅ 元组格式，count = result[0] = {result[0]}")
        elif isinstance(result, dict):
            print(f"✅ 字典格式，keys = {list(result.keys())}")
            print(f"✅ 字典格式，values = {list(result.values())}")
            
    except Exception as e:
        print(f"❌ 格式检查失败: {e}")

if __name__ == "__main__":
    test_statistics_queries()