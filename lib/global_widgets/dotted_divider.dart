import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final int dotCount; // Number of dots
  final double dashWidth;
  final double dashHeight;
  final Color color;

  const DottedDivider({
    super.key,
    this.dotCount = 50, // number of dots in divider
    this.dashWidth = 5.0,
    this.dashHeight = 2.0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(dotCount, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2), // margin between dots
            width: dashWidth,
            height: dashHeight,
            color: color,
          ),
        );
      }),
    );
  }
}
