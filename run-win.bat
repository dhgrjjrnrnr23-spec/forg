@echo off
REM Windows launcher (native) for the PowerShell-based scanner.
REM Double-clicking this file will invoke scan-win.ps1.

REM determine script directory and convert to PowerShell path
set scriptDir=%~dp0

powershell -NoProfile -ExecutionPolicy Bypass -File "%scriptDir%scan-win.ps1" %*
