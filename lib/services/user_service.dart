import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class UserService{
  static final _debug = DebugUtils("UserService");
 
  static Future<User?> getProfile({
    required String token
  }) async {
    return await HttpUtils.get(
      methodName: "getProfile", 
      token: token,
      api: ApiPath.getProfile,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return User.fromJson(res['data']);
        }
        return null;
      },
      debug: _debug,
    );
  }

  static Future<User?> updateProfile({
    required String token,
    required Map<String,dynamic> data
  }) async {
    return await HttpUtils.post(
      methodName: "updateProfile", 
      token: token,
      api: ApiPath.updateProfile,
      body: data,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return User.fromJson(res['data']);
        }
        return null;
      },
      debug: _debug,
    );
  }

 
}