import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/models/task_model.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskServices taskServices = TaskServices();
  bool hasMore = false;
  int currentPage = 1;
  int totalPages = 0;
  List<Task> tasks = [];
  TaskBloc() : super(TaskInitial()) {
    on<GetTasksEvent>((event, emit) async {
      try {
        emit(TasksLoading());
        print(state);
        final data = await taskServices.getData();
        totalPages = data.totalPages;
        if (totalPages > currentPage) {
          hasMore = true;
        } else {
          hasMore = false;
        }
        tasks = await taskServices.getTasks(event.page);
        emit(TasksLoaded(tasks: tasks, hasMore: hasMore));
        print(state);
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(state);
      }
    });

    on<LoadNextPageEvent>((event, emit) async {
      try {
        currentPage++;
        if (currentPage > totalPages) {
          hasMore = false;
          emit(TasksLoaded(tasks: tasks, hasMore: hasMore));
          return;
        } else if (currentPage == totalPages) {
          hasMore = false;
        }
        final List<Task> newTasks = await taskServices.getTasks(currentPage);
        tasks.addAll(newTasks);
        emit(TasksLoaded(tasks: tasks, hasMore: hasMore));
        print(state);
      } catch (e) {
        emit(const TasksError(message: 'Error Getting Tasks'));
        print(state);
      }
    });
  }
}
