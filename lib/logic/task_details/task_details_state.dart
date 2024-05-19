part of 'task_details_bloc.dart';

sealed class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object> get props => [];
}

final class TaskDetailsInitial extends TaskDetailsState {}

final class TaskDetailsLoading extends TaskDetailsState {}

final class TaskDetailsLoaded extends TaskDetailsState {
  final User user;

  const TaskDetailsLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

final class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
