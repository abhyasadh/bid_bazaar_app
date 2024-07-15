import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityNotifier() : super(ConnectivityStatus.notDetermined) {
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
      if (result[0] == ConnectivityResult.wifi || result[0] == ConnectivityResult.mobile) {
        state = ConnectivityStatus.isConnected;
      } else {
        state = ConnectivityStatus.isDisconnected;
      }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

final connectivityProvider =
StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
        (ref) => ConnectivityNotifier());
