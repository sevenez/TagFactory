from typing import List, Dict, Any, Optional
from datetime import datetime
from fastapi import APIRouter, Query, HTTPException
import logging
from backend.schemas import DataSource, TagInfo, TagStatus, TagType
from backend.data import data_sources, tags
from backend.database import db_pool, execute_query

# 配置日志
logger = logging.getLogger(__name__)


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


@router.get("/approvals/tags", response_model=Dict[str, Any])
def list_tag_approvals(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    name: Optional[str] = Query(None, description="标签名称"),
    status: Optional[str] = Query(None, description="审批状态"),
    category: Optional[str] = Query(None, description="标签类型")
):
    """
    获取标签审批列表，支持分页、筛选
    """
    try:
        # 构建查询基础语句，添加索引提示
        base_query = """
            SELECT /*+ INDEX(ta idx_tag_application_tag_id_status) INDEX(td idx_tag_definition_tag_id) INDEX(su idx_system_user_user_id) */
                ta.application_id,
                td.tag_id,
                td.tag_name as name,
                td.entity_type as type,
                ta.application_status as status,
                ta.application_reason as description,
                su.real_name as creator,
                td.create_time,
                td.update_time as updated_at,
                su.user_id as creator_id
            FROM tag_application ta
            JOIN tag_definition td ON ta.tag_id = td.tag_id
            JOIN system_user su ON ta.applicant_id = su.user_id
            WHERE 1=1
        """
        
        # 构建计数查询，添加索引提示
        count_query = """
            SELECT /*+ INDEX(ta idx_tag_application_tag_id_status) INDEX(td idx_tag_definition_tag_id) INDEX(su idx_system_user_user_id) */
                COUNT(*) as total
            FROM tag_application ta
            JOIN tag_definition td ON ta.tag_id = td.tag_id
            JOIN system_user su ON ta.applicant_id = su.user_id
            WHERE 1=1
        """
        
        # 构建查询参数
        params = []
        
        # 添加筛选条件
        if name:
            base_query += " AND td.tag_name LIKE %s"
            count_query += " AND td.tag_name LIKE %s"
            params.append(f"%{name}%")
        
        if status:
            base_query += " AND ta.application_status = %s"
            count_query += " AND ta.application_status = %s"
            params.append(status)
        else:
            # 默认显示待审批的标签
            base_query += " AND ta.application_status = 'PENDING'"
            count_query += " AND ta.application_status = 'PENDING'"
        
        if category:
            base_query += " AND td.entity_type = %s"
            count_query += " AND td.entity_type = %s"
            params.append(category)
        
        # 执行计数查询
        count_result = execute_query(count_query, tuple(params), fetch_one=True)
        total = count_result['total'] if count_result else 0
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += " LIMIT %s OFFSET %s"
        params.extend([page_size, offset])
        
        # 执行主查询
        approvals = execute_query(base_query, tuple(params), fetch_all=True) or []
        
        # 数据验证和清洗
        valid_statuses = {'PENDING', 'APPROVED', 'REJECTED'}
        cleaned_approvals = []
        
        for approval in approvals:
            # 验证必要字段是否存在
            if all(key in approval for key in ['tag_id', 'name', 'status', 'create_time']):
                # 验证状态值是否合法
                if approval['status'] not in valid_statuses:
                    approval['status'] = 'PENDING'  # 默认设为待审批
                
                # 确保时间字段格式正确
                if approval.get('create_time'):
                    try:
                        # 确保时间字段是字符串格式
                        approval['create_time'] = str(approval['create_time'])
                    except:
                        approval['create_time'] = ''
                
                if approval.get('updated_at'):
                    try:
                        # 确保时间字段是字符串格式
                        approval['updated_at'] = str(approval['updated_at'])
                    except:
                        approval['updated_at'] = ''
                
                cleaned_approvals.append(approval)
        
        # 计算总页数
        total_pages = (total + page_size - 1) // page_size
        
        return {
            "data": cleaned_approvals,
            "total": total,
            "page": page,
            "page_size": page_size,
            "total_pages": total_pages
        }
        
    except Exception as e:
        logger.error(f"获取标签审批列表失败: {e}")
        # 返回空数据，避免前端崩溃
        return {
            "data": [],
            "total": 0,
            "page": page,
            "page_size": page_size,
            "total_pages": 0
        }


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


@router.post("/approvals/tags/{tag_id}/approve", response_model=Dict[str, Any])
def approve_tag(tag_id: str):
    """
    审批通过标签
    """
    try:
        from backend.database import execute_update
        
        # 1. 获取标签申请信息
        app_query = "SELECT application_id, tag_id FROM tag_application WHERE tag_id = %s AND application_status = 'PENDING'"
        app_result = execute_query(app_query, (tag_id,), fetch_one=True)
        if not app_result:
            raise HTTPException(status_code=404, detail="未找到待审批的标签申请")
        
        application_id = app_result['application_id']
        
        # 2. 更新标签申请状态为已通过
        update_app_query = "UPDATE tag_application SET application_status = 'APPROVED', update_time = CURRENT_TIMESTAMP WHERE application_id = %s"
        execute_update(update_app_query, (application_id,))
        
        # 3. 更新标签状态为已通过
        update_tag_query = "UPDATE tag_definition SET status = 'APPROVED', update_time = CURRENT_TIMESTAMP WHERE tag_id = %s"
        execute_update(update_tag_query, (tag_id,))
        
        # 4. 记录审批记录（这里使用默认审批人，实际应从登录信息获取）
        insert_record_query = """
            INSERT INTO approval_record (application_id, approver_id, approval_status, approval_opinion, approval_order)
            VALUES (%s, 'USER005', 'APPROVED', '标签审批通过', 1)
        """
        execute_update(insert_record_query, (application_id,))
        
        return {
            "success": True,
            "message": "标签审批通过成功"
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"标签审批通过失败: {e}")
        raise HTTPException(status_code=500, detail=f"标签审批通过失败: {str(e)}")


@router.post("/approvals/tags/{tag_id}/reject", response_model=Dict[str, Any])
def reject_tag(tag_id: str, remark: Optional[str] = Query(None, description="拒绝原因")):
    """
    拒绝标签审批
    """
    try:
        from backend.database import execute_update
        
        # 1. 获取标签申请信息
        app_query = "SELECT application_id, tag_id FROM tag_application WHERE tag_id = %s AND application_status = 'PENDING'"
        app_result = execute_query(app_query, (tag_id,), fetch_one=True)
        if not app_result:
            raise HTTPException(status_code=404, detail="未找到待审批的标签申请")
        
        application_id = app_result['application_id']
        
        # 2. 更新标签申请状态为已拒绝
        update_app_query = "UPDATE tag_application SET application_status = 'REJECTED', update_time = CURRENT_TIMESTAMP WHERE application_id = %s"
        execute_update(update_app_query, (application_id,))
        
        # 3. 更新标签状态为已拒绝
        update_tag_query = "UPDATE tag_definition SET status = 'REJECTED', update_time = CURRENT_TIMESTAMP WHERE tag_id = %s"
        execute_update(update_tag_query, (tag_id,))
        
        # 4. 记录审批记录（这里使用默认审批人，实际应从登录信息获取）
        insert_record_query = """
            INSERT INTO approval_record (application_id, approver_id, approval_status, approval_opinion, approval_order)
            VALUES (%s, 'USER005', 'REJECTED', %s, 1)
        """
        execute_update(insert_record_query, (application_id, remark or '标签审批拒绝'))
        
        return {
            "success": True,
            "message": "标签审批拒绝成功"
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"标签审批拒绝失败: {e}")
        raise HTTPException(status_code=500, detail=f"标签审批拒绝失败: {str(e)}")


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
        customer_result = execute_query("SELECT COUNT(*) as total FROM customer_info WHERE is_deleted = 0", fetch_one=True)
        customer_count = customer_result['total'] if customer_result else 0
        
        # 获取商家总数
        merchant_result = execute_query("SELECT COUNT(*) as total FROM seller_info WHERE status = 1", fetch_one=True)
        merchant_count = merchant_result['total'] if merchant_result else 0
        
        # 获取商品总数
        product_result = execute_query("SELECT COUNT(*) as total FROM product_info WHERE status = 1", fetch_one=True)
        product_count = product_result['total'] if product_result else 0
        
        return {
            "customers": customer_count,
            "merchants": merchant_count,
            "products": product_count
        }
    except Exception as e:
        logger.error(f"获取统计数据失败: {e}")
        # 返回默认值，避免前端崩溃
        return {
            "customers": 0,
            "merchants": 0,
            "products": 0
        }


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
            base_query += " AND (customer_id LIKE %s OR phone LIKE %s)"
            count_query += " AND (customer_id LIKE %s OR phone LIKE %s)"
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
        customers = execute_query(base_query, pagination_params, fetch_all=True) or []
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
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
            base_query += " AND (seller_name LIKE %s OR credit_code LIKE %s)"
            count_query += " AND (seller_name LIKE %s OR credit_code LIKE %s)"
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
        merchants = execute_query(base_query, pagination_params, fetch_all=True) or []
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
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
    merchant_id: Optional[str] = Query(None, description="商家ID筛选"),
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
            base_query += " AND (product_name LIKE %s OR brand_name LIKE %s)"
            count_query += " AND (product_name LIKE %s OR brand_name LIKE %s)"
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
        products = execute_query(base_query, pagination_params, fetch_all=True) or []
        count_result = execute_query(count_query, params, fetch_one=True)
        total_count = list(count_result.values())[0] if count_result else 0
        
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


