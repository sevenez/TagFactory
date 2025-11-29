from typing import Optional
from fastapi import APIRouter, HTTPException, Query
from backend.schemas import UserProfile
from backend.database import execute_query


router = APIRouter(prefix="/users", tags=["users"])


@router.get("/lookup", response_model=UserProfile)
def lookup_user(user_id: Optional[str] = Query(default=None), phone: Optional[str] = Query(default=None)):
    """
    根据客户ID或手机号查询客户画像
    """
    # 构建查询条件
    query = """
    SELECT c.customer_id, c.phone, c.register_time, c.last_active_time, c.gender, c.age, c.education, c.province, c.total_consume, c.consume_months
    FROM customer_info c
    WHERE c.is_deleted = 0
    """
    params = []
    
    if user_id:
        query += " AND c.customer_id = %s"
        params.append(user_id)
    elif phone:
        query += " AND c.phone LIKE %s"
        params.append(f"%{phone}%")
    else:
        raise HTTPException(status_code=400, detail="参数错误")
    
    # 查询用户基本信息
    user_result = execute_query(query, tuple(params), fetch_one=True)
    
    # 检查是否找到用户
    if not user_result:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    # 查询用户标签
    tags_query = """
    SELECT td.tag_code, td.tag_name, td.tag_layer, trc.tag_value
    FROM tag_relation_customer trc
    JOIN tag_definition td ON trc.tag_code = td.tag_code
    WHERE trc.customer_id = %s AND td.status = 1
    """
    tags_result = execute_query(tags_query, (user_result["customer_id"],), fetch_all=True) or []
    
    # 分类标签
    basic_tags = {}
    behavior_tags = {}
    stats_tags = {}
    derived_tags = {}
    
    for tag in tags_result:
        tag_name = tag["tag_name"]
        tag_value = tag["tag_value"]
        tag_layer = tag["tag_layer"]
        
        if tag_layer == "基础":
            basic_tags[tag_name] = tag_value
        elif tag_layer == "行为":
            behavior_tags[tag_name] = tag_value
        elif tag_layer == "统计":
            stats_tags[tag_name] = tag_value
        elif tag_layer == "衍生":
            derived_tags[tag_name] = tag_value
    
    # 如果没有标签，添加默认标签
    if not basic_tags:
        # 从customer_info表中提取基础标签
        basic_tags = {
            "性别": user_result["gender"],
            "年龄段": f"{user_result['age']}-{user_result['age']+9}" if user_result['age'] > 0 else "未知",
            "学历": user_result["education"],
            "所在省份": user_result["province"] or "未知"
        }
    
    if not stats_tags:
        # 从customer_info表中提取统计标签
        stats_tags = {
            "累计消费金额": float(user_result["total_consume"]),
            "消费月数": user_result["consume_months"]
        }
    
    # 构建UserProfile对象
    user_profile = UserProfile(
        user_id=user_result["customer_id"],
        phone=user_result["phone"],
        registered_at=str(user_result["register_time"]),
        last_active_at=str(user_result["last_active_time"]) if user_result["last_active_time"] else str(user_result["register_time"]),
        basic_tags=basic_tags,
        behavior_tags=behavior_tags,
        stats_tags=stats_tags,
        derived_tags=derived_tags
    )
    
    return user_profile

