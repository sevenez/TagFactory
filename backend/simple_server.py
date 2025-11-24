from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import sys
import os

# 添加项目路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from database import execute_query, db_pool
from typing import Dict, Any, Optional
from fastapi import Query
import json

app = FastAPI(title="标签工厂管理系统API")

# 添加CORS中间件
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"name": "标签工厂管理系统API", "version": "1.0.0"}

@app.get("/data/sources")
def get_sources():
    """获取数据源列表"""
    status = db_pool.get_status()
    return [
        {
            "source_id": "DS_MYSQL",
            "name": "MySQL数据库",
            "type": "MySQL",
            "connected": status['connected'],
            "last_checked_at": "2025-11-24T19:39:00Z"
        }
    ]

@app.get("/data/statistics")
def get_statistics():
    """获取数据统计"""
    try:
        # 获取客户总数
        customer_result = execute_query("SELECT COUNT(*) FROM customer_info WHERE is_deleted = 0", fetch_one=True)
        customer_count = list(customer_result.values())[0] if customer_result else 0
        
        # 获取商家总数
        merchant_result = execute_query("SELECT COUNT(*) FROM seller_info WHERE status = 1", fetch_one=True)
        merchant_count = list(merchant_result.values())[0] if merchant_result else 0
        
        # 获取商品总数
        product_result = execute_query("SELECT COUNT(*) FROM product_info WHERE status = 1", fetch_one=True)
        product_count = list(product_result.values())[0] if product_result else 0
        
        return {
            "customers": customer_count,
            "merchants": merchant_count,
            "products": product_count
        }
    except Exception as e:
        return {"error": f"获取统计数据失败: {str(e)}"}

@app.get("/data/customers")
def get_customers(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: Optional[str] = Query("customer_id"),
    sort_order: Optional[str] = Query("asc"),
    name: Optional[str] = Query(None),
    status: Optional[str] = Query(None)
):
    """获取客户数据"""
    try:
        # 构建查询
        base_query = "SELECT * FROM customer_info WHERE 1=1"
        count_query = "SELECT COUNT(*) FROM customer_info WHERE 1=1"
        params = []
        
        # 添加筛选条件
        if name:
            base_query += " AND customer_id LIKE %s OR phone LIKE %s"
            count_query += " AND customer_id LIKE %s OR phone LIKE %s"
            params.extend([f"%{name}%", f"%{name}%"])
        
        添加排序
        # 验证排序字段名，防止SQL注入
        valid_fields = ['customer_id', 'phone', 'gender', 'age', 'education', 'province', 'register_time', 'last_active_time', 'total_consume', 'consume_months']
        if sort_by not in valid_fields:
            sort_by = 'customer_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        customers = execute_query(base_query, pagination_params, fetch_all=True)
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
        return {
            "data": customers or [],
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        return {"error": f"获取客户数据失败: {str(e)}"}

@app.get("/data/merchants")
def get_merchants(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: Optional[str] = Query("seller_id"),
    sort_order: Optional[str] = Query("asc"),
    name: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """获取商家数据"""
    try:
        # 构建查询
        base_query = "SELECT * FROM seller_info WHERE 1=1"
        count_query = "SELECT COUNT(*) FROM seller_info WHERE 1=1"
        params = []
        
        # 添加筛选条件
        if name:
            base_query += " AND seller_name LIKE %s OR credit_code LIKE %s"
            count_query += " AND seller_name LIKE %s OR credit_code LIKE %s"
            params.extend([f"%{name}%", f"%{name}%"])
        
        if category:
            base_query += " AND seller_type = %s"
            count_query += " AND seller_type = %s"
            params.append(category)
        
        添加排序
        # 验证排序字段名，防止SQL注入
        valid_fields = ['customer_id', 'phone', 'gender', 'age', 'education', 'province', 'register_time', 'last_active_time', 'total_consume', 'consume_months']
        if sort_by not in valid_fields:
            sort_by = 'customer_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        merchants = execute_query(base_query, pagination_params, fetch_all=True)
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
        return {
            "data": merchants or [],
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        return {"error": f"获取商家数据失败: {str(e)}"}

@app.get("/data/products")
def get_products(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: Optional[str] = Query("product_id"),
    sort_order: Optional[str] = Query("asc"),
    name: Optional[str] = Query(None),
    merchant_id: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """获取商品数据"""
    try:
        # 构建查询
        base_query = "SELECT * FROM product_info WHERE 1=1"
        count_query = "SELECT COUNT(*) FROM product_info WHERE 1=1"
        params = []
        
        # 添加筛选条件
        if name:
            base_query += " AND product_name LIKE %s OR brand_name LIKE %s"
            count_query += " AND product_name LIKE %s OR brand_name LIKE %s"
            params.extend([f"%{name}%", f"%{name}%"])
        
        if merchant_id:
            base_query += " AND seller_id = %s"
            count_query += " AND seller_id = %s"
            params.append(merchant_id)
        
        if category:
            base_query += " AND category = %s"
            count_query += " AND category = %s"
            params.append(category)
        
        添加排序
        # 验证排序字段名，防止SQL注入
        valid_fields = ['customer_id', 'phone', 'gender', 'age', 'education', 'province', 'register_time', 'last_active_time', 'total_consume', 'consume_months']
        if sort_by not in valid_fields:
            sort_by = 'customer_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        products = execute_query(base_query, pagination_params, fetch_all=True)
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
        return {
            "data": products or [],
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        return {"error": f"获取商品数据失败: {str(e)}"}

@app.get("/data/connection/status")
def get_connection_status():
    """获取连接状态"""
    status = db_pool.get_status()
    return {
        "status": status,
        "data_source": {
            "source_id": "DS_MYSQL",
            "name": "MySQL数据库",
            "connected": status['connected'],
            "last_checked_at": "2025-11-24T19:39:00Z"
        }
    }

@app.post("/data/connection/refresh")
def refresh_connection():
    """刷新连接"""
    db_pool.close_all_connections()
    connected = db_pool.test_connection()
    status = db_pool.get_status()
    
    return {
        "success": connected,
        "connected": connected,
        "attempts": 1,
        "status": status
    }

@app.get("/data/approvals/tags")
def get_tag_approvals():
    """获取标签审批列表"""
    return []  # 暂时返回空列表

if __name__ == "__main__":
    import uvicorn
    print("🚀 启动简化API服务器...")
    print("📡 服务地址: http://localhost:8001")
    print("📋 API文档: http://localhost:8001/docs")
    
    uvicorn.run(app, host="0.0.0.0", port=8001)