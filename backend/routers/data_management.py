from typing import List
from fastapi import APIRouter
from ..models import DataSource, TagInfo, TagStatus, TagType
from ..data import data_sources, tags


router = APIRouter(prefix="/data", tags=["data"])


@router.get("/sources", response_model=List[DataSource])
def list_sources():
    return data_sources


@router.get("/approvals/tags", response_model=List[TagInfo])
def list_tag_approvals():
    return [t for t in tags if t.status == TagStatus.PENDING or t.status == TagStatus.DISABLED and t.type == TagType.USER]

