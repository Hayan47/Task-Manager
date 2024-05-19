part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final Auth user;

  const AuthLoggedInState({required this.user});
}

class AuthLoginErrorState extends AuthState {
  final String message;

  const AuthLoginErrorState({required this.message});
}

class AuthLoggedoutState extends AuthState {}
