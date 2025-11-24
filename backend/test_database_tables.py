import pymysql
from database import db_pool, get_db_connection
import logging

# 配置日志
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

def test_database_connection():
    """测试数据库连接是否正常"""
    logger.info("=== 测试数据库连接 ===")
    
    if db_pool.test_connection():
        logger.info("✅ 数据库连接成功！")
        return True
    else:
        logger.error("❌ 数据库连接失败！")
        return False

def show_database_tables():
    """显示数据库中的所有表"""
    logger.info("\n=== 获取数据库表结构 ===")
    
    query = "SHOW TABLES"
    tables = execute_query(query)
    
    if tables:
        logger.info(f"📋 数据库中共有 {len(tables)} 张表：")
        for i, table in enumerate(tables, 1):
            table_name = list(table.values())[0]  # 获取表名
            logger.info(f"{i}. {table_name}")
        return tables
    else:
        logger.warning("❌ 未找到任何数据表")
        return []

def show_table_structure(table_name):
    """显示指定表的结构"""
    logger.info(f"\n=== 表 {table_name} 的结构 ===")
    
    query = f"DESCRIBE {table_name}"
    columns = execute_query(query)
    
    if columns:
        logger.info(f"表 {table_name} 共有 {len(columns)} 个字段：")
        for col in columns:
            field = col['Field']
            type_info = col['Type']
            null_info = col['Null']
            key_info = col['Key']
            default_info = col['Default']
            extra_info = col['Extra']
            logger.info(f"  📝 {field} | {type_info} | NULL: {null_info} | KEY: {key_info} | DEFAULT: {default_info} | EXTRA: {extra_info}")
    else:
        logger.warning(f"❌ 无法获取表 {table_name} 的结构")

def show_sample_data(table_name, limit=1):
    """显示表的前一条数据"""
    logger.info(f"\n=== 表 {table_name} 的前{limit}条数据 ===")
    
    # 先获取总记录数
    count_query = f"SELECT COUNT(*) as total_count FROM {table_name}"
    count_result = execute_query(count_query, fetch_one=True)
    
    if count_result and count_result['total_count'] > 0:
        logger.info(f"📊 表 {table_name} 共有 {count_result['total_count']} 条记录")
        
        # 获取前几条数据
        query = f"SELECT * FROM {table_name} LIMIT {limit}"
        records = execute_query(query)
        
        if records:
            for i, record in enumerate(records, 1):
                logger.info(f"\n🔸 记录 {i}:")
                for key, value in record.items():
                    logger.info(f"   {key}: {value}")
        else:
            logger.warning(f"❌ 无法获取表 {table_name} 的数据")
    else:
        logger.info(f"📊 表 {table_name} 暂无数据")

def execute_query(query: str, params: tuple = None, fetch_one: bool = False, fetch_all: bool = True):
    """执行查询语句"""
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

def main():
    """主测试函数"""
    logger.info("🚀 开始数据库测试...")
    
    # 1. 测试数据库连接
    if not test_database_connection():
        return
    
    # 2. 获取所有数据表
    tables = show_database_tables()
    
    if not tables:
        logger.warning("⚠️ 数据库中没有任何表，请先执行SQL脚本创建表结构")
        return
    
    # 3. 对每个表进行详细检查
    for table in tables:
        table_name = list(table.values())[0]  # 获取表名
        
        # 显示表结构
        show_table_structure(table_name)
        
        # 显示前1条数据
        show_sample_data(table_name, 1)
        
        logger.info("=" * 80)  # 分隔线

    logger.info("✅ 数据库测试完成！")

if __name__ == "__main__":
    main()