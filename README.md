# 标签工厂管理系统

## 部署与运行指南

### 环境要求

- 操作系统：Windows 10/11
- 后端：Python 3.9+ 与 pip
- 前端：Node.js 18+ 与 npm
- 数据库：MySQL 8.0+
- 内存：至少 4GB RAM
- 硬盘：至少 1GB 可用空间

### 项目概述

标签工厂管理系统是一个功能完整的数据管理与标签分析平台，支持客户、商家和商品数据的查询、管理和展示。系统采用前后端分离架构，包括数据管理、标签查询、个体画像、群体中心和标签审批等核心功能模块，为企业提供全面的标签管理解决方案。

### 项目结构

- 项目根目录：`e:\AIcodes\Case\TagFactory`
- 关键目录：
  - **backend/**：FastAPI 后端应用服务，包含核心业务逻辑和API接口
  - **frontend/**：Vue 3 + Vite 前端应用，包含用户界面和交互逻辑
  - **Documents/**：项目文档，包含需求文档、数据库脚本和模拟数据

### 数据库配置（重要）

1. 安装 MySQL 8.0+
2. 创建数据库 `tagfactory`
3. 导入初始数据：
   ```
   # 导入用户、商家、商品信息表
   mysql -u root -p tagfactory < Documents/SQL/用户信息表、商家信息表、商品信息表.sql

   # 导入标签系统基础表
   mysql -u root -p tagfactory < Documents/SQL/tag_system.sql

   # 导入标签定义表
   mysql -u root -p tagfactory < Documents/SQL/tag_definitions.sql

   # 导入标签计算表
   mysql -u root -p tagfactory < Documents/SQL/tag_calculation.sql

   # 导入标签审批表
   mysql -u root -p tagfactory < Documents/SQL/tag_approval.sql

   # 导入群体中心表
   mysql -u root -p tagfactory < Documents/SQL/group_center.sql
   ```
4. 数据库连接参数配置：
   - 主机：localhost
   - 端口：3306
   - 用户名：root
   - 密码：root
   - 数据库名：tagfactory
   - 字符集：utf8mb4

### 后端服务配置

1. 进入项目根目录：
   ```
   cd e:\AIcodes\Case\TagFactory
   ```
2. 安装依赖（首次执行）：
   ```
   pip install fastapi uvicorn pymysql sqlalchemy
   ```
3. 检查数据库连接配置：
   - 数据库配置文件：`backend/database.py`
   - 确认 `DB_CONFIG` 中的连接参数是否正确
4. 后端服务说明：
   - **主后端服务**：运行 `backend/main.py`，提供系统核心 API 服务
   - **固定端口后端服务**：运行 `backend/fixed_server.py`，提供特定功能支持
5. 手动启动后端（可选）：
   ```
   # 启动主后端服务
   python -m uvicorn backend.main:app --reload --port 8000

   # 启动固定端口后端服务
   python backend/fixed_server.py
   ```
6. 访问后端服务：
   - 主后端根接口：`http://127.0.0.1:8000/`
   - API 文档：`http://127.0.0.1:8000/docs`
   - 健康检查：`http://127.0.0.1:8000/health`
   - 固定端口后端：`http://localhost:8002`

### 前端服务配置

1. 进入前端目录并安装依赖（首次执行）：
   ```
   cd e:\AIcodes\Case\TagFactory\frontend
   npm install
   ```
2. 检查 API 连接配置：
   - API 配置文件：`frontend/src/api/client.js`
   - 默认后端地址：`http://localhost:8000`
3. 手动启动前端（可选）：
   ```
   npm run dev
   ```
4. 访问前端应用：
   - 应用地址：`http://localhost:5173/`

### 一键启动（推荐）

系统提供了一键启动脚本，简化部署流程：

1. 确保环境准备就绪：

   - Python 3.9+ 已安装
   - Node.js 18+ 已安装
   - MySQL 8.0+ 已安装且服务名为 `mysql80`
   - 数据库 `tagfactory` 已创建
2. 运行启动脚本：

   ```
   cd e:\AIcodes\Case\TagFactory
   start_tag_factory.bat
   ```
3. 脚本将自动：

   - 启动 MySQL 服务
   - 启动主后端 FastAPI 服务（端口 8000）
   - 启动固定端口后端服务（端口 8002）
   - 启动前端 Vue 开发服务（端口 5173）
   - 显示各服务访问地址

### 系统功能模块

- **标签查询**：标签类型与状态筛选，标签详情查看
- **标签审批**：标签申请审批流程，支持通过/拒绝操作，状态管理和统计，独立主功能模块
- **个体画像**：通过用户ID或手机号查询用户画像信息
- **群体中心**：群体创建、管理、分析和维护，支持群体列表查看和新建群体
- **数据管理**：客户、商家、商品数据的查询、筛选和分页
- **API 模块**：API 调用接口和文档，支持接口调用统计

### 核心 API 接口

- **数据管理**：

  - 客户数据：`GET /data/customers` (支持分页、筛选)
  - 商家数据：`GET /data/merchants` (支持分页、筛选)
  - 商品数据：`GET /data/products` (支持分页、筛选)
  - 数据统计：`GET /data/statistics`
  - 连接状态：`GET /data/connection/status`
  - 刷新连接：`POST /data/connection/refresh`
- **标签管理**：

  - 标签列表：`GET /tags`
  - 标签详情：`GET /tags/{tag_id}`
  - 标签创建：`POST /tags`
- **标签审批**：

  - 审批列表：`GET /data/approvals/tags` (支持分页、筛选)
  - 通过审批：`POST /data/approvals/tags/{tag_id}/approve`
  - 拒绝审批：`POST /data/approvals/tags/{tag_id}/reject`
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

### 配置修改说明

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

### 完整目录结构

```
TagFactory/
├─ backend/                  # 后端 FastAPI 应用
│  ├─ main.py                # 应用入口与路由挂载
│  ├─ schemas.py             # Pydantic 模型与枚举
│  ├─ data.py                # 数据处理逻辑
│  ├─ database.py            # 数据库连接池管理
│  ├─ fixed_server.py        # 固定端口后端服务
│  ├─ models/                # 数据库模型定义
│  │  └─ group.py            # 群体中心模型
│  ├─ test/                  # 后端测试代码
│  │  ├─ test_groups.py      # 群体中心测试
│  │  └─ test_services.py    # 服务测试
│  └─ routers/               # 各模块路由
│     ├─ __init__.py         # 路由初始化
│     ├─ tags.py             # 标签查询与操作
│     ├─ users.py            # 个体画像查询
│     ├─ groups.py           # 群体中心
│     ├─ data_management.py  # 数据管理与审批
│     └─ api.py              # 系统API和统计
├─ frontend/                 # 前端 Vue 3 应用
│  ├─ index.html
│  ├─ vite.config.js         # Vite 配置文件
│  ├─ dist/                  # 构建输出目录
│  ├─ tests/                 # 前端测试脚本
│  │  └─ test_data_page.js   # 数据页面功能测试
│  └─ src/
│     ├─ main.js             # Vue 应用入口
│     ├─ router/             # 路由配置
│     │  └─ index.js         # 路由定义
│     ├─ api/
│     │  └─ client.js        # Axios 客户端配置
│     ├─ styles/
│     │  ├─ theme.css        # 全局主题样式
│     │  ├─ CSS优化报告.md   # CSS优化报告
│     │  └─ CSS冲突与重复内容检查报告.md # CSS检查报告
│     ├─ components/         # 公共组件
│     │  ├─ FooterBar.vue    # 页脚组件
│     │  ├─ SideNav.vue      # 侧边导航组件
│     │  └─ TopInfoBar.vue   # 顶部信息栏组件
│     └─ pages/              # 各功能页面
│        ├─ Home.vue         # 首页模块卡片
│        ├─ Tags.vue         # 标签查询页面
│        ├─ Approvals.vue    # 标签审批页面
│        ├─ Profile.vue      # 个体画像页面
│        ├─ Groups.vue       # 群体中心首页
│        ├─ GroupList.vue    # 群体列表页面
│        ├─ GroupCreate.vue  # 群体创建页面
│        ├─ Data.vue         # 数据管理页面
│        ├─ DataTest.vue     # 数据测试页面
│        └─ Api.vue          # API 模块页面
├─ Documents/                # 项目文档
│  ├─ SQL/                   # 数据库脚本
│  │  ├─ group_center.sql    # 群体中心表结构
│  │  ├─ tag_approval.sql    # 标签审批表结构
│  │  ├─ tag_calculation.sql # 标签计算表结构
│  │  ├─ tag_definitions.sql # 标签定义表结构
│  │  ├─ tag_system.sql      # 标签系统基础表
│  │  └─ 用户信息表、商家信息表、商品信息表.sql # 基础业务表
│  ├─ 模拟数据/              # 模拟数据文件
│  │  ├─ approval_flow.csv   # 审批流程模拟数据
│  │  ├─ approval_record.csv # 审批记录模拟数据
│  │  ├─ group_definition.csv # 群体定义模拟数据
│  │  ├─ group_entity_relation.csv # 群体实体关系模拟数据
│  │  ├─ group_tag_relation.csv # 群体标签关系模拟数据
│  │  ├─ system_user.csv     # 系统用户模拟数据
│  │  ├─ tag_application.csv # 标签申请模拟数据
│  │  └─ tag_definition_test.csv # 标签定义测试数据
│  ├─ 标签审批建表及模拟数据导入说明.md # 标签审批模块文档
│  ├─ 标签工厂管理系统（Tag Factory MS）产品规格说明书.md # 产品规格
│  ├─ 标签工厂设计想法.md    # 设计思路文档
│  ├─ 群体中心功能技术文档.md # 群体中心技术文档
│  └─ 群体中心模拟数据导入说明.md # 群体中心数据导入说明
├─ README.md                 # 部署与运行指南
├─ start_tag_factory.bat     # 一键启动脚本
└─ package-lock.json         # 依赖锁定文件
```

### 常见问题与排查

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

### 部署注意事项

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

### 版本信息
- 系统版本：1.0.0
- 后端框架：FastAPI 0.104+
- 前端框架：Vue 3 + Vite 5+
- 数据库：MySQL 8.0+
- Python：3.9+
- Node.js：18+

### 许可证
保留所有权利。仅供演示和学习使用。
