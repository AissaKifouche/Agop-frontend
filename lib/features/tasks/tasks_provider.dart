import 'package:flutter/material.dart';
import 'task.dart';

class TasksProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get pending => _tasks.where((t) => !t.isDone).toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<Task> get done => _tasks.where((t) => t.isDone).toList();

  /*List<Task> forCrop(String cropId) =>
      _tasks.where((t) => t.cropId == cropId).toList();*/

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleDone(String taskId) {
    final t = _tasks.firstWhere((t) => t.id == taskId);
    t.isDone = !t.isDone;
    t.completedAt = t.isDone ? DateTime.now() : null;
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }


  List<Task> get overdue  => _tasks.where((t) => !t.isDone && t.dueDate.isBefore(_today())).toList();
  List<Task> get today    => _tasks.where((t) => !t.isDone && _sameDay(t.dueDate, DateTime.now())).toList();
  List<Task> get thisWeek => _tasks.where((t) => !t.isDone && t.dueDate.isAfter(_today()) && t.dueDate.isBefore(_today().add(const Duration(days: 7)))).toList();
  List<Task> get later    => _tasks.where((t) => !t.isDone && t.dueDate.isAfter(_today().add(const Duration(days: 7)))).toList();
  List<Task> get all      => List.unmodifiable(_tasks);

// Streak: consecutive days with at least 1 completion
  int get streak {
    if (_tasks.every((t) => t.completedAt == null)) return 0;
    int count = 0;
    DateTime day = DateTime.now();
    while (true) {
      final hasCompletion = _tasks.any((t) =>
      t.completedAt != null && _sameDay(t.completedAt!, day));
      if (!hasCompletion) break;
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;


}