from typing import Optional
from fastapi import APIRouter, HTTPException, Query
from ..models import UserProfile
from ..data import users


router = APIRouter(prefix="/users", tags=["users"])


@router.get("/lookup", response_model=UserProfile)
def lookup_user(user_id: Optional[str] = Query(default=None), phone: Optional[str] = Query(default=None)):
    if user_id:
        if user_id in users:
            return users[user_id]
        raise HTTPException(status_code=404, detail="用户不存在")
    if phone:
        for u in users.values():
            if phone in u.phone:
                return u
        raise HTTPException(status_code=404, detail="用户不存在")
    raise HTTPException(status_code=400, detail="参数错误")

