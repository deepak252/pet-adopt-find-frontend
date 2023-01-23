import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class AuthService{
  static final _debug = DebugUtils("AuthService");
 
  //Return token on successful SignUp
  static Future<String?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await HttpUtils.post<String?>(
      methodName: "signUp", 
      api: ApiPath.signUp, 
      body: {
        "fullName": name,
        "email": email,
        "password": password,
        "mobile": phone,
      },
      onSuccess: (res)async{
        return res?['data']?['token'];
      },
      debug: _debug,
    );
  }

  //Return token on successful SignIn
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    return await HttpUtils.post<String?>(
      methodName: "signIn", 
      api: ApiPath.signIn, 
      body: {
        "email": email,
        "password": password,
      },
      onSuccess: (res)async{
        return res?['data']?['token'];
      },
      debug: _debug,
    );
  }
  
  //Return true
  static Future<bool?> resetPassword({
    required String email,
    required String password,
  }) async {
    return await HttpUtils.post<bool?>(
      methodName: "resetPassword", 
      api: ApiPath.resetPassword, 
      body: {
        "email": email,
        "newPassword": password,
      },
      onSuccess: (res)async{
        if(res?["data"]?["message"]=="Password Reset Successful"){
          return true;
        }
        return false;
      },
      debug: _debug,
    );
  }
}