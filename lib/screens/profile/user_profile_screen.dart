import 'dart:developer';

import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/screens/profile/edit_user_profile_screen.dart';
import 'package:adopt_us/services/fcm_service.dart';
import 'package:adopt_us/utils/notification_utils.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/not_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({ Key? key }) : super(key: key);

  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    // log("${_userController.user}");
    return Scaffold(
      body: Obx((){
        if(!_userController.isSignedIn){
          return const NotSignedIn();
        }
        final user  = _userController.user!;
        // log("${user.profilePic.runtimeType}");
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImageContainer(
                      imgUrl: user.profilePic??"https://assets-global.website-files.com/60e5f2de011b86acebc30db7/61aa5a5ff33bfa3e4d4e9a21_avatar-24-denis.jpg",
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(width: 12,),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello ${user.fullName}",
                            style: TextStyle(
                              fontSize: 24
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12,),
                          Text(
                            "${user.mobile}",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          Text(
                            "${user.email}",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100,),
                Divider(),
                optionWidget(
                  label: "Settings",
                  icon: Icons.settings
                ),
                optionWidget(
                  label: "My Pets",
                  icon: Icons.pets
                ),
                optionWidget(
                  label: "Edit Profile",
                  icon: Icons.edit,
                  onTap: (){
                    Get.to(()=>EditUserProfileScreen());
                  }
                ),
                // optionWidget(
                //   label: "Notification",
                //   icon: Icons.notification_add,
                //   onTap: ()async{
                //     final token = await FCMService.getFcmToken();
                //     log("Fcmtoken = $token");
                //     FCMService.sendNotification(fcmToken: token!, title: "Hello");
                //     // NotificationUtils.createNewNotification(
                //     //   title: "Test",
                //     //   img: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png'
                //     // );
                //   }
                // ),
               
                

              ],
            ),
          ),
        );
      }),
    );
  }

  Widget optionWidget({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }){
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 18
        ),
      ),
      leading: Icon(
        icon,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
    );
  }

}