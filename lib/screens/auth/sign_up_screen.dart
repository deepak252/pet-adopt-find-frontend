import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/screens/splash_screen.dart';
import 'package:adopt_us/services/auth_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cfPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cfPasswordController.dispose();
    _phoneController.dispose();
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18,),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: " Phone",
                    validator: TextValidator.validatePhoneNumber,
                    keyboardType: TextInputType.phone,
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
                    validator: (confirmPassword)=> TextValidator.validateConfirmPassword(
                      confirmPassword, _passwordController.text
                    ),
                  ),
                  
                  const SizedBox(height: 36,),
                  CustomElevatedButton(
                    onPressed: ()async{
                      if(!_formkey.currentState!.validate()){
                        return;
                      }
                      final token = await AuthService.signUp(
                        name: _nameController.text, 
                        email: _emailController.text, 
                        phone: _phoneController.text, 
                        password: _passwordController.text
                      );
                      if(token!=null){
                        //Sign Up Successfull
                        await Get.delete<UserController>();
                        await UserPrefs.setToken(value: token);
                        Get.offAll(()=>const SplashScreen());
                      }
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