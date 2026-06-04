import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/TaskModel.dart';

import 'notification_service.dart';

class TaskService {
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final save = tasks.map((tasks) => jsonEncode(tasks.toJson())).toList();
    await prefs.setStringList('key', save);
  }

  Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final string = prefs.getStringList("key") ?? [];
    final load = string
        .map((string) => TaskModel.fromJson(jsonDecode(string)))
        .toList();
    return load;
  }

  Future<void> addTask(TaskModel tasks) async {
    final add = await loadTasks();
    add.add(tasks);
    await saveTasks(add);
  }

  Future<List<TaskModel>> toggleTask(String id) async {
    var result = await loadTasks();
    final task = result.firstWhere((item) => item.id == id);
    final toggled = task.copyWith(isCompleted: !task.isCompleted);
    result = result.map((item) => item.id == task.id ? toggled : item).toList();
    await saveTasks(result);
    return result;
  }

  Future<List<TaskModel>> deleteTask(String id) async {
    var result = await loadTasks();
    result.removeWhere((item) => item.id == id);
    await saveTasks(result);
    return result;
  }

  Future<List<TaskModel>> updateTask(TaskModel task) async {
    var result = await loadTasks();
    result = result.map((item) => item.id == task.id ? task : item).toList();
    await saveTasks(result);
    return result;
  }
}
