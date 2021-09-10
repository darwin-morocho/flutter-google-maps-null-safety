import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/home_page.dart';
import 'package:google_maps/app/ui/pages/home/utils/go_to_search.dart';
import 'package:flutter_meedu/state.dart';

class WhereAreYouGoingButton extends ConsumerWidget {
  const WhereAreYouGoingButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(homeProvider);
    final state = controller.state;
    final hide =
        controller.originAndDestinationReady || state.fetching || state.pickFromMap != null;

    if (hide) {
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
                Icons.add,
                color: Colors.black87,
              ),
              onPressed: controller.zoomIn,
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.remove,
                color: Colors.black87,
              ),
              onPressed: controller.zoomOut,
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              onPressed: () => goToSearch(),
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
                child: const Text(
                  "Where are you going?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
