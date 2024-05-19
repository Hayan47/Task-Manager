import 'package:dio/dio.dart';
import 'package:task_manager/services/models/auth_model.dart';

// username: 'kminchelle',
// password: '0lelplR',
class AuthServices {
  late Dio dio;

  AuthServices() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://dummyjson.com/auth/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => true,
    );
    dio = Dio(options);
  }

  //!login
  Future<Auth?> login(String email, String password) async {
    final response = await dio.post(
      "login",
      data: {"username": email, "password": password},
    );

    if (response.statusCode == 200) {
      final token = response.data["token"];
      return Auth(token: token);
    } else {
      throw Exception("Login failed");
    }
  }

  //!check auth
  Future<bool> checkAuth(String token) async {
    final response = await dio.get(
      "me",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token ',
        },
      ),
    );
    //! Token Valid
    if (response.statusCode == 200) {
      return true;
      //! Token Expired
    } else if (response.statusCode == 401) {
      return false;
    } else {
      throw Exception("Auth failed");
    }
  }
}
