import 'package:flutter/services.dart';
import 'package:google_maps/app/utils/platform.dart';

class BackgroundLocation {
  final _channel = const MethodChannel('app.meedu/background-location');

  Future<void> startForegroundService() async {
    if (isAndroid) {
      await _channel.invokeMethod('start');
    }
  }

  Future<void> stopForegroundService() async {
    if (isAndroid) {
      await _channel.invokeMethod('stop');
    }
  }
}
