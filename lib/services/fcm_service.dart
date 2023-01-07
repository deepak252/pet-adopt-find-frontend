
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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


    FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
      _logMessage("Handling a Foreground message", message.toMap());
      final data = message.data;
      // NotificationUtils.showNotification(
      //   title: data['title'],
      //   desc: data['body'],
      // );
     
    });

  }

  static Future sendMessage ({
    required String receiverFcm,
    required String data
  })async{
    await _messaging.sendMessage(
      to: receiverFcm,
      data: {
        "hellow" : data
      },
      collapseKey: "1",
      messageId: "2",
      messageType: "3"
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
              "Authorization":  "key=AAAADp_RBHg:APA91bHgdrOZ20nLvM1CyGg-I4L-gaMZtG2gn8_ma-9rfmBxgYzO_vld_52H5J2ZJ0agjTT7fQGUcCSpAeSMq721FFJbvbsa5bUUpLl552y7ISbuE0egoN3Auvx9R-uTf85QTNO7lBnq"
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