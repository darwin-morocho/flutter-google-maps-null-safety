import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelineTile extends StatelessWidget {
  final String label, description;
  final VoidCallback onPressed;
  final bool isTop;
  const TimelineTile({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.description,
    required this.isTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: isTop ? 12 : 0,
          left: 6.5,
          bottom: isTop ? 0 : null,
          height: isTop ? null : 14,
          child: Container(
            width: 1,
            color: Colors.black,
          ),
        ),
        if (!isTop)
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colors.black12,
            margin: const EdgeInsets.only(left: 30),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
