import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/models/auth_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authService;
  final FlutterSecureStorage flutterSecureStorage;
  final InternetCubit internetCubit;
  late StreamSubscription internetSubscription;
  bool isInternetConnected = false;

  AuthBloc({
    required this.flutterSecureStorage,
    required this.authService,
    required this.internetCubit,
  }) : super(AuthInitial()) {
    // Subscribe to the InternetCubit's stream
    internetSubscription = internetCubit.stream.listen((internetState) {
      if (internetState is InternetConnected) {
        isInternetConnected = true;
      } else if (internetState is InternetDisconnected) {
        isInternetConnected = false;
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        print(state);
        final auth = await authService.login(event.email, event.password);
        await flutterSecureStorage.write(
            key: 'accessToken', value: auth!.accessToken);
        await flutterSecureStorage.write(
            key: 'refreshToken', value: auth.refreshToken);
        emit(AuthLoggedInState(user: auth));
        print(state);
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'wrong email or password'));
        print(state);
        print(e);
      }
    });

    on<CheckAuthState>((event, emit) async {
      try {
        emit(AuthLoadingState());
        print(state);
        final accessToken = await flutterSecureStorage.read(key: 'accessToken');
        final refreshToken =
            await flutterSecureStorage.read(key: 'refreshToken');
        if (accessToken == null) {
          print("access token is null");
          emit(const AuthLoginErrorState(message: 'You Need to Login'));
          print(state);
          return;
        }
        print("access token found");

        if (isInternetConnected) {
          final isAuthorized = await authService.checkAuth(accessToken);
          if (!isAuthorized) {
            await flutterSecureStorage.deleteAll();
            print("tokens cleared");
            add(CheckAuthState());
            return;
          }
        }

        print("Authenticated");
        emit(AuthLoggedInState(
            user: Auth(accessToken: accessToken, refreshToken: refreshToken!)));
        print(state);
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error Getting User Auth'));
        print(state);
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await flutterSecureStorage.deleteAll();
        emit(AuthLoggedoutState());
        print(state);
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error'));
        print(state);
      }
    });
  }

  @override
  Future<void> close() {
    // Cancel the internet connectivity subscription to avoid memory leaks
    internetSubscription.cancel();
    return super.close();
  }
}
