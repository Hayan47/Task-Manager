import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/models/user_model.dart';

part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final InternetCubit internetCubit;
  TaskServices taskServices = TaskServices();
  TaskDetailsBloc({required this.internetCubit}) : super(TaskDetailsInitial()) {
    on<GetUserInfo>((event, emit) async {
      try {
        emit(TaskDetailsLoading());
        if (internetCubit.state == InternetDisconnected()) {
          emit(const TaskDetailsError(message: 'No Internet Connection!'));
        }
        final user = await taskServices.getUserInfo(event.id);
        emit(TaskDetailsLoaded(user: user));
      } catch (e) {
        emit(const TaskDetailsError(message: 'Error Getting Task Details'));
      }
    });
  }
}
