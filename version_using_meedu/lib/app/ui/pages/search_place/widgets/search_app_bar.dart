import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/state.dart';
import '../search_place_page.dart' show OriginAndDestinationResponse, searchProvider;
import 'package:flutter_meedu/router.dart' as router;

class SearchAppBar extends StatelessWidget with PreferredSizeWidget {
  const SearchAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
      elevation: 0,
      actions: [
        Consumer(
          builder: (context, ref, __) {
            final controller = ref.watch(searchProvider);
            final origin = controller.origin;
            final destination = controller.destination;
            final bool enabled = origin != null && destination != null;
            return CupertinoButton(
              child: const Text("SAVE"),
              onPressed: enabled
                  ? () {
                      router.pop(
                        OriginAndDestinationResponse(origin, destination),
                      );
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
