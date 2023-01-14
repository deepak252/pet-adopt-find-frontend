
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adopt_us/utils/notification_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


class FCMService {
  static final _messaging = FirebaseMessaging.instance;

  static Future getFcmToken()async {
    return await _messaging.getToken();
  }

  static Future init()async{
    
    await _messaging.subscribeToTopic("stelonotification");
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


    FirebaseMessaging.onMessage.listen(
      (message)=>handleFcmMessage(message,service: "FOREGROUND")
    );

  }

  //Only for testing
  static Future sendNotification({
    required String fcmToken,
    required String title,
    String? body,
  }) async {
    try {
      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              "Content-Type": "application/json",
              "Authorization":  "key=AAAAl-pRoxo:APA91bHS0Hir-Ctvql4m5UI_fX4kJlCyGhJS7BHp6KNVUVAphg3XF0EQtRVscLjpX7pL-HobUgZa21EwhTZPwH4i4qsUdTcQfsa1vPYqUdoATPU7hfEtLYLisPDNB6ePSbNJSD6waahl"
            },
            body: jsonEncode({
              "to": fcmToken,
              "data" : {
                "title" : title,
                "body" : body??''
              },
              "android" : {
                "priority" : "high"
              }
            }));
               
      _logMessage("sendNotification response", "${response.body}");

      if (response.statusCode == 200) {
        _logMessage("sendNotification", "Notification sent successfully");
      } else if (response.statusCode == 400) {
        _logError("sendNotification", "${response.statusCode} : Notification not sent");
      } else {
        return null;
      }
    } catch (e) {
      _logError("sendNotification", "Notification not sent, $e");
    }
  }

  static void _logMessage(String method, Object message){
    log("MESSAGE : FCMService -> $method : $message ");
  }

  static void _logError(String method, String message){
    log("ERROR : FCMService -> $method  : $message ");
  }
}

Future handleFcmMessage(RemoteMessage message,{String service = "BACKGROUND"})async{
  log("HANDLING A $service MESSAGE : ${message.toMap()}");
  
  NotificationUtils.showNotification(
    title: message.data['title'],
    body: message.data['body'],
    smallImage : message.data['smallImage'],
    bigImage : message.data['bigImage'],
  );
}
