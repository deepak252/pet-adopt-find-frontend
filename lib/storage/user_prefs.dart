import 'dart:convert';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:get_storage/get_storage.dart';

class UserPrefs {
  static final _debug = DebugUtils("UserPrefs");
  static final GetStorage _getStorage = GetStorage();

  static const String _tokenKey = 'token';
  static const String _profileKey = 'profile';
  static const String _firstStartKey = 'firstStart';

  static String? getToken() {
    return _getStorage.read(_tokenKey);
  }

  static Future setToken({required String value})async{
    await _getStorage.write(_tokenKey, value);
    _debug.message("setToken", value);
  }

  // static User? getProfile() {
  //   try{
  //     String? rawUser = _getStorage.read(_profileKey);
  //     if(rawUser!=null){
  //       return User.fromJson(jsonDecode(rawUser));
  //     }
  //   }catch(e,s){
  //     _debug.error("getProfile", error: e, stackTrace: s);
  //   }
  //   return null;
  // }

  // static Future setProfile({required User user})async{
  //   try{
  //     await _getStorage.write(_profileKey, jsonEncode(user.toJson()));
  //     _debug.message("setProfile", user.toJson());
  //   }catch(e,s){
  //     _debug.error("setProfile", error: e, stackTrace: s);
  //   }
    
  // }

  static bool isFirstStart() {
    return _getStorage.read(_firstStartKey)??true;
  }

  static Future setFirstStart({required bool value})async{
    await _getStorage.write(_firstStartKey, value);
    _debug.message("setFirstStart", value);
  }

  static Future clearData() async{
    await _getStorage.erase();
    _debug.message("clearData", "Removed User Prefs");
  }

}