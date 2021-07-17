import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

abstract class SearchRepository {
  Stream<List<Place>?> get onResults;
  void cancel();
  void dispose();
  void search(String query, LatLng at);
}
