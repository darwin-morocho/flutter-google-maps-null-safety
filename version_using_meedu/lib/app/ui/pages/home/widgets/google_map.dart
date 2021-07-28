import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/state.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'buttons/cancel_pick_from_map_button.dart';
import 'buttons/where_are_you_going_button.dart';
import '../home_page.dart' show homeProvider;
import '../widgets/buttons/confirm_from_map_button.dart';
import '../widgets/fixed_marker.dart';
import '../widgets/origin_and_destination.dart';

class MapView extends StatelessWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, gpsMessageWidget) {
        final controller = watch(homeProvider);
        final state = controller.state;

        if (!state.gpsEnabled) {
          return gpsMessageWidget!;
        }

        final initialCameraPosition = CameraPosition(
          target: LatLng(
            state.initialPosition!.latitude,
            state.initialPosition!.longitude,
          ),
          zoom: 15,
        );

        final mapPadding = size.height * 0.25;

        return LayoutBuilder(
          builder: (_, constraints) => Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                markers: state.markers.values.toSet(),
                polylines: state.polylines.values.toSet(),
                onMapCreated: (mapController) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    controller.onMapCreated(mapController);
                  });
                },
                initialCameraPosition: initialCameraPosition,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                compassEnabled: false,
                zoomControlsEnabled: false,
                padding: EdgeInsets.only(
                  top: mapPadding,
                ),
                onCameraMoveStarted: controller.onCameraMoveStarted,
                onCameraMove: controller.onCameraMove,
                onCameraIdle: controller.onCameraIdle,
              ),
              const WhereAreYouGoingButton(),
              const OriginAndDestination(),
              FixedMarker(
                mapPadding: mapPadding,
                height: constraints.maxHeight,
              ),
              const CancelPickFromMapButton(),
              const ConfirmFromMapButton(),
            ],
          ),
        );
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "To use our app we need the access to your location,\n so you must enable the GPS",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                homeProvider.read.turnOnGPS();
              },
              child: const Text("Turn on GPS"),
            ),
          ],
        ),
      ),
    );
  }
}
