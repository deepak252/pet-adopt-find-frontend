
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_icon_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future showConfirmationDialog({
  String? title,
  String? description,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  String cancelText = "Cancel",
  String confirmText = "Confirm",
  Color? cancelTextColor,
  Color? confirmTextColor,
})async{
  return await Get.dialog(
    AlertDialog(
      titlePadding: const EdgeInsets.only(
        left: 12,right: 12,top: 12,bottom: 4
      ),
      contentPadding: const EdgeInsets.only(
        left: 20,right: 12,top: 6,bottom: 12
      ),
      title: title!=null ? Text(
        title
      ) : null,
      content: description!=null ? Text(
        description
      ) : null,
      actions: [
        TextButton(
          onPressed: onCancel, 
          style: TextButton.styleFrom(
            foregroundColor: cancelTextColor
          ),
          child: Text(
            cancelText,
          ),
        ),
        TextButton(
          onPressed: onConfirm, 
          style: TextButton.styleFrom(
            foregroundColor: confirmTextColor
          ),
          child: Text(
            confirmText
          )
        ),
      ],
    ),
    // transitionCurve: Curves.easeInBack
  );
 
}
