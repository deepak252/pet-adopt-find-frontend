import 'dart:convert';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:http/http.dart' as http;

abstract class AuthService{
  static final _debug = DebugUtils("AuthService");
 
  //Return token on successful SignIn
  static Future<String?> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try{
      final payload = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      };
      http.Response  response = await http.post(
        Uri.parse(ApiPath.signUp),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload)
      );
      if(response.statusCode==200 || response.statusCode == 201){
        final data = jsonDecode(response.body);
        _debug.message("signUp", data);
        return data['data'];
      }else {
        throw response.body;
      }
    }catch(e,s){
      _debug.error("signUp", error: e,stackTrace: s);
    }
    return null;
  }

  //Return token on successful SignIn
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try{
      final payload = {
        "email": email,
        "password": password,
      };
      http.Response  response = await http.post(
        Uri.parse(ApiPath.signIn),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload)
      );
      if(response.statusCode==200){
        final data = jsonDecode(response.body);
        _debug.message("signIn", data);
        return data['data'];
      }else {
        throw response.body;
      }
    }catch(e,s){
      _debug.error("signIn", error: e,stackTrace: s);
    }
    return null;
  }

  
}