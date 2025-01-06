import 'package:flutter/material.dart';

class ColorChangingContainer extends StatefulWidget {
  final double width;
  final double height;
  final Icon icon;
  final Icon? iconPost;
  final double iconPadding;
  final double iconPostPadding;
  final Widget inWidget;
  final void Function()? onTap; // Make sure this is final

  ColorChangingContainer({
    super.key,
    this.width = double.infinity,
    this.height = 62,
    required this.icon,
    this.iconPadding = 12,
    required this.inWidget,
    this.iconPost,
    this.iconPostPadding = 0,
    this.onTap,
  });

  @override
  _ColorChangingContainerState createState() => _ColorChangingContainerState();
}

class _ColorChangingContainerState extends State<ColorChangingContainer> {
  Color _currentColor = Colors.white;
  bool _isHolding = false;

  void _changeColorOnHold(bool isHolding) {
    setState(() {
      _currentColor = isHolding ? Colors.grey.shade100 : Colors.white; // Change to your preferred colors
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _isHolding = true;
        _changeColorOnHold(_isHolding);
      },
      onTapUp: (_) {
        _isHolding = false;
        _changeColorOnHold(_isHolding);
        widget.onTap?.call(); // This is where the onTap callback is invoked
      },
      onTapCancel: () {
        _isHolding = false;
        _changeColorOnHold(_isHolding);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350), // Adjust duration as needed
        width: widget.width,
        height: widget.height,
        color: _currentColor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: widget.iconPadding),
              child: widget.icon,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0), // Added padding for alignment
                child: widget.inWidget,
              ),
            ),
            if (widget.iconPost != null) // This checks if iconPost is not null
              Padding(
                padding: EdgeInsets.only(left: widget.iconPostPadding),
                child: widget.iconPost, // Only include iconPost if it's not null
              ),
          ],
        ),
      ),
    );
  }
}
