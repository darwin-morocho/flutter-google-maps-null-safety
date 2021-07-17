import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:provider/provider.dart';

class CancelPickFromMapButton extends StatelessWidget {
  const CancelPickFromMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visible = context.select<HomeController, bool>(
      (controller) => controller.state.pickFromMap != null,
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
          onPressed: context.read<HomeController>().cancelPickFromMap,
        ),
      ),
    );
  }
}
