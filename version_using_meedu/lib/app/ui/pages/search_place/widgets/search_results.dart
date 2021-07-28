import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:google_maps/app/utils/distance_format.dart';

import 'package:flutter_meedu/state.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    final controller = watch(searchProvider);
    final places = controller.places;
    if (places == null) {
      return const Center(
        child: Text("Error"),
      );
    } else if (places.isEmpty && controller.query.length >= 3) {
      return const Center(
        child: Text("Empty"),
      );
    }

    return ListView.builder(
      itemBuilder: (_, index) {
        final place = places[index];
        return ListTile(
          leading: Text(
            distanceFormat(place.distance),
          ),
          title: Text(place.title),
          subtitle: Text(place.address),
          onTap: () {
            FocusScope.of(context).unfocus();
            controller.pickPlace(place);
          },
        );
      },
      itemCount: places.length,
    );
  }
}
