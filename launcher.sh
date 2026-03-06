#!/usr/bin/env bash
# Bash-only Minecraft launcher

set -e

echo "Простой лаунчер Minecraft (bash)"

# prompt user for path
read -rp "Введите путь к исполняемому файлу Minecraft: " path

if [[ -z "$path" ]]; then
    echo "Путь не указан. Выход."
    exit 1
fi

if [[ ! -e "$path" ]]; then
    echo "Файл не найден: $path"
    exit 1
fi

if [[ ! -x "$path" ]]; then
    echo "Файл найден, но не является исполняемым. Попытка запустить командой "bash"." >&2
fi

# launch
"$path" "$@" &
