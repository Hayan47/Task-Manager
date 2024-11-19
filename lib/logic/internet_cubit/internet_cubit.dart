import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/logger_service.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  final _logger = LoggerService().getLogger('Internet Bloc Logger');
  InternetCubit() : super(InternetConnected()) {
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    if (results.any((result) =>
        result == ConnectivityResult.none ||
        (result == ConnectivityResult.vpn && results.length == 1))) {
      emit(InternetDisconnected());
      _logger.info(state);
    } else {
      emit(InternetConnected());
      _logger.info(state);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
