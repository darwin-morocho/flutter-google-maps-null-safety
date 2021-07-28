import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'search_input.dart';

class SearchInputs extends StatelessWidget {
  const SearchInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = searchProvider.read;
    return Column(
      children: [
        SearchInput(
          controller: controller.originController,
          focusNode: controller.originFocusNode,
          placeholder: 'origin',
          onChanged: controller.onQueryChanged,
          onClear: controller.clearQuery,
        ),
        SearchInput(
          controller: controller.destinationController,
          focusNode: controller.destinationFocusNode,
          placeholder: 'destination',
          onChanged: controller.onQueryChanged,
          onClear: controller.clearQuery,
        ),
      ],
    );
  }
}
