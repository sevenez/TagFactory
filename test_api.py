import requests
import json

# 发送请求获取标签数据
response = requests.get("http://localhost:8002/tags")

# 检查响应状态码
if response.status_code == 200:
    # 解析JSON数据
    data = response.json()
    
    # 检查是否包含layer字段
    if data.get("data") and len(data["data"]) > 0:
        first_tag = data["data"][0]
        print("✅ API返回的数据包含layer字段:")
        print(f"   标签ID: {first_tag.get('tag_id')}")
        print(f"   标签名称: {first_tag.get('name')}")
        print(f"   标签层级: {first_tag.get('layer')}")
        print(f"   标签类型: {first_tag.get('type')}")
        print(f"   标签状态: {first_tag.get('status')}")
        print(f"\n📋 总标签数: {data.get('total')}")
        print(f"📄 页码: {data.get('page')}")
        print(f"📏 每页数量: {data.get('page_size')}")
    else:
        print("❌ API返回的数据不包含标签列表")
else:
    print(f"❌ API请求失败，状态码: {response.status_code}")
    print(f"   错误信息: {response.text}")
