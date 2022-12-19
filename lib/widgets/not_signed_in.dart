import 'package:adopt_us/screens/auth/sign_in_screen.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotSignedIn extends StatelessWidget {
  const NotSignedIn({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child : Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomElevatedButton(
          onPressed: ()async{
            Get.to(()=>const SignInScreen());
          },
          text: "Sign In",
        ),
      )
    );
  }
}