import 'package:flutter/material.dart';

class AppRouter{
  static Future push(BuildContext context,Widget widget){
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_)=>widget), 
    );
  }

  static Future pushAndRemoveUntil(BuildContext context,Widget widget){
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_)=>widget), 
      (route) => false
    );
  }

}