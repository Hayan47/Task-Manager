import 'package:dio/dio.dart';
import 'package:task_manager/services/models/user_model.dart';

class AuthServices {
  late Dio dio;

  AuthServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://reqres.in/api/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    );
    dio = Dio(options);
  }

  //!login
  Future<User?> login(String email, String password) async {
    final response = await dio.post(
      "login",
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final token = response.data["token"];
      return User(token: token);
    } else {
      throw Exception("Login failed");
    }
  }
}
