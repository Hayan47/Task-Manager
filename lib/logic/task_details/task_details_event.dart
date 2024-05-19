part of 'task_details_bloc.dart';

sealed class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetUserInfo extends TaskDetailsEvent {
  final int id;

  const GetUserInfo({required this.id});
}
