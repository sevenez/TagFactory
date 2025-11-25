from typing import List, Dict, Any, Optional
from datetime import datetime
from fastapi import APIRouter, Query, HTTPException
from backend.models import DataSource, TagInfo, TagStatus, TagType
from backend.data import data_sources, tags
from backend.database import db_pool, execute_query


router = APIRouter(prefix="/data", tags=["data"])


@router.get("/sources", response_model=List[DataSource])
def list_sources():
    """
    获取所有数据源的连接状态
    实时更新MySQL的连接状态
    """
    # 更新MySQL连接状态
    status = db_pool.get_status()
    for source in data_sources:
        if source.source_id == "DS_MYSQL":
            source.connected = status['connected']
            source.last_checked_at = datetime.utcnow().isoformat()
    return data_sources


@router.get("/approvals/tags", response_model=List[TagInfo])
def list_tag_approvals():
    """
    获取待审批的标签列表
    """
    return [t for t in tags if t.status == TagStatus.PENDING or (t.status == TagStatus.DISABLED and t.type == TagType.USER)]


@router.post("/connection/refresh")
def refresh_connection():
    """
    刷新数据库连接
    尝试重新连接数据库，最多重试3次
    """
    attempts = 0
    max_attempts = 3
    connected = False
    error = None
    
    # 关闭所有现有连接，重新建立连接池
    db_pool.close_all_connections()
    
    while attempts < max_attempts and not connected:
        attempts += 1
        connected = db_pool.test_connection()
        if not connected:
            # 等待一段时间后重试
            import time
            time.sleep(1)
    
    status = db_pool.get_status()
    return {
        'success': connected,
        'attempts': attempts,
        'connected': connected,
        'error': status.get('error', error),
        'status': status
    }


@router.get("/connection/status")
def get_connection_status():
    """
    获取数据库连接状态详情
    """
    status = db_pool.get_status()
    # 更新数据源状态
    for source in data_sources:
        if source.source_id == "DS_MYSQL":
            source.connected = status['connected']
            source.last_checked_at = datetime.utcnow().isoformat()
    
    return {
        'status': status,
        'data_source': next((s for s in data_sources if s.source_id == "DS_MYSQL"), None)
    }

@router.get("/statistics", response_model=Dict[str, int])
def get_statistics():
    """
    获取数据统计信息
    """
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
        raise HTTPException(status_code=500, detail=f"获取统计数据失败: {str(e)}")


# 获取客户数据接口
@router.get("/customers", response_model=Dict[str, Any])
def get_customers(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    sort_by: Optional[str] = Query("id", description="排序字段"),
    sort_order: Optional[str] = Query("asc", regex="^(asc|desc)$", description="排序方向"),
    name: Optional[str] = Query(None, description="客户名称搜索"),
    status: Optional[str] = Query(None, description="客户状态筛选")
):
    """
    获取客户数据，支持分页、排序和筛选
    """
    try:
        # 构建基础SQL查询
        base_query = "SELECT * FROM customer_info WHERE 1=1"
        count_query = "SELECT COUNT(*) FROM customer_info WHERE 1=1"
        params = []
        
        # 添加筛选条件
        if name:
            base_query += " AND customer_id LIKE %s OR phone LIKE %s"
            count_query += " AND customer_id LIKE %s OR phone LIKE %s"
            params.extend([f"%{name}%", f"%{name}%"])
        
        # 添加排序，映射排序字段
        field_map = {
            'id': 'customer_id',
            'created_at': 'register_time'
        }
        actual_sort_by = field_map.get(sort_by, sort_by)
        base_query += f" ORDER BY {actual_sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        customers = execute_query(base_query, pagination_params, fetch_all=True)
        total_count = execute_query(count_query, params, fetch_one=True)[0]
        
        return {
            "data": customers,
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取客户数据失败: {str(e)}")


# 获取商家数据接口
@router.get("/merchants", response_model=Dict[str, Any])
def get_merchants(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    sort_by: Optional[str] = Query("id", description="排序字段"),
    sort_order: Optional[str] = Query("asc", regex="^(asc|desc)$", description="排序方向"),
    name: Optional[str] = Query(None, description="商家名称搜索"),
    category: Optional[str] = Query(None, description="商家类别筛选")
):
    """
    获取商家数据，支持分页、排序和筛选
    """
    try:
        # 构建基础SQL查询
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
        
        # 添加排序，映射排序字段
        field_map = {
            'id': 'seller_id',
            'name': 'seller_name',
            'created_at': 'create_time'
        }
        actual_sort_by = field_map.get(sort_by, sort_by)
        base_query += f" ORDER BY {actual_sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        merchants = execute_query(base_query, pagination_params, fetch_all=True)
        total_count = execute_query(count_query, params, fetch_one=True)[0]
        
        return {
            "data": merchants,
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取商家数据失败: {str(e)}")


# 获取商品数据接口
@router.get("/products", response_model=Dict[str, Any])
def get_products(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    sort_by: Optional[str] = Query("id", description="排序字段"),
    sort_order: Optional[str] = Query("asc", regex="^(asc|desc)$", description="排序方向"),
    name: Optional[str] = Query(None, description="商品名称搜索"),
    merchant_id: Optional[int] = Query(None, description="商家ID筛选"),
    category: Optional[str] = Query(None, description="商品类别筛选")
):
    """
    获取商品数据，支持分页、排序和筛选
    """
    try:
        # 构建基础SQL查询
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
        
        # 添加排序，映射排序字段
        field_map = {
            'id': 'product_id',
            'name': 'product_name',
            'created_at': 'create_time'
        }
        actual_sort_by = field_map.get(sort_by, sort_by)
        base_query += f" ORDER BY {actual_sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        pagination_params = params.copy()
        pagination_params.extend([page_size, offset])
        
        # 执行查询
        products = execute_query(base_query, pagination_params, fetch_all=True)
        total_count = execute_query(count_query, params, fetch_one=True)[0]
        
        return {
            "data": products,
            "total": total_count,
            "page": page,
            "page_size": page_size,
            "total_pages": (total_count + page_size - 1) // page_size
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取商品数据失败: {str(e)}")


# 删除了重复的统计路由定义，保留了上面正确的实现


