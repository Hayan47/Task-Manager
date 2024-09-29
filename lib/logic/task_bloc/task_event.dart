part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasksEvent extends TaskEvent {
  final int skip;

  const GetTasksEvent({required this.skip});

  @override
  List<Object> get props => [skip];
}

class RefreshEvent extends TaskEvent {}

class GetTasksFromCache extends TaskEvent {
  final int page;

  const GetTasksFromCache({required this.page});

  @override
  List<Object> get props => [page];
}

// class LoadNextPageEvent extends TaskEvent {}

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

  @override
  List<Object> get props => [taskID];
}
