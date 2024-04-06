import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/models/user_model.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoadingState());
        final user = await authService.login(event.email, event.password);
        emit(AuthLoggedInState(user: user!));
      } on Exception {
        emit(const AuthLoginErrorState(message: 'wrong email or password'));
      }
    });
  }
}
