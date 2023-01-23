import 'package:adopt_us/config/app_theme.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final EdgeInsets? padding;
  final double width;
  final double textSize;
  final bool boldText;
  final Color borderColor;
  final Color? txtColor;
  final Widget? child;
  final double borderRadius;
  const CustomOutlinedButton({ 
    Key? key,
    required this.onPressed,
    this.child,
    this.text,
    this.padding,
    this.textSize=18,
    this.width = double.infinity,
    this.boldText = true,
    this.borderColor = Colors.red,
    this.txtColor,
    this.borderRadius=12
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding ?? const EdgeInsets.all(12),
        side: BorderSide(
          color: borderColor
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        minimumSize: Size(width, 1)
      ),
      child: child?? Text(
        '$text',
        style: TextStyle(
          fontSize: textSize,
          fontWeight: boldText ? FontWeight.w500 : FontWeight.w400,
          color: txtColor??borderColor
        ),
      ),
    );
  }
}