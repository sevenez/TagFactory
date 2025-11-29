from fastapi import FastAPI, HTTPException
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

@app.get("/data/connection/status")
def get_connection_status():
    """获取连接状态"""
    try:
        status = db_pool.get_status()
        return {
            "status": {
                "connected": status['connected'],
                "active_connections": status['active_connections'],
                "pool_size": status['pool_size'],
                "error": status.get('error', '')
            }
        }
    except Exception as e:
        return {
            "status": {
                "connected": False,
                "active_connections": 0,
                "pool_size": 0,
                "error": str(e)
            }
        }

@app.post("/data/connection/refresh")
def refresh_connection():
    """刷新连接"""
    try:
        # 测试连接
        test_result = execute_query("SELECT 1", fetch_one=True)
        if test_result:
            return {"connected": True, "message": "连接成功"}
    except Exception as e:
        return {"connected": False, "error": str(e)}

@app.get("/data/approvals/tags")
def get_tag_approvals(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    name: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """获取标签审批列表"""
    try:
        # 模拟审批数据，实际应该从数据库查询
        mock_approvals = [
            {
                "tag_id": "T001",
                "name": "优质商家",
                "category": "商家标签",
                "type": "自动生成",
                "description": "基于评分和好评率自动生成的优质商家标签",
                "creator": "系统",
                "status": "pending",
                "create_time": "2025-11-24T10:00:00Z",
                "processed_time": None,
                "processor": None,
                "remark": None,
                "usage_count": 0
            },
            {
                "tag_id": "T002", 
                "name": "高价值客户",
                "category": "客户标签",
                "type": "手动创建",
                "description": "消费金额高且活跃的优质客户标签",
                "creator": "管理员",
                "status": "approved",
                "create_time": "2025-11-23T15:30:00Z",
                "processed_time": "2025-11-23T16:00:00Z",
                "processor": "审批员A",
                "remark": "符合标签规则，批准通过",
                "usage_count": 156
            },
            {
                "tag_id": "T003",
                "name": "热销商品",
                "category": "商品标签", 
                "type": "自动生成",
                "description": "月销量超过1000的商品标签",
                "creator": "系统",
                "status": "rejected",
                "create_time": "2025-11-22T09:15:00Z",
                "processed_time": "2025-11-22T10:00:00Z",
                "processor": "审批员B",
                "remark": "阈值设置过低，建议调整为月销量2000以上",
                "usage_count": 0
            }
        ]
        
        # 应用筛选条件
        filtered_approvals = mock_approvals
        
        if name:
            filtered_approvals = [a for a in filtered_approvals if name.lower() in a["name"].lower()]
        
        if status:
            filtered_approvals = [a for a in filtered_approvals if a["status"] == status]
            
        if category:
            filtered_approvals = [a for a in filtered_approvals if a["category"] == category]
        
        # 计算总数和分页
        total = len(filtered_approvals)
        start_index = (page - 1) * page_size
        end_index = start_index + page_size
        paged_approvals = filtered_approvals[start_index:end_index]
        
        return {
            "data": paged_approvals,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    except Exception as e:
        return {"error": f"获取审批列表失败: {str(e)}"}

@app.post("/data/approvals/tags/{tag_id}/approve")
def approve_tag(tag_id: str):
    """通过标签审批"""
    try:
        # 实际应该更新数据库中的审批状态
        return {"success": True, "message": f"标签 {tag_id} 审批通过"}
    except Exception as e:
        return {"success": False, "error": f"审批通过失败: {str(e)}"}

@app.post("/data/approvals/tags/{tag_id}/reject") 
def reject_tag(tag_id: str, remark: str = ""):
    """拒绝标签审批"""
    try:
        # 实际应该更新数据库中的审批状态
        return {"success": True, "message": f"标签 {tag_id} 审批拒绝", "remark": remark}
    except Exception as e:
        return {"success": False, "error": f"审批拒绝失败: {str(e)}"}

@app.get("/data/customers")
def get_customers(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: str = Query("customer_id"),
    sort_order: str = Query("asc", regex="^(asc|desc)$"),
    name: Optional[str] = Query(None),
    status: Optional[str] = Query(None)
):
    """获取客户数据"""
    try:
        # 构建基础查询
        base_query = "SELECT * FROM customer_info WHERE is_deleted = 0"
        count_query = "SELECT COUNT(*) FROM customer_info WHERE is_deleted = 0"
        
        # 添加筛选条件
        if name:
            base_query += f" AND phone LIKE '%{name}%'"
            count_query += f" AND phone LIKE '%{name}%'"
            
        if status:
            if status == 'active':
                base_query += f" AND last_active_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
                count_query += f" AND last_active_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
        
        # 获取总数
        count_result = execute_query(count_query, fetch_one=True)
        total = list(count_result.values())[0] if count_result else 0
        
        # 添加排序 - 验证排序字段名，防止SQL注入
        valid_fields = ['customer_id', 'phone', 'gender', 'age', 'education', 'province', 'register_time', 'last_active_time', 'total_consume', 'consume_months']
        if sort_by not in valid_fields:
            sort_by = 'customer_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += f" LIMIT {page_size} OFFSET {offset}"
        
        # 执行查询
        customers = execute_query(base_query)
        
        return {
            "data": customers,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    except Exception as e:
        return {"error": f"获取客户数据失败: {str(e)}"}

@app.get("/data/merchants")
def get_merchants(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: str = Query("seller_id"),
    sort_order: str = Query("asc", regex="^(asc|desc)$"),
    name: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """获取商家数据"""
    try:
        # 构建基础查询
        base_query = "SELECT * FROM seller_info WHERE status = 1"
        count_query = "SELECT COUNT(*) FROM seller_info WHERE status = 1"
        
        # 添加筛选条件
        if name:
            base_query += f" AND seller_name LIKE '%{name}%'"
            count_query += f" AND seller_name LIKE '%{name}%'"
            
        if category:
            base_query += f" AND seller_type LIKE '%{category}%'"
            count_query += f" AND seller_type LIKE '%{category}%'"
        
        # 获取总数
        count_result = execute_query(count_query, fetch_one=True)
        total = list(count_result.values())[0] if count_result else 0
        
        # 添加排序 - 验证排序字段名，防止SQL注入
        valid_fields = ['seller_id', 'seller_name', 'seller_type', 'credit_code', 'contact_phone', 'contact_email', 'business_address', 'city', 'establish_time', 'registered_capital', 'seller_rating', 'praise_rate', 'create_time', 'update_time']
        if sort_by not in valid_fields:
            sort_by = 'seller_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += f" LIMIT {page_size} OFFSET {offset}"
        
        # 执行查询
        merchants = execute_query(base_query)
        
        return {
            "data": merchants,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    except Exception as e:
        return {"error": f"获取商家数据失败: {str(e)}"}

@app.get("/tags")
def get_tags(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    type: Optional[str] = Query(None),
    name: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    created_at: Optional[str] = Query(None),
    sort_by: str = Query("created_at"),
    sort_order: str = Query("desc", regex="^(asc|desc)$")
):
    """获取标签数据"""
    try:
        # 构建基础查询
        base_query = "SELECT tag_id, tag_code, tag_name, tag_layer, entity_type as type, status, create_time as created_at, update_time as updated_at FROM tag_definition"
        count_query = "SELECT COUNT(*) as total FROM tag_definition"
        
        # 构建筛选条件
        filters = []
        params = []
        
        if type:
            # 转换前端类型到数据库实体类型
            type_map = {
                "USER": "CUSTOMER",
                "MERCHANT": "SELLER",
                "PRODUCT": "PRODUCT"
            }
            db_type = type_map.get(type, type)
            filters.append("entity_type = %s")
            params.append(db_type)
        
        if name:
            filters.append("tag_name LIKE %s")
            params.append(f"%{name}%")
        
        if status:
            # 转换前端状态到数据库状态
            status_map = {
                "ENABLED": 1,
                "DISABLED": 0,
                "PENDING": 2  # 假设待审核状态对应数据库中的2
            }
            db_status = status_map.get(status, 1)
            filters.append("status = %s")
            params.append(db_status)
        
        if created_at:
            filters.append("DATE(create_time) = %s")
            params.append(created_at)
        
        # 添加筛选条件到查询
        if filters:
            where_clause = " WHERE " + " AND ".join(filters)
            base_query += where_clause
            count_query += where_clause
        
        # 执行计数查询
        count_result = execute_query(count_query, tuple(params), fetch_one=True)
        total = count_result["total"] if count_result else 0
        
        # 排序
        valid_sort_fields = ["tag_id", "tag_name", "entity_type", "status", "create_time"]
        if sort_by not in valid_sort_fields:
            sort_by = "create_time"
        
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 分页
        offset = (page - 1) * page_size
        base_query += f" LIMIT %s OFFSET %s"
        params.extend([page_size, offset])
        
        # 执行查询
        tags = execute_query(base_query, tuple(params))
        
        # 转换结果格式
        formatted_tags = []
        for tag in tags:
            # 转换数据库状态到前端状态
            status_map = {
                1: "ENABLED",
                0: "DISABLED",
                2: "PENDING"
            }
            
            # 转换数据库实体类型到前端类型
            type_map = {
                "CUSTOMER": "USER",
                "SELLER": "MERCHANT",
                "PRODUCT": "PRODUCT"
            }
            
            formatted_tags.append({
                "tag_id": tag["tag_id"],
                "name": tag["tag_name"],
                "layer": tag.get("tag_layer", tag.get("layer", "未知")),
                "type": type_map.get(tag["type"], tag["type"]),
                "status": status_map.get(tag["status"], "ENABLED"),
                "cover_users": 0,  # 从其他表统计或默认值
                "created_at": tag["created_at"],
                "updated_at": tag["updated_at"]
            })
        
        return {
            "data": formatted_tags,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    except Exception as e:
        return {"error": f"获取标签数据失败: {str(e)}"}

@app.get("/data/products")
def get_products(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    sort_by: str = Query("product_id"),
    sort_order: str = Query("asc", regex="^(asc|desc)$"),
    name: Optional[str] = Query(None),
    merchant_id: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """获取商品数据"""
    try:
        # 构建基础查询
        base_query = "SELECT * FROM product_info WHERE status = 1"
        count_query = "SELECT COUNT(*) FROM product_info WHERE status = 1"
        
        # 添加筛选条件
        if name:
            base_query += f" AND product_name LIKE '%{name}%'"
            count_query += f" AND product_name LIKE '%{name}%'"
            
        if merchant_id:
            base_query += f" AND seller_id = '{merchant_id}'"
            count_query += f" AND seller_id = '{merchant_id}'"
            
        if category:
            base_query += f" AND category LIKE '%{category}%'"
            count_query += f" AND category LIKE '%{category}%'"
        
        # 获取总数
        count_result = execute_query(count_query, fetch_one=True)
        total = list(count_result.values())[0] if count_result else 0
        
        # 添加排序 - 验证排序字段名，防止SQL注入
        valid_fields = ['product_id', 'product_name', 'brand_name', 'category', 'spec_params', 'price', 'original_price', 'discount_rate', 'monthly_sales', 'buy_customer_count', 'stock_quantity', 'stock_status', 'production_date', 'shelf_life', 'product_weight', 'product_volume', 'is_free_shipping', 'after_sales_policy', 'product_tags', 'status', 'seller_id', 'create_time', 'update_time']
        if sort_by not in valid_fields:
            sort_by = 'product_id'
        base_query += f" ORDER BY {sort_by} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        base_query += f" LIMIT {page_size} OFFSET {offset}"
        
        # 执行查询
        products = execute_query(base_query)
        
        return {
            "data": products,
            "total": total,
            "page": page,
            "page_size": page_size
        }
    except Exception as e:
        return {"error": f"获取商品数据失败: {str(e)}"}

# 定义用户数据
user_data = {
    "10001": {
        "user_id": "10001",
        "phone": "138***0012",
        "registered_at": "2025-10-01T09:00:00",
        "last_active_at": "2025-11-20T20:00:00",
        "basic_tags": {"性别": "男", "年龄段": "25-34"},
        "behavior_tags": {"最近7天访问次数": 5, "最近30天下单次数": 2},
        "stats_tags": {"累计消费金额": 1200.5, "订单数": 8},
        "derived_tags": {"忠诚度": "中"}
    },
    "10002": {
        "user_id": "10002",
        "phone": "139***7788",
        "registered_at": "2025-09-15T11:00:00",
        "last_active_at": "2025-11-18T21:00:00",
        "basic_tags": {"性别": "女", "年龄段": "18-24"},
        "behavior_tags": {"最近7天访问次数": 10, "最近30天下单次数": 5},
        "stats_tags": {"累计消费金额": 3500.0, "订单数": 20},
        "derived_tags": {"忠诚度": "高"}
    }
}

@app.get("/users/lookup")
def lookup_user(
    user_id: Optional[str] = Query(default=None),
    phone: Optional[str] = Query(default=None)
):
    """根据用户ID或手机号查询用户画像"""
    try:
        if user_id:
            if user_id in user_data:
                return user_data[user_id]
            raise HTTPException(status_code=404, detail="用户不存在")
        if phone:
            for u in user_data.values():
                if phone in u.phone:
                    return u
            raise HTTPException(status_code=404, detail="用户不存在")
        raise HTTPException(status_code=400, detail="参数错误")
    except HTTPException:
        raise
    except Exception as e:
        return {"error": f"查询用户画像失败: {str(e)}"}

if __name__ == "__main__":
    import uvicorn
    print("🚀 启动修复版API服务器...")
    print("📡 服务地址: http://localhost:8002")
    print("📋 API文档: http://localhost:8002/docs")
    
    uvicorn.run(app, host="0.0.0.0", port=8002)