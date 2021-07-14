import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../search_place_controller.dart';
import 'search_input.dart';

class SearchInputs extends StatelessWidget {
  const SearchInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SearchPlaceController>(context, listen: false);
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
