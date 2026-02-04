import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityService extends ChangeNotifier {
  ConnectivityStatus _status = ConnectivityStatus.online;
  ConnectivityStatus get status => _status;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateStatus(results);
    });
    _checkInitialStatus();
  }

  void _updateStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      _status = ConnectivityStatus.offline;
    } else {
      _status = ConnectivityStatus.online;
    }
    notifyListeners();
  }

  Future<void> _checkInitialStatus() async {
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results);
  }

  bool get isOffline => _status == ConnectivityStatus.offline;
  bool get isOnline => _status == ConnectivityStatus.online;
}
