@echo off
rem Простой лаунчер Minecraft для Windows (batch)

set /p path="Введите путь к исполняемому файлу Minecraft: "
if "%path%"=="" (
    echo Путь не указан.
    exit /b 1
)

if not exist "%path%" (
    echo Файл не найден: %path%
    exit /b 1
)

rem Запуск
start "" "%path%" %*
