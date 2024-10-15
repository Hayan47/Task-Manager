import 'package:task_manager/data/apis/task_services.dart';
import 'package:task_manager/data/models/user_model.dart';

class TaskDetailsRepository {
  final TaskServices taskServices;

  TaskDetailsRepository({required this.taskServices});

  Future<User> getUserInfo(int id) async {
    return await taskServices.getUserInfo(id);
  }
}
