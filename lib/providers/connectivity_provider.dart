import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    Connectivity().onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);

    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }
    notifyListeners();
  }
}