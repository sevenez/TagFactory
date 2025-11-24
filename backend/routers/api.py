from typing import List
from uuid import uuid4
from fastapi import APIRouter
from ..models import ApiKey, CallStat
from ..data import VERSION, api_keys, call_stats


router = APIRouter(prefix="/api", tags=["api"])


@router.get("/version")
def version():
    return {"version": VERSION}


@router.get("/stats", response_model=List[CallStat])
def stats():
    return list(call_stats.values())


@router.get("/keys", response_model=List[ApiKey])
def list_keys():
    return api_keys


@router.post("/keys", response_model=ApiKey)
def create_key(name: str):
    key = ApiKey(key_id=str(uuid4()), name=name, token=str(uuid4()).replace("-", ""), created_at="")
    api_keys.append(key)
    return key

