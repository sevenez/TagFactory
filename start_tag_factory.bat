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
echo 注意: 跳过版本检查和依赖安装，假设环境已配置完成。
echo.
echo 开始启动服务...
echo.

rem 启动MySQL服务
echo 正在启动MySQL服务 (mysql80)...
net start mysql80 > nul 2>&1
if errorlevel 1 (
    echo 警告: MySQL服务启动失败或已在运行中。请确认MySQL已正确安装且服务名为mysql80。
    rem 短时间延时，让用户能看到警告信息，然后继续执行
    timeout /t 2 > nul
) else (
    echo MySQL服务启动成功！
)

rem 等待MySQL服务初始化
ping 127.0.0.1 -n 2 > nul

rem 启动后端服务
cd /d "%PROJECT_DIR%"
echo 正在启动后端服务 (FastAPI) ...
start "后端服务 - TagFactory" cmd /k "python -m uvicorn backend.main:app --reload --port 8000"

rem 等待后端服务启动
ping 127.0.0.1 -n 3 > nul

rem 启动前端服务
cd /d "%FRONTEND_DIR%"
echo 正在启动前端服务 (Vue 3 + Vite) ...
start "前端服务 - TagFactory" cmd /k "npm run dev"

echo.
echo ==========================================
echo 服务启动完成！
echo - MySQL服务: 已启动 (mysql80)
echo - 后端服务地址: http://127.0.0.1:8000
echo - 后端API文档: http://127.0.0.1:8000/docs
echo - 前端服务地址: http://localhost:5173
echo ==========================================
echo 提示：请保持新的两个命令窗口，始终处于打开状态。
echo 提示：本窗口可以关闭，服务将继续运行。
rem 移除pause命令，让窗口保持运行状态
