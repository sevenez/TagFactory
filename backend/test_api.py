import requests
import json

def test_api_endpoints():
    """测试后端API接口"""
    base_url = "http://localhost:8000"
    
    print("🚀 开始测试后端API接口...")
    
    # 测试接口列表
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
                if isinstance(data, dict):
                    if 'data' in data:
                        print(f"   数据条数: {len(data.get('data', []))}")
                    elif 'customers' in data:
                        print(f"   客户数: {data.get('customers', 0)}")
                    elif 'status' in data:
                        print(f"   连接状态: {'已连接' if data['status'].get('connected') else '未连接'}")
                    else:
                        print(f"   返回字段: {list(data.keys())}")
                else:
                    print(f"   数据类型: {type(data)}")
            else:
                print(f"❌ 失败 - 状态码: {response.status_code}")
                print(f"   错误信息: {response.text}")
                
        except requests.exceptions.ConnectionError:
            print(f"❌ 连接失败 - 后端服务未启动")
            return False
        except requests.exceptions.Timeout:
            print(f"❌ 请求超时")
        except Exception as e:
            print(f"❌ 请求异常: {str(e)}")
    
    print("\n✅ API测试完成")
    return True

if __name__ == "__main__":
    test_api_endpoints()