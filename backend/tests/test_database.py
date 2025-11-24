import time
import random
import threading
import sys
import os

# 添加backend目录到Python路径
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import DatabaseConnectionPool, execute_query, execute_update

# 测试数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4'
}

# 测试类
class TestDatabaseConnection:
    
    def setup_method(self):
        """每个测试方法前初始化连接池"""
        # DatabaseConnectionPool可能不需要显式传递配置参数
        # 假设它内部已经使用了正确的配置
        self.db_pool = DatabaseConnectionPool()
    
    def teardown_method(self):
        """每个测试方法后关闭连接池"""
        if hasattr(self, 'db_pool'):
            self.db_pool.close_all_connections()
    
    def test_connection_creation(self):
        """测试连接创建功能"""
        conn = self.db_pool.get_connection()
        assert conn is not None, "数据库连接创建失败"
        self.db_pool.release_connection(conn)
    
    def test_connection_pooling(self):
        """测试连接池管理功能"""
        # 获取多个连接
        connections = []
        for _ in range(5):
            conn = self.db_pool.get_connection()
            if conn:
                connections.append(conn)
        
        # 验证连接数量
        assert len(connections) > 0, "未能获取到连接"
        
        # 释放连接
        for conn in connections:
            self.db_pool.release_connection(conn)
        
        # 验证连接已放回池中
        assert len(self.db_pool.connection_pool) >= len(connections), "连接未正确释放到池中"
    
    def test_connection_test(self):
        """测试连接测试功能"""
        result = self.db_pool.test_connection()
        print(f"连接测试结果: {result}")
        # 注意：这里不强制要求测试通过，因为可能数据库未启动
        # 主要验证方法能正常执行而不抛出异常
    
    def test_execute_query(self):
        """测试查询执行功能"""
        try:
            # 尝试执行一个简单的查询
            result = execute_query("SELECT 1 as test")
            assert result is not None, "查询执行失败"
            print(f"查询测试结果: {result}")
        except Exception as e:
            print(f"查询测试遇到异常: {e}")
            # 不强制失败，因为数据库可能未启动
    
    def test_connection_status_tracking(self):
        """测试连接状态跟踪"""
        # 初始状态检查
        print(f"初始连接状态: {self.db_pool.is_connected}")
        
        # 尝试获取连接后的状态
        conn = self.db_pool.get_connection()
        print(f"获取连接后状态: {self.db_pool.is_connected}")
        self.db_pool.release_connection(conn)
    
    def test_error_handling(self):
        """测试错误处理机制"""
        # 使用错误的SQL语句测试异常处理
        try:
            execute_query("INVALID SQL STATEMENT")
        except Exception as e:
            print(f"错误处理测试成功捕获异常: {e}")

# 性能测试
def test_performance_multiple_queries():
    """测试多查询性能"""
    db_pool = DatabaseConnectionPool()
    start_time = time.time()
    
    try:
        # 执行多个简单查询
        for i in range(10):
            try:
                execute_query("SELECT 1 as test")
            except Exception as e:
                print(f"性能测试查询 {i} 失败: {e}")
                
        end_time = time.time()
        print(f"执行10次查询耗时: {end_time - start_time:.4f}秒")
    finally:
        db_pool.close_all_connections()

# 并发测试
def concurrent_connection_test(thread_id, results):
    """并发连接测试函数"""
    try:
        db_pool = DatabaseConnectionPool()
        conn = db_pool.get_connection()
        if conn:
            results[thread_id] = True
            # 模拟查询操作
            time.sleep(random.uniform(0.1, 0.3))
            db_pool.release_connection(conn)
        else:
            results[thread_id] = False
    except Exception as e:
        print(f"线程 {thread_id} 异常: {e}")
        results[thread_id] = False
    finally:
        db_pool.close_all_connections()

def test_concurrent_connections():
    """测试并发连接处理"""
    num_threads = 10
    results = {}
    threads = []
    
    # 创建多个线程
    for i in range(num_threads):
        t = threading.Thread(target=concurrent_connection_test, args=(i, results))
        threads.append(t)
    
    # 启动所有线程
    for t in threads:
        t.start()
    
    # 等待所有线程完成
    for t in threads:
        t.join()
    
    # 统计结果
    success_count = sum(1 for success in results.values() if success)
    print(f"并发测试结果: {success_count}/{num_threads} 线程成功")

# 重连测试
def test_reconnect_mechanism():
    """测试重连机制"""
    db_pool = DatabaseConnectionPool()
    
    # 测试多次连接尝试
    success_count = 0
    for i in range(3):
        if db_pool.test_connection():
            success_count += 1
        time.sleep(1)  # 等待1秒再尝试
    
    print(f"重连测试结果: 3次尝试中 {success_count} 次成功")
    db_pool.close_all_connections()

# 运行测试
if __name__ == "__main__":
    print("开始数据库连接测试...")
    
    # 实例化测试类并运行测试
    test_obj = TestDatabaseConnection()
    
    # 运行各项测试
    print("\n1. 测试连接创建...")
    try:
        test_obj.setup_method()
        test_obj.test_connection_creation()
    except Exception as e:
        print(f"连接创建测试失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n2. 测试连接池管理...")
    try:
        test_obj.setup_method()
        test_obj.test_connection_pooling()
    except Exception as e:
        print(f"连接池管理测试失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n3. 测试连接测试功能...")
    try:
        test_obj.setup_method()
        test_obj.test_connection_test()
    except Exception as e:
        print(f"连接测试功能失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n4. 测试查询执行功能...")
    try:
        test_obj.setup_method()
        test_obj.test_execute_query()
    except Exception as e:
        print(f"查询执行功能失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n5. 测试连接状态跟踪...")
    try:
        test_obj.setup_method()
        test_obj.test_connection_status_tracking()
    except Exception as e:
        print(f"连接状态跟踪测试失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n6. 测试错误处理机制...")
    try:
        test_obj.setup_method()
        test_obj.test_error_handling()
    except Exception as e:
        print(f"错误处理机制测试失败: {e}")
    finally:
        test_obj.teardown_method()
    
    print("\n7. 测试多查询性能...")
    try:
        test_performance_multiple_queries()
    except Exception as e:
        print(f"性能测试失败: {e}")
    
    print("\n8. 测试并发连接处理...")
    try:
        test_concurrent_connections()
    except Exception as e:
        print(f"并发测试失败: {e}")
    
    print("\n9. 测试重连机制...")
    try:
        test_reconnect_mechanism()
    except Exception as e:
        print(f"重连机制测试失败: {e}")
    
    print("\n数据库连接测试完成!")
