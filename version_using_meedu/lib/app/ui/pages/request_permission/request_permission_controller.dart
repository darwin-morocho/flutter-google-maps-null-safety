import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionController {
  final Permission _locationPermission;
  RequestPermissionController(this._locationPermission);

  final _streamController = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onStatusChanged => _streamController.stream;

  Future<PermissionStatus> check() async {
    final status = await _locationPermission.status;
    return status;
  }

  Future<void> request() async {
    final status = await _locationPermission.request();
    _notify(status);
  }

  void _notify(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
