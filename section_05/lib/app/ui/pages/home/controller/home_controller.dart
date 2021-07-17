import 'dart:async';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:google_maps/app/data/providers/local/geolocator_wrapper.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/domain/repositories/brackground_location_repository.dart';
import 'package:google_maps/app/domain/repositories/reverse_geocode_repository.dart';
import 'package:google_maps/app/domain/repositories/routes_repository.dart';
import 'package:google_maps/app/helpers/current_position.dart';
import 'package:google_maps/app/ui/pages/home/controller/utils/set_route.dart';
import 'package:google_maps/app/ui/pages/home/controller/utils/set_zoom.dart';
import 'package:google_maps/app/ui/pages/home/widgets/custom_painters/circle_marker.dart';
import 'package:google_maps/app/ui/utils/fit_map.dart';
import 'package:google_maps/app/ui/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'home_state.dart';

class HomeController extends ChangeNotifier {
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

  StreamSubscription? _gpsSubscription, _postionSubscription;
  GoogleMapController? _mapController;

  final GeolocatorWrapper _geolocator;
  final RoutesRepository _routesRepository;
  final ReverseGeocodeRepository _reverseGeocodeRepository;
  final BackgroundLocationRepository _backgroundLocationRepository;

  BitmapDescriptor? _dotMarker;
  LatLng? _cameraPosition;

  bool get originAndDestinationReady =>
      _state.origin != null && _state.destination != null;

  HomeController({
    required GeolocatorWrapper geolocator,
    required RoutesRepository routesRepository,
    required ReverseGeocodeRepository reverseGeocodeRepository,
    required BackgroundLocationRepository backgroundLocationRepository,
  })  : _routesRepository = routesRepository,
        _geolocator = geolocator,
        _reverseGeocodeRepository = reverseGeocodeRepository,
        _backgroundLocationRepository = backgroundLocationRepository {
    _init();
  }

  Future<void> _init() async {
    final gpsEnabled = await _geolocator.isLocationServiceEnabled;
    _state = state.copyWith(gpsEnabled: gpsEnabled);

    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        _state = state.copyWith(gpsEnabled: enabled);
        notifyListeners();
      },
    );

    _initLocationUpdates();
    _dotMarker = await getDotMarker();
  }

  Future<void> _initLocationUpdates() async {
    bool initialized = false;
    _backgroundLocationRepository.startForegroundService();

    _postionSubscription = _geolocator.onLocationUpdates.listen(
      (position) {
        print("🔥 $position");
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
        CurrentPosition.i.setValue(
          LatLng(position.latitude, position.longitude),
        );
      },
    );
  }

  void _setInitialPosition(Position position) {
    if (state.gpsEnabled && state.initialPosition == null) {
      _state = state.copyWith(
        initialPosition: LatLng(
          position.latitude,
          position.longitude,
        ),
        loading: false,
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
    _mapController = controller;
    final cameraUpdate = CameraUpdate.newLatLng(CurrentPosition.i.value!);
    _mapController!.moveCamera(cameraUpdate);
  }

  void setOriginAndDestination(Place origin, Place destination) async {
    if (originAndDestinationReady) {
      clearData(true);
    } else {
      _state = _state.copyWith(
        fetching: true,
      );
      notifyListeners();
    }

    final routes = await _routesRepository.get(
      origin: origin.position,
      destination: destination.position,
    );

    if (routes != null && routes.isNotEmpty) {
      _state = await setRouteAndMarkers(
        state: state,
        routes: routes,
        origin: origin,
        destination: destination,
        dot: _dotMarker!,
      );

      await _mapController?.animateCamera(
        fitMap(
          origin.position,
          destination.position,
          padding: 100,
        ),
      );

      notifyListeners();
    } else {
      _state = _state.copyWith(
        fetching: false,
      );
      notifyListeners();
    }
  }

  void confirmOriginOrDestination() {
    _state = _state.confirmOriginOrDestination();
    if (originAndDestinationReady) {
      setOriginAndDestination(
        _state.origin!,
        _state.destination!,
      );
    } else {
      notifyListeners();
    }
  }

  Future<void> exchange() async {
    final origin = _state.destination!;
    final destination = _state.origin!;
    clearData();
    return setOriginAndDestination(origin, destination);
  }

  Future<void> turnOnGPS() => _geolocator.openLocationSettings();

  Future<void> zoomIn() async {
    if (_mapController != null) {
      await setZoom(_mapController!, true);
    }
  }

  Future<void> zoomOut() async {
    if (_mapController != null) {
      await setZoom(_mapController!, false);
    }
  }

  void clearData([bool fetching = false]) {
    _state = _state.clearOriginAndDestination(fetching);
    notifyListeners();
  }

  void pickFromMap(bool isOrigin) {
    _state = _state.setPickFromMap(isOrigin);
    notifyListeners();
  }

  void cancelPickFromMap() {
    _state = _state.cancelPickFromMap();
    notifyListeners();
  }

  Future<void> goToMyPosition() async {
    final zoom = await _mapController!.getZoomLevel();
    final cameraUpdate = CameraUpdate.newLatLngZoom(
      CurrentPosition.i.value!,
      zoom < 16 ? 16 : zoom,
    );
    return _mapController!.animateCamera(cameraUpdate);
  }

  void onCameraMoveStarted() {
    if (_state.pickFromMap != null) {
      _state = _state.copyWith(
        pickFromMap: _state.pickFromMap!.copyWith(
          dragging: true,
        ),
      );
      notifyListeners();
    }
  }

  void onCameraMove(CameraPosition cameraPosition) {
    _cameraPosition = cameraPosition.target;
  }

  void onCameraIdle() async {
    if (_state.pickFromMap != null && _cameraPosition != null) {
      final place = await _reverseGeocodeRepository.parse(
        _cameraPosition!,
      );

      _state = _state.copyWith(
        pickFromMap: _state.pickFromMap!.copyWith(
          dragging: false,
          place: place,
        ),
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _postionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _reverseGeocodeRepository.cancel();
    _mapController?.dispose();
    _backgroundLocationRepository.stopForegroundService();
    super.dispose();
  }
}
