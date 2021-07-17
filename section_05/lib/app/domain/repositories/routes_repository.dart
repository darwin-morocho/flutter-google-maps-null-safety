import 'package:google_maps/app/domain/models/route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

abstract class RoutesRepository {
  Future<List<Route>?> get({
    required LatLng origin,
    required LatLng destination,
  });
}
