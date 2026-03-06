@echo off
REM Windows launcher for Minecraft scanner using WSL.
REM Double-clicking this file will start the server and open the browser.

REM directory of the batch file
set scriptDir=%~dp0
REM convert Windows path to WSL path
for /f "delims=" %%i in ('wsl wslpath -a "%scriptDir%"') do set wdir=%%i

echo Starting scanner in WSL directory: %wdir%
wsl -e bash -lc "cd '%wdir%' && ./run.sh"

echo done. Close this window when finished.