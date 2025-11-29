import logging
from contextlib import contextmanager
from typing import Optional, Dict, Any, List, Tuple
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.ext.declarative import declarative_base
import pymysql

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

# 创建SQLAlchemy引擎
DATABASE_URL = f"mysql+pymysql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}?charset=utf8mb4"

engine = create_engine(
    DATABASE_URL,
    pool_size=10,           # 连接池大小
    max_overflow=20,        # 最大溢出连接数
    pool_timeout=30,        # 获取连接超时时间（秒）
    pool_recycle=3600,      # 连接回收时间（秒）
    pool_pre_ping=True,     # 连接有效性检查
    echo=False              # 是否打印SQL语句
)

# 创建SessionLocal类
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 创建Base类
Base = declarative_base()

# 依赖项，用于获取数据库会话
def get_db() -> Session:
    """
    获取数据库会话
    用于FastAPI依赖注入
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 兼容旧版API的连接池管理类
class DatabaseConnectionPool:
    """
    数据库连接池管理类（兼容旧版API）
    负责管理数据库连接的创建、复用和释放
    """
    
    def __init__(self, **config):
        self.config = DB_CONFIG.copy()
        if config:
            self.config.update(config)
        self.is_connected = False
        self.connection_error = None
        self.last_connection_attempt = 0
        self._test_connection()
    
    def _test_connection(self) -> bool:
        """测试数据库连接是否正常"""
        try:
            # 使用SQLAlchemy引擎测试连接
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            self.is_connected = True
            self.connection_error = None
            return True
        except Exception as e:
            self.connection_error = str(e)
            self.is_connected = False
            logger.error(f"连接测试失败: {e}")
            return False
    
    def get_connection(self) -> Optional[pymysql.connections.Connection]:
        """获取数据库连接（兼容旧版API）"""
        try:
            # 使用SQLAlchemy引擎获取底层连接
            with engine.connect() as conn:
                # 获取底层pymysql连接
                raw_conn = conn.connection
                return raw_conn
        except Exception as e:
            logger.error(f"获取连接失败: {e}")
            return None
    
    def release_connection(self, conn: Optional[pymysql.connections.Connection]):
        """释放数据库连接（兼容旧版API）"""
        # SQLAlchemy会自动管理连接，这里不需要做任何操作
        pass
    
    def test_connection(self) -> bool:
        """测试数据库连接是否正常"""
        return self._test_connection()
    
    def close_all_connections(self):
        """关闭所有连接（兼容旧版API）"""
        # SQLAlchemy会自动管理连接，这里只需要关闭引擎
        try:
            engine.dispose()
            logger.info("所有数据库连接已关闭")
        except Exception as e:
            logger.error(f"关闭连接失败: {e}")
    
    def get_status(self) -> Dict[str, Any]:
        """获取连接池状态信息"""
        return {
            'connected': self.is_connected,
            'active_connections': engine.pool.checkedout(),
            'pool_size': engine.pool.size(),
            'error': self.connection_error,
            'last_attempt': self.last_connection_attempt
        }

# 创建全局数据库连接池实例（兼容旧版API）
db_pool = DatabaseConnectionPool(**DB_CONFIG)

@contextmanager
def get_db_connection():
    """
    数据库连接上下文管理器（兼容旧版API）
    用于自动获取和释放数据库连接
    """
    try:
        # 使用SQLAlchemy引擎获取连接
        with engine.connect() as conn:
            yield conn.connection
    except Exception as e:
        logger.error(f"获取数据库连接失败: {e}")
        yield None

def execute_query(query: str, params: tuple = None, fetch_one: bool = False, fetch_all: bool = True) -> Optional[list] or Optional[dict]:
    """
    执行查询语句
    fetch_one: 是否只获取一条数据
    fetch_all: 是否获取所有数据
    """
    try:
        with engine.connect() as conn:
            # 执行查询 - 使用exec_driver_sql执行原始SQL，支持%s占位符
            # 注意：exec_driver_sql对于单个执行，参数应该是元组或字典，而不是列表
            # 确保params是元组格式
            if params is not None and isinstance(params, list):
                params = tuple(params)
            
            logger.info(f"执行SQL查询: {query}")
            logger.info(f"查询参数: {params}")
            
            # 执行查询
            result = conn.exec_driver_sql(query, params)
            logger.info(f"查询执行成功，开始获取结果")
            
            if fetch_one:
                row = result.fetchone()
                logger.info(f"获取单条结果: {row}")
                return dict(row._mapping) if row else None
            elif fetch_all:
                rows = result.fetchall()
                logger.info(f"获取所有结果，共 {len(rows)} 条")
                return [dict(row._mapping) for row in rows]
            else:
                return None
    except Exception as e:
        logger.error(f"查询执行失败: {type(e).__name__}: {e}")
        logger.error(f"SQL: {query}")
        logger.error(f"Params: {params}")
        import traceback
        logger.error(f"堆栈信息: {traceback.format_exc()}")
        return None

def execute_update(query: str, params: tuple = None) -> bool:
    """
    执行更新语句（插入、更新、删除）
    """
    try:
        with engine.begin() as conn:  # 使用begin()自动提交
            # 执行更新 - 使用exec_driver_sql执行原始SQL，支持%s占位符
            # 注意：exec_driver_sql对于单个执行，参数应该是元组或字典，而不是列表
            # 确保params是元组格式
            if params is not None and isinstance(params, list):
                params = tuple(params)
            
            conn.exec_driver_sql(query, params)
        return True
    except Exception as e:
        logger.error(f"更新执行失败: {e}")
        logger.error(f"SQL: {query}")
        logger.error(f"Params: {params}")
        return False

# 初始化数据库连接
# 在应用启动时测试连接
try:
    db_pool.test_connection()
except Exception as e:
    logger.warning(f"数据库连接初始化失败: {e}")

# 导入必要的SQLAlchemy函数
from sqlalchemy import text