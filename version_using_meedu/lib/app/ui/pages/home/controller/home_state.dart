import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    @Default(true) bool loading,
    @Default(false) bool gpsEnabled,
    @Default(false) bool fetching,
    @Default({}) Map<MarkerId, Marker> markers,
    @Default({}) Map<PolylineId, Polyline> polylines,
    LatLng? initialPosition,
    Place? origin,
    Place? destination,
    PickFromMap? pickFromMap,
  }) = _HomeState;

  static HomeState get initialState => const HomeState();

  HomeState clearOriginAndDestination(bool fetching) {
    return HomeState(
      pickFromMap: null,
      fetching: fetching,
      loading: loading,
      gpsEnabled: gpsEnabled,
      markers: {},
      polylines: {},
      initialPosition: initialPosition,
      origin: null,
      destination: null,
    );
  }

  HomeState setPickFromMap(bool isOrigin) {
    return HomeState(
      pickFromMap: PickFromMap(
        place: null,
        isOrigin: isOrigin,
        origin: origin,
        destination: destination,
        markers: markers,
        polylines: polylines,
        dragging: false,
      ),
      markers: {},
      polylines: {},
      origin: null,
      destination: null,
      loading: loading,
      fetching: fetching,
      gpsEnabled: gpsEnabled,
      initialPosition: initialPosition,
    );
  }

  HomeState cancelPickFromMap() {
    final prevData = pickFromMap!;
    return HomeState(
      pickFromMap: null,
      fetching: fetching,
      loading: loading,
      gpsEnabled: gpsEnabled,
      markers: prevData.markers,
      polylines: prevData.polylines,
      initialPosition: initialPosition,
      origin: prevData.origin,
      destination: prevData.destination,
    );
  }

  HomeState confirmOriginOrDestination() {
    final data = pickFromMap!;

    return HomeState(
      loading: loading,
      gpsEnabled: gpsEnabled,
      markers: markers,
      polylines: polylines,
      initialPosition: initialPosition,
      origin: data.isOrigin ? data.place : data.origin,
      destination: !data.isOrigin ? data.place : data.destination,
      fetching: fetching,
      pickFromMap: null,
    );
  }
}

@freezed
class PickFromMap with _$PickFromMap {
  const PickFromMap._();
  const factory PickFromMap({
    Place? place,
    Place? origin,
    Place? destination,
    required bool isOrigin,
    required bool dragging,
    required Map<MarkerId, Marker> markers,
    required Map<PolylineId, Polyline> polylines,
  }) = _PickFromMap;
}
