# Таймер / Pomodoro Timer — шаблон

## Без базы данных (SharedPreferences + Dart Timer)
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.0
  provider: ^6.1.0
```

## lib/services/timer_service.dart
```dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  int _remaining = 0;     // seconds
  int _total = 0;         // configured duration
  bool _isRunning = false;
  TimerMode _mode = TimerMode.pomodoro;

  static const pomodoroDuration = 25 * 60;  // 25 min
  static const breakDuration = 5 * 60;      // 5 min

  int get remaining => _remaining;
  int get total => _total;
  bool get isRunning => _isRunning;
  TimerMode get mode => _mode;
  double get progress => _total > 0 ? 1 - (_remaining / _total) : 0;

  String get formatted {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void start({int? seconds}) {
    if (seconds != null) { _total = seconds; _remaining = seconds; }
    _timer?.cancel();
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > 0) { _remaining--; notifyListeners(); }
      else { _timer?.cancel(); _isRunning = false; notifyListeners(); }
    });
    notifyListeners();
  }

  void pause() { _timer?.cancel(); _isRunning = false; notifyListeners(); }

  void reset() { _timer?.cancel(); _remaining = _total; _isRunning = false; notifyListeners(); }

  void setMode(TimerMode mode) {
    _mode = mode;
    _total = mode == TimerMode.pomodoro ? pomodoroDuration : breakDuration;
    _remaining = _total;
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }
}

enum TimerMode { pomodoro, break_ }
```

## lib/screens/home_screen.dart
```dart
// CircularProgressIndicator as timer face
// Center text: formatted time
// Buttons: Start/Pause, Reset
// Mode toggle: Pomodoro / Break
```

## lib/main.dart
```dart
// Same ChangeNotifierProvider pattern
// No DB init needed
```
