from typing import List, Optional, Dict, Any
from uuid import uuid4
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from backend.database import get_db
from backend.schemas import GroupInfo, GroupCreateMethod, GroupStatus
from backend.models.group import GroupDefinition, GroupTagRelation, GroupEntityRelation


router = APIRouter(prefix="/groups", tags=["groups"])


@router.get("", response_model=Dict[str, Any])
def list_groups(
    db: Session = Depends(get_db),
    status: Optional[GroupStatus] = None,
    method: Optional[GroupCreateMethod] = None,
    entity_type: Optional[str] = None,
    name: Optional[str] = None,
    skip: int = Query(0, ge=0, description="分页偏移量"),
    limit: int = Query(100, ge=1, le=1000, description="每页数量"),
    sort_by: Optional[str] = Query("create_time", description="排序字段"),
    sort_order: Optional[str] = Query("desc", regex="^(asc|desc)$", description="排序方向")
):
    """
    查询群体列表
    支持按状态、创建方式、实体类型、名称过滤
    支持分页、排序
    """
    from sqlalchemy import func
    
    # 构建查询，包含标签数量
    query = db.query(
        GroupDefinition,
        func.count(GroupTagRelation.id).label('tag_count')
    ).outerjoin(
        GroupTagRelation, GroupDefinition.group_id == GroupTagRelation.group_id
    )
    
    # 分组
    query = query.group_by(GroupDefinition.group_id)
    
    # 过滤条件
    if status is not None:
        query = query.filter(GroupDefinition.status == (status == GroupStatus.ENABLED))
    if method is not None:
        query = query.filter(GroupDefinition.create_method == method)
    if entity_type is not None:
        query = query.filter(GroupDefinition.entity_type == entity_type)
    if name is not None:
        query = query.filter(GroupDefinition.group_name.like(f"%{name}%"))
    
    # 排序
    sort_column = getattr(GroupDefinition, sort_by, GroupDefinition.create_time)
    if sort_order == "desc":
        query = query.order_by(sort_column.desc())
    else:
        query = query.order_by(sort_column.asc())
    
    # 获取总数
    total = query.count()
    
    # 分页
    group_results = query.offset(skip).limit(limit).all()
    
    # 转换为响应模型
    group_list = []
    for group, tag_count in group_results:
        # 获取群体标签，生成规则字符串
        tags = db.query(GroupTagRelation).filter(GroupTagRelation.group_id == group.group_id).all()
        rule_parts = []
        for tag in tags:
            rule_parts.append(f"{tag.tag_code} {tag.tag_value}")
        rule = " AND ".join(rule_parts) if rule_parts else ""
        
        group_list.append(GroupInfo(
            group_id=str(group.group_id),
            name=group.group_name,
            method=GroupCreateMethod(group.create_method),
            rule=rule,
            users=group.entity_count,
            status=GroupStatus.ENABLED if group.status else GroupStatus.DISABLED,
            created_at=group.create_time.isoformat() if group.create_time else "",
            updated_at=group.update_time.isoformat() if group.update_time else "",
            creator=group.creator,
            entity_type=group.entity_type,
            tag_count=tag_count
        ))
    
    # 返回包含分页信息的响应
    return {
        "data": group_list,
        "total": total,
        "page": skip // limit + 1,
        "page_size": limit,
        "total_pages": (total + limit - 1) // limit
    }


@router.get("/{group_id}", response_model=GroupInfo)
def get_group(
    group_id: str,
    db: Session = Depends(get_db)
):
    """
    查询群体详情
    """
    from sqlalchemy import func
    
    # 查询群体基本信息和标签数量
    result = db.query(
        GroupDefinition,
        func.count(GroupTagRelation.id).label('tag_count')
    ).outerjoin(
        GroupTagRelation, GroupDefinition.group_id == GroupTagRelation.group_id
    ).filter(
        GroupDefinition.group_id == group_id
    ).group_by(
        GroupDefinition.group_id
    ).first()
    
    if not result:
        raise HTTPException(status_code=404, detail="群体不存在")
    
    group, tag_count = result
    
    # 生成规则字符串
    tags = db.query(GroupTagRelation).filter(GroupTagRelation.group_id == group_id).all()
    rule_parts = []
    for tag in tags:
        rule_parts.append(f"{tag.tag_code} {tag.tag_value}")
    rule = " AND ".join(rule_parts) if rule_parts else ""
    
    return GroupInfo(
        group_id=str(group.group_id),
        name=group.group_name,
        method=GroupCreateMethod(group.create_method),
        rule=rule,
        users=group.entity_count,
        status=GroupStatus.ENABLED if group.status else GroupStatus.DISABLED,
        created_at=group.create_time.isoformat() if group.create_time else "",
        updated_at=group.update_time.isoformat() if group.update_time else "",
        creator=group.creator,
        entity_type=group.entity_type,
        tag_count=tag_count
    )


@router.post("", response_model=GroupInfo)
def create_group(
    name: str,
    method: GroupCreateMethod,
    entity_type: str,
    tags: str = Query(None, description="标签列表JSON字符串，包含tag_code和tag_value"),
    description: str = Query("", description="群体描述"),
    db: Session = Depends(get_db),
    creator: str = "演示帐号"
):
    """
    创建群体
    """
    import json
    
    # 解析标签JSON字符串
    tag_list = []
    if tags:
        try:
            tag_list = json.loads(tags)
        except json.JSONDecodeError:
            raise HTTPException(status_code=400, detail="标签格式错误，必须是有效的JSON字符串")
    
    # 验证标签类型是否与群体实体类型一致
    if tag_list:
        from backend.database import execute_query
        for tag in tag_list:
            # 检查标签是否包含必要字段
            if "tag_code" not in tag:
                raise HTTPException(status_code=400, detail="标签缺少必要字段：tag_code")
            
            tag_info = execute_query(
                "SELECT entity_type FROM tag_definition WHERE tag_code = %s",
                (tag["tag_code"],),
                fetch_one=True
            )
            if not tag_info:
                raise HTTPException(status_code=400, detail=f"标签 {tag['tag_code']} 不存在")
            if tag_info["entity_type"] != entity_type:
                raise HTTPException(status_code=400, detail=f"标签 {tag['tag_code']} 类型与群体实体类型不一致")
    
    # 创建群体定义
    group = GroupDefinition(
        group_code=f"GROUP_{uuid4().hex[:8].upper()}",
        group_name=name,
        entity_type=entity_type,
        create_method=method,
        status=True,
        creator=creator,
        description=description
    )
    db.add(group)
    db.commit()
    db.refresh(group)
    
    # 保存标签关系
    if tag_list:
        for tag in tag_list:
            group_tag = GroupTagRelation(
                group_id=group.group_id,
                tag_code=tag["tag_code"],
                tag_value=tag.get("tag_value", ""),
                operator=tag.get("operator", "AND")
            )
            db.add(group_tag)
    
    # 提交事务
    db.commit()
    
    # 生成规则字符串
    rule_parts = []
    if tag_list:
        for tag in tag_list:
            rule_parts.append(f"{tag['tag_code']} {tag.get('tag_value', '')}")
    rule = " AND ".join(rule_parts) if rule_parts else ""
    
    return GroupInfo(
        group_id=str(group.group_id),
        name=group.group_name,
        method=method,
        rule=rule,
        users=0,
        status=GroupStatus.ENABLED,
        created_at=group.create_time.isoformat() if group.create_time else "",
        updated_at=group.update_time.isoformat() if group.update_time else "",
        creator=group.creator
    )


@router.put("/{group_id}", response_model=GroupInfo)
def update_group(
    group_id: str,
    name: Optional[str] = None,
    status: Optional[GroupStatus] = None,
    description: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """
    更新群体信息
    """
    group = db.query(GroupDefinition).filter(GroupDefinition.group_id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="群体不存在")
    
    # 更新字段
    if name is not None:
        group.group_name = name
    if status is not None:
        group.status = (status == GroupStatus.ENABLED)
    if description is not None:
        group.description = description
    
    db.commit()
    db.refresh(group)
    
    return GroupInfo(
        group_id=str(group.group_id),
        name=group.group_name,
        method=GroupCreateMethod(group.create_method),
        rule="",
        users=group.entity_count,
        status=GroupStatus.ENABLED if group.status else GroupStatus.DISABLED,
        created_at=group.create_time.isoformat() if group.create_time else "",
        updated_at=group.update_time.isoformat() if group.update_time else "",
        creator=group.creator
    )


@router.delete("/{group_id}")
def delete_group(
    group_id: str,
    db: Session = Depends(get_db)
):
    """
    删除群体
    """
    group = db.query(GroupDefinition).filter(GroupDefinition.group_id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="群体不存在")
    
    db.delete(group)
    db.commit()
    
    return {"message": "群体删除成功"}


@router.get("/{group_id}/tags")
def get_group_tags(
    group_id: str,
    db: Session = Depends(get_db)
):
    """
    查询群体标签
    """
    tags = db.query(GroupTagRelation).filter(GroupTagRelation.group_id == group_id).all()
    return [
        {
            "tag_code": tag.tag_code,
            "tag_value": tag.tag_value,
            "operator": tag.operator,
            "create_time": tag.create_time.isoformat() if tag.create_time else ""
        }
        for tag in tags
    ]


@router.get("/{group_id}/entities")
def get_group_entities(
    group_id: str,
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100
):
    """
    查询群体实体
    """
    entities = db.query(GroupEntityRelation).filter(GroupEntityRelation.group_id == group_id).offset(skip).limit(limit).all()
    return [
        {
            "entity_id": entity.entity_id,
            "entity_type": entity.entity_type,
            "add_time": entity.add_time.isoformat() if entity.add_time else ""
        }
        for entity in entities
    ]


@router.get("/{group_id}/stats")
def get_group_stats(
    group_id: str,
    db: Session = Depends(get_db)
):
    """
    查询群体统计信息
    """
    # 查询群体基本信息
    group = db.query(GroupDefinition).filter(GroupDefinition.group_id == group_id).first()
    if not group:
        raise HTTPException(status_code=404, detail="群体不存在")
    
    # 查询实体数量
    entity_count = db.query(func.count(GroupEntityRelation.id)).filter(GroupEntityRelation.group_id == group_id).scalar()
    
    # 查询标签数量
    tag_count = db.query(func.count(GroupTagRelation.id)).filter(GroupTagRelation.group_id == group_id).scalar()
    
    return {
        "group_id": str(group.group_id),
        "group_name": group.group_name,
        "entity_count": entity_count,
        "tag_count": tag_count,
        "entity_type": group.entity_type,
        "status": "启用" if group.status else "停用",
        "create_time": group.create_time.isoformat() if group.create_time else ""
    }

