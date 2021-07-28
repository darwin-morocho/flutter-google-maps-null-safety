import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> setZoom(GoogleMapController mapController, bool zoomIn) async {
  double zoom = await mapController.getZoomLevel();
  if (!zoomIn) {
    if (zoom - 1 <= 0) {
      return;
    }
  }

  zoom = zoomIn ? zoom + 1 : zoom - 1;

  final bounds = await mapController.getVisibleRegion();
  final northeast = bounds.northeast;
  final southwest = bounds.southwest;
  final center = LatLng(
    (northeast.latitude + southwest.latitude) / 2,
    (northeast.longitude + southwest.longitude) / 2,
  );
  final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
  await mapController.animateCamera(cameraUpdate);
}
