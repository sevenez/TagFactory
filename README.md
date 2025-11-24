# 标签工厂管理系统（演示版）部署与运行指南

## 环境要求
- 操作系统：Windows 10/11
- 后端：Python 3.9+ 与 pip
- 前端：Node.js 18+ 与 npm
- 数据库：MySQL 8.0+
- 内存：至少 4GB RAM
- 硬盘：至少 1GB 可用空间

## 项目概述
标签工厂管理系统是一个数据管理与标签分析平台，支持客户、商家和商品数据的查询、管理和展示。系统采用前后端分离架构，包括数据管理、标签查询、个体画像和群体中心等功能模块。

## 项目结构
- 项目根目录：`e:\AIstydycode\TagFactory`
- 关键目录：
  - 后端：`backend/` - FastAPI 应用服务
  - 前端：`frontend/` - Vue 3 + Vite 前端应用
  - 文档：`Documents/` - 需求文档和数据库脚本

## 数据库配置（重要）
1. 安装 MySQL 8.0+
2. 创建数据库 `tagfactory`
3. 导入初始数据（如果有）：
   ```
   mysql -u root -p tagfactory < Documents/用户信息表、商家信息表、商品信息表.sql
   ```
4. 数据库连接参数配置：
   - 主机：localhost
   - 端口：3306
   - 用户名：root
   - 密码：root
   - 数据库名：tagfactory
   - 字符集：utf8mb4

## 后端服务配置
1. 进入项目根目录：
   ```
   cd e:\AIstydycode\TagFactory
   ```
2. 安装依赖（首次执行）：
   ```
   pip install fastapi uvicorn pymysql
   ```
3. 检查数据库连接配置：
   - 数据库配置文件：`backend/database.py`
   - 确认 `DB_CONFIG` 中的连接参数是否正确
4. 手动启动后端（可选）：
   ```
   python -m uvicorn backend.main:app --reload --port 8000
   ```
5. 访问后端服务：
   - 根接口：`http://127.0.0.1:8000/`
   - API 文档：`http://127.0.0.1:8000/docs`
   - 健康检查：`http://127.0.0.1:8000/health`

## 前端服务配置
1. 进入前端目录并安装依赖（首次执行）：
   ```
   cd e:\AIstydycode\TagFactory\frontend
   npm install
   ```
2. 检查 API 连接配置：
   - API 配置文件：`frontend/src/api/client.js`
   - 默认后端地址：`http://127.0.0.1:8000`
3. 手动启动前端（可选）：
   ```
   npm run dev
   ```
4. 访问前端应用：
   - 应用地址：`http://localhost:5173/`

## 一键启动（推荐）
系统提供了一键启动脚本，简化部署流程：

1. 确保环境准备就绪：
   - Python 3.9+ 已安装
   - Node.js 18+ 已安装
   - MySQL 8.0+ 已安装且服务名为 `mysql80`
   - 数据库 `tagfactory` 已创建

2. 运行启动脚本：
   ```
   cd e:\AIstydycode\TagFactory
   start_tag_factory.bat
   ```

3. 脚本将自动：
   - 启动 MySQL 服务
   - 启动后端 FastAPI 服务
   - 启动前端 Vue 开发服务
   - 显示各服务访问地址

## 系统功能模块
- **数据管理**：客户、商家、商品数据的查询、筛选、排序和分页
- **标签查询**：标签类型与状态筛选，标签详情查看
- **个体画像**：通过用户ID或手机号查询用户画像信息
- **群体中心**：群体创建、管理和分析
- **API 文档**：自动生成的 Swagger API 文档

## 核心 API 接口
- **数据管理**：
  - 客户数据：`GET /data/customers` (支持分页、筛选、排序)
  - 商家数据：`GET /data/merchants` (支持分页、筛选、排序)
  - 商品数据：`GET /data/products` (支持分页、筛选、排序)
  - 数据统计：`GET /data/stats`

- **标签管理**：
  - 标签列表：`GET /tags`
  - 标签详情：`GET /tags/{tag_id}`
  - 标签创建：`POST /tags`

- **用户画像**：
  - 用户查询：`GET /users/lookup?user_id=10001` 或 `?phone=138***0012`
  - 用户详情：`GET /users/{user_id}`

- **群体中心**：
  - 群体列表：`GET /groups`
  - 群体创建：`POST /groups`
  - 群体详情：`GET /groups/{group_id}`

- **系统服务**：
  - 健康检查：`GET /health`
  - API 文档：`GET /docs`
  - 系统状态：`GET /status`

## 配置修改说明
- **后端配置**：
  - 端口修改：启动命令中使用 `--port` 参数
  - 数据库配置：修改 `backend/database.py` 中的 `DB_CONFIG`
  - 日志级别：修改 `backend/database.py` 中的日志配置

- **前端配置**：
  - 端口修改：修改 `frontend/vite.config.js` 的 `server.port`
  - API 地址：修改 `frontend/src/api/client.js` 中的 `baseURL`
  - 主题样式：修改 `frontend/src/styles/theme.css`

- **启动脚本**：
  - MySQL 服务名：修改 `start_tag_factory.bat` 中的服务名
  - 等待时间：调整脚本中的 `ping` 等待时间

## 完整目录结构
```
TagFactory/
├─ backend/                  # 后端 FastAPI 应用
│  ├─ main.py                # 应用入口与路由挂载
│  ├─ models.py              # Pydantic 模型与枚举
│  ├─ data.py                # 数据处理逻辑
│  ├─ database.py            # 数据库连接池管理
│  ├─ tests/                 # 后端测试代码
│  │  └─ test_database.py    # 数据库连接测试
│  └─ routers/               # 各模块路由
│     ├─ tags.py             # 标签查询与操作
│     ├─ users.py            # 个体画像查询
│     ├─ groups.py           # 群体中心
│     ├─ data_management.py  # 数据管理与审批
│     └─ api.py              # 系统API和统计
├─ frontend/                 # 前端 Vue 3 应用
│  ├─ index.html
│  ├─ vite.config.js         # Vite 配置文件
│  ├─ tests/                 # 前端测试脚本
│  │  └─ test_data_page.js   # 数据页面功能测试
│  └─ src/
│     ├─ main.js             # Vue 应用入口
│     ├─ router/             # 路由配置
│     ├─ api/
│     │  └─ client.js        # Axios 客户端配置
│     ├─ styles/
│     │  └─ theme.css        # 全局主题样式
│     ├─ components/         # 公共组件
│     └─ pages/              # 各功能页面
│        ├─ Data.vue         # 数据管理页面
│        ├─ Tags.vue         # 标签查询页面
│        ├─ Profile.vue      # 个体画像页面
│        └─ Groups.vue       # 群体中心页面
├─ Documents/                # 项目文档
│  ├─ 标签工厂管理系统（演示版）需求文档.md
│  └─ 用户信息表、商家信息表、商品信息表.sql
├─ README.md                 # 部署与运行指南
└─ start_tag_factory.bat     # 一键启动脚本
```

## 常见问题与排查
1. **数据库连接失败**
   - 确认 MySQL 服务已启动
   - 检查数据库名称是否为 `tagfactory`
   - 验证用户名 `root` 和密码 `root` 是否正确
   - 检查端口 `3306` 是否开放且未被占用

2. **后端服务启动失败**
   - 确认 Python 依赖已正确安装
   - 检查端口 `8000` 是否被占用
   - 查看错误日志，检查数据库连接配置

3. **前端无法连接后端**
   - 确认后端服务是否正常运行
   - 检查 `frontend/src/api/client.js` 中的 `baseURL` 配置
   - 验证网络连接和跨域设置

4. **服务启动慢或性能问题**
   - 增加等待时间，调整启动脚本中的 `ping` 延迟
   - 检查系统资源占用，确保有足够的内存和CPU
   - 优化数据库查询和连接池设置

## 部署注意事项
1. **开发环境**
   - 使用 `--reload` 参数支持代码热更新
   - 适合开发和测试阶段

2. **生产环境准备**
   - 移除 `--reload` 参数提高性能
   - 配置合适的日志级别和存储
   - 考虑使用 Nginx 等反向代理
   - 数据库连接池参数优化

3. **安全建议**
   - 修改默认的数据库密码
   - 配置适当的访问控制
   - 考虑添加 API 认证机制
   - 定期备份数据库

## 版本信息
- 后端框架：FastAPI 0.104+
- 前端框架：Vue 3 + Vite 5+
- 数据库：MySQL 8.0+
- Python：3.9+
- Node.js：18+

## 许可证
保留所有权利。仅供演示和学习使用。
