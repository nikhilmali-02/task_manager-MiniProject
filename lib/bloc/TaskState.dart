import 'package:equatable/equatable.dart';
import 'package:task_manager/models/TaskModel.dart';

abstract class TaskState extends Equatable{
  @override
  List<Object?> get props => [];
}

class TaskLoadingState extends TaskState{}

class TaskLoadedState extends TaskState{
  final List<Taskmodel> task;

  TaskLoadedState({required this.task});
  @override
  List<Object?> get props => [task];
}

class TaskErrorState extends TaskState{
  final String message;

  TaskErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}