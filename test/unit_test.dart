import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/data/apis/auth_services.dart';
import 'package:task_manager/data/apis/task_services.dart';
import 'package:task_manager/data/models/auth_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/user_model.dart';

// Generate a Mock for Dio
@GenerateMocks([Dio, FlutterSecureStorage])
import 'unit_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockFlutterSecureStorage mockStorage;
  late AuthServices authServices;
  late TaskServices taskServices;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockFlutterSecureStorage();

    // Create AuthServices with mock storage
    authServices = AuthServices(flutterSecureStorage: mockStorage);

    // Replace the Dio instance in AuthServices with our mock
    authServices.dio = mockDio;

    taskServices = TaskServices();
    taskServices.dio = mockDio;
  });

  group('checkAuth', () {
    test('returns true when status code is 200', () async {
      when(mockDio.get(
        'me',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'message': 'Success'},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await authServices.checkAuth('valid_token');
      expect(result, true);
    });

    test('returns false when status code is 401', () async {
      when(mockDio.get(
        'me',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'message': 'Unauthorized'},
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await authServices.checkAuth('expired_token');
      expect(result, false);
    });

    test('throws exception for other status codes', () async {
      when(mockDio.get(
        'me',
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            data: {'message': 'Server Error'},
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(() => authServices.checkAuth('some_token'), throwsException);
    });
  });

  group('login', () {
    test('returns Auth object when login is successful', () async {
      when(mockDio.post(
        'login',
        data: {
          'username': 'test@example.com',
          'password': 'password123',
          'expiresInMins': 1
        },
      )).thenAnswer((_) async => Response(
            data: {
              'accessToken': 'fake_access_token',
              'refreshToken': 'fake_refresh_token'
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result =
          await authServices.login('test@example.com', 'password123');

      expect(result, isA<Auth>());
      expect(result!.accessToken, 'fake_access_token');
      expect(result.refreshToken, 'fake_refresh_token');
    });

    test('throws exception when login fails', () async {
      when(mockDio.post(
        'login',
        data: {
          'username': 'test@example.com',
          'password': 'wrong_password',
          'expiresInMins': 1
        },
      )).thenAnswer((_) async => Response(
            data: {'message': 'Invalid credentials'},
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(
        () => authServices.login('test@example.com', 'wrong_password'),
        throwsException,
      );
    });
  });

  group(
    "refresh token",
    () {
      test(
        "refresh token success",
        () async {
          when(mockDio.post('refresh', data: {'refreshToken': 'refreshToken'}))
              .thenAnswer(
            (_) async => Response(
              data: {
                'accessToken': 'accessToken',
                'refreshToken': 'refreshToken',
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          final result = await authServices.refreshTokens('refreshToken');

          expect(result, isA<Auth>());
          expect(result!.accessToken, 'accessToken');
          expect(result.refreshToken, 'refreshToken');
        },
      );

      test("refresh token fail", () async {
        when(mockDio.post('refresh',
                data: {'refreshToken': 'unvalid_refreshToken'}))
            .thenAnswer((_) async => Response(
                  statusCode: 403,
                  data: {"message": "Invalid refresh token"},
                  requestOptions: RequestOptions(path: ''),
                ));

        expect(
          () => authServices.refreshTokens('unvalid_refreshToken'),
          throwsException,
        );
      });
    },
  );

  group(
    "task services",
    () {
      test(
        "get total page number success",
        () async {
          when(mockDio.get('todos')).thenAnswer((_) async => Response(
                statusCode: 200,
                data: {'total': 10},
                requestOptions: RequestOptions(path: ''),
              ));

          final result = await taskServices.totalPagesNumber();
          expect(result, 10);
        },
      );

      test(
        'get total page number fails',
        () async {
          when(mockDio.get('todos')).thenAnswer((_) async => Response(
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

          expect(
            () => taskServices.totalPagesNumber(),
            throwsException,
          );
        },
      );

      test(
        "get page of tasks success",
        () async {
          when(mockDio.get("todos", queryParameters: {'limit': 10, 'skip': 0}))
              .thenAnswer((_) async => Response(
                    statusCode: 200,
                    data: {
                      'todos': [
                        {
                          'id': 0,
                          'todo': '',
                          'completed': true,
                          'userid': 0,
                        }
                      ]
                    },
                    requestOptions: RequestOptions(path: ''),
                  ));

          final result = await taskServices.getPageOfTasks(0);

          expect(result, isA<List<Task>>());
        },
      );

      test(
        "get page of tasks fail",
        () async {
          when(mockDio.get('todos', queryParameters: {'limit': 10, 'skip': 0}))
              .thenAnswer(
            (_) async => Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          expect(() => taskServices.getPageOfTasks(0), throwsException);
        },
      );

      test(
        'get user info success',
        () async {
          when(mockDio.get('users/1')).thenAnswer(
            (_) async => Response(
              statusCode: 200,
              data: {
                "id": 1,
                "firstName": "Emily",
                "lastName": "Johnson",
                "maidenName": "Smith",
                "age": 28,
                "gender": "female",
                "email": "emily.johnson@x.dummyjson.com",
                "phone": "+81 965-431-3024",
                "username": "emilys",
                "password": "emilyspass",
                "birthDate": "1996-5-30",
                "image": "https://dummyjson.com/icon/emilys/128",
                "bloodGroup": "O-",
                "height": 193.24,
                "weight": 63.16,
                "eyeColor": "Green",
                "hair": {"color": "Brown", "type": "Curly"},
                "ip": "42.48.100.32",
                "address": {
                  "address": "626 Main Street",
                  "city": "Phoenix",
                  "state": "Mississippi",
                  "stateCode": "MS",
                  "postalCode": "29112",
                  "coordinates": {"lat": -77.16213, "lng": -92.084824},
                  "country": "United States"
                },
                "macAddress": "47:fa:41:18:ec:eb",
                "university": "University of Wisconsin--Madison",
                "bank": {
                  "cardExpire": "03/26",
                  "cardNumber": "9289760655481815",
                  "cardType": "Elo",
                  "currency": "CNY",
                  "iban": "YPUXISOBI7TTHPK2BR3HAIXL"
                },
                "company": {
                  "department": "Engineering",
                  "name": "Dooley, Kozey and Cronin",
                  "title": "Sales Manager",
                  "address": {
                    "address": "263 Tenth Street",
                    "city": "San Francisco",
                    "state": "Wisconsin",
                    "stateCode": "WI",
                    "postalCode": "37657",
                    "coordinates": {"lat": 71.814525, "lng": -161.150263},
                    "country": "United States"
                  }
                },
                "ein": "977-175",
                "ssn": "900-590-289",
                "userAgent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36",
                "crypto": {
                  "coin": "Bitcoin",
                  "wallet": "0xb9fc2fe63b2a6c003f1c324c3bfa53259162181a",
                  "network": "Ethereum (ERC20)"
                },
                "role": "admin"
              },
              requestOptions: RequestOptions(path: ''),
            ),
          );
          final result = await taskServices.getUserInfo(1);

          expect(result, isA<User>());
        },
      );

      test(
        'get user info fail',
        () async {
          when(mockDio.get('users/1')).thenAnswer(
            (_) async => Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          expect(() => taskServices.getUserInfo(1), throwsException);
        },
      );
    },
  );
}
