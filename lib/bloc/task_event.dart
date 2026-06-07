import 'package:equatable/equatable.dart';
import 'package:task_manager/models/TaskModel.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final TaskModel task;

  AddTaskEvent({required this.task});
  @override
  List<Object?> get props => [task];
}

class ToggleTaskEvent extends TaskEvent {
  final String id;

  ToggleTaskEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;

  DeleteTaskEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel task;

  UpdateTaskEvent({required this.task});
  @override
  List<Object?> get props => [task];
}
