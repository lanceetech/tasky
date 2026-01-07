
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');
  List<Task> _tasks = [];

  TaskProvider() {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks => _tasks.where((task) => !task.isDone).toList();

  List<Task> get completedTasks => _tasks.where((task) => task.isDone).toList();

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    notifyListeners();
  }

  void addTask(String title, Duration duration) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      duration: duration,
    );
    _taskBox.put(newTask.id, newTask);
    _loadTasks();
  }

  void toggleTaskStatus(String id) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.isDone = !task.isDone;
      if (task.isDone) {
        pauseTimer(id);
      }
      task.save();
      _loadTasks();
    }
  }

  void editTask(String id, String newTitle, Duration newDuration) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.title = newTitle;
      task.duration = newDuration;
      task.remainingTime = newDuration;
      task.save();
      _loadTasks();
    }
  }

  void deleteTask(String id) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.timer?.cancel();
      _taskBox.delete(id);
      _loadTasks();
    }
  }

  void startTimer(String id) {
    final task = _taskBox.get(id);
    if (task != null && task.timer == null && !task.isDone) {
      task.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (task.remainingTime.inSeconds > 0) {
          task.remainingTime -= const Duration(seconds: 1);
          task.save();
          notifyListeners();
        } else {
          timer.cancel();
          task.timer = null;
          task.isDone = true;
          task.save();
          notifyListeners();
        }
      });
    }
  }

  void pauseTimer(String id) {
    final task = _taskBox.get(id);
    if (task != null && task.timer != null) {
      task.timer!.cancel();
      task.timer = null;
      task.save();
      notifyListeners();
    }
  }

  void resetTimer(String id) {
    final task = _taskBox.get(id);
    if (task != null) {
      task.timer?.cancel();
      task.timer = null;
      task.remainingTime = task.duration;
      task.save();
      notifyListeners();
    }
  }
}
