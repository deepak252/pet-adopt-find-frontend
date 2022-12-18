import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUserProfileScreen extends StatefulWidget {
  EditUserProfileScreen({Key? key}) : super(key: key);

  @override
  _EditUserProfileScreenState createState() =>
      _EditUserProfileScreenState();
}

class _EditUserProfileScreenState
    extends State<EditUserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _userController =Get.put(UserController());

  // final TextStyle labelStyle = TextStyle(
  //   color: Constants.kTextColor.withOpacity(0.8),
  //   fontSize: Device.height * 0.018,
  // );

  @override
  void initState() {
    initControllers();
    super.initState();
  }

  void initControllers() {
    _nameController.text = _userController.user?.fullName??'';
    _phoneController.text = _userController.user?.mobile??'';
    _emailController.text = _userController.user?.email??'';
    
    // _nameController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _nameController.text.length));
    // _phoneController.selection = TextSelection.fromPosition(
    //     TextPosition(offset: _phoneController.text.length));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Scaffold(
        backgroundColor: Themes.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                editProfileForm(),
                SizedBox(
                  height: 100,
                ),

                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   child: CustomTextButton(
                //     onPressed: () async {
                //       unfocus(context); //Dismiss keyboard
                //       customProgressDialog(
                //           context: context, text: "Please wait...", willPop: false);
                //       if (_formKey.currentState!.validate() &&
                //           _customerProfileController.getCustomerProfile != null) {
                //         bool? profileUpdated =
                //             await Get.put(CustomerProfileController())
                //                 .updateProfile(
                //           customer: _customerProfileController.getCustomerProfile!
                //               .copy(
                //                   name: _nameController.text,
                //                   mobile: _phoneController.text),
                //         );
                //         if (profileUpdated == true) {
                //           customSnackbar(
                //               message: "Profile updated successfully",
                //               bgColor: Constants.snackbarColorSuccess);
                //           Navigator.pop(context); //Dismiss customProgressDialog
                //           // Navigator.pop(context); //Go back to my profile page
                //           _bottomNavigationController.goToEcommerceDashboard();
                //         } else {
                //           Navigator.pop(context); //Dismiss customProgressDialog
                //         }
                //       } else {
                //         Navigator.pop(context); //Dismiss customProgressDialog
                //       }
                //     },
                //     text: "Save",
                //     radius: 8,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomElevatedButton(
            onPressed: ()async {
              unfocus(context);
              
            },
            text: "Save",
          ),
        )
      ),
    );
  }

  Widget editProfileForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          // Text(
          //   "Address",
          //   style: labelStyle,
          // ),
          // Obx((){
          //   return CustomTextField(
          //     hintText : AddressUtils.stringifyAddress(
          //       address: _customerProfileController.getCurrentAddress
          //     ),
          //     enabled: false,
          //     fillColor: Colors.white,
          //     borderColor: Constants.kTextColor.withOpacity(0.3),
          //     textColor: Constants.kTextColor.withOpacity(0.5),
          //     maxLines: 5,
          //   );
          // }),
          
        ],
      ),
    );
  }

  
}