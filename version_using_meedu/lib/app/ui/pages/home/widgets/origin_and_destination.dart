import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/home_state.dart';
import '../home_page.dart' show homeProvider;
import '../utils/go_to_search.dart';

import 'buttons/timeline_tile.dart';
import 'package:flutter_meedu/state.dart';

class OriginAndDestination extends ConsumerWidget {
  const OriginAndDestination({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, watch) {
    // only build if the origin and destination have changed
    final controller = watch(
      homeProvider.select((state) {
        return state.origin != null && state.destination != null;
      }),
    );

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
        child: controller.originAndDestinationReady ? _View(state: controller.state) : Container(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key, required this.state}) : super(key: key);
  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final origin = state.origin!;
    final destination = state.destination!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoButton(
            onPressed: homeProvider.read.clearData,
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
                        onPressed: () => goToSearch(),
                      ),
                      TimelineTile(
                        label: "Drop off",
                        isTop: false,
                        description: destination.title,
                        onPressed: () => goToSearch( false),
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
                  onPressed: homeProvider.read.exchange,
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
