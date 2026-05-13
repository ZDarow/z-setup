#!/bin/bash
set -e

OPENCEDE_DIR="$HOME/.config/opencode"

echo "🗑️ Удаление OpenCode Setup..."
echo "=========================="

# Восстановление резервной копии
if [ -f "$OPENCEDE_DIR/opencode.json.backup" ]; then
    mv "$OPENCEDE_DIR/opencode.json.backup" "$OPENCEDE_DIR/opencode.json"
    echo "✅ Восстановлена резервная копия opencode.json"
fi

# Удаление установленных компонентов
echo "📦 Удаление навыков..."
rm -rf "$OPENCEDE_DIR/skills/"* 2>/dev/null || true

echo "🤖 Удаление агентов..."
rm -rf "$OPENCEDE_DIR/agents/"* 2>/dev/null || true

echo "⌨️ Удаление команд..."
rm -rf "$OPENCEDE_DIR/commands/"* 2>/dev/null || true

echo "📚 Удаление документации..."
rm -rf "$OPENCEDE_DIR/docs/" 2>/dev/null || true

echo "✅ Удаление завершено!"
echo "Перезапустите OpenCode."
