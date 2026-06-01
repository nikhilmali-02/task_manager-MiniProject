import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/TaskModel.dart';

import 'notification_service.dart';

class TaskService {
    Future<void> saveTasks(List<Taskmodel> tasks) async {
      final prefs = await SharedPreferences.getInstance();
      final save = tasks.map((tasks)=> jsonEncode(tasks.toJson())).toList();
      await prefs.setStringList('key', save);
    }

    Future<List<Taskmodel>> loadTasks() async{
      final prefs = await SharedPreferences.getInstance();
      final string = prefs.getStringList("key") ?? [];
      final load = string.map((string) => Taskmodel.fromJson(jsonDecode(string))).toList();
      return load;
    }

    Future<void> addTask(Taskmodel tasks) async {
      final add = await loadTasks();
      add.add(tasks);
      await saveTasks(add);
    }

    Future<List<Taskmodel>> toggleTask(String id) async{
      var result = await loadTasks();
      final task = result.firstWhere((item) => item.id == id);
      final toggled = task.copyWith(isCompleted: !task.isCompleted);
      result = result.map((item) => item.id == task.id ? toggled : item).toList();
      await saveTasks(result);
      return result;
    }

    Future<List<Taskmodel>> deleteTask(String id) async{
      var result = await loadTasks();
      result.removeWhere((item) => item.id == id);
      await saveTasks(result);
      return result;
    }

    Future<List<Taskmodel>> updateTask(Taskmodel task) async {
      var result = await loadTasks();
      result = result.map((item) => item.id == task.id ? task : item).toList();
      await saveTasks(result);
      return result;
    }
}