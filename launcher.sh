#!/usr/bin/env bash
#
# Minecraft Launcher (Bash версия)
# Поддерживает: .jar файлы, исполняемые файлы (.exe, бинарники), скрипты
# Использование: ./launcher.sh [путь_к_минекрафту] [аргументы]
#

set -o pipefail

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Логирование
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

# Заголовок
print_header() {
    echo -e "${BLUE}╔════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   ⛏️  Minecraft Launcher       ║${NC}"
    echo -e "${BLUE}║      (Bash version)            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════╝${NC}"
    echo
}

# Проверка файла
check_file() {
    local file="$1"
    
    if [[ ! -e "$file" ]]; then
        log_error "Файл не найден: $file"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        log_error "Это не файл: $file"
        return 1
    fi
    
    return 0
}

# Определение типа файла и запуск
launch_file() {
    local filepath="$1"
    shift  # Оставшиеся аргументы - параметры для запуска
    local args=("$@")
    
    if ! check_file "$filepath"; then
        return 1
    fi
    
    local filename=$(basename "$filepath")
    local extension="${filename##*.}"
    
    log_info "Запуск: $filename"
    
    case "$extension" in
        jar)
            # Java JAR файл
            if ! command -v java &> /dev/null; then
                log_error "Java не установлена. Установите Java JRE или JDK."
                return 1
            fi
            log_info "Обнаружен JAR файл. Запуск через Java..."
            java -jar "$filepath" "${args[@]}" &
            ;;
        exe)
            # Windows EXE или другие исполняемые файлы
            if command -v wine &> /dev/null; then
                log_info "Обнаружен .exe файл. Запуск через Wine (если доступно)..."
                wine "$filepath" "${args[@]}" &
            else
                log_warn "Wine не установлен. Попытка прямого запуска..."
                chmod +x "$filepath" 2>/dev/null || true
                "$filepath" "${args[@]}" &
            fi
            ;;
        *)
            # Прочие исполняемые файлы
            if [[ -x "$filepath" ]]; then
                log_info "Файл уже исполняемый. Запуск..."
                "$filepath" "${args[@]}" &
            else
                log_warn "Файл не имеет прав на выполнение. Добавляю права..."
                chmod +x "$filepath"
                "$filepath" "${args[@]}" &
            fi
            ;;
    esac
    
    local pid=$!
    log_success "Процесс запущен (PID: $pid)"
    
    # Опционально: ждать завершения (разкомментировать если нужно)
    # wait $pid
    # log_info "Процесс завершен со статусом: $?"
}

# Поиск Minecraft в текущей директории
auto_detect() {
    log_info "Поиск Minecraft в текущей директории..."
    
    local candidates=(
        "minecraft"
        "Minecraft.jar"
        "minecraft.jar"
        "MinecraftLauncher"
        "MinecraftLauncher.exe"
        "./minecraft"
        "./Minecraft"
    )
    
    for candidate in "${candidates[@]}"; do
        if [[ -e "$candidate" ]]; then
            log_success "Обнаружен: $candidate"
            echo "$candidate"
            return 0
        fi
    done
    
    return 1
}

# Главная функция
main() {
    print_header
    
    local filepath=""
    
    # Если путь передан как аргумент
    if [[ $# -gt 0 ]]; then
        filepath="$1"
        shift
        local args=("$@")
    else
        # Попытка автоматического обнаружения
        if filepath=$(auto_detect); then
            log_info "Автодетект прошел успешно подготовка к запуску..."
            local args=()
        else
            # Интерактивный ввод
            log_warn "Файл не найден в текущей директории."
            echo
            read -rp "$(echo -e ${BLUE})Введите путь к исполняемому файлу Minecraft:$(echo -e ${NC}) " filepath
            echo
            
            if [[ -z "$filepath" ]]; then
                log_error "Путь не указан."
                return 1
            fi
            
            local args=()
        fi
    fi
    
    # Путь может находиться в кавычках
    filepath="${filepath%\"}"
    filepath="${filepath#\"}"
    
    # Запуск
    if launch_file "$filepath" "${args[@]}"; then
        log_success "Лаунчер завершил работу успешно."
        return 0
    else
        log_error "Ошибка при запуске файла."
        return 1
    fi
}

# Запуск
main "$@"
exit $?

