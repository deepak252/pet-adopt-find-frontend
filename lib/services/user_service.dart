import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class UserService{
  static final _debug = DebugUtils("UserService");
 
  static Future getProfile({
    required String token
  }) async {
    return await HttpUtils.get(
      methodName: "getProfile", 
      token: token,
      api: ApiPath.getProfile,
      onSuccess: (res)async{
        return res?['data'];
      },
      debug: _debug,
    );
  }

 
}