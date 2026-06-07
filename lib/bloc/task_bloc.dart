import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/bloc/TaskState.dart';
import 'package:task_manager/bloc/task_event.dart';
import 'package:task_manager/services/firestore_service.dart';

import '../services/notification_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _firestoreService = FirestoreService();
  TaskBloc() : super(TaskLoadingState()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        final result = await _firestoreService.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e) {
        emit(TaskErrorState(message: 'Failed to load'));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        await _firestoreService.addTask(event.task);
        await NotificationService.scheduleNotification(event.task);
        final result = await _firestoreService.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e) {
        emit(TaskErrorState(message: 'Failed to Add'));
      }
    });

    on<ToggleTaskEvent>((event, emit) async {
      try {
        await _firestoreService.toggleTask(event.id);
        final result = await _firestoreService.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e) {
        emit(TaskErrorState(message: 'Failed to Update'));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        await _firestoreService.deleteTask(event.id);
        final result = await _firestoreService.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e) {
        emit(TaskErrorState(message: 'Failed to Delete'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        await _firestoreService.updateTask(event.task);
        await NotificationService.scheduleNotification(event.task);
        final result = await _firestoreService.loadTasks();
        emit(TaskLoadedState(task: result));
      } catch (e) {
        emit(TaskErrorState(message: 'Failed to Update'));
      }
    });
  }
}
