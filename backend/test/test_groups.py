import requests
import json
import time

# 基础URL
BASE_URL = "http://localhost:8000"

# 测试数据
TEST_GROUP_NAME = "测试群体"
TEST_ENTITY_TYPE = "CUSTOMER"
TEST_METHOD = "RULE"
TEST_DESCRIPTION = "这是一个测试群体"

# 等待服务启动
print("等待服务启动...")
time.sleep(5)

# 测试创建群体
def test_create_group():
    print("\n=== 测试创建群体 ===")
    
    # 准备测试数据
    tags = [
        {"tag_code": "TAG_001", "tag_value": "", "operator": "AND"},
        {"tag_code": "TAG_002", "tag_value": "", "operator": "AND"}
    ]
    
    params = {
        "name": TEST_GROUP_NAME,
        "entity_type": TEST_ENTITY_TYPE,
        "method": TEST_METHOD,
        "description": TEST_DESCRIPTION,
        "tags": json.dumps(tags)
    }
    
    try:
        response = requests.post(f"{BASE_URL}/groups", params=params)
        
        if response.status_code == 200:
            print("✅ 创建群体成功")
            group_data = response.json()
            print(f"   群体ID: {group_data['group_id']}")
            print(f"   群体名称: {group_data['name']}")
            print(f"   群体规则: {group_data['rule']}")
            return group_data['group_id']
        else:
            print(f"❌ 创建群体失败: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print(f"❌ 创建群体测试失败: {e}")
        return None

# 测试获取群体列表
def test_get_groups():
    print("\n=== 测试获取群体列表 ===")
    
    try:
        response = requests.get(f"{BASE_URL}/groups")
        
        if response.status_code == 200:
            print("✅ 获取群体列表成功")
            groups_data = response.json()
            print(f"   总群体数: {groups_data['total']}")
            print(f"   当前页: {groups_data['page']}")
            print(f"   每页数量: {groups_data['page_size']}")
            print(f"   总页数: {groups_data['total_pages']}")
            print(f"   群体列表: {[group['name'] for group in groups_data['data']]}")
            return True
        else:
            print(f"❌ 获取群体列表失败: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ 获取群体列表测试失败: {e}")
        return False

# 测试获取群体详情
def test_get_group_detail(group_id):
    print(f"\n=== 测试获取群体详情 (ID: {group_id}) ===")
    
    try:
        response = requests.get(f"{BASE_URL}/groups/{group_id}")
        
        if response.status_code == 200:
            print("✅ 获取群体详情成功")
            group_data = response.json()
            print(f"   群体ID: {group_data['group_id']}")
            print(f"   群体名称: {group_data['name']}")
            print(f"   群体规则: {group_data['rule']}")
            print(f"   群体状态: {group_data['status']}")
            return True
        else:
            print(f"❌ 获取群体详情失败: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ 获取群体详情测试失败: {e}")
        return False

# 测试获取群体标签
def test_get_group_tags(group_id):
    print(f"\n=== 测试获取群体标签 (ID: {group_id}) ===")
    
    try:
        response = requests.get(f"{BASE_URL}/groups/{group_id}/tags")
        
        if response.status_code == 200:
            print("✅ 获取群体标签成功")
            tags_data = response.json()
            print(f"   标签数量: {len(tags_data)}")
            for tag in tags_data:
                print(f"   - {tag['tag_code']}: {tag['tag_value']} ({tag['operator']})")
            return True
        else:
            print(f"❌ 获取群体标签失败: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ 获取群体标签测试失败: {e}")
        return False

# 测试获取群体实体
def test_get_group_entities(group_id):
    print(f"\n=== 测试获取群体实体 (ID: {group_id}) ===")
    
    try:
        response = requests.get(f"{BASE_URL}/groups/{group_id}/entities")
        
        if response.status_code == 200:
            print("✅ 获取群体实体成功")
            entities_data = response.json()
            print(f"   实体数量: {len(entities_data)}")
            return True
        else:
            print(f"❌ 获取群体实体失败: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ 获取群体实体测试失败: {e}")
        return False

# 测试获取群体统计信息
def test_get_group_stats(group_id):
    print(f"\n=== 测试获取群体统计信息 (ID: {group_id}) ===")
    
    try:
        response = requests.get(f"{BASE_URL}/groups/{group_id}/stats")
        
        if response.status_code == 200:
            print("✅ 获取群体统计信息成功")
            stats_data = response.json()
            print(f"   群体名称: {stats_data['group_name']}")
            print(f"   实体数量: {stats_data['entity_count']}")
            print(f"   标签数量: {stats_data['tag_count']}")
            print(f"   实体类型: {stats_data['entity_type']}")
            print(f"   状态: {stats_data['status']}")
            return True
        else:
            print(f"❌ 获取群体统计信息失败: {response.status_code} - {response.text}")
            return False
    except Exception as e:
        print(f"❌ 获取群体统计信息测试失败: {e}")
        return False

# 主测试函数
def run_tests():
    print("开始群体中心功能测试...")
    
    # 运行测试
    group_id = test_create_group()
    test_get_groups()
    
    if group_id:
        test_get_group_detail(group_id)
        test_get_group_tags(group_id)
        test_get_group_entities(group_id)
        test_get_group_stats(group_id)
    
    print("\n群体中心功能测试完成！")

# 执行测试
if __name__ == "__main__":
    run_tests()
