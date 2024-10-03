import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/models/auth_model.dart';

// Generate mocks
@GenerateMocks([AuthServices, FlutterSecureStorage, InternetCubit])
import 'bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthServices mockAuthServices;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockInternetCubit mockInternetCubit;

  setUpAll(() {
    // Provide a dummy value for InternetState
    provideDummy<InternetState>(InternetConnected());
  });

  setUp(() {
    mockAuthServices = MockAuthServices();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockInternetCubit = MockInternetCubit();

    // Set up InternetCubit to emit connected state
    when(mockInternetCubit.stream)
        .thenAnswer((_) => Stream.value(InternetConnected()));
    when(mockInternetCubit.state).thenReturn(InternetConnected());

    authBloc = AuthBloc(
      authService: mockAuthServices,
      flutterSecureStorage: mockFlutterSecureStorage,
      internetCubit: mockInternetCubit,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group(
    "InternetCubit",
    () {
      test('initial state is InternetConnected', () {
        when(mockInternetCubit.state).thenReturn(InternetConnected());
        expect(mockInternetCubit.state, isA<InternetConnected>());
      });

      test('emits InternetDisConnected state', () {
        when(mockInternetCubit.state).thenReturn(InternetDisconnected());
        expect(mockInternetCubit.state, isA<InternetDisconnected>());
      });
    },
  );

  group(
    "AuthBloc",
    () {
      test('initial state is AuthInitial', () {
        expect(authBloc.state, isA<AuthInitial>());
      });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthLoggedInState] when LoginEvent is added and login is successful',
        build: () {
          when(mockAuthServices.login(any, any)).thenAnswer(
              (_) async => Auth(accessToken: 'token', refreshToken: 'refresh'));
          when(mockFlutterSecureStorage.write(key: any, value: any))
              .thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(
            const LoginEvent(email: 'test@example.com', password: 'password')),
        expect: () => [
          isA<AuthLoadingState>(),
          isA<AuthLoggedInState>(),
        ],
        verify: (_) {
          verify(mockAuthServices.login('test@example.com', 'password'))
              .called(1);
          verify(mockFlutterSecureStorage.write(key: 'accessToken', value: any))
              .called(1);
          verify(mockFlutterSecureStorage.write(
                  key: 'refreshToken', value: any))
              .called(1);
        },
      );
    },
  );
}
