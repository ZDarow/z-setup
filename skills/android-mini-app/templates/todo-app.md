# Todo App — базовый шаблон

## Отличия от напоминалки
- Нет даты/времени (или опционально)
- Нет уведомлений
- Есть категории/теги
- Drag-to-reorder

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  provider: ^6.1.0
```

## lib/models/todo.dart
```dart
class Todo {
  final int? id;
  final String title;
  final String? category;
  final bool isDone;
  final int sortOrder;
  final DateTime createdAt;

  Todo({...});

  Map<String, dynamic> toMap() => {...};

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(...);

  Todo copyWith({...}) => Todo(...);
}
```

## lib/services/database_service.dart
```dart
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  category TEXT,
  isDone INTEGER DEFAULT 0,
  sortOrder INTEGER DEFAULT 0,
  createdAt INTEGER NOT NULL
)
```

## lib/screens/home_screen.dart
- ReorderableListView
- Swipe-to-delete (Dismissible)
- Filter: All / Active / Done
- Category filter chips

## lib/main.dart
```dart
// Same pattern as RemindMe, without notification init
```
