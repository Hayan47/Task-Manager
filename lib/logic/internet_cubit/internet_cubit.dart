import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  InternetCubit() : super(InternetDisconnected()) {
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    if (results.any((result) => result == ConnectivityResult.none)) {
      emit(InternetDisconnected());
    } else {
      emit(InternetConnected());
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
