import requests
import json
import time

def test_simple_api():
    """测试简化API"""
    base_url = "http://localhost:8001"
    
    print("🚀 开始测试简化API接口...")
    
    # 等待服务启动
    for i in range(5):
        try:
            response = requests.get(f"{base_url}/", timeout=2)
            if response.status_code == 200:
                print(f"✅ 服务已启动 (尝试 {i+1}/5)")
                break
        except:
            if i < 4:
                print(f"⏳ 等待服务启动... (尝试 {i+1}/5)")
                time.sleep(2)
            else:
                print("❌ 服务启动失败")
                return False
    
    endpoints = [
        ("/", "根路径"),
        ("/data/sources", "数据源列表"),
        ("/data/statistics", "数据统计"),
        ("/data/customers", "客户数据"),
        ("/data/merchants", "商家数据"),
        ("/data/products", "商品数据"),
        ("/data/connection/status", "连接状态")
    ]
    
    for endpoint, description in endpoints:
        try:
            print(f"\n📡 测试 {description} - {endpoint}")
            response = requests.get(f"{base_url}{endpoint}", timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                print(f"✅ 成功 - 状态码: {response.status_code}")
                
                if 'error' in data:
                    print(f"⚠️ 返回错误: {data['error']}")
                elif isinstance(data, dict):
                    if 'data' in data:
                        print(f"   数据条数: {len(data.get('data', []))}")
                        if data.get('data') and len(data.get('data')) > 0:
                            sample = data['data'][0]
                            print(f"   示例字段: {list(sample.keys())}")
                    elif 'customers' in data:
                        print(f"   客户数: {data.get('customers', 0)}")
                    elif 'status' in data:
                        print(f"   连接状态: {'已连接' if data['status'].get('connected') else '未连接'}")
                    else:
                        print(f"   返回字段: {list(data.keys())}")
                elif isinstance(data, list):
                    print(f"   数据类型: 列表，长度: {len(data)}")
                else:
                    print(f"   数据类型: {type(data)}")
                    print(f"   内容: {data}")
            else:
                print(f"❌ 失败 - 状态码: {response.status_code}")
                print(f"   错误信息: {response.text}")
                
        except requests.exceptions.ConnectionError:
            print(f"❌ 连接失败 - 服务未启动")
            return False
        except requests.exceptions.Timeout:
            print(f"❌ 请求超时")
        except Exception as e:
            print(f"❌ 请求异常: {str(e)}")
    
    print("\n✅ API测试完成")
    return True

if __name__ == "__main__":
    test_simple_api()