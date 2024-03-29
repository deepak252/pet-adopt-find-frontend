import 'dart:convert';
import 'dart:developer';

import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

typedef SuccessCallback<T> = Future<T?> Function(dynamic);

abstract class HttpUtils{

  static Future<T?> post<T>({
    required String methodName,
    required String api,
    required DebugUtils debug,
    required SuccessCallback<T> onSuccess,
    VoidCallback? onError,
    String? token,
    Map<String,dynamic>? body,
    bool showError=true

  }) async {
    try{
      var headers = {
        "Content-Type": "application/json",
      };
      if(token!=null){
        headers["Authorization"] = "Bearer $token";
      }
      http.Response  response = await http.post(
        Uri.parse(api),
        headers: headers,
        body: body!=null ? jsonEncode(body) : null
      );
      if(response.statusCode==200){
        final result = jsonDecode(response.body);
        debug.message(methodName, result);
        return await onSuccess(result);
      }else {
        throw response.body;
      }
    }catch(e,s){
      debug.error(methodName, error: e,stackTrace: s);
      if(showError){
        try{
          final error =  jsonDecode(e.toString())['error'] as String;
          if(!error.contains("ER_NO_SUCH_TABLE")){
            CustomSnackbar.error(error: error);
          }
        }catch(e2){
          CustomSnackbar.error(error: "Something went wrong!");
        }
      }
    }
    return null;
  }

  static Future<T?> get<T>({
    required String methodName,
    required String api,
    DebugUtils? debug,
    required SuccessCallback<T> onSuccess,
    VoidCallback? onError,
    String? token,
    bool showError=true
  }) async {
    try{
      var headers = {
        "Content-Type": "application/json",
      };
      if(token!=null){
        headers["Authorization"] = "Bearer $token";
      }
      http.Response  response = await http.get(
        Uri.parse(api),
        headers: headers
      );
      if(response.statusCode==200){
        final result = jsonDecode(response.body);
        debug?.message(methodName, result);
        return await onSuccess(result);
      }else {
        throw response.body;
      }
    }catch(e,s){
      debug?.error(methodName, error: e,stackTrace: s);
      if(showError){
        try{
          final error =  jsonDecode(e.toString())['error'] as String;
          if(!error.contains("ER_NO_SUCH_TABLE")){
            CustomSnackbar.error(error: error);
          }
        }catch(e2){
          CustomSnackbar.error(error: "Something went wrong!");
        }
      }
    }
    return null;
  }

  static Future<T?> put<T>({
    required String methodName,
    required String api,
    required DebugUtils debug,
    required SuccessCallback<T> onSuccess,
    VoidCallback? onError,
    String? token,
    Map<String,dynamic>? body,
    bool showError=true

  }) async {
    try{
      var headers = {
        "Content-Type": "application/json",
      };
      if(token!=null){
        headers["Authorization"] = "Bearer $token";
      }
      http.Response  response = await http.put(
        Uri.parse(api),
        headers: headers,
        body: body!=null ? jsonEncode(body) : null
      );
      if(response.statusCode==200){
        final result = jsonDecode(response.body);
        debug.message(methodName, result);
        return await onSuccess(result);
      }else {
        throw response.body;
      }
    }catch(e,s){
      debug.error(methodName, error: e,stackTrace: s);
      if(showError){
        try{
          final error =  jsonDecode(e.toString())['error'] as String;
          if(!error.contains("ER_NO_SUCH_TABLE")){
            CustomSnackbar.error(error: error);
          }
        }catch(e2){
          CustomSnackbar.error(error: "Something went wrong!");
        }
      }
    }
    return null;
  }

  static Future<T?> delete<T>({
    required String methodName,
    required String api,
    required DebugUtils debug,
    required SuccessCallback<T> onSuccess,
    VoidCallback? onError,
    String? token,
    Map<String,dynamic>? body,
    bool showError=true

  }) async {
    try{
      var headers = {
        "Content-Type": "application/json",
      };
      if(token!=null){
        headers["Authorization"] = "Bearer $token";
      }
      http.Response  response = await http.delete(
        Uri.parse(api),
        headers: headers,
        body: body!=null ? jsonEncode(body) : null
      );
      if(response.statusCode==200){
        final result = jsonDecode(response.body);
        debug.message(methodName, result);
        return await onSuccess(result);
      }else {
        throw response.body;
      }
    }catch(e,s){
      debug.error(methodName, error: e,stackTrace: s);
      if(showError){
        try{
          final error =  jsonDecode(e.toString())['error'] as String;
          if(!error.contains("ER_NO_SUCH_TABLE")){
            CustomSnackbar.error(error: error);
          }
        }catch(e2){
          CustomSnackbar.error(error: "Something went wrong!");
        }
      }
    }
    return null;
  }

}