import pymysql

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'tagfactory',
    'charset': 'utf8mb4'
}

def check_tag_layer_data():
    """检查tag_definition表中的tag_layer字段数据"""
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # 查询tag_definition表中的tag_layer字段数据
        cursor.execute("SELECT tag_id, tag_name, tag_layer FROM tag_definition LIMIT 10")
        data = cursor.fetchall()
        
        print("🔍 检查tag_definition表中的tag_layer字段数据:")
        for row in data:
            tag_id, tag_name, tag_layer = row
            print(f"   ID: {tag_id}, 名称: {tag_name}, 层级: {tag_layer}")
        
        # 查询tag_layer字段的不同值
        cursor.execute("SELECT DISTINCT tag_layer FROM tag_definition")
        distinct_layers = cursor.fetchall()
        print(f"\n📋 不同的tag_layer值: {[layer[0] for layer in distinct_layers]}")
        
        # 查询tag_layer为NULL的记录数
        cursor.execute("SELECT COUNT(*) FROM tag_definition WHERE tag_layer IS NULL")
        null_count = cursor.fetchone()[0]
        print(f"📊 tag_layer为NULL的记录数: {null_count}")
        
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ 检查tag_layer数据失败: {e}")

if __name__ == "__main__":
    check_tag_layer_data()
