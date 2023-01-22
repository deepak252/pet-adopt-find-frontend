import 'dart:developer';
import 'dart:io';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/pet_categories.dart';
import 'package:adopt_us/config/pet_gender.dart';
import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/services/firebase_storage_service.dart';
import 'package:adopt_us/services/location_utils.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/custom_dropdown.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_radio_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({ Key? key }) : super(key: key);

  @override
  State<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = PetStatus.surrender;
  String _selectedCategory = PetCategory.dog;
  String _selectedGender = PetGender.m;

  final _petNameController = TextEditingController();
  final _petAgeController = TextEditingController();
  final _petDescriptionController = TextEditingController();
  final _breedController = TextEditingController();

  final  _addrLineController = TextEditingController();
  final  _cityController = TextEditingController();
  final  _stateController = TextEditingController();
  final  _pincodeController = TextEditingController();
  final  _countryController = TextEditingController();
  final  _latController = TextEditingController();
  final  _lngController = TextEditingController();

  List<File> _petImages=[];
  final _petController = Get.put(PetController());
  final _userController = Get.put(UserController());


  
  @override
  void dispose() {
    _petNameController.dispose();
    _petAgeController.dispose();
    _petDescriptionController.dispose();
    _breedController.dispose();

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
    bool isKeyoboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return GestureDetector(
      onTap: ()=>unfocus(context),
      child: Scaffold(
        backgroundColor: Themes.backgroundColor,
        appBar: AppBar(title: const Text("Pet Details"),),
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: petProfileForm()
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: !isKeyoboardOpen,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomElevatedButton(
              onPressed: ()async {
                unfocus(context);
                bool postCreated=false;
                if(!_formKey.currentState!.validate()){
                  log("Invalid form");
                  return;
                }
                if(_petImages.isEmpty){
                  return CustomSnackbar.error(error: "Upload Pet Image");
                }
                if(!_userController.isSignedIn){
                  return CustomSnackbar.error(error: "Not Signed In");
                }
                customLoadingIndicator(context: context,canPop : false);
                //Upload pet images to firebase
                var imgUrls = await Future.wait(
                  _petImages.map((img)async{
                    String? fileName = FileUtils.getFileNameFromPath(img.path);
                    if(fileName!=null){
                      return  FirebaseStorageService.uploadFile(
                          file : img,
                          fileName: fileName,
                          path: StoragePath.petPic
                      );
                    }
                  })
                )..removeWhere((e) => e==null);
                log("$imgUrls");
                if(imgUrls.isNotEmpty){
                  postCreated = await _petController.createPet({
                    "userId" : _userController.user!.userId,
                    "petName" : _petNameController.text,
                    "breed" : _breedController.text,
                    "age" : _petAgeController.text,
                    "photos" : imgUrls,
                    "petStatus" : _selectedStatus,
                    "gender" : _selectedGender,
                    "petInfo" : _petDescriptionController.text,
                    "category" : _selectedCategory,
                    
                    "addressLine" : _addrLineController.text,
                    "city" : _cityController.text,
                    "state" : _stateController.text,
                    "country" : _countryController.text,
                    "pincode" : _pincodeController.text,
                    "latitude" : double.parse(_latController.text),
                    "longitude" : double.parse(_latController.text),
                  });
                }
                if(mounted){
                  Navigator.pop(context); //Dismiss loading indicator
                  if(postCreated){
                    CustomSnackbar.message(msg: "Pet profile created successfully");
                    Navigator.pop(context);
                  }else{
                    //Operation unsuccessful
                    // Delete pet images from firebase storage
                    FirebaseStorageService.deleteMultipleFiles(
                      fileUrls: imgUrls
                    );
                    
                  }
                }
              },
              text: "Submit",
            ),
          ),
        )
      ),
    );
  }

  Widget petProfileForm(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            CustomRadioButton(
              options: PetStatus.list,
              selectionOption: _selectedStatus,
              onChanged: (val){
                setState(() {
                  _selectedStatus = val!;
                });
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Flexible(
                  child: CustomDropdown(
                    items: PetCategory.list, 
                    value: _selectedCategory, 
                    onChanged: (val){
                      _selectedCategory=val!;
                      setState(() {});
                    }
                  ),
                ),
                const SizedBox(width: 18,),
                Flexible(
                  child: CustomDropdown(
                    items: PetGender.list, 
                    value: _selectedGender, 
                    onChanged: (val){
                      _selectedGender=val!;
                      setState(() {});
                    }
                  ),
                ),
                
              ],
            ),
            // if(_selectedStatus!=PetStatus.missing)
              // Column(
              //   children: [
              //     const SizedBox(height: 18,),
              //     CustomTextField(
              //       controller: _petNameController,
              //       hintText: " Name",
              //       validator: TextValidator.validateName,
              //     ),
              //     const SizedBox(height: 18),
              //     CustomTextField(
              //       controller: _petAgeController,
              //       hintText: " Age",
              //       keyboardType: TextInputType.number,
              //       inputFormatters: [
              //         FilteringTextInputFormatter.digitsOnly
              //       ],
              //     ),
              //   ],
              // ),

            const SizedBox(height: 18,),
            CustomTextField(
              controller: _petNameController,
              hintText: " Name",
              validator: TextValidator.validateName,
            ),
            const SizedBox(height: 18),
            CustomTextField(
              controller: _petAgeController,
              hintText: " Age",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 18,),
            CustomTextField(
              controller: _breedController,
              hintText: " Breed",
            ),




            

            
            if(_selectedStatus==PetStatus.missing)
            Column(
              children: [
                const SizedBox(height: 12,),
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
                      child: const Text(
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
                  hintText: " Address Line*",
                  validator: TextValidator.requiredText,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _cityController,
                  hintText: " City*",
                  validator: TextValidator.requiredText,
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _stateController,
                  hintText: " State",
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _countryController,
                  hintText: " Country*",
                  validator: TextValidator.requiredText,
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _pincodeController,
                  hintText: " Pincode*",
                  validator: TextValidator.requiredText,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _latController,
                  hintText: " Latitude*",
                  validator: TextValidator.requiredText,
                  keyboardType: TextInputType.number,
                
                ),
                const SizedBox(height: 18,),
                CustomTextField(
                  controller: _lngController,
                  hintText: " Longitude*",
                  validator: TextValidator.requiredText,
                  keyboardType: TextInputType.number,
                
                ),
              ],
            ),







            const SizedBox(height: 18,),
            CustomTextField(
              controller: _petDescriptionController,
              hintText: " Description",
              maxLines: 5,
              maxLength: 250,
            ),

            const SizedBox(height: 8,),
          
            Align(
              alignment: Alignment.center,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for(int i=0;i<_petImages.length;i++)
                    imageTile(_petImages[i]),
                  if(_petImages.length<5)
                    InkWell(
                      onTap: ()async{
                        final imgFile = await FileUtils.pickAndCropImage();
                        if(imgFile!=null){
                          _petImages.add(imgFile);
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(
                          minHeight: 100,
                          minWidth: 100,
                        ),
                        decoration: BoxDecoration(
                          color: Themes.colorSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1,color: Themes.colorSecondary)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate,
                              color: Themes.colorSecondary,
                              size: 40,
                            ),
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                color: Themes.colorSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),

            
            const SizedBox(height: 100,),
              
          ],
        ),
      ),
    );
  }


  Widget imageTile(File img){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.file(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        InkWell(
          onTap: (){
            _petImages.remove(img);
            setState(() {
              
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Themes.colorSecondary,
              borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
