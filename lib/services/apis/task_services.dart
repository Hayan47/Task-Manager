import 'package:dio/dio.dart';
import 'package:task_manager/services/models/task_model.dart';

class TaskServices {
  late Dio dio;

  TaskServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://reqres.in/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    );
    dio = Dio(options);
  }

  //!get data
  Future<Data> getData() async {
    final response = await dio.get("users");
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return Data.fromJson(data);
    } else {
      throw Exception("Eroor Getting Tasks");
    }
  }

  //!get all tasks
  Future<List<Task>> getTasks(int page) async {
    final response = await dio.get(
      "users",
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final tasks = data["data"] as List<dynamic>;
      return tasks.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception("Eroor Getting Tasks");
    }
  }

  //!add task
  Future<String> addTask(Task task) async {
    // final response = await dio.post("users", data: task.toJson());
    return 'Task Added Successfully';
  }

  //!update task
  Future<String> updateTask(Task task) async {
    final response = await dio.put("users/${task.id}");
    if (response.statusCode == 200) {
      return response.data['updatedAt'];
    } else {
      throw Exception("Eroor Updating Tasks");
    }
  }

  //!add task
  Future<String> deleteTask(int taskID) async {
    final response = await dio.delete("users/$taskID");
    if (response.statusCode == 204) {
      return 'task deleted successfully';
    } else {
      throw Exception("Eroor Deleting Tasks");
    }
  }
}
