import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Adopt Us',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      home: SplashScreen(),
    );
  }
}
