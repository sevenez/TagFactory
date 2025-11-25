import requests
import time

# 测试服务状态的函数
def test_service(url, name):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            print(f"✅ {name} 服务正常运行: {url}")
            return True
        else:
            print(f"❌ {name} 服务返回错误状态码: {response.status_code} - {url}")
            return False
    except requests.exceptions.ConnectionError:
        print(f"❌ {name} 服务无法连接: {url}")
        return False
    except requests.exceptions.Timeout:
        print(f"❌ {name} 服务超时: {url}")
        return False
    except Exception as e:
        print(f"❌ {name} 服务测试失败: {e} - {url}")
        return False

# 等待一段时间让服务启动
print("等待服务启动...")
time.sleep(5)

# 测试各个服务
test_service("http://localhost:8000", "Main Backend")
test_service("http://localhost:8002", "Fixed Backend")
test_service("http://localhost:8002/data/sources", "Fixed Backend API")
test_service("http://localhost:5173", "Frontend")

print("\n服务测试完成！")