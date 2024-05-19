part of 'internet_cubit.dart';

sealed class InternetState extends Equatable {
  const InternetState();

  @override
  List<Object> get props => [];
}

final class InternetConnected extends InternetState {}

final class InternetDisconnected extends InternetState {}
