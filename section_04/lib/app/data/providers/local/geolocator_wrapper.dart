import 'dart:async';
import 'package:geolocator/geolocator.dart';

class GeolocatorWrapper {
  StreamController<Position>? _positionController;
  StreamController<bool>? _serviceEnabledController;
  StreamSubscription? _positionSubscription, _serviceEnabledSubscription;

  /// check if the Location Service is Enabled
  Future<bool> get isLocationServiceEnabled => Geolocator.isLocationServiceEnabled();

  /// Returns a [Future] indicating if the user allows the App to access the device's location.
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<bool> get hasPermission async {
    final status = await checkPermission();
    return status == LocationPermission.always || status == LocationPermission.whileInUse;
  }

  /// Calculates the initial bearing between two points
  double bearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  /// return a stream to listen the changes in the GPS status
  Stream<bool> get onServiceEnabled {
    _serviceEnabledController ??= StreamController.broadcast();

    // listen the changes in GPS status
    _serviceEnabledSubscription = Geolocator.getServiceStatusStream().listen(
      (event) {
        final enabled = event == ServiceStatus.enabled;
        if (enabled) {
          _notifyServiceEnabled(true);
          if (_positionController != null) {
            _initLocationUpdates();
          }
        }
      },
    );

    return _serviceEnabledController!.stream;
  }

  /// return a stream to listen the changes in the current position
  Stream<Position> get onLocationUpdates {
    _positionController ??= StreamController.broadcast();
    _initLocationUpdates();
    return _positionController!.stream;
  }

  /// start listening the position changes
  void _initLocationUpdates() async {
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream().listen(
      (event) {
        _positionController?.sink.add(event);
      },
      onError: (e) {
        if (e is LocationServiceDisabledException) {
          _notifyServiceEnabled(false);
        }
      },
    );
  }

  /// notify to all listeners that the location service has changed
  void _notifyServiceEnabled(bool enabled) {
    _serviceEnabledController?.sink.add(enabled);
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  /// returns the current position
  Future<Position?> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) async {
    try {
      // getCurrentPosition throws an exception when the location service is disabled
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  /// Returns the last known position stored on the users device.
  Future<Position?> getLastKnownPosition({bool forceAndroidLocationManager = false}) async {
    return Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: forceAndroidLocationManager,
    );
  }

  /// release the controllers and cancel all subscribers
  void dispose() {
    _positionController?.close();
    _serviceEnabledSubscription?.cancel();
    _serviceEnabledController?.close();
    _positionSubscription?.cancel();
  }
}
