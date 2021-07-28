import 'package:google_maps/app/data/providers/remote/reverse_geocode_api.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/repositories/reverse_geocode_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ReverseGeocodeRepositoryImpl implements ReverseGeocodeRepository {
  final ReverseGeocodeAPI _reverseGeocodeAPI;

  ReverseGeocodeRepositoryImpl(this._reverseGeocodeAPI);
  @override
  void cancel() {
    _reverseGeocodeAPI.cancel();
  }

  @override
  Future<Place?> parse(LatLng at) {
    return _reverseGeocodeAPI.parse(at);
  }
}
