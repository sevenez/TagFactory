# 标签工厂管理系统（演示版）运行指南

## 环境要求
- 操作系统：Windows 10/11
- 后端：Python 3.9+
- 前端：Node.js 18+（含 npm）

## 获取代码
- 项目根目录：`e:\AIstydycode\TagFactory`
- 关键目录：
  - 后端：`backend/`
  - 前端：`frontend/`

## 启动后端（FastAPI）
1) 进入项目根目录：
```
cd e:\AIstydycode\TagFactory
```
2) 安装依赖（首次执行）：
```
pip install fastapi uvicorn
```
3) 启动开发服务：
```
python -m uvicorn backend.main:app --reload --port 8000
```
4) 验证：
- 根接口：`http://127.0.0.1:8000/`
- Swagger 文档：`http://127.0.0.1:8000/docs`

## 启动前端（Vue 3 + Vite）
1) 进入前端目录并安装依赖（首次执行）：
```
cd e:\AIstydycode\TagFactory\frontend
npm install
```
2) 启动开发服务：
```
npm run dev
```
3) 访问演示页面：
- 前端地址：`http://localhost:5173/`

## 前后端联调说明
- 前端默认请求后端地址为 `http://127.0.0.1:8000`，可在 `frontend/src/api/client.js` 中修改 `baseURL`。
- 开发时需同时运行后端与前端两个服务。

## 常用接口
- 标签列表筛选：`GET /tags`
- 用户画像查询：`GET /users/lookup?user_id=10001` 或 `?phone=138***0012`
- 群体列表与创建：`GET /groups`、`POST /groups`
- 数据源状态：`GET /data/sources`
- API 文档与统计：`GET /api/version`、`GET /api/stats`

## 端口与修改
- 后端端口：默认 `8000`，可在启动命令中通过 `--port` 调整
- 前端端口：默认 `5173`，可在 `frontend/vite.config.js` 的 `server.port` 调整

## 目录结构（简要）
```
TagFactory/
├─ backend/
│  ├─ main.py                 # 应用入口与路由挂载
│  ├─ models.py               # Pydantic 模型与枚举
│  ├─ data.py                 # 演示数据源
│  └─ routers/                # 各模块路由
│     ├─ tags.py              # 标签查询与操作
│     ├─ users.py             # 个体画像查询
│     ├─ groups.py            # 群体中心
│     ├─ data_management.py   # 数据管理与审批
│     └─ api.py               # 版本、密钥与统计
├─ frontend/
│  ├─ index.html
│  ├─ vite.config.js
│  └─ src/
│     ├─ main.js
│     ├─ styles/theme.css     # 全局主题样式
│     ├─ components/          # 顶栏/侧栏/页脚
│     ├─ pages/               # 各功能页面
│     └─ api/client.js        # Axios 客户端
└─ README.md                   # 运行指南（本文档）
```

## 常见问题
- 若前端无法请求后端，确认后端服务已在 `8000` 端口运行，且前端 `baseURL` 指向正确。
- 若端口被占用，可修改端口后重新运行前后端。
