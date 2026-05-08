---
name: vscode-setup
description: Настройка VS Code для проекта, анализ плагинов и создание стартовой документации
---

## What I do

- Анализирую структуру проекта и определяю нужные расширения VS Code
- Проверяю установленные плагины и сравниваю с рекомендуемыми для данного стека
- Выявляю отсутствующие расширения (форматтеры, линтеры, дебаггеры, LSP)
- Оцениваю состояние проекта: готовность к разработке, технический долг, покрытие тестами, наличие документации
- Создаю `.vscode/extensions.json` с рекомендациями
- Настраиваю `.vscode/settings.json` под проект
- Создаю `.vscode/launch.json` для отладки
- Предлагаю варианты развития проекта на основе стека
- Генерирую стартовую документацию (README.md, CONTRIBUTING.md)
- Создаю `.vscode/tasks.json` для часто используемых задач (build, test, lint)
- Настраиваю отладку и точки останова через `launch.json`
- Проверяю наличие `.editorconfig` и создаю его при необходимости
- Настраиваю форматирование кода (Prettier, ESLint и др.) под проект
- Создаю `.gitignore` и `.env.example`, если их нет
- Проверяю структуру папок и предлагаю оптимальную организацию
- Настраиваю сниппеты и шорткаты для ускорения работы

## How to work autonomously

1. Используй `bash` с командой `code --list-extensions` для получения списка установленных расширений
2. Анализируй стек проекта (package.json, requirements.txt и др.) и определи нужные расширения
3. Используй `bash` с командой `code --install-extension <id>` для установки отсутствующих расширений
4. Создай `.vscode/extensions.json` с рекомендациями для команды
5. Настрой `.vscode/settings.json` для форматирования, линтеров и LSP
6. Создай необходимые конфигурационные файлы (.editorconfig, .gitignore и др.)

## When to use me

Используй при открытии нового проекта в VS Code, когда нужно быстро настроить окружение, установить нужные плагины и подготовить документацию.

## VS Code CLI Commands

### Extension Management
```bash
# Список установленных расширений
code --list-extensions

# Установка расширения
code --install-extension ms-python.python

# Удаление расширения
code --uninstall-extension ms-python.python

# Проверка конкретного расширения
code --list-extensions | grep "python"
```

### Workspace Setup
```bash
# Открыть папку в VS Code
code /path/to/project

# Установить ассоциацию файлов
code --add /path/to/file.txt

# Создать новое окно
code --new-window
```

## Configuration Templates

### .vscode/extensions.json
```json
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint"
  ],
  "unwantedRecommendations": [
    "some.extension-to-avoid"
  ]
}
```

### .vscode/settings.json
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "python.formatting.provider": "black",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "typescript.preferences.preferTypeOnlyAutoImports": true
}
```

### .vscode/launch.json
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "program": "${workspaceFolder}/app.js"
    },
    {
      "type": "python",
      "request": "launch",
      "name": "Python: Current File",
      "program": "${file}"
    }
  ]
}
```

### .vscode/tasks.json
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "type": "shell",
      "command": "npm run build",
      "group": "build"
    },
    {
      "label": "test",
      "type": "shell",
      "command": "npm test",
      "group": "test"
    }
  ]
}
```

## Project Analysis Checklist

### Technology Stack Detection
- **Node.js**: package.json → рекомендую Node.js расширения
- **Python**: requirements.txt, pyproject.toml → Python расширения
- **Java**: pom.xml, build.gradle → Java расширения
- **C#**: *.csproj → C# расширения

### Project Health Assessment
- [ ] Есть ли README.md?
- [ ] Есть ли .gitignore?
- [ ] Настроен ли линтер/форматтер?
- [ ] Есть ли тесты и покрытие?
- [ ] Настроен ли CI/CD?
- [ ] Есть ли документация API?

## Recommended Extensions by Stack

### JavaScript/TypeScript
- `dbaeumer.vscode-eslint` - ESLint
- `esbenp.prettier-vscode` - Prettier
- `ms-typescript.vscode-typescript-next` - TypeScript

### Python
- `ms-python.python` - Python
- `ms-python.vscode-pylance` - Pylance
- `ms-python.black-formatter` - Black

### Java
- `redhat.java` - Language Support
- `vscjava.vscode-java-debug` - Debugger
- `vscjava.vscode-maven` - Maven

### C#/.NET
- `ms-dotnettools.csdev-kit` - C# Dev Kit
- `ms-dotnettools.vscode-dotnet-runtime` - Runtime

## Output Templates

When setting up VS Code, provide:

1. **Extensions analysis** - what's installed vs. what's needed
2. **Configuration files** - ready-to-use JSON files
3. **Project health report** - assessment of documentation, tests, tooling
4. **Next steps** - recommended actions with priorities
5. **Automation scripts** - bash commands for batch extension installation
