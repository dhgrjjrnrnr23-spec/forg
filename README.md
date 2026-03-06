# 🎮 Minecraft Launcher

Многоплатформенный лаунчер Minecraft на **Bash**, **HTML/JavaScript**, и **Python**.

> **Лаунчер не устанавливает Minecraft.** Он только запускает уже имеющуюся копию игры.

---

## 📋 Доступные версии

| Файл | Язык | Назначение | Требования |
|------|------|-----------|-----------|
| `launcher.sh` | Bash | Запуск из терминала (Linux/Mac/WSL) | Bash, Java (для JAR) |
| `launcher.bat` | Windows Batch | Запуск на Windows | Git Bash или WSL |
| `launcher.html` | HTML/JavaScript | Веб-интерфейс | Браузер |

---

## 🚀 Как использовать

### 1️⃣ **Bash версия** (Linux/Mac/WSL)

```bash
chmod +x launcher.sh
./launcher.sh
```

- **Автодетект**: если Minecraft лежит в той же папке, запустится автоматически
- **Интерактивный ввод**: если не найден, попросит путь
- **Поддержка**: JAR, EXE, бинарники

**Примеры:**
```bash
# С автодетектом
./launcher.sh

# С явным путем
./launcher.sh "/path/to/minecraft.jar"

# С аргументами для игры
./launcher.sh "/path/to/minecraft" --server myserver.com
```

### 2️⃣ **Windows версия** (.bat)

```bash
launcher.bat
```

Или двойной клик по файлу. Автоматически найдет Git Bash или WSL.

### 3️⃣ **Веб-версия** (HTML)

Откройте `launcher.html` в браузере:

```bash
# Linux/Mac
open launcher.html
xdg-open launcher.html

# Windows
start launcher.html
```

**Особенности:**
- Красивый интерфейс
- Сохранение недавних файлов (localStorage)
- Цветные статус-сообщения



### Запуск «кликом»

Если вы хотите просто дважды нажать на иконку, а не запускать скрипт вручную:

1. Убедитесь, что `launcher.sh` исполняемый (`chmod +x launcher.sh`).
2. Отредактируйте или создайте файл `launcher.desktop` (пример в репозитории) и укажите полный путь к `launcher.sh` в строке `Exec=`.
3. Поместите `launcher.desktop` на рабочий стол или в `~/.local/share/applications/` и сделайте его исполняемым (`chmod +x launcher.desktop`).
4. Двойной клик по иконке вызовет скрипт; затем он запросит путь к Minecraft и запустит игру.

В некоторых окружениях можно записать путь прямо внутрь `launcher.sh`, тогда клик сразу запустит Minecraft.
### Вариант на JavaScript (Electron)

Проект содержит простое приложение на [Electron](https://www.electronjs.org/).
Оно запускает графическое окно с полем для пути и кнопками «Выбрать»/«Запустить».

Собрать и запустить:

```bash
cd electron-launcher
npm install
npm start
```

Это работает как на Linux, так и на Windows и macOS (требуется Node.js).

Исходники находятся в `electron-launcher/`:

- `main.js` – основной процесс, управляет окном и вызывает `child_process` для старта игры
- `preload.js`, `renderer.js` и `index.html` – интерфейс
- `package.json` – зависимости и скрипт старта
## Примечание

- **Лаунчер не устанавливает Minecraft.** Он только запускает уже имеющуюся копию игры. Сначала установите Minecraft через официальный сай
til, пакетный менеджер или другой удобный способ, а затем укажите путь к её исполняемому файлу.
- Лаунчер не управляет версиями и не выполняет авторизацию.
- Работает на Unix-подобных системах; под Windows можно запустить через WSL или Git Bash.

## Версия для Windows

Для пользователей Windows добавлен пакетный скрипт `launcher.bat`, который делает то же самое, но без необходимости Bash:

```bat
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
```

Запустите двойным кликом или из командной строки, укажите путь и игра стартует.
