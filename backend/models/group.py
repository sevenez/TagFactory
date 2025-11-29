from sqlalchemy import Column, Integer, String, Enum, DateTime, ForeignKey, Boolean, Text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from backend.database import Base

# 导入枚举类型
from backend.schemas import GroupCreateMethod, GroupStatus


class GroupDefinition(Base):
    """
    群体定义表模型
    映射group_definition表
    """
    __tablename__ = "group_definition"
    
    group_id = Column(Integer, primary_key=True, autoincrement=True, comment="群体ID")
    group_code = Column(String(50), unique=True, nullable=False, comment="群体编码")
    group_name = Column(String(50), nullable=False, comment="群体显示名")
    entity_type = Column(Enum("CUSTOMER", "PRODUCT", "SELLER"), nullable=False, comment="群体归属实体类型")
    create_method = Column(Enum("RULE", "BEHAVIOR", "IMPORT"), nullable=False, default="RULE", comment="创建方式")
    status = Column(Boolean, default=True, comment="状态（1-启用 0-停用）")
    entity_count = Column(Integer, default=0, comment="群体包含实体数量")
    create_time = Column(DateTime, default=func.now(), comment="创建时间")
    update_time = Column(DateTime, default=func.now(), onupdate=func.now(), comment="更新时间")
    creator = Column(String(50), default="system", comment="创建人")
    description = Column(String(255), comment="群体描述")
    
    # 关系定义
    tags = relationship("GroupTagRelation", back_populates="group", cascade="all, delete-orphan")
    entities = relationship("GroupEntityRelation", back_populates="group", cascade="all, delete-orphan")


class GroupTagRelation(Base):
    """
    群体标签关系表模型
    映射group_tag_relation表
    """
    __tablename__ = "group_tag_relation"
    
    id = Column(Integer, primary_key=True, autoincrement=True, comment="主键ID")
    group_id = Column(Integer, ForeignKey("group_definition.group_id", ondelete="CASCADE"), nullable=False, comment="关联group_definition.group_id")
    tag_code = Column(String(50), nullable=False, comment="关联tag_definition.tag_code")
    tag_value = Column(String(255), nullable=False, comment="标签值")
    operator = Column(Enum("AND", "OR"), default="AND", comment="标签间逻辑关系")
    create_time = Column(DateTime, default=func.now(), comment="创建时间")
    
    # 关系定义
    group = relationship("GroupDefinition", back_populates="tags")


class GroupEntityRelation(Base):
    """
    群体实体关系表模型
    映射group_entity_relation表
    """
    __tablename__ = "group_entity_relation"
    
    id = Column(Integer, primary_key=True, autoincrement=True, comment="主键ID")
    group_id = Column(Integer, ForeignKey("group_definition.group_id", ondelete="CASCADE"), nullable=False, comment="关联group_definition.group_id")
    entity_id = Column(String(17), nullable=False, comment="实体ID")
    entity_type = Column(Enum("CUSTOMER", "PRODUCT", "SELLER"), nullable=False, comment="实体类型")
    add_time = Column(DateTime, default=func.now(), comment="加入时间")
    
    # 关系定义
    group = relationship("GroupDefinition", back_populates="entities")
