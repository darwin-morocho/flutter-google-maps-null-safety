import 'package:google_maps_flutter/google_maps_flutter.dart';

class Route {
  final int duration, length;
  final List<LatLng> points;

  Route({
    required this.duration,
    required this.length,
    required this.points,
  });
}
