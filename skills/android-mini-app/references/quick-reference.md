# Quick Reference — Flutter Mini-App Components

## Material 3 Theme
```dart
theme: ThemeData(
  colorSchemeSeed: Colors.teal,
  useMaterial3: true,
  brightness: Brightness.light,   // or dark
  cardTheme: CardTheme(elevation: 0, shape: RoundedRectangleBorder(...)),
  inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
)
```

## State Management Comparison
| Size | Solution | When |
|------|----------|------|
| 1 screen | `setState` | Simplest timer, counter |
| 2-3 screens | `Provider` + `ChangeNotifier` | Most mini-apps |
| 3+ screens, complex | `Riverpod` | When testing matters |
| Real-time | `Riverpod` + `StreamProvider` | Timers, sensors |

## Common Widgets

### Empty State
```dart
Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 80, color: theme.colorScheme.primary.withOpacity(0.3)),
      gap16,
      Text('No items', style: theme.textTheme.titleMedium),
      gap8,
      Text('Tap + to add', style: theme.textTheme.bodyMedium),
    ],
  ),
)
```

### Loading State
```dart
FutureBuilder<List<Item>>(
  future: loadItems(),
  builder: (context, snap) {
    if (snap.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
    return ListView(children: snap.data!.map((i) => ItemTile(i)).toList());
  },
)
```

### Date/Time Picker
```dart
Future<void> pickDateTime(BuildContext context, DateTime initial) async {
  final date = await showDatePicker(
    context: context, initialDate: initial,
    firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)),
  );
  if (date == null) return;
  final time = await showTimePicker(
    context: context, initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
```

### Dismissible (swipe to delete)
```dart
Dismissible(
  key: ValueKey(item.id),
  direction: DismissDirection.endToStart,
  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 16), child: Icon(Icons.delete, color: Colors.white)),
  onDismissed: (_) => provider.remove(item),
  child: ListTile(title: Text(item.title)),
)
```

### ReorderableListView
```dart
ReorderableListView(
  children: items.map((i) => ItemTile(i, key: ValueKey(i.id))).toList(),
  onReorder: (oldIndex, newIndex) => provider.reorder(oldIndex, newIndex),
)
```

### Dialog Confirmation
```dart
Future<bool> confirmDelete(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete?'),
      content: Text('This cannot be undone'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
      ],
    ),
  ) ?? false;
}
```

## Permissions Pattern (Android 13+)
```dart
// In main.dart or init
if (Platform.isAndroid) {
  final status = await FlutterLocalNotificationsPlugin()
    .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
}
```

## SQLite CRUD Patterns
```dart
// Insert
Future<int> insert(Item item) => (await db).insert(table, item.toMap());

// Read all
Future<List<Item>> getAll() async {
  final maps = await (await db).query(table, orderBy: 'createdAt DESC');
  return maps.map((m) => Item.fromMap(m)).toList();
}

// Update
Future<int> update(Item item) => (await db).update(table, item.toMap(),
  where: 'id = ?', whereArgs: [item.id]);

// Delete
Future<int> delete(int id) => (await db).delete(table,
  where: 'id = ?', whereArgs: [id]);
```

## pubspec.yaml Template
```yaml
name: myapp
description: Mini app
publish_to: 'none'
version: 1.0.0+1
environment:
  sdk: ^3.0.0
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  provider: ^6.1.0
  intl: ^0.19.0
  shared_preferences: ^2.2.0
flutter:
  uses-material-design: true
```
