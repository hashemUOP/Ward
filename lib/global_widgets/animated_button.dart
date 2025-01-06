import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.onTap,
    required this.buttonColor,
    required this.text,
    this.containerHeight,
    this.containerWidth,
    required this.textColor,
    required this.textSize,
    this.containerRadius,
    this.containerBorderColor,
    super.key,
  });

  final VoidCallback onTap;
  final Color buttonColor;
  final String text;
  final double? containerHeight;
  final double? containerWidth;
  final Color textColor;
  final double textSize;
  final double? containerRadius;
  final Color? containerBorderColor;

  @override
  State<AnimatedButton> createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  double _buttonScale = 1;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final buttonColor = widget.buttonColor;
    final text = widget.text;
    final containerHeight = widget.containerHeight ?? screenHeight * 0.055; // default values
    final containerWidth = widget.containerWidth ?? screenWidth * 0.89;//default values
    final textColor = widget.textColor;
    final textSize = widget.textSize;
    final containerRadius = widget.containerRadius ?? 29; //default values
    final containerBorderColor = widget.containerBorderColor;

    _buttonScale = 1 - _controller.value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _startAnimation(),
      onTapUp: (_) {
        _reverseAnimation();
        widget.onTap.call();
      },
      onTapCancel: () => _reverseAnimation(),
      child: Transform.scale(
        scale: _buttonScale,
        child: Container(
          height: containerHeight,
          width: containerWidth,
          decoration: BoxDecoration(
            color: buttonColor,
            border: containerBorderColor != null
                ? Border.all(
              color: containerBorderColor,
              width: 1,
            )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: textSize,
                  color: textColor,
                  fontFamily: 'fonts/Ubuntu-Medium.ttf',
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startAnimation() {
    _controller.forward();
  }

  void _reverseAnimation() {
    _controller.reverse();
  }
}
