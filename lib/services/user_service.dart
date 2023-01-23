import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/notification_model.dart';
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

  static Future<List<NotificationModel>?> getNotifications({required String token}) async {
    return await HttpUtils.get(
      methodName: "getNotifications", 
      api: ApiPath.getNotifications,
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<NotificationModel> notifs = [];
          for(var notif in res?['data']){
            try{
              notifs.add(NotificationModel.fromJson(notif));
            }catch(e,s){
              _debug.error("getNotifications (Invalid json Notification)", error: e, stackTrace: s);
            }
          }
          return notifs;
        }
        return null;
      },
      debug: _debug,
      showError: false
    );
  }


  static Future<bool?> markNotificationRead({
    required String token,
    required String notificationId
  }) async {
    return await HttpUtils.put(
      methodName: "markNotificationRead", 
      token: token,
      api: ApiPath.readNotification,
      body: {"read" : "true","notificationId" : notificationId },
      onSuccess: (res)async{
        return true;
      },
      debug: _debug,
      showError: false
    );
  }

 
}