import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/database_helper.dart';
import 'package:task_manager/services/models/task_model.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskServices taskServices;
  final DatabaseHelper databaseHelper;
  final InternetCubit internetCubit;
  late StreamSubscription internetSubscription;
  bool isInternetConnected = false;
  int? totalTasksNumber;
  bool hasMore = true;
  List<Task> tasks = [];

  Future<bool> isCacheValid(int page) async {
    final tasks = await databaseHelper.getTasksForPage(page);
    return tasks.isEmpty ? false : true;
  }

  TaskBloc({
    required this.internetCubit,
    required this.databaseHelper,
    required this.taskServices,
  }) : super(TaskInitial()) {
    // Subscribe to the InternetCubit's stream
    internetSubscription = internetCubit.stream.listen((internetState) {
      if (internetState is InternetConnected) {
        isInternetConnected = true;
      } else if (internetState is InternetDisconnected) {
        isInternetConnected = false;
      }
    });

    on<GetTasksEvent>((event, emit) async {
      try {
        int skip = event.skip;
        int page = skip ~/ 10;
        if (await isCacheValid(page)) {
          add(GetTasksFromCache(page: page));
          return;
        }
        if (!isInternetConnected) {
          return;
        }
        totalTasksNumber ??= await taskServices.totalPagesNumber();

        final List<Task> newTasks = await taskServices.getPageOfTasks(skip);
        //! Cache tasks in the database
        await databaseHelper.insertTasks(newTasks, page, totalTasksNumber!);
        tasks.addAll(newTasks);
        if (skip >= totalTasksNumber!) {
          skip += skip - totalTasksNumber!;
          hasMore = false;
        } else {
          hasMore = true;
        }
        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
        print(state);
        print('FROM API');
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(state);
        print(e);
      }
    });

    on<GetTasksFromCache>((event, emit) async {
      try {
        final newtasks = await databaseHelper.getTasksForPage(event.page);
        final totalPages = await databaseHelper.getTotalPages();
        final hasMore = totalPages > event.page;
        tasks.addAll(newtasks);
        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
        print('FROM Cache');
        print(state);
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks from Cache'));
        print(e);
        print(state);
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        await taskServices.addTask(event.task);
        emit(const TaskAdded(message: 'Task Added Successfully'));
        print(state);
      } catch (e) {
        emit(const TasksError(message: 'Error Adding Task'));
        print(state);
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        await taskServices.updateTask(event.task);
        emit(const TaskUpdated(message: 'task updated sucessfully'));
        print(state);
        add(const GetTasksEvent(skip: 0));
      } catch (e) {
        emit(const TasksError(message: 'Error Updating Task'));
        print(state);
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        await taskServices.deleteTask(event.taskID);
        emit(const TaskDeleted(message: 'Task Deleted Successfully'));
        print(state);
        add(const GetTasksEvent(skip: 0));
      } catch (e) {
        emit(const TasksError(message: 'Error Deleting Task'));
        print(state);
      }
    });
  }
}
