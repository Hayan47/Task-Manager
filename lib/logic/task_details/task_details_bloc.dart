import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/logger_service.dart';
import 'package:task_manager/data/repositories/task_details_repository.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/data/models/user_model.dart';
part 'task_details_event.dart';
part 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final TaskDetailsRepository taskDetailsRepository;
  final InternetCubit internetCubit;
  late StreamSubscription internetSubscription;
  final _logger = LoggerService().getLogger('Task Details Bloc Logger');
  bool isInternetConnected = false;
  TaskDetailsBloc(
      {required this.internetCubit, required this.taskDetailsRepository})
      : super(TaskDetailsInitial()) {
    internetSubscription = internetCubit.stream.listen((internetState) {
      if (internetState is InternetConnected) {
        isInternetConnected = true;
      } else if (internetState is InternetDisconnected) {
        isInternetConnected = false;
      }
    });
    on<GetUserInfo>((event, emit) async {
      try {
        emit(TaskDetailsLoading());
        _logger.info(state);
        if (internetCubit.state == InternetDisconnected()) {
          emit(const TaskDetailsError(message: 'No Internet Connection!'));
          _logger.info(state);
          return;
        }
        final user = await taskDetailsRepository.getUserInfo(event.id);
        emit(TaskDetailsLoaded(user: user));
        _logger.info(state);
      } catch (e) {
        emit(const TaskDetailsError(message: 'Error Getting Task Details'));
        _logger.severe(e);
        _logger.info(state);
      }
    });
  }
  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
}
