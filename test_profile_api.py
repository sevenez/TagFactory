import requests
import json

# 测试用户ID搜索
def test_user_id_search():
    print("🔍 测试用户ID搜索...")
    url = "http://localhost:8003/users/lookup"
    params = {"user_id": "10001"}
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        
        print(f"✅ 用户ID搜索成功，状态码: {response.status_code}")
        print(f"   用户ID: {data.get('user_id')}")
        print(f"   手机号: {data.get('phone')}")
        print(f"   注册时间: {data.get('registered_at')}")
        print(f"   最近活跃时间: {data.get('last_active_at')}")
        print(f"   基础标签数量: {len(data.get('basic_tags', {}))}")
        print(f"   行为标签数量: {len(data.get('behavior_tags', {}))}")
        print(f"   统计标签数量: {len(data.get('stats_tags', {}))}")
        print(f"   衍生标签数量: {len(data.get('derived_tags', {}))}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ 用户ID搜索失败: {e}")
        return False

# 测试手机号搜索
def test_phone_search():
    print("\n🔍 测试手机号搜索...")
    url = "http://localhost:8003/users/lookup"
    params = {"phone": "138"}
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        
        print(f"✅ 手机号搜索成功，状态码: {response.status_code}")
        print(f"   用户ID: {data.get('user_id')}")
        print(f"   手机号: {data.get('phone')}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ 手机号搜索失败: {e}")
        return False

# 测试手机号模糊搜索
def test_phone_fuzzy_search():
    print("\n🔍 测试手机号模糊搜索...")
    url = "http://localhost:8003/users/lookup"
    params = {"phone": "139"}
    
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        
        print(f"✅ 手机号模糊搜索成功，状态码: {response.status_code}")
        print(f"   用户ID: {data.get('user_id')}")
        print(f"   手机号: {data.get('phone')}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ 手机号模糊搜索失败: {e}")
        return False

# 测试无效用户ID搜索
def test_invalid_user_id_search():
    print("\n🔍 测试无效用户ID搜索...")
    url = "http://localhost:8003/users/lookup"
    params = {"user_id": "invalid_user"}
    
    try:
        response = requests.get(url, params=params)
        if response.status_code == 404:
            print(f"✅ 无效用户ID搜索返回404，状态码: {response.status_code}")
            return True
        else:
            print(f"❌ 无效用户ID搜索返回意外状态码: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ 无效用户ID搜索失败: {e}")
        return False

# 测试无效手机号搜索
def test_invalid_phone_search():
    print("\n🔍 测试无效手机号搜索...")
    url = "http://localhost:8003/users/lookup"
    params = {"phone": "invalid_phone"}
    
    try:
        response = requests.get(url, params=params)
        if response.status_code == 404:
            print(f"✅ 无效手机号搜索返回404，状态码: {response.status_code}")
            return True
        else:
            print(f"❌ 无效手机号搜索返回意外状态码: {response.status_code}")
            return False
    except requests.exceptions.RequestException as e:
        print(f"❌ 无效手机号搜索失败: {e}")
        return False

# 主函数
def main():
    print("🚀 开始测试个体画像API...")
    print("=" * 50)
    
    # 运行所有测试
    test_results = {
        "用户ID搜索": test_user_id_search(),
        "手机号搜索": test_phone_search(),
        "手机号模糊搜索": test_phone_fuzzy_search(),
        "无效用户ID搜索": test_invalid_user_id_search(),
        "无效手机号搜索": test_invalid_phone_search()
    }
    
    print("\n" + "=" * 50)
    print("📋 测试结果汇总:")
    for test_name, result in test_results.items():
        status = "✅ 成功" if result else "❌ 失败"
        print(f"   {test_name}: {status}")
    
    # 计算成功率
    success_count = sum(test_results.values())
    total_count = len(test_results)
    success_rate = (success_count / total_count) * 100
    print(f"\n📊 测试成功率: {success_count}/{total_count} ({success_rate:.1f}%)")
    
    if success_rate == 100:
        print("🎉 所有测试通过！")
    else:
        print("⚠️  部分测试失败，请检查API实现。")

if __name__ == "__main__":
    main()
