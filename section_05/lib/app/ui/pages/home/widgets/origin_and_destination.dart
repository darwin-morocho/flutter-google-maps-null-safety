import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app/ui/pages/home/controller/home_controller.dart';
import 'package:google_maps/app/ui/pages/home/utils/go_to_search.dart';
import 'package:google_maps/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

import 'buttons/timeline_tile.dart';

class OriginAndDestination extends StatelessWidget {
  const OriginAndDestination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final originAndDestinationReady = context.select<HomeController, bool>((controller) {
      final state = controller.state;
      return state.origin != null && state.destination != null;
    });

    return Positioned(
      left: 15,
      right: 15,
      top: 10,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final position = Tween<Offset>(
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(animation);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
        child: originAndDestinationReady ? const _View() : Container(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(
      context,
      listen: false,
    );
    final state = controller.state;
    final origin = state.origin!;
    final destination = state.destination!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoButton(
            onPressed: context.read<HomeController>().clearData,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(30),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TimelineTile(
                        label: "Pickup",
                        isTop: true,
                        description: origin.title,
                        onPressed: () => goToSearch(context),
                      ),
                      TimelineTile(
                        label: "Drop off",
                        isTop: false,
                        description: destination.title,
                        onPressed: () => goToSearch(context, false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                CupertinoButton(
                  color: Colors.grey.withOpacity(0.2),
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(30),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.blue,
                  ),
                  onPressed: controller.exchange,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
