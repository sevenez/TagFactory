import requests
import json

BASE_URL = "http://localhost:8002"

def test_api():
    print("🧪 测试修复版API接口...")
    
    # 测试根路径
    try:
        response = requests.get(f"{BASE_URL}/")
        print(f"✅ 根路径: {response.json()}")
    except Exception as e:
        print(f"❌ 根路径失败: {e}")
    
    # 测试数据源
    try:
        response = requests.get(f"{BASE_URL}/data/sources")
        print(f"✅ 数据源: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"❌ 数据源失败: {e}")
    
    # 测试统计数据
    try:
        response = requests.get(f"{BASE_URL}/data/statistics")
        print(f"✅ 统计数据: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"❌ 统计数据失败: {e}")
    
    # 测试连接状态
    try:
        response = requests.get(f"{BASE_URL}/data/connection/status")
        print(f"✅ 连接状态: {json.dumps(response.json(), ensure_ascii=False, indent=2)}")
    except Exception as e:
        print(f"❌ 连接状态失败: {e}")
    
    # 测试客户数据
    try:
        response = requests.get(f"{BASE_URL}/data/customers?page=1&page_size=5")
        data = response.json()
        print(f"✅ 客户数据: 总数={data.get('total', 0)}, 实际={len(data.get('data', []))}条")
        if data.get('data'):
            print(f"   样例: {data['data'][0]['customer_id']} - {data['data'][0]['phone']}")
    except Exception as e:
        print(f"❌ 客户数据失败: {e}")
    
    # 测试商家数据
    try:
        response = requests.get(f"{BASE_URL}/data/merchants?page=1&page_size=5")
        data = response.json()
        print(f"✅ 商家数据: 总数={data.get('total', 0)}, 实际={len(data.get('data', []))}条")
        if data.get('data'):
            print(f"   样例: {data['data'][0]['seller_id']} - {data['data'][0]['seller_name']}")
    except Exception as e:
        print(f"❌ 商家数据失败: {e}")
    
    # 测试商品数据
    try:
        response = requests.get(f"{BASE_URL}/data/products?page=1&page_size=5")
        data = response.json()
        print(f"✅ 商品数据: 总数={data.get('total', 0)}, 实际={len(data.get('data', []))}条")
        if data.get('data'):
            print(f"   样例: {data['data'][0]['product_id']} - {data['data'][0]['product_name']}")
    except Exception as e:
        print(f"❌ 商品数据失败: {e}")

if __name__ == "__main__":
    test_api()