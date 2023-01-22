import 'dart:developer';

import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/request_controller.dart';
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
  
  String? _token = UserPrefs.token;

  bool get validateUser{
    log("ProfileController, Validate User");
    if(user!=null){
      final user=this.user!;
      return !(user.fullName==null || user.fullName!.trim() == '' ||
        user.email==null || user.email!.trim() == '' ||
        user.mobile==null || user.mobile!.trim() == '' ||
        user.address?.addressLine==null || user.address?.addressLine?.trim() == '' ||
        user.address?.city==null || user.address?.city?.trim() == '' ||
        user.address?.country==null || user.address?.country?.trim() == '' ||
        user.address?.pincode==null || user.address?.pincode?.trim() == '' ||
        user.address?.latitude==null || user.address?.longitude==null
      );
    }
    return false;
  }
  
  @override
  void onInit() {
    _token = UserPrefs.token;
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
    // log("${data}");
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
    await Get.delete<ChatController>();
    await Get.delete<BottomNavController>();
    await Get.delete<RequestController>();
    await Get.delete<PetController>();
    await Get.delete<UserController>();
  }

}