import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/services/fcm_service.dart';
import 'package:adopt_us/splash_screen.dart';
import 'package:adopt_us/utils/notification_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationUtils.initializeLocalNotifications();
    await GetStorage.init();
    await FCMService.init();
    FirebaseMessaging.onBackgroundMessage(handleFcmMessage);
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
