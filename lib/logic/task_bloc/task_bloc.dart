import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/database_helper.dart';
import 'package:task_manager/services/models/task_model.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskServices taskServices = TaskServices();
  DatabaseHelper databaseHelper = DatabaseHelper();
  final InternetCubit internetCubit;
  int totalTasksNumber = 1;
  bool hasMore = true;
  List<Task> tasks = [];

  Future<bool> isCacheValid(int page) async {
    final tasks = await databaseHelper.getTasksForPage(page);
    return tasks.isEmpty ? false : true;
  }

  TaskBloc({required this.internetCubit}) : super(TaskInitial()) {
    on<GetTasksEvent>((event, emit) async {
      try {
        int skip = event.skip;
        if (await isCacheValid(skip ~/ 10)) {
          add(GetTasksFromCache(page: skip ~/ 10));
          return;
        }
        if (internetCubit.state == InternetDisconnected()) {
          return;
        }
        totalTasksNumber = await taskServices.totalPagesNumber();

        final List<Task> newTasks = await taskServices.getPageOfTasks(skip);
        //! Cache tasks in the database
        await databaseHelper.insertTasks(
            newTasks, skip ~/ 10, totalTasksNumber);
        tasks.addAll(newTasks);
        if (skip >= totalTasksNumber) {
          skip += skip - totalTasksNumber;
          hasMore = false;
        } else {
          hasMore = true;
        }
        emit(TasksLoaded(
            tasks: tasks, hasMore: hasMore, dateTime: DateTime.now()));
        print('FROM API');
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
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
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks from Cache'));
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        await taskServices.addTask(event.task);
        emit(const TaskAdded(message: 'Task Added Successfully'));
      } catch (e) {
        emit(const TasksError(message: 'Error Adding Task'));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        await taskServices.updateTask(event.task);
        emit(const TaskUpdated(message: 'task updated sucessfully'));
        add(const GetTasksEvent(skip: 0));
      } catch (e) {
        emit(const TasksError(message: 'Error Updating Task'));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        await taskServices.deleteTask(event.taskID);
        emit(const TaskDeleted(message: 'Task Deleted Successfully'));
        add(const GetTasksEvent(skip: 0));
      } catch (e) {
        emit(const TasksError(message: 'Error Deleting Task'));
      }
    });
  }
}
