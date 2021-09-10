import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_meedu/state.dart';
import '../home_page.dart' show homeProvider;

class FixedMarker extends ConsumerWidget {
  final double mapPadding, height;
  const FixedMarker({
    Key? key,
    required this.mapPadding,
    required this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final pickFromMap = ref.select(
      homeProvider.select((_) => _.pickFromMap),
    );

    if (pickFromMap == null) {
      return Container();
    }

    final place = pickFromMap.place;
    final dragging = pickFromMap.dragging;

    return Positioned(
      top: 0.5 * (height + mapPadding) - 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, -25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      child: place != null && !dragging
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 250,
                              ),
                              child: Text(
                                place.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : dragging
                              ? const SpinKitCircle(
                                  color: Colors.white,
                                  size: 24,
                                )
                              : const SizedBox(width: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 2,
                  height: 10,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
