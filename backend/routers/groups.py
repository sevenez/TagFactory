from typing import List
from uuid import uuid4
from fastapi import APIRouter
from ..models import GroupInfo, GroupCreateMethod, GroupStatus
from ..data import groups


router = APIRouter(prefix="/groups", tags=["groups"])


@router.get("", response_model=List[GroupInfo])
def list_groups():
    return groups


@router.post("", response_model=GroupInfo)
def create_group(name: str, method: GroupCreateMethod, rule: str):
    g = GroupInfo(
        group_id=str(uuid4()),
        name=name,
        method=method,
        rule=rule,
        users=0,
        status=GroupStatus.RUNNING,
        created_at="",
        updated_at="",
        creator="演示帐号",
    )
    groups.append(g)
    return g


@router.put("/{group_id}/status", response_model=GroupInfo)
def update_group_status(group_id: str, status: GroupStatus):
    for g in groups:
        if g.group_id == group_id:
            g.status = status
            return g
    return GroupInfo(group_id=group_id, name="", method=GroupCreateMethod.RULE, rule="", users=0, status=status, created_at="", updated_at="", creator="")

