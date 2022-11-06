import 'package:adopt_us/screens/dashboard.dart';
import 'package:adopt_us/screens/home_screen.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _loading=ValueNotifier(true);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),()=>_loading.value=false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (context, isLoading, child) {
        if(isLoading){
          return _splash;
        }
        return const Dashboard();
        // return const HomeScreen();
      }
    );
  }

  Widget get _splash =>const  Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: AppIconWidget()
    ),
  );
}