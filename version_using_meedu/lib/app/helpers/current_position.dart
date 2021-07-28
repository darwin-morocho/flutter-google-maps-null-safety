import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentPosition {
  CurrentPosition._();
  static CurrentPosition i = CurrentPosition._();

  LatLng? _value;
  LatLng? get value => _value;

  void setValue(LatLng? v) {
    _value = v;
  }
}
