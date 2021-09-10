import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_meedu/state.dart';
import '../../home_page.dart' show homeProvider;

class ConfirmFromMapButton extends ConsumerWidget {
  const ConfirmFromMapButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final data = ref.select(
      homeProvider.select((_) => _.pickFromMap),
    );

    final controller = homeProvider.read;

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
              onPressed: controller.goToMyPosition,
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: data.place != null ? controller.confirmOriginOrDestination : null,
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
