#!/bin/bash
# Утилита, которая запускает локальный CGI-сервер, открывает страницу и (по желанию) сразу выполняет сканирование.
# Usage:
#   ./run.sh [IP1 IP2 ...]      # откроет браузер, запустит сервер и просканирует адреса
#   ./run.sh                    # откроет браузер и запустит сервер, без початков

PORT=8000
SERVER_LOG="/tmp/scan_server.log"

start_server() {
    # если сервер уже запущен, ничего не делаем
    if lsof -iTCP:$PORT -sTCP:LISTEN &>/dev/null; then
        echo "CGI server already running on port $PORT"
        return
    fi
    # запускаем сервер в фоновом режиме
    echo "Starting CGI server on port $PORT (log -> $SERVER_LOG)"
    (cd "$(dirname "$0")" && python3 -m http.server --cgi $PORT) &> "$SERVER_LOG" &
    sleep 1
}

open_browser() {
    local url="http://localhost:$PORT/scanner.html"
    echo "Opening $url in default browser..."
    # xdg-open для Linux, open для macOS
    if command -v xdg-open &>/dev/null; then
        xdg-open "$url" &
    elif command -v open &>/dev/null; then
        open "$url" &
    else
        echo "Cannot find a command to open browser. Please open $url manually."
    fi
}

# main
start_server
open_browser

# если переданы аргументы, прогоняем сканер сразу
if [ $# -gt 0 ]; then
    echo "
--- scanning provided addresses: $* ---" 
    ./scan.sh "$@"
fi

echo "run.sh finished. To stop server, kill its PID or use 'pkill -f \"http.server --cgi\"'"