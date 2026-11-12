@echo off
chcp 65001 >nul
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"
set "PYTHON_EXE="

REM 1) Official portable runtime, if one is bundled next to this script
if exist "%SCRIPT_DIR%\runtime\python.exe" (
    set "PYTHON_EXE=%SCRIPT_DIR%\runtime\python.exe"
)

REM 2) Otherwise, try activating a conda env named "vc" (no-op if conda isn't on PATH)
if not defined PYTHON_EXE (
    call conda activate vc >nul 2>&1
)

REM 3) Resolve whatever "python" now points to on PATH (post-activation, or system default)
if not defined PYTHON_EXE (
    for /f "delims=" %%P in ('where python 2^>nul') do (
        if not defined PYTHON_EXE set "PYTHON_EXE=%%P"
    )
)

if not defined PYTHON_EXE (
    echo [ERROR] Could not find a Python interpreter.
    echo Activate your RVC conda/venv environment before running this script,
    echo or place a portable Python distribution at "%SCRIPT_DIR%\runtime\python.exe".
    pause
    exit /b 1
)

set "GRADIO_ANALYTICS_ENABLED=False"
set "NO_PROXY=localhost,127.0.0.1,::1,%NO_PROXY%"
echo First launch may take about 20 seconds, please be patient.
echo Using Python: %PYTHON_EXE%
"%PYTHON_EXE%" webui.py --pycmd "%PYTHON_EXE%" --port 7897
pause
