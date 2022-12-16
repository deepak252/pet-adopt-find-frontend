import 'dart:developer';

import 'package:adopt_us/models/user.dart';
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
    // fetchProfile();
    // TODO: implement onInit
    super.onInit();
  }

  Future fetchProfile({bool enableLoading = false})async{
    // log("TOKEN1 : $_token");
    // log("TOKEN2 : ${UserPrefs.token}");
    if(isLoading || _token==null){
      return;
    }
    if(enableLoading){
      _loading(true);
    }
    final user = await UserService.getProfile(token: _token!);
    if(user!=null){
      _user(user);
    }
    if(enableLoading){
      _loading(false);
    }
  }

  Future logOut()async{
    _user(null);
    await UserPrefs.clearData();
    await Get.delete<UserController>();
  }

}