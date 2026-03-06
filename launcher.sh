#!/usr/bin/env bash
# Bash-only Minecraft launcher (auto-detect in folder)

set -e

echo "Простой лаунчер Minecraft (bash)"

# если рядом с скриптом лежит исполняемый Minecraft, запускаем его без запроса
for candidate in "minecraft" "Minecraft.jar" "MinecraftLauncher.exe"; do
    if [[ -e "$candidate" ]]; then
        echo "Найден файл '$candidate' в текущей директории. Запускаем его."
        if [[ "$candidate" == *.jar ]]; then
            java -jar "$candidate" "$@" &
        else
            chmod +x "$candidate" 2>/dev/null || true
            "./$candidate" "$@" &
        fi
        exit 0
    fi
done

# prompt user for path if ничего не найдено
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
    echo "Файл найден, но не является исполняемым. Попытка запустить командой \"bash\"." >&2
fi

# launch
"$path" "$@" &

