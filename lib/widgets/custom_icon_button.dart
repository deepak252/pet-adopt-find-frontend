import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? child;
  final double? size;
  final Color? btnColor;
  const CustomIconButton({ 
    Key? key,
    required this.onPressed,
    this.child,
    this.icon,
    this.size=50,
    this.btnColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: RawMaterialButton(
        onPressed: onPressed, 
        shape: const CircleBorder(),
        fillColor: btnColor,
        child: child ??( icon!=null 
          ? Icon(icon!) 
          : const SizedBox()
        )
      ),
    );
  }
}