@echo off
chcp 65001 > nul 2>&1

cls
echo 标签工厂管理系统 - 一键启动脚本
echo ===================================
echo.

rem 设置项目目录
set "PROJECT_DIR=%~dp0"
set "BACKEND_DIR=%PROJECT_DIR%backend"
set "FRONTEND_DIR=%PROJECT_DIR%frontend"

echo 项目目录: %PROJECT_DIR%
echo 后端目录: %BACKEND_DIR%
echo 前端目录: %FRONTEND_DIR%
echo.
echo 数据库配置信息:
echo - 主机: localhost
echo - 端口: 3306
echo - 用户名: root
echo - 密码: root
echo - 数据库名: tagfactory
echo.
echo 注意: 请确保MySQL已安装且包含tagfactory数据库，数据库连接参数已配置正确。
echo.
echo 开始启动服务...
echo.

rem 启动MySQL服务
echo 正在启动MySQL服务 (mysql80)...
net start mysql80 > nul 2>&1
if errorlevel 1 (
    echo 警告: MySQL服务启动失败或已在运行中。
    echo 请确认:
    echo 1. MySQL已正确安装
    echo 2. 服务名为mysql80或修改此脚本中的服务名
    echo 3. 已创建tagfactory数据库
    echo 4. 用户名root的密码为root
    rem 短时间延时，让用户能看到警告信息，然后继续执行
    timeout /t 3 > nul
) else (
    echo MySQL服务启动成功！
)

rem 等待MySQL服务初始化
echo 等待MySQL服务初始化...
ping 127.0.0.1 -n 3 > nul

rem 启动后端服务
cd /d "%PROJECT_DIR%"
echo 正在启动后端服务 (FastAPI) ...
echo 服务地址: http://127.0.0.1:8000
echo API文档: http://127.0.0.1:8000/docs
start "后端服务 - TagFactory" cmd /k "python -m uvicorn backend.main:app --reload --port 8000"

rem 等待后端服务启动
echo 等待后端服务初始化...
ping 127.0.0.1 -n 5 > nul

rem 启动前端服务
cd /d "%FRONTEND_DIR%"
echo 正在启动前端服务 (Vue 3 + Vite) ...
echo 服务地址: http://localhost:5173
start "前端服务 - TagFactory" cmd /k "npm run dev"

echo.
echo ==========================================
echo 服务启动完成！
echo ==========================================
echo - MySQL服务: 已尝试启动 (mysql80)
echo - 后端服务地址: http://127.0.0.1:8000
echo - 后端API文档: http://127.0.0.1:8000/docs
echo - 前端服务地址: http://localhost:5173
echo ==========================================
echo 使用说明:
echo 1. 请保持后端和前端服务的命令窗口始终处于打开状态
echo 2. 访问 http://localhost:5173 打开系统界面
echo 3. 在数据页面可查看客户、商家和商品信息
echo 4. 如需停止服务，请关闭相应的命令窗口
rem 移除pause命令，让窗口保持运行状态
rem 等待用户查看信息
echo.
echo 按任意键关闭此窗口（服务将继续运行）...
pause > nul
