import 'dart:async';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:google_maps/app/helpers/image_to_bytes.dart';
import 'package:google_maps/app/ui/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();

  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;

  final initialCameraPosition = const CameraPosition(
    target: LatLng(-0.2053476, -78.4894387),
    zoom: 15,
  );

  final _homerIcon = Completer<BitmapDescriptor>();

  HomeController() {
    imageToBytes(
      'https://i.pinimg.com/originals/43/d3/57/43d357652634907fd265991b38010f62.png',
      width: 130,
      fromNetwork: true,
    ).then(
      (value) {
        final bitmap = BitmapDescriptor.fromBytes(value);
        _homerIcon.complete(bitmap);
      },
    );
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mapStyle);
  }

  void onTap(LatLng position) async {
    final id = _markers.length.toString();
    final markerId = MarkerId(id);

    final icon = await _homerIcon.future;

    final marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
      icon: icon,
      // anchor: const Offset(0.5, 1),
      onTap: () {
        _markersController.sink.add(id);
      },
      onDragEnd: (newPosition) {
        print("new position $newPosition");
      },
    );
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _markersController.close();
    super.dispose();
  }
}
