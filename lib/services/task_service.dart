import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/TaskModel.dart';

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

    Future<void> addTasks(Taskmodel tasks) async {
      final add = await loadTasks();
      add.add(tasks);
      final save = await saveTasks(add);
    }
}