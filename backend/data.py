from typing import Dict, List
from datetime import datetime
from backend.schemas import TagInfo, TagType, TagStatus, UserProfile, GroupInfo, GroupCreateMethod, GroupStatus, DataSource, ApiKey, CallStat


VERSION = "V2.5.1"


tags: List[TagInfo] = [
    TagInfo(tag_id="T001", name="性别", type=TagType.USER, status=TagStatus.ENABLED, cover_users=120000, created_at="2025-11-01T10:00:00", updated_at="2025-11-20T09:00:00", creator="系统", description="人口属性"),
    TagInfo(tag_id="T002", name="消费等级", type=TagType.USER, status=TagStatus.PENDING, cover_users=45000, created_at="2025-11-15T12:00:00", updated_at="2025-11-15T12:00:00", creator="演示帐号", description="消费能力"),
    TagInfo(tag_id="T003", name="店铺星级", type=TagType.MERCHANT, status=TagStatus.ENABLED, cover_users=3000, created_at="2025-11-10T08:00:00", updated_at="2025-11-18T08:30:00", creator="演示帐号", description="商家评分"),
    TagInfo(tag_id="T004", name="品类", type=TagType.PRODUCT, status=TagStatus.DISABLED, cover_users=8000, created_at="2025-11-02T11:00:00", updated_at="2025-11-19T11:00:00", creator="系统", description="商品分类")
]


users: Dict[str, UserProfile] = {
    "10001": UserProfile(
        user_id="10001",
        phone="138***0012",
        registered_at="2025-10-01T09:00:00",
        last_active_at="2025-11-20T20:00:00",
        basic_tags={"性别": "男", "年龄段": "25-34"},
        behavior_tags={"最近7天访问次数": 5, "最近30天下单次数": 2},
        stats_tags={"累计消费金额": 1200.5, "订单数": 8},
        derived_tags={"忠诚度": "中"}
    ),
    "10002": UserProfile(
        user_id="10002",
        phone="139***7788",
        registered_at="2025-09-15T11:00:00",
        last_active_at="2025-11-18T21:00:00",
        basic_tags={"性别": "女", "年龄段": "18-24"},
        behavior_tags={"最近7天访问次数": 10, "最近30天下单次数": 5},
        stats_tags={"累计消费金额": 3500.0, "订单数": 20},
        derived_tags={"忠诚度": "高"}
    )
}


groups: List[GroupInfo] = [
    GroupInfo(group_id="G001", name="高价值用户", method=GroupCreateMethod.RULE, rule="累计消费金额>3000", users=5000, status=GroupStatus.ENABLED, created_at="2025-11-05T10:00:00", updated_at="2025-11-20T10:00:00", creator="演示帐号"),
    GroupInfo(group_id="G002", name="近7天活跃", method=GroupCreateMethod.BEHAVIOR, rule="最近7天访问次数>=3", users=12000, status=GroupStatus.RUNNING, created_at="2025-11-12T13:00:00", updated_at="2025-11-19T13:00:00", creator="演示帐号")
]


data_sources: List[DataSource] = [
    DataSource(source_id="DS_MYSQL", name="MySQL", connected=True, last_checked_at=datetime.utcnow().isoformat())
]


api_keys: List[ApiKey] = []


call_stats: Dict[str, CallStat] = {}

