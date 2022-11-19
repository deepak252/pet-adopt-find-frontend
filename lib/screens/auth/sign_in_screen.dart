import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/screens/auth/sign_up_screen.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>unfocus(context),
      child: Scaffold(
        backgroundColor: Themes.backgroundColor,
        appBar: AppBar(
          title: const Text("Sign In"),
        ),
        body: SingleChildScrollView(
          physics : const BouncingScrollPhysics(),
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16
              ),
              child: Column(
                children : [
                  const SizedBox(height: 12,),
                  const AppIconWidget(),
                  const SizedBox(height: 36,),
                  CustomTextField(
                    controller: _emailController,
                    hintText: " Email",
                    validator: TextValidator.validateEmail,
                  ),
                  const SizedBox(height: 18,),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: " Password",
                    validator: (val)=>val==null || val.isEmpty ? "Enter password" : null,
                  ),
                  const SizedBox(height: 12,),
                  Align(
                    alignment : Alignment.topRight,
                    child: InkWell(
                      onTap: (){

                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Themes.colorSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36,),
                  CustomElevatedButton(
                    onPressed: (){

                    },
                    text: "Sign In",
                  ),
                  const SizedBox(height: 18,),
                  const Text(
                    "Don't have an account? ",
                  ),
                  GestureDetector(
                    onTap: (){
                      unfocus(context);
                      Get.to(()=>const SignUpScreen());
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Themes.colorSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18,),
                  
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}