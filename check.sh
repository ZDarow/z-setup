#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENCEDE_DIR="$HOME/.config/opencode"

echo "🔍 Проверка установки OpenCode Setup..."
echo "======================================"

# Проверка конфигурации
if [ -f "$OPENCEDE_DIR/opencode.json" ]; then
    echo "✅ opencode.json: установлен"
else
    echo "❌ opencode.json: не найден"
fi

if [ -f "$OPENCEDE_DIR/tui.json" ]; then
    echo "✅ tui.json: установлен"
else
    echo "❌ tui.json: не найден"
fi

# Проверка количества навыков
if [ -d "$OPENCEDE_DIR/skills" ]; then
    SKILL_COUNT=$(ls -1 "$OPENCEDE_DIR/skills" 2>/dev/null | wc -l)
    echo "✅ Навыки: $SKILL_COUNT шт."
else
    echo "❌ Навыки: директория не найдена"
fi

# Проверка агентов
if [ -d "$OPENCEDE_DIR/agents" ]; then
    AGENT_COUNT=$(ls -1 "$OPENCEDE_DIR/agents" 2>/dev/null | wc -l)
    echo "✅ Агенты: $AGENT_COUNT шт."
else
    echo "❌ Агенты: директория не найдена"
fi

# Проверка команд
if [ -d "$OPENCEDE_DIR/commands" ]; then
    CMD_COUNT=$(ls -1 "$OPENCEDE_DIR/commands" 2>/dev/null | wc -l)
    echo "✅ Команды: $CMD_COUNT шт."
else
    echo "❌ Команды: директория не найдена"
fi

echo ""
echo "📍 Расположение: $OPENCEDE_DIR"
