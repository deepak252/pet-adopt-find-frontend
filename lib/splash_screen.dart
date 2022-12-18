
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/screens/dashboard.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _loading=ValueNotifier(true);
  final _userController = Get.put(UserController());

  @override
  void initState() {
    initUser();
    super.initState();
  }

  Future initUser()async{
    _loading.value=true;
    await _userController.fetchProfile(enableLoading: true);
    _loading.value=false;
  }

  @override
  Widget build(BuildContext context) {
    // return Obx((){
    //   log("_userController.isLoading ${_userController.isLoading}");
    //   if(_userController.isLoading){
    //     return _splash;
    //   }
    //   return const Dashboard();
    // });
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (context, isLoading, child) {
        if(isLoading){
          return _splash;
        }
        return const Dashboard();
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