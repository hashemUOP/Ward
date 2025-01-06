import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final double fromLeft;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final int? maxLines; // Changed from int to int? to allow for null
  final Color color;
  final String? fontFamily;

  const MyText({
    super.key, // Added Key? key to fix the super constructor
    required this.fromLeft,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    this.maxLines = 1, // Defined maxLines with a default value of 1
    this.color = Colors.black87,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjusting padding and font size based on screen width
    double paddingValue = fromLeft * screenWidth / 375; // 375 is a reference screen width

    return Padding(
      padding: EdgeInsets.only(left: paddingValue),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
      ),
    );
  }
}
