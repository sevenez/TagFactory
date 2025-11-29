import logging
from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Query, HTTPException
from backend.schemas import TagInfo, TagType, TagStatus
from backend.database import execute_query, execute_update

logger = logging.getLogger(__name__)


router = APIRouter(prefix="/tags", tags=["tags"])


@router.get("", response_model=Dict[str, Any])
def list_tags(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(20, ge=1, le=100, description="每页数量"),
    type: Optional[List[str]] = Query(default=None, description="标签类型列表，多个类型用逗号分隔"),
    name: Optional[str] = Query(default=None, description="标签名称"),
    status: Optional[str] = Query(default=None, description="标签状态"),
    created_at: Optional[str] = Query(default=None, description="创建日期"),
    sort_by: Optional[str] = Query(default="created_at", description="排序字段"),
    sort_order: Optional[str] = Query(default="desc", regex="^(asc|desc)$", description="排序方向"),
):
    """
    获取标签列表，支持分页、筛选和排序
    """
    try:
        logger.info(f"获取标签列表请求: page={page}, page_size={page_size}, type={type}, name={name}, status={status}")
        
        # 构建查询基础语句
        base_query = """SELECT td.tag_id, td.tag_name as name, td.entity_type as type, 
                           td.tag_layer as layer,
                           CASE td.status WHEN 1 THEN 'ENABLED' WHEN 0 THEN 'DISABLED' ELSE 'PENDING' END as status,
                           COUNT(trc.customer_id) as cover_users, td.create_time as created_at
                        FROM tag_definition td
                        LEFT JOIN tag_relation_customer trc ON td.tag_code = trc.tag_code
                        WHERE 1=1"""
        
        # 构建查询参数
        params = []
        
        # 添加筛选条件
        if type and len(type) > 0:
            # 处理多个类型的情况
            placeholders = ", ".join(["%s"] * len(type))
            base_query += f" AND td.entity_type IN ({placeholders})"
            params.extend(type)
        if name:
            base_query += " AND td.tag_name LIKE %s"
            params.append(f"%{name}%")
        if status:
            status_map = {'ENABLED': 1, 'DISABLED': 0, 'PENDING': 0}
            base_query += " AND td.status = %s"
            params.append(status_map.get(status, 0))
        if created_at:
            base_query += " AND DATE(td.create_time) = %s"
            params.append(created_at)
        
        # 添加分组和排序
        base_query += " GROUP BY td.tag_id, td.tag_name, td.entity_type, td.tag_layer, td.status, td.create_time"
        
        # 映射排序字段到数据库字段
        sort_field_map = {
            'created_at': 'td.create_time',
            'name': 'td.tag_name',
            'tag_id': 'td.tag_id',
            'type': 'td.entity_type',
            'layer': 'td.tag_layer',
            'cover_users': 'COUNT(trc.customer_id)'
        }
        actual_sort_field = sort_field_map.get(sort_by, 'td.create_time')
        base_query += f" ORDER BY {actual_sort_field} {sort_order}"
        
        # 添加分页
        offset = (page - 1) * page_size
        paginated_query = base_query + " LIMIT %s OFFSET %s"
        params.extend([page_size, offset])
        
        # 执行主查询
        tags = execute_query(paginated_query, tuple(params), fetch_all=True) or []
        
        # 执行总数查询
        count_query = f"SELECT COUNT(DISTINCT td.tag_id) FROM tag_definition td WHERE 1=1"
        count_params = []
        if type and len(type) > 0:
            # 处理多个类型的情况
            placeholders = ", ".join(["%s"] * len(type))
            count_query += f" AND td.entity_type IN ({placeholders})"
            count_params.extend(type)
        if name:
            count_query += " AND td.tag_name LIKE %s"
            count_params.append(f"%{name}%")
        if status:
            status_map = {'ENABLED': 1, 'DISABLED': 0, 'PENDING': 0}
            count_query += " AND td.status = %s"
            count_params.append(status_map.get(status, 0))
        if created_at:
            count_query += " AND DATE(td.create_time) = %s"
            count_params.append(created_at)
        
        total_result = execute_query(count_query, tuple(count_params), fetch_one=True)
        total = total_result['COUNT(DISTINCT td.tag_id)'] if total_result else 0
        
        # 计算总页数
        total_pages = (total + page_size - 1) // page_size
        
        logger.info(f"获取标签列表成功: 共{total}条记录，第{page}/{total_pages}页")
        
        return {
            "data": tags,
            "total": total,
            "page": page,
            "page_size": page_size,
            "total_pages": total_pages
        }
        
    except Exception as e:
        logger.error(f"获取标签列表失败: {e}")
        logger.error(f"异常类型: {type(e).__name__}")
        import traceback
        logger.error(f"堆栈信息: {traceback.format_exc()}")
        # 返回空数据，避免前端崩溃
        return {
            "data": [],
            "total": 0,
            "page": page,
            "page_size": page_size,
            "total_pages": 0
        }


@router.put("/{tag_id}/enable", response_model=TagInfo)
def enable_tag(tag_id: str):
    """
    启用标签
    """
    try:
        # 更新标签状态为启用
        update_query = "UPDATE tag_definition SET status = 1, update_time = CURRENT_TIMESTAMP WHERE tag_id = %s"
        execute_update(update_query, (tag_id,))
        
        # 查询更新后的标签信息
        query = """SELECT td.tag_id, td.tag_name as name, td.entity_type as type, td.status, COUNT(trc.customer_id) as cover_users, td.create_time as created_at, td.update_time as updated_at
                 FROM tag_definition td
                 LEFT JOIN tag_relation_customer trc ON td.tag_code = trc.tag_code
                 WHERE td.tag_id = %s
                 GROUP BY td.tag_id, td.tag_name, td.entity_type, td.status, td.create_time, td.update_time"""
        tag_result = execute_query(query, (tag_id,), fetch_one=True)
        
        if tag_result:
            return TagInfo(
                tag_id=tag_result['tag_id'],
                name=tag_result['name'],
                type=TagType(tag_result['type']),
                status=TagStatus.ENABLED,
                cover_users=tag_result['cover_users'],
                created_at=str(tag_result['created_at']),
                updated_at=str(tag_result['updated_at']),
                creator="",
                description=""
            )
        else:
            raise HTTPException(status_code=404, detail="标签不存在")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"启用标签失败: {str(e)}")


@router.put("/{tag_id}/disable", response_model=TagInfo)
def disable_tag(tag_id: str):
    """
    停用标签
    """
    try:
        # 更新标签状态为停用
        update_query = "UPDATE tag_definition SET status = 0, update_time = CURRENT_TIMESTAMP WHERE tag_id = %s"
        execute_update(update_query, (tag_id,))
        
        # 查询更新后的标签信息
        query = """SELECT td.tag_id, td.tag_name as name, td.entity_type as type, td.status, COUNT(trc.customer_id) as cover_users, td.create_time as created_at, td.update_time as updated_at
                 FROM tag_definition td
                 LEFT JOIN tag_relation_customer trc ON td.tag_code = trc.tag_code
                 WHERE td.tag_id = %s
                 GROUP BY td.tag_id, td.tag_name, td.entity_type, td.status, td.create_time, td.update_time"""
        tag_result = execute_query(query, (tag_id,), fetch_one=True)
        
        if tag_result:
            return TagInfo(
                tag_id=tag_result['tag_id'],
                name=tag_result['name'],
                type=TagType(tag_result['type']),
                status=TagStatus.DISABLED,
                cover_users=tag_result['cover_users'],
                created_at=str(tag_result['created_at']),
                updated_at=str(tag_result['updated_at']),
                creator="",
                description=""
            )
        else:
            raise HTTPException(status_code=404, detail="标签不存在")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"停用标签失败: {str(e)}")


@router.delete("/{tag_id}", response_model=Dict[str, Any])
def delete_tag(tag_id: str):
    """
    删除标签
    """
    try:
        # 只有待审核状态的标签才能删除
        check_query = "SELECT status FROM tag_definition WHERE tag_id = %s"
        tag_status = execute_query(check_query, (tag_id,), fetch_one=True)
        
        if not tag_status:
            raise HTTPException(status_code=404, detail="标签不存在")
        
        # 检查标签状态是否为待审核
        if tag_status['status'] != 0:  # 假设0是待审核状态
            raise HTTPException(status_code=400, detail="只有待审核状态的标签才能删除")
        
        # 删除标签
        delete_query = "DELETE FROM tag_definition WHERE tag_id = %s"
        execute_update(delete_query, (tag_id,))
        
        # 返回成功消息
        return {
            "success": True,
            "message": "标签删除成功"
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"删除标签失败: {str(e)}")


@router.post("", response_model=TagInfo)
def create_tag(
    tag: TagInfo
):
    """
    创建新标签
    """
    try:
        # 检查标签名称是否已存在
        check_query = "SELECT tag_id FROM tag_definition WHERE tag_name = %s"
        existing_tag = execute_query(check_query, (tag.name,), fetch_one=True)
        
        if existing_tag:
            raise HTTPException(status_code=400, detail="标签名称已存在")
        
        # 生成标签代码（可以根据业务规则生成）
        tag_code = f"TAG_{tag.name.upper().replace(' ', '_')}_{int(time.time())}"
        
        # 插入标签数据
        insert_query = """INSERT INTO tag_definition (tag_name, tag_code, entity_type, status, create_time, update_time)
                         VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)"""
        
        # 将TagStatus转换为数据库中的数字状态
        status_map = {
            TagStatus.ENABLED.value: 1,
            TagStatus.DISABLED.value: 0,
            TagStatus.PENDING.value: 0  # 待审核状态使用0
        }
        
        execute_update(insert_query, (
            tag.name,
            tag_code,
            tag.type.value,
            status_map.get(tag.status.value, 0)
        ))
        
        # 获取刚创建的标签ID
        new_tag_query = "SELECT LAST_INSERT_ID() as tag_id"
        new_tag_result = execute_query(new_tag_query, fetch_one=True)
        tag_id = new_tag_result['tag_id']
        
        # 查询新创建的标签信息
        query = """SELECT td.tag_id, td.tag_name as name, td.entity_type as type, td.status, COUNT(trc.customer_id) as cover_users, td.create_time as created_at, td.update_time as updated_at
                 FROM tag_definition td
                 LEFT JOIN tag_relation_customer trc ON td.tag_code = trc.tag_code
                 WHERE td.tag_id = %s
                 GROUP BY td.tag_id, td.tag_name, td.entity_type, td.status, td.create_time, td.update_time"""
        tag_result = execute_query(query, (tag_id,), fetch_one=True)
        
        if tag_result:
            return TagInfo(
                tag_id=str(tag_result['tag_id']),
                name=tag_result['name'],
                type=TagType(tag_result['type']),
                status=TagStatus.ENABLED if tag_result['status'] == 1 else TagStatus.DISABLED,
                cover_users=tag_result['cover_users'],
                created_at=str(tag_result['created_at']),
                updated_at=str(tag_result['updated_at']),
                creator=tag.creator,
                description=tag.description
            )
        else:
            raise HTTPException(status_code=500, detail="创建标签失败，无法获取新标签信息")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"创建标签失败: {str(e)}")


@router.put("/{tag_id}", response_model=TagInfo)
def update_tag(
    tag_id: str,
    tag: TagInfo
):
    """
    更新标签信息
    """
    try:
        # 检查标签是否存在
        check_query = "SELECT tag_id FROM tag_definition WHERE tag_id = %s"
        existing_tag = execute_query(check_query, (tag_id,), fetch_one=True)
        
        if not existing_tag:
            raise HTTPException(status_code=404, detail="标签不存在")
        
        # 检查标签名称是否已被其他标签使用
        check_name_query = "SELECT tag_id FROM tag_definition WHERE tag_name = %s AND tag_id != %s"
        existing_name = execute_query(check_name_query, (tag.name, tag_id), fetch_one=True)
        
        if existing_name:
            raise HTTPException(status_code=400, detail="标签名称已被其他标签使用")
        
        # 更新标签数据
        update_query = """UPDATE tag_definition 
                         SET tag_name = %s, entity_type = %s, status = %s, update_time = CURRENT_TIMESTAMP
                         WHERE tag_id = %s"""
        
        # 将TagStatus转换为数据库中的数字状态
        status_map = {
            TagStatus.ENABLED.value: 1,
            TagStatus.DISABLED.value: 0,
            TagStatus.PENDING.value: 0  # 待审核状态使用0
        }
        
        execute_update(update_query, (
            tag.name,
            tag.type.value,
            status_map.get(tag.status.value, 0),
            tag_id
        ))
        
        # 查询更新后的标签信息
        query = """SELECT td.tag_id, td.tag_name as name, td.entity_type as type, td.status, COUNT(trc.customer_id) as cover_users, td.create_time as created_at, td.update_time as updated_at
                 FROM tag_definition td
                 LEFT JOIN tag_relation_customer trc ON td.tag_code = trc.tag_code
                 WHERE td.tag_id = %s
                 GROUP BY td.tag_id, td.tag_name, td.entity_type, td.status, td.create_time, td.update_time"""
        tag_result = execute_query(query, (tag_id,), fetch_one=True)
        
        if tag_result:
            return TagInfo(
                tag_id=str(tag_result['tag_id']),
                name=tag_result['name'],
                type=TagType(tag_result['type']),
                status=TagStatus.ENABLED if tag_result['status'] == 1 else TagStatus.DISABLED,
                cover_users=tag_result['cover_users'],
                created_at=str(tag_result['created_at']),
                updated_at=str(tag_result['updated_at']),
                creator=tag.creator,
                description=tag.description
            )
        else:
            raise HTTPException(status_code=404, detail="标签不存在")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"更新标签失败: {str(e)}")

