import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/helpers/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchAPI {
  final Dio _dio;

  SearchAPI(this._dio);
  CancelToken? _cancelToken;
  final _controller = StreamController<List<Place>?>.broadcast();
  Stream<List<Place>?> get onResults => _controller.stream;

  void search(String query, LatLng at) async {
    try {
      _cancelToken = CancelToken();
      final response = await _dio.get(
        'https://autosuggest.search.hereapi.com/v1/autosuggest',
        queryParameters: {
          "apiKey": apiKey,
          "q": query,
          "at": "${at.latitude},${at.longitude}",
          "in": "countryCode:ECU",
          "types": "place,street,city,locality,intersection",
        },
        cancelToken: _cancelToken,
      );
      final results = (response.data['items'] as List)
          .map(
            (e) => Place.fromJson(e),
          )
          .toList();
      _controller.sink.add(results);
      _cancelToken = null;
    } on DioError catch (e) {
      if (e.type != DioErrorType.cancel) {
        _controller.sink.add(null);
      }
    }
  }

  void cancel() {
    if (_cancelToken != null) {
      _cancelToken!.cancel();
      _cancelToken = null;
    }
  }

  void dispose() {
    cancel();
    _controller.close();
  }
}
