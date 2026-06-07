import 'package:flutter/material.dart';
import 'package:task_manager/models/TaskModel.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService service;

  TaskController(this.service);

  bool isLoading = false;
  List<TaskModel> completedList = [];
  List<TaskModel> incompleteList = [];
  String? error;

  Future<void> loadTask() async {
    if (isLoading) return;
    try {
      isLoading = true;
      notifyListeners();
      var result = await service.loadTasks();
      completedList = result.where((item) => item.isCompleted == true).toList();
      incompleteList = result
          .where((item) => item.isCompleted == false)
          .toList();
    } catch (e) {
      error = "Failed to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TaskModel tasks) async {
    try {
      isLoading = true;
      notifyListeners();
      await service.addTask(tasks);
      await loadTask();
      NotificationService.scheduleNotification(tasks);
    } catch (e) {
      error = "Failed to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTask(TaskModel tasks) async {
    try {
      final toggled = tasks.copyWith(isCompleted: !tasks.isCompleted);
      var result = await service.loadTasks();
      result = result
          .map((item) => item.id == tasks.id ? toggled : item)
          .toList();
      await service.saveTasks(result);
      await loadTask();
      notifyListeners();
    } catch (e) {
      error = "Failed to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(TaskModel tasks) async {
    try {
      var result = await service.loadTasks();
      result.removeWhere((item) => item.id == tasks.id);
      await service.saveTasks(result);
      await loadTask();
      notifyListeners();
    } catch (e) {
      error = "Failed to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel tasks) async {
    try {
      var result = await service.loadTasks();
      result = result
          .map((item) => item.id == tasks.id ? tasks : item)
          .toList();
      await service.saveTasks(result);
      await loadTask();
      NotificationService.scheduleNotification(tasks);
      notifyListeners();
    } catch (e) {
      error = "Failed to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
