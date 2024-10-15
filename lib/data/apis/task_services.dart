import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/user_model.dart';

class TaskServices {
  late Dio dio;

  TaskServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://dummyjson.com/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
    );
    dio = Dio(options);
  }

  //!get total pages number
  Future<int> totalPagesNumber() async {
    final response = await dio.get("todos");
    print(response);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final totalTasks = data["total"] as int;
      return totalTasks;
    } else {
      throw Exception("Error Getting Total Pages Number");
    }
  }

  //!get page of tasks
  Future<List<Task>> getPageOfTasks(int skip) async {
    final response =
        await dio.get("todos", queryParameters: {'limit': 10, 'skip': skip});
    print(response);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final tasks = data["todos"] as List<dynamic>;
      return tasks.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception("Error Getting Tasks");
    }
  }

  //!add task
  Future<String> addTask(Task task) async {
    final response = await dio.post(
      "todos/add",
      data: jsonEncode({
        'todo': task.todo,
        'completed': task.completed,
        'userId': task.userId,
      }),
    );
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Error Adding Task");
    }
  }

  //!update task
  Future<Task> updateTask(Task task) async {
    final response = await dio.put(
      "todos/${task.id}",
      data: jsonEncode({
        'todo': task.todo,
        'completed': task.completed,
        'userId': task.userId,
      }),
    );
    print(response);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final task = Task.fromJson(data);
      return task;
    } else {
      throw Exception("Error Updating Task");
    }
  }

  //!delete task
  Future<String> deleteTask(int taskID) async {
    final response = await dio.delete("todos/$taskID");
    print(response);
    if (response.statusCode == 200) {
      return 'task deleted successfully';
    } else {
      throw Exception("Error Deleting Tasks");
    }
  }

  //!get user info
  Future<User> getUserInfo(int id) async {
    final response = await dio.get(
      "users/$id",
    );
    // print(response);
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final User user = User.fromJson(data);
      return user;
    } else {
      throw Exception("Error Getting User Info");
    }
  }
}
