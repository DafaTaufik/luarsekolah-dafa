import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final Widget? icon;
  final Widget? customContent;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final double? iconSpacing;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    this.backgroundColor = const Color(0xFF077E60),
    this.textColor = Colors.white,
    this.borderColor,
    this.icon,
    this.customContent,
    this.onPressed,
    this.width,
    this.height = 46,
    this.borderRadius = 6,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.iconSpacing = 8,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child:
            customContent ??
            (icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      SizedBox(width: iconSpacing),
                      Flexible(
                        child: Text(
                          text,
                          style:
                              textStyle ??
                              TextStyle(
                                fontSize: fontSize,
                                fontWeight: fontWeight,
                                color: textColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style:
                        textStyle ??
                        TextStyle(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: textColor,
                        ),
                    textAlign: TextAlign.center,
                  )),
      ),
    );
  }
}
