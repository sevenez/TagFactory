import requests
import json

BASE_URL = "http://localhost:8002"

def test_frontend_data_requests():
    print("🔍 测试前端数据请求...")
    
    # 测试前端会发送的实际请求
    test_cases = [
        {
            "name": "统计数据",
            "url": f"{BASE_URL}/data/statistics",
            "method": "GET"
        },
        {
            "name": "客户数据 - 默认排序",
            "url": f"{BASE_URL}/data/customers?page=1&page_size=20&sort_by=register_time&sort_order=desc",
            "method": "GET"
        },
        {
            "name": "商家数据 - 默认排序", 
            "url": f"{BASE_URL}/data/merchants?page=1&page_size=20&sort_by=create_time&sort_order=desc",
            "method": "GET"
        },
        {
            "name": "商品数据 - 默认排序",
            "url": f"{BASE_URL}/data/products?page=1&page_size=20&sort_by=create_time&sort_order=desc",
            "method": "GET"
        },
        {
            "name": "客户数据 - 按手机号筛选",
            "url": f"{BASE_URL}/data/customers?page=1&page_size=20&sort_by=phone&sort_order=asc&name=138",
            "method": "GET"
        },
        {
            "name": "商家数据 - 按名称筛选",
            "url": f"{BASE_URL}/data/merchants?page=1&page_size=20&sort_by=seller_name&sort_order=asc&name=华为",
            "method": "GET"
        },
        {
            "name": "商品数据 - 按商家筛选",
            "url": f"{BASE_URL}/data/products?page=1&page_size=20&sort_by=product_name&sort_order=asc&merchant_id=S0000000000000001",
            "method": "GET"
        }
    ]
    
    for test in test_cases:
        try:
            print(f"\n📡 测试: {test['name']}")
            print(f"   URL: {test['url']}")
            
            response = requests.get(test['url'])
            
            if response.status_code == 200:
                data = response.json()
                if 'error' in data:
                    print(f"   ❌ 失败: {data['error']}")
                else:
                    if 'data' in data:
                        print(f"   ✅ 成功: 总数={data.get('total', 0)}, 返回={len(data.get('data', []))}条")
                        if data.get('data') and len(data['data']) > 0:
                            sample = data['data'][0]
                            if 'customer_id' in sample:
                                print(f"      样例: {sample['customer_id']} - {sample.get('phone', 'N/A')}")
                            elif 'seller_id' in sample:
                                print(f"      样例: {sample['seller_id']} - {sample.get('seller_name', 'N/A')}")
                            elif 'product_id' in sample:
                                print(f"      样例: {sample['product_id']} - {sample.get('product_name', 'N/A')}")
                    else:
                        print(f"   ✅ 成功: {json.dumps(data, ensure_ascii=False)}")
            else:
                print(f"   ❌ HTTP错误: {response.status_code}")
                
        except Exception as e:
            print(f"   ❌ 异常: {e}")

if __name__ == "__main__":
    test_frontend_data_requests()