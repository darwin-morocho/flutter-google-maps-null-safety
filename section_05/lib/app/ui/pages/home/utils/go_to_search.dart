import 'package:flutter/material.dart' show BuildContext, MaterialPageRoute, Navigator, WidgetsBinding;
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

void goToSearch(BuildContext context, [bool hasOriginFocus = true]) async {
  final controller = Provider.of<HomeController>(
    context,
    listen: false,
  );

  final state = controller.state;

  final route = MaterialPageRoute<SearchResponse>(
    builder: (_) => SearchPlacePage(
      initialOrigin: state.origin,
      initialDestination: state.destination,
      hasOriginFocus: hasOriginFocus,
    ),
  );
  final response = await Navigator.push<SearchResponse>(
    context,
    route,
  );
  if (response != null) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        final controller = context.read<HomeController>();
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
