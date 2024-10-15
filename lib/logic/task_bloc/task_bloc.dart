import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/data/models/task_model.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final InternetCubit internetCubit;
  late StreamSubscription internetSubscription;
  bool isInternetConnected = false;
  int? totalTasksNumber;
  bool hasMore = true;
  List<Task> tasks = [];

  TaskBloc({
    required this.internetCubit,
    required this.taskRepository,
  }) : super(TaskInitial()) {
    // Subscribe to InternetCubit stream
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

        if (await taskRepository.isCacheValid(page)) {
          add(GetTasksFromCache(page: page));
          print('From Cache');
          return;
        }

        if (!isInternetConnected) {
          return;
        }

        totalTasksNumber ??= await taskRepository.getTotalTasksNumber();
        final List<Task> newTasks = await taskRepository.getTasksFromApi(skip);
        print('From API');

        tasks.addAll(newTasks);
        if (skip >= totalTasksNumber!) {
          skip += skip - totalTasksNumber!;
          hasMore = false;
        } else {
          hasMore = true;
        }

        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(e);
      }
    });

    on<GetTasksFromCache>((event, emit) async {
      try {
        final newTasks = await taskRepository.getTasksFromCache(event.page);
        final totalPages = await taskRepository.getTotalPages();
        final hasMore = totalPages > event.page;
        tasks.addAll(newTasks);
        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks from Cache'));
        print(e);
      }
    });

    on<RefreshEvent>(
      (event, emit) async {
        //! Check internet before api calls
        if (!isInternetConnected) {
          return;
        }

        await taskRepository.clearCache();
        tasks = [];
        add(const GetTasksEvent(skip: 0));
      },
    );

    on<AddTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        await taskRepository.addTask(event.task);
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
        await taskRepository.updateTask(event.task);
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
        await taskRepository.deleteTask(event.taskID);
        emit(const TaskDeleted(message: 'Task Deleted Successfully'));
        print(state);
        add(const GetTasksEvent(skip: 0));
      } catch (e) {
        emit(const TasksError(message: 'Error Deleting Task'));
        print(state);
      }
    });
  }

  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
}
