import 'package:google_maps/app/data/providers/remote/search_api.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/repositories/search_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchRepositoryImpl implements SearchRepository {
  final SearchAPI _searchAPI;

  SearchRepositoryImpl(this._searchAPI);

  @override
  void search(String query, LatLng at) {
    _searchAPI.search(query, at);
  }

  @override
  void cancel() {
    _searchAPI.cancel();
  }

  @override
  void dispose() {
    _searchAPI.dispose();
  }

  @override
  Stream<List<Place>?> get onResults => _searchAPI.onResults;
}
