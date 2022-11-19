import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cfPasswordController = TextEditingController();

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
          title: const Text("Sign Up"),
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
                    controller: _nameController,
                    hintText: " Name",
                    validator: TextValidator.validateName,
                  ),
                  const SizedBox(height: 18,),
                  CustomTextField(
                    controller: _emailController,
                    hintText: " Email",
                    validator: TextValidator.validateEmail,
                  ),
                  const SizedBox(height: 18,),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: " Password",
                    validator: TextValidator.validatePassword,
                  ),
                  const SizedBox(height: 18,),
                  CustomTextField(
                    controller: _cfPasswordController,
                    hintText: " Confirm Password",
                    validator:(confirmPassword)=> TextValidator.validateConfirmPassword(
                      confirmPassword, _passwordController.text
                    ),
                  ),
                  
                  const SizedBox(height: 36,),
                  CustomElevatedButton(
                    onPressed: (){

                    },
                    text: "Sign Up",
                  ),
                  const SizedBox(height: 18,),
                  const Text(
                    "Already have an account? ",
                  ),
                  GestureDetector(
                    onTap: (){
                      unfocus(context);
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Sign In",
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