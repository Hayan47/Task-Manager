import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/models/auth_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthServices authService = AuthServices();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final auth = await authService.login(event.email, event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', auth!.token);
        emit(AuthLoggedInState(user: auth));
      } on Exception {
        emit(const AuthLoginErrorState(message: 'wrong email or password'));
      }
    });

    on<CheckAuthState>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          bool autharized = await authService.checkAuth(token);
          if (!autharized) {
            prefs.clear();
            add(CheckAuthState());
          }
          emit(AuthLoggedInState(user: Auth(token: token)));
        } else {
          emit(const AuthLoginErrorState(message: 'You Need to Login'));
        }
      } catch (e) {
        emit(const AuthLoginErrorState(message: 'Error Getting User Auth'));
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
