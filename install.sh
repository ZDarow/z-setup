#!/bin/bash
set -e

OPENCEDE_DIR="$HOME/.config/opencode"
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Установка OpenCode Setup..."
echo "=========================="

# Создание директорий
mkdir -p "$OPENCEDE_DIR/skills"
mkdir -p "$OPENCEDE_DIR/agents"
mkdir -p "$OPENCEDE_DIR/commands"
mkdir -p "$OPENCEDE_DIR/docs"

# Резервное копирование существующих настроек
if [ -f "$OPENCEDE_DIR/opencode.json" ]; then
    cp "$OPENCEDE_DIR/opencode.json" "$OPENCEDE_DIR/opencode.json.backup"
    echo "✅ Создана резервная копия opencode.json"
fi

# Копирование файлов
echo "📦 Копирование конфигураций..."
cp "$PROJECT_DIR/opencode.json" "$OPENCEDE_DIR/"
cp "$PROJECT_DIR/tui.json" "$OPENCEDE_DIR/"
cp "$PROJECT_DIR/AGENTS.md" "$OPENCEDE_DIR/"

echo "🎯 Копирование навыков (90+)..."
cp -r "$PROJECT_DIR/skills/"* "$OPENCEDE_DIR/skills/"

echo "🤖 Копирование агентов (35)..."
cp -r "$PROJECT_DIR/agents/"* "$OPENCEDE_DIR/agents/"

echo "⌨️ Копирование команд (43)..."
cp -r "$PROJECT_DIR/commands/"* "$OPENCEDE_DIR/commands/"

echo "📚 Копирование документации..."
cp -r "$PROJECT_DIR/docs/"* "$OPENCEDE_DIR/docs/" 2>/dev/null || true

echo "✅ Установка завершена!"
echo "Перезапустите OpenCode для применения изменений."
