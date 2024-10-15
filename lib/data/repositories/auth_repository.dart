import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/data/apis/auth_services.dart';
import 'package:task_manager/data/models/auth_model.dart';

class AuthRepository {
  final AuthServices authServices;
  final FlutterSecureStorage flutterSecureStorage;

  AuthRepository({
    required this.authServices,
    required this.flutterSecureStorage,
  });

  Future<Auth?> login(String email, String password) async {
    final auth = await authServices.login(email, password);
    if (auth != null) {
      // Storing tokens securely
      await flutterSecureStorage.write(
          key: 'accessToken', value: auth.accessToken);
      await flutterSecureStorage.write(
          key: 'refreshToken', value: auth.refreshToken);
    }
    return auth;
  }

  Future<String?> getAccessToken() async {
    return await flutterSecureStorage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await flutterSecureStorage.read(key: 'refreshToken');
  }

  Future<void> deleteTokens() async {
    return await flutterSecureStorage.deleteAll();
  }

  Future<bool> checkAuth(String accessToken) async {
    final isAuthorized = await authServices.checkAuth(accessToken);
    if (!isAuthorized) {
      await flutterSecureStorage.deleteAll();
      return false;
    }
    return true;
  }
}
