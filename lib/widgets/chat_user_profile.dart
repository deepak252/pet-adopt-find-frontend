
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_icon_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future showChatUserProfile(User user)async{
  return await Get.dialog(
    AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedImageContainer(
            imgUrl: user.profilePic??Constants.defaultPic,
            height: 300,
            width: 1000,
            borderRadius: BorderRadius.circular(4),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse("tel:${user.mobile}"))) {
                      CustomSnackbar.error(error: "error");
                    }
                  },
                  btnColor: Colors.green,
                  child: const Icon(Icons.phone, color: Colors.white,)
                ),
                const SizedBox(width: 20,),
                CustomIconButton(
                  onPressed: ()async{
                    if (!await launchUrl(Uri.parse("mailto:${user.email}"))) {
                      CustomSnackbar.error(error: "error");
                    }
                  },
                  btnColor: const Color(0xFFD64A3E),
                  child: const Icon(Icons.email, color: Colors.white,)
                ),
              ],
            ),
          )
        ],
      ),
    )
  );
 
}
