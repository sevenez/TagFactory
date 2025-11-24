import pymysql
from pymysql.cursors import DictCursor
from typing import Optional, Dict, Any
import logging
from contextlib import contextmanager
import time

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4',
    'autocommit': True,
    'connect_timeout': 10
}

class DatabaseConnectionPool:
    """
    数据库连接池管理类
    负责管理数据库连接的创建、复用和释放
    """
    
    def __init__(self, **config):
        # 如果没有提供配置，使用默认的DB_CONFIG
        self.config = DB_CONFIG.copy()
        # 更新用户提供的配置参数
        if config:
            self.config.update(config)
        self.connection_pool = []
        self.max_connections = 10
        self.active_connections = 0
        self.last_connection_attempt = 0
        self.connection_error = None
        self.is_connected = False
    
    def get_connection(self) -> Optional[pymysql.connections.Connection]:
        """获取数据库连接，优先从连接池获取，没有则创建新连接"""
        # 尝试从连接池获取可用连接
        while self.connection_pool:
            conn = self.connection_pool.pop()
            try:
                # 检查连接是否有效
                conn.ping(reconnect=False)
                self.active_connections += 1
                return conn
            except Exception as e:
                logger.error(f"连接不可用: {e}")
                try:
                    conn.close()
                except:
                    pass
        
        # 如果连接池为空且未达到最大连接数，创建新连接
        if self.active_connections < self.max_connections:
            return self._create_connection()
        
        logger.warning("连接池已满，无法获取新连接")
        return None
    
    def _create_connection(self) -> Optional[pymysql.connections.Connection]:
        """创建新的数据库连接"""
        try:
            # 避免频繁尝试连接
            current_time = time.time()
            if self.connection_error and (current_time - self.last_connection_attempt < 5):
                logger.warning("连接尝试过于频繁，跳过本次尝试")
                return None
            
            self.last_connection_attempt = current_time
            self.connection_error = None
            
            # 创建连接时增加异常处理和详细日志
            logger.info(f"正在尝试连接数据库: {self.config.get('host')}:{self.config.get('port')}/{self.config.get('database')}")
            conn = pymysql.connect(
                **self.config,
                cursorclass=DictCursor
            )
            
            self.active_connections += 1
            self.is_connected = True
            logger.info("数据库连接创建成功")
            return conn
            
        except Exception as e:
            self.connection_error = str(e)
            self.is_connected = False
            logger.error(f"创建数据库连接失败: {e}")
            return None
    
    def release_connection(self, conn: Optional[pymysql.connections.Connection]):
        """释放数据库连接回连接池"""
        if conn is None:
            return
        
        self.active_connections = max(0, self.active_connections - 1)
        
        try:
            # 检查连接是否仍然有效
            conn.ping(reconnect=False)
            # 重置连接状态，处理不同pymysql版本可能没有in_transaction属性的情况
            try:
                if hasattr(conn, 'in_transaction'):
                    if not conn.in_transaction:
                        self.connection_pool.append(conn)
                    else:
                        try:
                            conn.rollback()
                        except:
                            pass
                        conn.close()
                else:
                    # 对于不支持in_transaction属性的版本，尝试直接回滚后放回池中
                    try:
                        conn.rollback()
                    except:
                        pass
                    self.connection_pool.append(conn)
            except Exception:
                # 如果出现其他错误，关闭连接
                try:
                    conn.close()
                except:
                    pass
        except Exception as e:
            logger.error(f"释放连接失败: {e}")
            try:
                conn.close()
            except:
                pass
    
    def test_connection(self) -> bool:
        """测试数据库连接是否正常"""
        conn = None
        try:
            conn = self.get_connection()
            if conn:
                conn.ping()
                self.is_connected = True
                self.connection_error = None
                return True
            return False
        except Exception as e:
            self.connection_error = str(e)
            self.is_connected = False
            logger.error(f"连接测试失败: {e}")
            return False
        finally:
            self.release_connection(conn)
    
    def close_all_connections(self):
        """关闭所有连接"""
        for conn in self.connection_pool:
            try:
                conn.close()
            except:
                pass
        
        self.connection_pool.clear()
        self.active_connections = 0
        self.is_connected = False
        logger.info("所有数据库连接已关闭")
    
    def get_status(self) -> Dict[str, Any]:
        """获取连接池状态信息"""
        return {
            'connected': self.is_connected,
            'active_connections': self.active_connections,
            'pool_size': len(self.connection_pool),
            'error': self.connection_error,
            'last_attempt': self.last_connection_attempt
        }

# 创建全局数据库连接池实例
db_pool = DatabaseConnectionPool(**DB_CONFIG)

@contextmanager
def get_db_connection():
    """
    数据库连接上下文管理器
    用于自动获取和释放数据库连接
    """
    connection = None
    try:
        connection = db_pool.get_connection()
        yield connection
    finally:
        db_pool.release_connection(connection)

def execute_query(query: str, params: tuple = None, fetch_one: bool = False, fetch_all: bool = True) -> Optional[list] or Optional[dict]:
    """
    执行查询语句
    fetch_one: 是否只获取一条数据
    fetch_all: 是否获取所有数据
    """
    with get_db_connection() as conn:
        if not conn:
            logger.warning("无法获取数据库连接")
            return None
        
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                if fetch_one:
                    return cursor.fetchone()
                elif fetch_all:
                    return cursor.fetchall()
                else:
                    return None
        except Exception as e:
            logger.error(f"查询执行失败: {e}")
            return None

def execute_update(query: str, params: tuple = None) -> bool:
    """
    执行更新语句（插入、更新、删除）
    """
    with get_db_connection() as conn:
        if not conn:
            logger.warning("无法获取数据库连接进行更新操作")
            return False
        
        try:
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"更新执行失败: {e}")
            try:
                conn.rollback()
            except:
                pass
            return False

# 初始化数据库连接
# 在应用启动时测试连接
try:
    db_pool.test_connection()
except Exception as e:
    logger.warning(f"数据库连接初始化失败: {e}")