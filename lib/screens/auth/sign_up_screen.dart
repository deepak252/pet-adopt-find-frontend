import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/splash_screen.dart';
import 'package:adopt_us/services/auth_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
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

  final _passwordVisibilityNotifier = ValueNotifier<bool>(false);
  final _cfPasswordVisibilityNotifier = ValueNotifier<bool>(false);  //for confirm password

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
                  ValueListenableBuilder<bool>(
                    valueListenable: _passwordVisibilityNotifier,
                    builder: (context,_passwordVisible, child) {
                      return CustomTextField(
                        controller: _passwordController,
                        hintText: " Password",
                        obscureText: !_passwordVisible,
                        suffixIcon: passwordVisibilityIcon(_passwordVisibilityNotifier),
                        validator: TextValidator.validatePassword,
                      );
                    }
                  ),
                  const SizedBox(height: 18,),
                  ValueListenableBuilder<bool>(
                    valueListenable: _cfPasswordVisibilityNotifier,
                    builder: (context,_cfPasswordVisible, child) {
                      return CustomTextField(
                        controller: _cfPasswordController,
                        hintText: " Confirm Password",
                        obscureText: !_cfPasswordVisible,
                        suffixIcon: passwordVisibilityIcon(_cfPasswordVisibilityNotifier),
                        validator: (confirmPassword)=> TextValidator.validateConfirmPassword(
                          confirmPassword, _passwordController.text
                        ),
                      );
                    }
                  ),
                  
                  const SizedBox(height: 36,),
                  CustomElevatedButton(
                    onPressed: ()async{
                      if(!_formkey.currentState!.validate()){
                        return;
                      }
                      customLoadingIndicator(context: context,canPop: false);
                      final token = await AuthService.signUp(
                        name: _nameController.text.trim(), 
                        email: _emailController.text.trim(), 
                        phone: _phoneController.text.trim(), 
                        password: _passwordController.text.trim()
                      );
                      if(mounted){
                        Navigator.pop(context); //dismiss loading indicator
                      }
                      if(token!=null){
                        //Sign Up Successfull
                        CustomSnackbar.success(msg: "Account Created Successfully");
                        await Get.delete<UserController>();
                        await Get.delete<BottomNavController>();
                        await Get.delete<ChatController>();
                        await Get.delete<PetController>();
                        await Get.delete<RequestController>();
                        await UserPrefs.setToken(value: token);
                        if(mounted){
                          AppNavigator.pushAndRemoveUntil(context, const SplashScreen());
                        }
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

  IconButton  passwordVisibilityIcon(ValueNotifier<bool> _visibilityNotifier){
    return IconButton(
      icon: Icon(
        // Based on passwordVisible state choose the icon
        _visibilityNotifier.value ? Icons.visibility : Icons.visibility_off,
        color: Themes.colorSecondary,
        size: 23,
      ),
      onPressed: () {
        _visibilityNotifier.value = !_visibilityNotifier.value;
      },
      padding: const EdgeInsets.only(right: 8),
    );
  }
}