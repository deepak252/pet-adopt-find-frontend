import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log("ERROR : Firebase Initialization Error , $e");
  }
  

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
