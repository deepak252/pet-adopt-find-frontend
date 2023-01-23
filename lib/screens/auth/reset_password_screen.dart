import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/services/auth_service.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<ResetPasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cfPasswordController = TextEditingController();

  final _passwordVisibilityNotifier = ValueNotifier<bool>(false);
  final _cfPasswordVisibilityNotifier = ValueNotifier<bool>(false);  //for confirm password


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cfPasswordController.dispose();
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
                    controller: _emailController,
                    hintText: " Email",
                    validator: TextValidator.validateEmail,
                    keyboardType: TextInputType.emailAddress,
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
                      final res = await AuthService.resetPassword(
                        email: _emailController.text, 
                        password: _passwordController.text
                      );
                      if(mounted){
                        Navigator.pop(context); //dismiss loading indicator
                      }
                      if(res==true){
                        //Sign Up Successfull
                        CustomSnackbar.success(msg: "Password Reset Successful");
                        await Get.delete<UserController>();
                        if(mounted){
                          Navigator.pop(context);
                        }
                      }else{
                        CustomSnackbar.error(error: "Couldn't Reset Password");
                      }
                    },
                    text: "Submit",
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