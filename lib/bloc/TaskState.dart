import 'package:equatable/equatable.dart';
import 'package:task_manager/models/TaskModel.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<TaskModel> task;

  TaskLoadedState({required this.task});
  @override
  List<Object?> get props => [task];

  int activeCount() => task.where((t) => !t.isCompleted).length;
  int completedCount() => task.where((t) => t.isCompleted).length;
}

class TaskErrorState extends TaskState {
  final String message;

  TaskErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}
