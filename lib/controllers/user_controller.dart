import 'dart:developer';

import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/services/fcm_service.dart';
import 'package:adopt_us/services/user_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final _loading = false.obs;
  bool get isLoading => _loading.value;

  final  _user = Rxn<User>();
  User? get user => _user.value;
  bool get isSignedIn => user!=null;
  
  final _token = UserPrefs.token;
  
  @override
  void onInit() {
    super.onInit();
    
    fetchProfile();
    
  }

  Future fetchProfile({bool enableLoading = false})async{
    if(isLoading || UserPrefs.token==null){
      return;
    }
    log("JWT TOKEN : ${UserPrefs.token}");
    if(enableLoading){
      _loading(true);
    }
    final result = await UserService.getProfile(token: UserPrefs.token!);
    _user(result);
    // if(user!=null){
    //   // final String? fcmToken = await FCMService.getFcmToken();
    //   // log("FCM Token $fcmToken");
    //   // UserService.updateProfile(
    //   //   token: _token!,
    //   //   data: {
    //   //     "fcmToken" : fcmToken
    //   //   }
    //   // );
    // }
    if(enableLoading){
      _loading(false);
    }
  }


  Future<bool> updateProfile(Map<String,dynamic> data)async{
    if(_token==null){
      return false;
    }
    final user = await UserService.updateProfile(
      token: _token!,
      data: data
    );
    if(user!=null){
      _user(user);
      return true;
    }
    return false;
  }

  Future logOut()async{
    _user(null);
    await UserPrefs.clearData();
    await Get.delete<UserController>();
    await Get.delete<BottomNavController>();
  }

}