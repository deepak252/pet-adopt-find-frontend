import 'dart:developer';
import 'dart:io';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/screens/pet/my_pets_screen.dart';
import 'package:adopt_us/screens/profile/edit_user_profile_screen.dart';
import 'package:adopt_us/services/firebase_storage_service.dart';
import 'package:adopt_us/services/location_utils.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
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
                    //Profile Pic
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CachedImageContainer(
                            imgUrl: user.profilePic??Constants.defaultPic,
                            height: 100,
                            width: 100,
                          )
                        ),
                        InkWell(
                          onTap: ()async{
                            final imgFile = await FileUtils.pickAndCropImage();
                            if(imgFile==null){
                              return;
                            }
                            // log("Cropped File : ${croppedImage.path}. size ${FileUtils.fileSizeKB(croppedImage)} KB");
                            customLoadingIndicator(context: context,canPop: false);
                            final newImgUrl = await FirebaseStorageService.uploadFile(
                                file : imgFile,
                                fileName: FileUtils.getFileNameFromPath(imgFile.path)??'',
                                path: StoragePath.profilePic
                            );
                            Navigator.pop(context);
                            if(newImgUrl==null){
                              return CustomSnackbar.error(
                                error: "Couldn't update profile pic. Try again later."
                              );
                            }
                            final oldImgUrl = user.profilePic??'';
                            _userController.updateProfile({
                              'profilePic' : newImgUrl
                            }).then((success){
                              if(success){
                                //remove old pic from storage
                                FirebaseStorageService.deleteFile(fileUrl: oldImgUrl);
                              }else{
                                // api error : remove new pic from storage
                                FirebaseStorageService.deleteFile(fileUrl: newImgUrl);
                              }
                            });
                          },
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Themes.colorPrimary.withOpacity(0.7),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        )
                      ],
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
                          if(user.address!=null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.address!.addressLine}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Themes.colorBlack.withOpacity(0.5),

                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${user.address!.state}-${user.address!.pincode}, ${user.address!.country}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Themes.colorBlack.withOpacity(0.5)
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                Divider(),
                optionWidget(
                  label: "Settings",
                  icon: Icons.settings
                ),
                optionWidget(
                  label: "My Pets",
                  icon: Icons.pets,
                  onTap: (){
                    AppNavigator.push(context, MyPetsScreen());
                  }
                ),
                optionWidget(
                  label: "Edit Profile",
                  icon: Icons.edit,
                  onTap: (){
                    AppNavigator.push(context, EditUserProfileScreen());
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

                // optionWidget(
                //   label: "Address",
                //   icon: Icons.location_city,
                //   onTap: ()async{
                //     final location =await LocationUtils.getCurrentLocation();
                //     // final location =await LocationUtils.getAddressFromCoordinaties(
                //     //   28.6691,77.0929
                //     // );
                //     if(location!=null){
                //       log('''
                //         ${location.name},
                //         ${location.sublocality},
                //         ${location.city},
                //         ${location.state},
                //         ${location.country},
                //         ${location.longitude},
                //         ${location.latitude},
                //       ''');
                //     }
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