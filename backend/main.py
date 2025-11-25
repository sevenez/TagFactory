import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from typing import Callable
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from backend.routers import tags as tags_router
from backend.routers import users as users_router
from backend.routers import groups as groups_router
from backend.routers import data_management as data_router
from backend.routers import api as api_router
from backend.data import call_stats


app = FastAPI(title="标签工厂管理系统（演示版）")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(tags_router.router)
app.include_router(users_router.router)
app.include_router(groups_router.router)
app.include_router(data_router.router)
app.include_router(api_router.router)


@app.middleware("http")
async def count_calls(request: Request, call_next: Callable):
    key = f"{request.method} {request.url.path}"
    if key in call_stats:
        c = call_stats[key]
        c.count += 1
    else:
        from backend.models import CallStat
        call_stats[key] = CallStat(path=request.url.path, method=request.method, count=1)
    response = await call_next(request)
    return response


@app.get("/")
def root():
    return {"name": "标签工厂管理系统（演示版）"}

