part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final int page;

  const GetTasksEvent({required this.page});
}

class LoadNextPageEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent({required this.task});
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent({required this.task});
}

class DeleteTaskEvent extends TaskEvent {
  final int taskID;

  const DeleteTaskEvent({required this.taskID});
}
