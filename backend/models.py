from enum import Enum
from typing import Any, Dict, Optional
from pydantic import BaseModel


class TagType(str, Enum):
    USER = "USER"
    MERCHANT = "MERCHANT"
    PRODUCT = "PRODUCT"
    CUSTOMER = "CUSTOMER"


class TagStatus(str, Enum):
    ENABLED = "ENABLED"
    PENDING = "PENDING"
    DISABLED = "DISABLED"


class GroupCreateMethod(str, Enum):
    RULE = "RULE"
    BEHAVIOR = "BEHAVIOR"
    IMPORT = "IMPORT"


class GroupStatus(str, Enum):
    ENABLED = "ENABLED"
    RUNNING = "RUNNING"
    DISABLED = "DISABLED"


class TagInfo(BaseModel):
    tag_id: str
    name: str
    type: TagType
    status: TagStatus
    cover_users: int
    created_at: str
    updated_at: str
    creator: Optional[str] = None
    description: Optional[str] = None


class UserProfile(BaseModel):
    user_id: str
    phone: str
    registered_at: str
    last_active_at: str
    basic_tags: Dict[str, Any]
    behavior_tags: Dict[str, Any]
    stats_tags: Dict[str, Any]
    derived_tags: Dict[str, Any]


class GroupInfo(BaseModel):
    group_id: str
    name: str
    method: GroupCreateMethod
    rule: str
    users: int
    status: GroupStatus
    created_at: str
    updated_at: str
    creator: Optional[str] = None


class DataSource(BaseModel):
    source_id: str
    name: str
    connected: bool
    last_checked_at: str


class ApiKey(BaseModel):
    key_id: str
    name: str
    token: str
    created_at: str


class CallStat(BaseModel):
    path: str
    method: str
    count: int

