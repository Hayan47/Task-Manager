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

  const TasksLoaded({required this.tasks, required this.hasMore});

  @override
  List<Object> get props => [tasks, hasMore];
}

final class TasksError extends TaskState {
  final String message;

  const TasksError({required this.message});

  @override
  List<Object> get props => [message];
}
