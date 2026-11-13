@echo off
cd /d "%~dp0"
echo ============================================
echo  Setting up the Python environment (uv sync)
echo ============================================
uv sync
if errorlevel 1 (
  echo.
  echo [ERROR] uv sync failed. Check that uv is installed and try again.
  pause
  exit /b 1
)
if not exist .env (
  copy .env.example .env >nul
  echo.
  echo Created .env  ^<-- open it and paste your MotherDuck token
)
echo.
echo Done! Open this folder in VS Code and run notebooks\02_clean.ipynb
pause
