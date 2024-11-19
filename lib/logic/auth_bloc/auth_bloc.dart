import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/logger_service.dart';
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
  final _logger = LoggerService().getLogger('Auth Bloc Logger');

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
        _logger.info(state);
        final auth = await authRepository.login(event.email, event.password);
        if (auth != null) {
          emit(AuthLoggedInState(user: auth));
          _logger.info(state);
        } else {
          emit(const AuthLoginErrorState(message: 'wrong email or password'));
          _logger.info(state);
        }
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'wrong email or password'));
        _logger.info(state);
        _logger.severe(e);
      }
    });

    on<CheckAuthState>((event, emit) async {
      try {
        emit(AuthLoadingState());
        _logger.info(state);
        final accessToken = await authRepository.getAccessToken();
        final refreshToken = await authRepository.getRefreshToken();
        if (accessToken == null) {
          _logger.info('access token is null');
          emit(const AuthLoginErrorState(message: 'You Need to Login'));
          _logger.info(state);
          return;
        }
        _logger.info('access token found');

        if (isInternetConnected) {
          final isAuthorized = await authRepository.checkAuth(accessToken);
          if (!isAuthorized) {
            add(CheckAuthState());
            return;
          }
        }
        _logger.info('Authenticated');
        emit(AuthLoggedInState(
            user: Auth(accessToken: accessToken, refreshToken: refreshToken!)));
        _logger.info(state);
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error Getting User Auth'));
        _logger.info(state);
        _logger.severe(e);
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await authRepository.deleteTokens();
        emit(AuthLoggedoutState());
        _logger.info(state);
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error'));
        _logger.info(state);
        _logger.severe(e);
      }
    });
  }

  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
}
