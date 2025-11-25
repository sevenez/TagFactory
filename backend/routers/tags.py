from typing import List, Optional
from fastapi import APIRouter, Query
from backend.models import TagInfo, TagType, TagStatus
from backend.data import tags


router = APIRouter(prefix="/tags", tags=["tags"])


@router.get("", response_model=List[TagInfo])
def list_tags(
    type: Optional[TagType] = Query(default=None),
    status: Optional[TagStatus] = Query(default=None),
    created_start: Optional[str] = Query(default=None),
    created_end: Optional[str] = Query(default=None),
    page: int = 1,
    size: int = 10,
):
    filtered = tags
    if type is not None:
        filtered = [t for t in filtered if t.type == type]
    if status is not None:
        filtered = [t for t in filtered if t.status == status]
    if created_start is not None:
        filtered = [t for t in filtered if t.created_at >= created_start]
    if created_end is not None:
        filtered = [t for t in filtered if t.created_at <= created_end]
    start = (page - 1) * size
    end = start + size
    return filtered[start:end]


@router.put("/{tag_id}/enable", response_model=TagInfo)
def enable_tag(tag_id: str):
    for t in tags:
        if t.tag_id == tag_id:
            t.status = TagStatus.ENABLED
            return t
    return TagInfo(tag_id=tag_id, name="", type=TagType.USER, status=TagStatus.ENABLED, cover_users=0, created_at="", updated_at="", creator="", description="")


@router.put("/{tag_id}/disable", response_model=TagInfo)
def disable_tag(tag_id: str):
    for t in tags:
        if t.tag_id == tag_id:
            t.status = TagStatus.DISABLED
            return t
    return TagInfo(tag_id=tag_id, name="", type=TagType.USER, status=TagStatus.DISABLED, cover_users=0, created_at="", updated_at="", creator="", description="")


@router.delete("/{tag_id}", response_model=List[TagInfo])
def delete_tag(tag_id: str):
    remaining: List[TagInfo] = []
    for t in tags:
        if t.tag_id == tag_id and t.status == TagStatus.PENDING:
            pass
        else:
            remaining.append(t)
    tags.clear()
    tags.extend(remaining)
    return tags

