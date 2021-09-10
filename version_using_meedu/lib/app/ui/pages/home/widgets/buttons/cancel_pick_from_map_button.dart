import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/state.dart';
import 'package:google_maps/app/ui/pages/home/home_page.dart';

class CancelPickFromMapButton extends ConsumerWidget {
  const CancelPickFromMapButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final visible = ref.select(
      homeProvider.select((_) => _.pickFromMap != null),
    );

    if (!visible) {
      return Container();
    }
    return Positioned(
      left: 15,
      top: 15,
      child: SafeArea(
        child: CupertinoButton(
          padding: const EdgeInsets.all(7),
          borderRadius: BorderRadius.circular(30),
          child: const Icon(
            Icons.close_rounded,
            color: Colors.black,
            size: 30,
          ),
          color: Colors.white,
          onPressed: homeProvider.read.cancelPickFromMap,
        ),
      ),
    );
  }
}
