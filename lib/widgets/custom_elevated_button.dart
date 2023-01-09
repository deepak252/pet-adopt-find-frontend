import 'package:adopt_us/config/app_theme.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsets? padding;
  final double width;
  final double textSize;
  final bool boldText;
  final Color? btnColor;
  final Color? txtColor;
  final Widget? child;
  final double borderRadius;
  const CustomElevatedButton({ 
    Key? key,
    required this.onPressed,
    this.child,
    this.text,
    this.padding,
    this.textSize=18,
    this.width = double.infinity,
    this.boldText = true,
    this.btnColor,
    this.txtColor,
    this.borderRadius=12
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(18),
        backgroundColor: btnColor??Themes.colorPrimary,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size(width, 1)
      ),
      child: child?? Text(
        '$text',
        style: TextStyle(
            fontSize: textSize,
            fontWeight: boldText ? FontWeight.w500 : FontWeight.w400,
            color: txtColor
          ),
      ),
    );
  }
}