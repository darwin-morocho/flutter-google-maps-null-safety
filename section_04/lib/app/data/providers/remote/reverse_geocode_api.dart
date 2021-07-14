import 'package:dio/dio.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/helpers/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class ReverseGeocodeAPI {
  final Dio _dio;

  ReverseGeocodeAPI(this._dio);
  CancelToken? _cancelToken;

  Future<Place?> parse(LatLng at) async {
    cancel();
    try {
      _cancelToken = CancelToken();
      final response = await _dio.get(
        'https://revgeocode.search.hereapi.com/v1/revgeocode',
        queryParameters: {
          'at': '${at.latitude},${at.longitude}',
          'apiKey': apiKey,
        },
        cancelToken: _cancelToken,
      );

      _cancelToken = null;

      final list = response.data['items'] as List;
      if (list.isEmpty) {
        return null;
      }

      final element = list.first;

      return Place(
        id: element['id'],
        title: element['title'],
        address: element['address']['label'],
        position: at,
        distance: element['distance'],
      );
    } catch (e) {
      _cancelToken = null;
      return null;
    }
  }

  void cancel() {
    _cancelToken?.cancel();
    _cancelToken = null;
  }
}
