import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/TaskState.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/services/task_service.dart';

import '../services/notification_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _taskservice = TaskService();
  TaskBloc () : super(TaskLoadingState()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        final result = await _taskservice.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e){
        emit(TaskErrorState(message: 'Failed to load'));
      }
    });
    
    on<AddTaskEvent>((event, emit) async {
      try{
        await _taskservice.addTask(event.task);
        final result = await _taskservice.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch(e){
        emit(TaskErrorState(message: 'Failed to Add'));
      }
    });

    on<ToggleTaskEvent>((event, emit) async {
      try {
        await _taskservice.toggleTask(event.id);
        final result = await _taskservice.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e){
        emit(TaskErrorState(message: 'Failed to Update'));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try{
        await _taskservice.deleteTask(event.id);
        final result = await _taskservice.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch(e){
        emit(TaskErrorState(message: 'Failed to Delete'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try{
        await _taskservice.updateTask(event.task);
        final result = await _taskservice.loadTasks();
        emit(TaskLoadedState(task: result));
        NotificationService.scheduleNotification(event.task);
      } catch(e){
        emit(TaskErrorState(message: 'Failed to Update'));
      }
    });
  }
}