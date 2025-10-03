import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double borderWidth;
  final double? width;
  final double? height;

  const CustomBox({
    Key? key,
    required this.child,
    this.borderColor = const Color(0xFF3F3F4B),
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 6.0,
    this.borderWidth = 1.0,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
