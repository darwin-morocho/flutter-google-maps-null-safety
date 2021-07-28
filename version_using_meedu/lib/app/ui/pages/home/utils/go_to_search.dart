import 'package:flutter/material.dart' show WidgetsBinding;
import 'package:google_maps/app/ui/pages/home/home_page.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:flutter_meedu/router.dart' as router;

void goToSearch([bool hasOriginFocus = true]) async {
  final controller = homeProvider.read;
  final state = controller.state;

  final response = await router.push<SearchResponse>(
    const SearchPlacePage(),
    transition: router.Transition.downToUp,
    transitionDuration: const Duration(milliseconds: 200),
    arguments: SearchPlaceArguments(
      initialOrigin: state.origin,
      initialDestination: state.destination,
      hasOriginFocus: hasOriginFocus,
      
    ),
  );
  if (response != null) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        if (response is OriginAndDestinationResponse) {
          controller.setOriginAndDestination(
            response.origin,
            response.destination,
          );
        } else if (response is PickFromMapResponse) {
          controller.pickFromMap(response.isOrigin);
        }
      },
    );
  }
}
