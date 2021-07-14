import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_controller.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class PickFromMapButton extends StatelessWidget {
  const PickFromMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final originHasFocus = context.select<SearchPlaceController, bool>(
      (controller) => controller.originHasFocus,
    );

    return CupertinoButton(
      onPressed: () {
        Navigator.pop(
          context,
          PickFromMapResponse(originHasFocus),
        );
      },
      child: Text("Pick ${originHasFocus ? "origin" : "destination"} from map"),
    );
  }
}
