import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../search_place_page.dart' show PickFromMapResponse, searchProvider;
import 'package:flutter_meedu/router.dart' as router;
import 'package:flutter_meedu/state.dart';

class PickFromMapButton extends ConsumerWidget {
  const PickFromMapButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    final originHasFocus = watch(
      searchProvider.select((_) => _.originHasFocus),
    ).originHasFocus;

    return CupertinoButton( 
      onPressed: () {
        router.pop(
          PickFromMapResponse(originHasFocus),
        );
      },
      child: Text("Pick ${originHasFocus ? "origin" : "destination"} from map"),
    );
  }
}
