import 'package:task_manager/data/apis/task_services.dart';
import 'package:task_manager/data/database_helper.dart';
import 'package:task_manager/data/models/task_model.dart';

class TaskRepository {
  final TaskServices taskServices;
  final DatabaseHelper databaseHelper;

  TaskRepository({
    required this.taskServices,
    required this.databaseHelper,
  });

  Future<void> clearCache() async {
    await databaseHelper.clearTable('task_table');
  }

  Future<bool> isCacheValid(int page) async {
    final tasks = await databaseHelper.getTasksForPage(page);
    return tasks.isNotEmpty;
  }

  Future<int?> getTotalTasksNumber() async {
    return await taskServices.totalPagesNumber();
  }

  Future<List<Task>> getTasksFromApi(int skip) async {
    final tasks = await taskServices.getPageOfTasks(skip);
    final totalTasks = await getTotalTasksNumber();
    await databaseHelper.insertTasks(tasks, skip ~/ 10, totalTasks!);
    return tasks;
  }

  Future<List<Task>> getTasksFromCache(int page) async {
    return await databaseHelper.getTasksForPage(page);
  }

  Future<int> getTotalPages() async {
    return await databaseHelper.getTotalPages();
  }

  Future<void> addTask(Task task) async {
    await taskServices.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await taskServices.updateTask(task);
  }

  Future<void> deleteTask(int taskId) async {
    await taskServices.deleteTask(taskId);
  }
}
