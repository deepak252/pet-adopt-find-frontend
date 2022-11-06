import 'package:adopt_us/config/device.dart';
import 'package:adopt_us/config/image_path.dart';
import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  final double? size;
  const AppIconWidget({ Key? key, this.size =70 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImagePath.appIcon,
      width: size,
      height: size,
    );
  }
}