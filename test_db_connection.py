#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试数据库连接和各个模块的功能
"""

import sys
import os
# 添加backend目录到Python路径
sys.path.append(os.path.join(os.path.dirname(__file__), 'backend'))

from backend.database import engine, execute_query, execute_update, db_pool
from backend.routers.tags import list_tags
from backend.routers.users import lookup_user
from backend.routers.data_management import get_statistics

print("=== 测试数据库连接 ===")

# 测试1: 测试数据库连接池状态
print("\n1. 测试数据库连接池状态:")
status = db_pool.get_status()
print(f"连接状态: {'已连接' if status['connected'] else '未连接'}")
print(f"活跃连接数: {status['active_connections']}")
print(f"连接池大小: {status['pool_size']}")
if status['error']:
    print(f"错误信息: {status['error']}")

# 测试2: 测试简单查询
print("\n2. 测试简单查询:")
try:
    result = execute_query("SELECT 1 as test", fetch_one=True)
    print(f"查询结果: {result}")
    print("✓ 简单查询成功")
except Exception as e:
    print(f"✗ 简单查询失败: {e}")

# 测试3: 测试标签查询
print("\n3. 测试标签查询:")
try:
    # 模拟FastAPI的Query参数
    class MockQuery:
        def __init__(self, **kwargs):
            self.__dict__.update(kwargs)
    
    # 调用标签列表查询
    tags_result = list_tags(
        page=1,
        page_size=10,
        type=None,
        name=None,
        status=None,
        created_at=None,
        sort_by="created_at",
        sort_order="desc"
    )
    print(f"标签数量: {tags_result['total']}")
    print(f"返回标签: {len(tags_result['data'])}")
    print("✓ 标签查询成功")
except Exception as e:
    print(f"✗ 标签查询失败: {e}")
    import traceback
    traceback.print_exc()

# 测试4: 测试数据统计
print("\n4. 测试数据统计:")
try:
    stats = get_statistics()
    print(f"客户总数: {stats['customers']}")
    print(f"商家总数: {stats['merchants']}")
    print(f"商品总数: {stats['products']}")
    print("✓ 数据统计成功")
except Exception as e:
    print(f"✗ 数据统计失败: {e}")
    import traceback
    traceback.print_exc()

# 测试5: 测试客户画像查询（使用测试数据）
print("\n5. 测试客户画像查询:")
try:
    # 先插入一条测试数据
    insert_query = """
    INSERT INTO customer_info (customer_id, phone, register_time, gender, age, education, province, total_consume, consume_months, is_deleted)
    VALUES ('U1234567890123456', '13800138000', NOW(), '男', 30, '本科', '广东省', 1000.00, 5, 0)
    ON DUPLICATE KEY UPDATE phone='13800138000'
    """
    execute_update(insert_query)
    
    # 查询客户画像
    user_profile = lookup_user(user_id='U1234567890123456', phone=None)
    print(f"客户ID: {user_profile.user_id}")
    print(f"手机号: {user_profile.phone}")
    print(f"基础标签: {user_profile.basic_tags}")
    print("✓ 客户画像查询成功")
except Exception as e:
    print(f"✗ 客户画像查询失败: {e}")
    import traceback
    traceback.print_exc()

print("\n=== 测试完成 ===")
