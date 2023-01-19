import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/services/location_utils.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController _addrLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

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
    final user = _userController.user!;
    _nameController.text = user.fullName??'';
    _phoneController.text = user.mobile??'';
    _emailController.text = user.email??'';

    if(user.address!=null){
      _addrLineController.text = user.address?.addressLine??"";
      _cityController.text = user.address?.city??"";
      _stateController.text = user.address?.state??"";
      _pincodeController.text = user.address?.pincode??"";
      _countryController.text = user.address?.country??"";
      _latController.text = user.address?.latitude?.toString()??"";
      _lngController.text = user.address?.longitude?.toString()??"";
    }
    
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

    _addrLineController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _countryController.dispose();
    _latController.dispose();
    _lngController.dispose();
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
                const SizedBox(
                  height: 8,
                ),
                editProfileForm(),
                const SizedBox(
                  height: 100,
                ),
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
              if(!_formKey.currentState!.validate()){
                return;
              }
              customLoadingIndicator(context: context, canPop: false);
              bool result = await _userController.updateProfile({
                "fullName" : _nameController.text,
                "email" : _emailController.text,
                "mobile" : _phoneController.text,
                "addressLine" : _addrLineController.text,
                "city" : _cityController.text,
                "state" : _stateController.text,
                "country" : _countryController.text,
                "pincode" : _pincodeController.text,
                "latitude" : double.parse(_latController.text),
                "longitude" : double.parse(_latController.text),
              });
              if(mounted){
                Navigator.pop(context); //Dismiss loading indicator
                if(result){
                  Navigator.pop(context);
                }
              }
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
          const SizedBox(height: 18,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: ()async{
                  customLoadingIndicator(context: context, canPop: false);
                  final location =await LocationUtils.getCurrentLocation();
                  if(mounted){
                    Navigator.pop(context);
                    if(location!=null){
                      setState(() {
                        _addrLineController.text=(location.name??'') +', '+ (location.sublocality??'');
                        _cityController.text=location.city??'';
                        _stateController.text=location.state??'';
                        _countryController.text=location.country??'';
                        _pincodeController.text=location.pincode??'';
                        _latController.text=location.latitude.toStringAsFixed(4);
                        _lngController.text=location.longitude.toStringAsFixed(4);
                      });

                    }
                  }



                },
                child: Text(
                  "Use Current Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Themes.colorSecondary
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12,),
          CustomTextField(
            controller: _addrLineController,
            hintText: " Address Line",
            validator: TextValidator.requiredText,
            keyboardType: TextInputType.streetAddress,
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _cityController,
            hintText: " City",
            validator: TextValidator.requiredText,
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _stateController,
            hintText: " State",
            validator: TextValidator.requiredText,
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _countryController,
            hintText: " Country",
            validator: TextValidator.requiredText,
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _pincodeController,
            hintText: " Pincode",
            validator: TextValidator.requiredText,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _latController,
            hintText: " Latitude",
            validator: TextValidator.requiredText,
            keyboardType: TextInputType.number,
           
          ),
          const SizedBox(height: 18,),
          CustomTextField(
            controller: _lngController,
            hintText: " Longitude",
            validator: TextValidator.requiredText,
            keyboardType: TextInputType.number,
           
          ),
          
        ],
      ),
    );
  }

  
}