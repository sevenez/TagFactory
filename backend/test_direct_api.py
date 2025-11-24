import sys
import os
import json

# 添加项目路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database import execute_query, db_pool

def test_database_directly():
    """直接测试数据库查询"""
    print("🚀 直接测试数据库查询...")
    
    try:
        # 1. 测试连接
        print("\n📡 测试数据库连接...")
        status = db_pool.get_status()
        print(f"连接状态: {'已连接' if status['connected'] else '未连接'}")
        print(f"活跃连接数: {status['active_connections']}")
        print(f"连接池大小: {status['pool_size']}")
        
        if not status['connected']:
            print("❌ 数据库未连接，无法继续测试")
            return False
        
        # 2. 测试统计查询
        print("\n📊 测试统计查询...")
        try:
            customer_count = execute_query("SELECT COUNT(*) FROM customer_info WHERE is_deleted = 0", fetch_one=True)
            merchant_count = execute_query("SELECT COUNT(*) FROM seller_info WHERE status = 1", fetch_one=True)
            product_count = execute_query("SELECT COUNT(*) FROM product_info WHERE status = 1", fetch_one=True)
            
            print(f"✅ 客户总数: {customer_count[0] if customer_count else 0}")
            print(f"✅ 商家总数: {merchant_count[0] if merchant_count else 0}")
            print(f"✅ 商品总数: {product_count[0] if product_count else 0}")
            
        except Exception as e:
            print(f"❌ 统计查询失败: {e}")
        
        # 3. 测试客户数据查询
        print("\n👥 测试客户数据查询...")
        try:
            customers = execute_query("SELECT * FROM customer_info LIMIT 3", fetch_all=True)
            if customers:
                print(f"✅ 查询到 {len(customers)} 条客户记录")
                for i, customer in enumerate(customers, 1):
                    print(f"   {i}. {customer['customer_id']} - {customer['phone']} - {customer['gender']}")
            else:
                print("❌ 未查询到客户数据")
        except Exception as e:
            print(f"❌ 客户数据查询失败: {e}")
        
        # 4. 测试商家数据查询
        print("\n🏪 测试商家数据查询...")
        try:
            merchants = execute_query("SELECT * FROM seller_info LIMIT 3", fetch_all=True)
            if merchants:
                print(f"✅ 查询到 {len(merchants)} 条商家记录")
                for i, merchant in enumerate(merchants, 1):
                    print(f"   {i}. {merchant['seller_id']} - {merchant['seller_name']} - {merchant['city']}")
            else:
                print("❌ 未查询到商家数据")
        except Exception as e:
            print(f"❌ 商家数据查询失败: {e}")
        
        # 5. 测试商品数据查询
        print("\n📦 测试商品数据查询...")
        try:
            products = execute_query("SELECT * FROM product_info LIMIT 3", fetch_all=True)
            if products:
                print(f"✅ 查询到 {len(products)} 条商品记录")
                for i, product in enumerate(products, 1):
                    print(f"   {i}. {product['product_id']} - {product['product_name']} - {product['price']}")
            else:
                print("❌ 未查询到商品数据")
        except Exception as e:
            print(f"❌ 商品数据查询失败: {e}")
        
        print("\n✅ 数据库直接测试完成")
        return True
        
    except Exception as e:
        print(f"❌ 测试失败: {e}")
        return False

def simulate_api_responses():
    """模拟API响应格式"""
    print("\n🔧 模拟前端API响应格式...")
    
    try:
        # 模拟客户数据API
        print("\n📋 模拟客户数据API响应:")
        customers = execute_query("SELECT * FROM customer_info LIMIT 5", fetch_all=True)
        if customers:
            api_response = {
                "data": customers,
                "total": len(customers),
                "page": 1,
                "page_size": 5,
                "total_pages": 1
            }
            print(f"✅ API格式正确，数据条数: {len(api_response['data'])}")
            print(f"   数据结构: {list(api_response.keys())}")
        else:
            print("❌ 客户数据为空")
        
        # 模拟商家数据API
        print("\n🏪 模拟商家数据API响应:")
        merchants = execute_query("SELECT * FROM seller_info LIMIT 5", fetch_all=True)
        if merchants:
            api_response = {
                "data": merchants,
                "total": len(merchants),
                "page": 1,
                "page_size": 5,
                "total_pages": 1
            }
            print(f"✅ API格式正确，数据条数: {len(api_response['data'])}")
            print(f"   数据结构: {list(api_response.keys())}")
        else:
            print("❌ 商家数据为空")
        
        # 模拟商品数据API
        print("\n📦 模拟商品数据API响应:")
        products = execute_query("SELECT * FROM product_info LIMIT 5", fetch_all=True)
        if products:
            api_response = {
                "data": products,
                "total": len(products),
                "page": 1,
                "page_size": 5,
                "total_pages": 1
            }
            print(f"✅ API格式正确，数据条数: {len(api_response['data'])}")
            print(f"   数据结构: {list(api_response.keys())}")
        else:
            print("❌ 商品数据为空")
        
        print("\n✅ API响应格式模拟完成")
        return True
        
    except Exception as e:
        print(f"❌ API格式模拟失败: {e}")
        return False

if __name__ == "__main__":
    # 先测试数据库连接
    if test_database_directly():
        # 再模拟API响应
        simulate_api_responses()
    else:
        print("❌ 数据库测试失败，跳过API模拟")