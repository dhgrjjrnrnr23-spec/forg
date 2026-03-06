#!/bin/bash
# Простой скрипт для проверки доступности Minecraft серверов по IP
# Требует утилиты "nc" (netcat) или "timeout" с nc

# Если мы получили адреса из stdin или формы CGI, разбираем их
if [ -n "$QUERY_STRING" ]; then
    # Разбор параметров form-data для CGI
    targets=$(echo "$QUERY_STRING" | sed -e 's/^targets=//' -e 's/%20/ /g' -e 's/+//g' -e 's/&.*//')
else
    targets="$*"
fi

# Преобразуем список в массив (разделители пробелы, запятые и новые строки)
IFS=$' ,\n' read -ra ADDR <<< "$targets"

# Функция проверки
check_ip() {
    local ip=$1
    # Minecraft использует порт 25565 по умолчанию
    if timeout 1 bash -c "</dev/tcp/$ip/25565" &>/dev/null; then
        echo "$ip: открыт порт 25565 (может работать Minecraft сервер)"
    else
        echo "$ip: порт 25565 недоступен"
    fi
}

# Вывод заголовков CGI, если скрипт вызывается из веба
if [ -n "$REQUEST_METHOD" ]; then
    echo "Content-Type: text/plain; charset=utf-8"
    echo
fi

# Пробег по всем адресам
for ip in "${ADDR[@]}"; do
    [ -z "$ip" ] && continue
    check_ip "$ip"
done
