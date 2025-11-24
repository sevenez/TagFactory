import requests
import json

BASE_URL = "http://localhost:8002"

def test_data_without_sorting():
    print("🧪 测试去掉排序功能后的API调用...")
    
    # 测试客户数据（不带排序参数）
    try:
        response = requests.get(f"{BASE_URL}/data/customers?page=1&page_size=5")
        data = response.json()
        print(f"✅ 客户数据: 总数={data.get('total', 0)}, 返回={len(data.get('data', []))}条")
    except Exception as e:
        print(f"❌ 客户数据失败: {e}")
    
    # 测试商家数据（不带排序参数）
    try:
        response = requests.get(f"{BASE_URL}/data/merchants?page=1&page_size=5")
        data = response.json()
        print(f"✅ 商家数据: 总数={data.get('total', 0)}, 返回={len(data.get('data', []))}条")
    except Exception as e:
        print(f"❌ 商家数据失败: {e}")
    
    # 测试商品数据（不带排序参数）
    try:
        response = requests.get(f"{BASE_URL}/data/products?page=1&page_size=5")
        data = response.json()
        print(f"✅ 商品数据: 总数={data.get('total', 0)}, 返回={len(data.get('data', []))}条")
    except Exception as e:
        print(f"❌ 商品数据失败: {e}")
    
    print("\n📝 说明:")
    print("- 已移除表头的点击排序功能")
    print("- 表头不再显示排序图标")
    print("- 数据将按数据库默认顺序显示")
    print("- 仍保留下拉筛选框中的排序选项")

if __name__ == "__main__":
    test_data_without_sorting()