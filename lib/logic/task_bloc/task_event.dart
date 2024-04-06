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
