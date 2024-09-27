import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage flutterSecureStorage;

  TokenRefreshInterceptor(this.dio, this.flutterSecureStorage);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print("ON ERROR INTERCEPTOR CALLED");
    if (err.response?.statusCode == 401) {
      print("ERROR 401 CATCHED");
      // Token has expired
      try {
        // Get the refresh token
        final refreshToken =
            await flutterSecureStorage.read(key: "refreshToken");
        if (refreshToken == null) {
          // No refresh token, user needs to login again
          print("NO REFRESH TOKEN, USER NEEDS TO LOGIN");
          throw DioException(
              requestOptions: err.requestOptions, error: 'No refresh token');
        }

        // Call your refresh token endpoint
        final response = await dio.post(
          '/refresh',
          data: {'refreshToken': refreshToken, "expiresInMins": 1},
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
        );
        print("REFRESH RESPONSE  $response");
        if (response.statusCode == 200) {
          print("GOT NEW TOKENS");
          // Save the new tokens
          await flutterSecureStorage.write(
              key: "accessToken", value: response.data["accessToken"]);
          await flutterSecureStorage.write(
              key: "refreshToken", value: response.data["refreshToken"]);
          print("STORED NEW TOKENS");

          // Retry the original request with the new token
          final opts = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          );
          opts.headers!['Authorization'] =
              'Bearer ${response.data['accessToken']}';

          final clonedRequest = await dio.request(
            err.requestOptions.path,
            options: opts,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          print("RAN CLONED REQUEST");

          return handler.resolve(clonedRequest);
        }
      } catch (e) {
        // If refresh fails, user needs to login again
        // You might want to navigate to login screen or show a dialog here
        print("REFRESH FAILED");
        return handler.next(DioException(
            requestOptions: err.requestOptions, error: 'Refresh token failed'));
      }
    }
    return handler.next(err);
  }
}
