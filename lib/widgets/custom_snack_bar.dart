import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomSnackbar{

  static void message({required Object msg, int durationMS=4000}){
    snackbar(
      message: msg.toString(),
      duration: Duration(milliseconds: durationMS)
    );
  }

  static void success({required Object msg, int durationMS=4000}){
    snackbar(
      message: msg.toString(),
      duration: Duration(milliseconds: durationMS),
      bgColor: Colors.green,
      titleColor: Colors.white,
      messageColor : Colors.white
    );
  }

  static void error({required Object error, int durationMS=4000}){
    snackbar(
      message: error.toString(),
      duration: Duration(milliseconds: durationMS),
      bgColor: const Color(0xFFf25746)
    );
  }

  static void snackbar({
    String? title,
    String? message, 
    Color ? bgColor,
    Color ? titleColor,
    Color ? messageColor,
    double ? titleSize,
    double ? messageSize,
    Duration duration = const  Duration(seconds: 5),
    EdgeInsets? margin,
    VoidCallback? onTap
  }){
    Get.snackbar(
        '','',
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 8,
          bottom: message==null ? 8 : 14,
        ),
        titleText: Text(
          "$title",
          style: TextStyle(
            color: titleColor?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: title==null 
              ? 0
              : titleSize ?? 16,
            height: title==null ? 0 : null,
          ),
        ),
        messageText: Text(
          "$message",
          style: TextStyle(
            color: messageColor?? Colors.white,
            fontSize: message==null 
              ? 0
              : messageSize ?? 15,
            height: message==null ? 0 : null,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor ?? Colors.black87.withOpacity(0.7),
        margin: margin?? const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        duration: duration,
        animationDuration: const Duration(milliseconds: 300),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        borderRadius: 6,
        onTap: (GetSnackBar snackBar){
          onTap!=null? onTap() : Get.closeCurrentSnackbar();
        },
        
    );
  }
}