@echo off
setlocal enabledelayedexpansion

REM Minecraft Launcher (Windows BAT version)
REM Запускает bash скрипт launcher.sh через Git Bash или WSL
REM

title Minecraft Launcher

cls

echo.
echo   ╔════════════════════════════════╗
echo   ║   ⛏️  Minecraft Launcher       ║
echo   ║      (Windows .bat version)    ║
echo   ╚════════════════════════════════╝
echo.

REM Получаем директорию скрипта
set "SCRIPT_DIR=%~dp0"
set "LAUNCHER_SCRIPT=%SCRIPT_DIR%launcher.sh"

REM Проверяем наличие launcher.sh
if not exist "%LAUNCHER_SCRIPT%" (
    echo [ERROR] Файл launcher.sh не найден в директории %SCRIPT_DIR%
    echo.
    pause
    exit /b 1
)

REM Пытаемся найти Git Bash
set "GIT_BASH="
for /f "tokens=*" %%A in ('where bash 2^>nul') do set "GIT_BASH=%%A"

REM Если Git Bash не найденный, пытаемся найти в стандартных локациях
if "!GIT_BASH!"=="" (
    if exist "C:\Program Files\Git\bin\bash.exe" (
        set "GIT_BASH=C:\Program Files\Git\bin\bash.exe"
    ) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
        set "GIT_BASH=C:\Program Files (x86)\Git\bin\bash.exe"
    ) else if exist "%USERPROFILE%\scoop\apps\git\current\bin\bash.exe" (
        set "GIT_BASH=%USERPROFILE%\scoop\apps\git\current\bin\bash.exe"
    ) else if exist "C:\Program Files\Git for Windows\bin\bash.exe" (
        set "GIT_BASH=C:\Program Files\Git for Windows\bin\bash.exe"
    )
)

REM Проверяем WSL как альтернатива
set "USE_WSL=0"
if "!GIT_BASH!"=="" (
    where wsl >nul 2>&1
    if !errorlevel! equ 0 (
        echo [INFO] Git Bash не найден. Используем WSL...
        set "USE_WSL=1"
    ) else (
        echo [ERROR] Не найден ни Git Bash, ни WSL
        echo.
        echo Установите одно из:
        echo   1. Git for Windows: https://git-scm.com/download/win
        echo   2. Windows Subsystem for Linux (WSL): https://docs.microsoft.com/windows/wsl
        echo.
        pause
        exit /b 1
    )
)

echo [INFO] Запуск лаунчера...
echo.

REM Запускаем скрипт
if !USE_WSL! equ 1 (
    REM Конвертируем путь Windows в WSL формат
    for /f "tokens=*" %%A in ('wsl wslpath -a "%LAUNCHER_SCRIPT%"') do set "WSL_PATH=%%A"
    wsl bash "!WSL_PATH!" %*
) else (
    REM Используем Git Bash
    "!GIT_BASH!" "%LAUNCHER_SCRIPT%" %*
)

set "EXIT_CODE=!errorlevel!"

if !EXIT_CODE! neq 0 (
    echo.
    echo [ERROR] Лаунчер завершился с ошибкой %EXIT_CODE%
    pause
)

exit /b !EXIT_CODE!
