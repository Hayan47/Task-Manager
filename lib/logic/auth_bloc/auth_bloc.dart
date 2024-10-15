import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/data/models/auth_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final InternetCubit internetCubit;
  late StreamSubscription internetSubscription;
  bool isInternetConnected = false;

  AuthBloc({
    required this.authRepository,
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
        final auth = await authRepository.login(event.email, event.password);
        if (auth != null) {
          emit(AuthLoggedInState(user: auth));
          print(state);
        } else {
          emit(const AuthLoginErrorState(message: 'wrong email or password'));
          print(state);
        }
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
        final accessToken = await authRepository.getAccessToken();
        final refreshToken = await authRepository.getRefreshToken();
        if (accessToken == null) {
          print("access token is null");
          emit(const AuthLoginErrorState(message: 'You Need to Login'));
          print(state);
          return;
        }
        print("access token found");

        if (isInternetConnected) {
          final isAuthorized = await authRepository.checkAuth(accessToken);
          if (!isAuthorized) {
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
        await authRepository.deleteTokens();
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
    internetSubscription.cancel();
    return super.close();
  }
}
