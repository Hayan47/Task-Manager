import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/models/user_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthServices authService = AuthServices();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final user = await authService.login(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user!.token);
        emit(AuthLoggedInState(user: user!));
      } on Exception {
        emit(const AuthLoginErrorState(message: 'wrong email or password'));
      }
    });

    on<CheckAuthState>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          emit(AuthLoggedInState(user: User(token: token)));
        }
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        emit(AuthLoggedoutState());
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error'));
      }
    });
  }
}
