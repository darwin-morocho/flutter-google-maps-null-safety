import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_state.dart';
import 'package:provider/provider.dart';

class ConfirmFromMapButton extends StatelessWidget {
  const ConfirmFromMapButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PickFromMap? data = context.select<HomeController, PickFromMap?>((controller) {
      final state = controller.state;
      return state.pickFromMap;
    });

    if (data == null) {
      return Container();
    }
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.gps_fixed_rounded,
                color: Colors.black87,
              ),
              onPressed: context.read<HomeController>().goToMyPosition,
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: data.place != null
                  ? () {
                      context.read<HomeController>().confirmOriginOrDestination();
                    }
                  : null,
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Confirm ${data.isOrigin ? 'origin' : 'destination'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
