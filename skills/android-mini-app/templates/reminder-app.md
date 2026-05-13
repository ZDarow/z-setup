# Напоминалка — полный код

## Project Structure
```
remindme/
├── lib/
│   ├── main.dart
│   ├── models/reminder.dart
│   ├── services/database_service.dart
│   ├── services/notification_service.dart
│   ├── providers/reminder_provider.dart
│   ├── screens/home_screen.dart
│   ├── screens/add_edit_screen.dart
│   └── widgets/reminder_tile.dart
└── pubspec.yaml
```

## pubspec.yaml
```yaml
name: remindme
description: Simple reminder app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path_provider: ^2.1.0
  intl: ^0.19.0
  provider: ^6.1.0
  flutter_local_notifications: ^17.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
```

## lib/models/reminder.dart
```dart
class Reminder {
  final int? id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool isCompleted;

  Reminder({
    this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'dateTime': dateTime.millisecondsSinceEpoch,
    'isCompleted': isCompleted ? 1 : 0,
  };

  factory Reminder.fromMap(Map<String, dynamic> map) => Reminder(
    id: map['id'] as int?,
    title: map['title'] as String,
    description: map['description'] as String?,
    dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    isCompleted: (map['isCompleted'] as int) == 1,
  );

  Reminder copyWith({
    int? id, String? title, String? description,
    DateTime? dateTime, bool? isCompleted,
  }) => Reminder(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dateTime: dateTime ?? this.dateTime,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}
```

## lib/services/database_service.dart
```dart
import 'package:sqflite/sqflite.dart';
import '../models/reminder.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();
  static Database? _db;

  Future<Database> get db async => _db ??= await _init();

  Future<Database> _init() async {
    final path = await getDatabasesPath();
    return openDatabase(
      '$path/reminders.db',
      version: 1,
      onCreate: (db, v) => db.execute('''
        CREATE TABLE reminders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          dateTime INTEGER NOT NULL,
          isCompleted INTEGER DEFAULT 0
        )
      '''),
    );
  }

  Future<int> insert(Reminder item) =>
    (await db).insert('reminders', item.toMap());

  Future<List<Reminder>> getAll() async {
    final maps = await (await db)
      .query('reminders', orderBy: 'dateTime ASC');
    return maps.map((m) => Reminder.fromMap(m)).toList();
  }

  Future<int> update(Reminder item) =>
    (await db).update('reminders', item.toMap(),
      where: 'id = ?', whereArgs: [item.id]);

  Future<int> delete(int id) =>
    (await db).delete('reminders', where: 'id = ?', whereArgs: [id]);
}
```

## lib/services/notification_service.dart
```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> show(int id, String title, String body, DateTime when) async {
    final android = AndroidNotificationDetails(
      'reminders', 'Reminders',
      channelDescription: 'Reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    await plugin.schedule(
      id, title, body, when,
      NotificationDetails(android: android),
    );
  }

  Future<void> cancel(int id) async => plugin.cancel(id);
  Future<void> cancelAll() async => plugin.cancelAll();
}
```

## lib/providers/reminder_provider.dart
```dart
import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  final _db = DatabaseService.instance;
  final _notif = NotificationService.instance;
  List<Reminder> _items = [];
  bool _loading = true;

  List<Reminder> get items => _items;
  List<Reminder> get pending => _items.where((r) => !r.isCompleted).toList();
  List<Reminder> get completed => _items.where((r) => r.isCompleted).toList();
  bool get loading => _loading;

  Future<void> load() async {
    _items = await _db.getAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Reminder item) async {
    final id = await _db.insert(item);
    _items.add(item.copyWith(id: id));
    await _notif.show(id, item.title, item.description ?? '', item.dateTime);
    notifyListeners();
  }

  Future<void> toggle(Reminder item) async {
    final updated = item.copyWith(isCompleted: !item.isCompleted);
    await _db.update(updated);
    if (updated.isCompleted) await _notif.cancel(item.id!);
    await load();
  }

  Future<void> remove(Reminder item) async {
    await _db.delete(item.id!);
    await _notif.cancel(item.id!);
    await load();
  }
}
```

## lib/screens/home_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_tile.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        centerTitle: true,
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none,
                    size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text('No reminders yet',
                    style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Tap + to create one',
                    style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.items.length,
            itemBuilder: (context, i) => ReminderTile(
              reminder: provider.items[i],
              dateFormat: DateFormat.MMMd().add_jm(),
              onToggle: () => provider.toggle(provider.items[i]),
              onDelete: () => provider.remove(provider.items[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AddEditScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## lib/screens/add_edit_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';
import '../providers/reminder_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Reminder? reminder;
  const AddEditScreen({super.key, this.reminder});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.reminder?.dateTime ?? DateTime.now().add(const Duration(hours: 1));
    if (widget.reminder != null) {
      _titleCtrl.text = widget.reminder!.title;
      _descCtrl.text = widget.reminder!.description ?? '';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null) return;
    setState(() => _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    final reminder = Reminder(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      dateTime: _dateTime,
    );
    await context.read<ReminderProvider>().add(reminder);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reminder == null ? 'New Reminder' : 'Edit Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('Date & Time'),
              subtitle: Text(DateFormat.yMMMd().add_jm().format(_dateTime)),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _pickDateTime,
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## lib/widgets/reminder_tile.dart
```dart
import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final DateFormat dateFormat;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ReminderTile({
    super.key,
    required this.reminder,
    required this.dateFormat,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = !reminder.isCompleted && reminder.dateTime.isBefore(DateTime.now());
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          reminder.isCompleted ? Icons.check_circle : (overdue ? Icons.warning : Icons.circle_outlined),
          color: reminder.isCompleted
            ? Colors.green
            : (overdue ? Colors.red : Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          reminder.title,
          style: TextStyle(
            decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (reminder.description != null)
              Text(reminder.description!, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(dateFormat.format(reminder.dateTime)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
        onTap: onToggle,
      ),
    );
  }
}
```

## lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'providers/reminder_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const RemindMeApp());
}

class RemindMeApp extends StatelessWidget {
  const RemindMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReminderProvider()..load(),
      child: MaterialApp(
        title: 'RemindMe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
```

## Build & Run
```bash
cd remindme
flutter pub get
flutter run                    # на устройстве
flutter build apk --debug      # сборка APK
```
