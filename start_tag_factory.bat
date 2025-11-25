@echo off
chcp 65001 > nul 2>&1

cls
echo Tag Factory Management System

echo Starting MySQL service...
net start mysql80 > nul 2>&1
if errorlevel 1 (
    echo Warning: MySQL service start failed or already running.
    echo Please ensure MySQL is installed and configured correctly.
)

ping 127.0.0.1 -n 3 > nul

echo Starting main backend service...
start "Main Backend" cmd /k "python -m uvicorn backend.main:app --reload --port 8000"

ping 127.0.0.1 -n 3 > nul

echo Starting fixed backend service...
start "Fixed Backend" cmd /k "python backend/fixed_server.py"

ping 127.0.0.1 -n 5 > nul

cd frontend
echo Starting frontend service...
start "Frontend" cmd /k "npm run dev"

echo.
echo Services started!
echo Main Backend: http://127.0.0.1:8000
echo Fixed Backend: http://localhost:8002
echo Frontend: http://localhost:5173
echo.
echo Press any key to close...