import 'package:flutter/material.dart';
import 'package:task_manager/models/TaskModel.dart';
import 'package:task_manager/services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService service;

  TaskController(this.service);

  bool isLoading = false;
  List<Taskmodel> completedList = [];
  List<Taskmodel> incompeletedList = [];
  String? error;

  Future<void> loadTask() async {
    if(isLoading) return;
    try{
      isLoading = true;
      notifyListeners();
      var result = await service.loadTasks();
      completedList = result.where((item) => item.isCompleted == true).toList();
      incompeletedList = result.where((item) => item.isCompleted == false).toList();
    } catch (e){
      error = "Falied to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Taskmodel tasks) async {
    try{
      isLoading = true;
      notifyListeners();
      await service.addTasks(tasks);
      await loadTask();
    } catch (e){
      error = "Falied to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTask(Taskmodel tasks) async {
    try{
      final toggled = tasks.copyWith(isCompleted: !tasks.isCompleted);
      var result = await service.loadTasks();
      result = result.map((item) => item == tasks ? toggled : item).toList();
      await service.saveTasks(result);
      await loadTask();
      notifyListeners();
    } catch (e){
      error = "Falied to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(Taskmodel tasks) async {
    try{
      var result = await service.loadTasks();
      result.removeWhere((item) => item == tasks);
      await service.saveTasks(result);
      await loadTask();
      notifyListeners();
    } catch (e){
      error = "Falied to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(Taskmodel tasks) async {
    try{
      var result = await service.loadTasks();
      result = result.map((item) => item == tasks ? tasks : item).toList();
      await service.saveTasks(result);
      await loadTask();
      notifyListeners();
    } catch (e){
      error = "Falied to load";
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}