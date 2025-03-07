// lib/widgets/offline_indicator.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineIndicator extends StatelessWidget {
  final VoidCallback onSync;

  OfflineIndicator({required this.onSync});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final isOffline = snapshot.data == ConnectivityResult.none;
        if (!isOffline) {
          onSync(); // Trigger sync when online
        }
        return isOffline
            ? Container(
          padding: EdgeInsets.all(8),
          color: Colors.red,
          child: Text('Offline', style: TextStyle(color: Colors.white)),
        )
            : SizedBox.shrink();
      },
    );
  }
}



Future<bool> isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}
