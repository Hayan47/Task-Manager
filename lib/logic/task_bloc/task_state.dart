part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}

final class TasksLoading extends TaskState {}

final class TasksLoaded extends TaskState {
  final List<Task> tasks;
  final bool hasMore;
  final DateTime dateTime;

  const TasksLoaded(
      {required this.tasks, required this.hasMore, required this.dateTime});

  @override
  List<Object> get props => [tasks, hasMore, dateTime];
}

final class TasksError extends TaskState {
  final String message;

  const TasksError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ConnectionError extends TaskState {
  final String message;

  const ConnectionError({required this.message});

  @override
  List<Object> get props => [message];
}

final class TaskAdded extends TaskState {
  final String message;

  const TaskAdded({required this.message});

  @override
  List<Object> get props => [message];
}

final class TaskDeleted extends TaskState {
  final String message;

  const TaskDeleted({required this.message});

  @override
  List<Object> get props => [message];
}

final class TaskUpdated extends TaskState {
  final String message;

  const TaskUpdated({required this.message});

  @override
  List<Object> get props => [message];
}
