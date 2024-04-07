import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/database_helper.dart';
import 'package:task_manager/services/models/task_model.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskServices taskServices = TaskServices();
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool hasMore = false;
  int currentPage = 1;
  int totalPages = 2;
  List<Task> tasks = [];

  Future<bool> isCacheValid() async {
    final tasks = await databaseHelper.gettasks();
    return tasks.isEmpty ? false : true;
  }

  TaskBloc() : super(TaskInitial()) {
    on<GetTasksEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        //!get from cache
        if (await isCacheValid()) {
          final tasksMapList = await databaseHelper.gettasks();
          tasks = tasksMapList.map((e) => Task.fromJson(e)).toList();
          emit(TasksLoaded(
              tasks: tasks, hasMore: true, dateTime: DateTime.now()));
          print(state);
          print('FROM CACHE');
          currentPage = 1;
          return;
          //!get from api
        } else {
          final data = await taskServices.getData();
          totalPages = data.totalPages;
          tasks = await taskServices.getTasks(event.page);
          databaseHelper.addTasks(tasks);
          emit(TasksLoaded(
              tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
          print(state);
          print('FROM API');
          currentPage = 1;
        }
        currentPage++;
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(state);
        print(e);
      }
    });

    on<LoadNextPageEvent>((event, emit) async {
      try {
        if (currentPage > totalPages) {
          hasMore = false;
          emit(TasksLoaded(
              tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
          return;
        } else if (currentPage == totalPages) {
          hasMore = false;
        }
        final List<Task> newTasks = await taskServices.getTasks(currentPage);
        tasks.addAll(newTasks);
        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
        print(state);
        currentPage = 1;
      } on DioException catch (e) {
        print(e);
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(state);
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        await taskServices.addTask(event.task);
        emit(const TaskAdded(message: 'Task Added Successfully'));
      } catch (e) {
        emit(const TasksError(message: 'Error Adding Task'));
        print(state);
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        final updatedAt = await taskServices.updateTask(event.task);
        emit(TaskUpdated(
            message: 'Task Updated at: ${updatedAt.substring(0, 10)}'));
        add(const GetTasksEvent(page: 1));
      } catch (e) {
        emit(const TasksError(message: 'Error Updating Task'));
        print(state);
        print(e);
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        await taskServices.deleteTask(event.taskID);
        emit(const TaskDeleted(message: 'Task Deleted Successfully'));
        add(const GetTasksEvent(page: 1));
      } catch (e) {
        emit(const TasksError(message: 'Error Deleting Task'));
        print(state);
      }
    });
  }
}
