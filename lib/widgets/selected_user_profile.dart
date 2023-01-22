
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_icon_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future showUserProfile(User user)async{
  return await Get.bottomSheet(
    SelectedUserProfile(user: user,),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16)
      )
    )
  );
}

class SelectedUserProfile extends StatelessWidget {
  final User user;
  const SelectedUserProfile({ Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        titleSpacing: 0,
        
        title: Row(
          children: [
            CachedImageContainer(
              imgUrl: user.profilePic??Constants.defaultPic,
              height: 40,
              width: 40,
              borderRadius: BorderRadius.circular(100),
            ),
            const SizedBox(width: 6,),
            Text(
              "${user.fullName}",
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              optionWidget(
                label: "${user.mobile}",
                trailingIcon: Icons.phone,
                trailingColor: Colors.green,
                onTap: user.mobile?.isNotEmpty==true
                ? ()async{
                    if (!await launchUrl(Uri.parse("tel:${user.mobile}"))) {
                      CustomSnackbar.error(error: "error");
                    }
                  }
                : null
              ),
              optionWidget(
                label: "${user.email}",
                trailingIcon: Icons.email,
                trailingColor: const Color(0xFFD64A3E),
                onTap: user.email?.isNotEmpty==true
                ? ()async{
                    if (!await launchUrl(Uri.parse("mailto:${user.email}"))) {
                      CustomSnackbar.error(error: "error");
                    }
                  }
                : null
              ),
              if(user.address!=null)
                optionWidget(
                  label: "${user.address?.addressLine}",
                  trailingIcon: Icons.location_on,
                  trailingColor: Colors.blue,
                  onTap: user.email?.isNotEmpty==true
                  ? ()async{
                      // if (!await launchUrl(Uri.parse("mailto:${user.email}"))) {
                      //   CustomSnackbar.error(error: "error");
                      // }
                    }
                  : null
                ),
              
              
              // Row(
              //   children: [
              //     Icon(
              //       Icons.email,
              //       size: 20,
              //     ),
              //     SizedBox(width: 6,),
              //     Text(
              //       "${user.email}",
              //       style: TextStyle(
              //         fontSize: 16
              //       ),
              //     ),
              //   ],
              // ),
            
              Divider(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget optionWidget({
    required String label,
    IconData? trailingIcon,
    Color? trailingColor,
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
      trailing: trailingIcon !=null
      ? CustomIconButton(
          onPressed: onTap,
          btnColor: trailingColor,
          child: Icon(trailingIcon, color: Colors.white,)
        )
      : null
    );
  }

}