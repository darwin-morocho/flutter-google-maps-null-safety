import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/state.dart';
import 'package:google_maps/app/domain/models/place.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/widgets/pick_from_map_button.dart';
import 'package:google_maps/app/ui/pages/search_place/widgets/search_results.dart';

import 'widgets/search_app_bar.dart';
import 'widgets/search_inputs.dart';
import 'package:flutter_meedu/page.dart';
import 'package:flutter_meedu/meedu.dart';

final searchProvider = SimpleProvider(
  (_) => SearchPlaceController(_.arguments),
);

abstract class SearchResponse {}

class PickFromMapResponse extends SearchResponse {
  final bool isOrigin;
  PickFromMapResponse(this.isOrigin);
}

class OriginAndDestinationResponse extends SearchResponse {
  final Place origin, destination;
  OriginAndDestinationResponse(this.origin, this.destination);
}

class SearchPlacePage extends PageWithArgumentsWidget {
  const SearchPlacePage({Key? key}) : super(key: key);

  @override
  void onInit(RouteSettings settings) {
    searchProvider.setArguments(
      settings.arguments as SearchPlaceArguments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderListener<SearchPlaceController>(
      provider: searchProvider,
      onAfterFirstLayout: (_, controller) => Timer(
        const Duration(milliseconds: 300),
        () {
          if (!controller.disposed) {
            controller.setInitialFocus();
          }
        },
      ),
      builder: (_, controller) {
        return Scaffold(
          appBar: const SearchAppBar(),
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: const [
                  SearchInputs(),
                  SizedBox(height: 10),
                  PickFromMapButton(),
                  Expanded(
                    child: SearchResults(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
