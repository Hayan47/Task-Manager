import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/data/apis/dio_intercepters.dart';
import 'package:task_manager/data/logger_service.dart';
import 'package:task_manager/data/models/auth_model.dart';

// username: 'kminchelle',
// password: '0lelplR',
class AuthServices {
  late Dio dio;
  final FlutterSecureStorage flutterSecureStorage;
  final _logger = LoggerService().getLogger('Auth Service Logger');

  AuthServices({required this.flutterSecureStorage}) {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://dummyjson.com/auth/',
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != 401,
    );
    dio = Dio(options);
    dio.interceptors.add(TokenRefreshInterceptor(dio, flutterSecureStorage));
  }

  //!login
  Future<Auth?> login(String email, String password) async {
    final response = await dio.post(
      "login",
      data: {"username": email, "password": password, "expiresInMins": 1},
    );
    if (response.statusCode == 200) {
      final accessToken = response.data["accessToken"];
      final refreshToken = response.data["refreshToken"];
      return Auth(accessToken: accessToken, refreshToken: refreshToken);
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
    if (response.statusCode == 200) {
      //! Token Valid
      _logger.info("Token Valid");
      return true;
    } else if (response.statusCode == 401) {
      //! Token Expired
      _logger.info("Token Expired");
      return false;
    } else {
      throw Exception("Auth failed");
    }
  }

  //!Refresh Tokens
  Future<Auth?> refreshTokens(String refreshToken) async {
    final response = await dio.post(
      "refresh",
      data: {"refreshToken": refreshToken},
    );
    if (response.statusCode == 200) {
      final accessToken = response.data["accessToken"];
      final refreshToken = response.data["refreshToken"];
      return Auth(accessToken: accessToken, refreshToken: refreshToken);
    } else {
      throw Exception("Login failed");
    }
  }
}
