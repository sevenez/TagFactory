import pymysql
from typing import Dict, Any

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4'
}

def check_mysql_connection() -> bool:
    """检查MySQL连接是否正常"""
    try:
        conn = pymysql.connect(
            host=DB_CONFIG['host'],
            port=DB_CONFIG['port'],
            user=DB_CONFIG['user'],
            password=DB_CONFIG['password'],
            charset=DB_CONFIG['charset']
        )
        conn.close()
        print("✅ MySQL连接正常")
        return True
    except Exception as e:
        print(f"❌ MySQL连接失败: {e}")
        return False

def check_database_exists() -> bool:
    """检查tagfactory数据库是否存在"""
    try:
        conn = pymysql.connect(
            host=DB_CONFIG['host'],
            port=DB_CONFIG['port'],
            user=DB_CONFIG['user'],
            password=DB_CONFIG['password'],
            charset=DB_CONFIG['charset']
        )
        cursor = conn.cursor()
        cursor.execute("SHOW DATABASES LIKE 'tagfactory'")
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if result:
            print("✅ tagfactory数据库存在")
            return True
        else:
            print("❌ tagfactory数据库不存在")
            return False
    except Exception as e:
        print(f"❌ 检查数据库失败: {e}")
        return False

def check_table_exists() -> bool:
    """检查tag_definition表是否存在"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES LIKE 'tag_definition'")
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if result:
            print("✅ tag_definition表存在")
            return True
        else:
            print("❌ tag_definition表不存在")
            return False
    except Exception as e:
        print(f"❌ 检查表失败: {e}")
        return False

def check_table_structure() -> bool:
    """检查tag_definition表结构是否完整"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("DESCRIBE tag_definition")
        columns = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # 检查必要字段是否存在
        required_columns = ['tag_id', 'tag_code', 'tag_name', 'tag_layer', 'entity_type', 'status', 'create_time']
        existing_columns = [col['Field'] for col in columns]
        
        missing_columns = [col for col in required_columns if col not in existing_columns]
        if missing_columns:
            print(f"❌ tag_definition表缺少必要字段: {missing_columns}")
            return False
        else:
            print("✅ tag_definition表结构完整")
            return True
    except Exception as e:
        print(f"❌ 检查表结构失败: {e}")
        return False

def check_table_data() -> bool:
    """检查tag_definition表中是否有数据"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) as count FROM tag_definition")
        result = cursor.fetchone()
        cursor.close()
        conn.close()
        
        count = result['count']
        if count > 0:
            print(f"✅ tag_definition表中有 {count} 条数据")
            return True
        else:
            print("❌ tag_definition表中没有数据")
            return False
    except Exception as e:
        print(f"❌ 检查表数据失败: {e}")
        return False

def get_sample_data() -> None:
    """获取tag_definition表的示例数据"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tag_definition LIMIT 5")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        
        print("\n📋 tag_definition表示例数据:")
        for row in data:
            print(f"ID: {row['tag_id']}, 名称: {row['tag_name']}, 类型: {row['entity_type']}, 状态: {row['status']}")
    except Exception as e:
        print(f"❌ 获取示例数据失败: {e}")

def main():
    """主函数"""
    print("🔍 开始检查数据库状态...\n")
    
    # 检查MySQL连接
    if not check_mysql_connection():
        return
    
    # 检查数据库是否存在
    if not check_database_exists():
        return
    
    # 检查表是否存在
    if not check_table_exists():
        return
    
    # 检查表结构
    if not check_table_structure():
        return
    
    # 检查表数据
    if check_table_data():
        # 获取示例数据
        get_sample_data()
    
    print("\n✅ 数据库检查完成")

if __name__ == "__main__":
    main()
