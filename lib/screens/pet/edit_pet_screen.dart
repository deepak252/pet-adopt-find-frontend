import 'dart:developer';
import 'dart:io';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/pet_categories.dart';
import 'package:adopt_us/config/pet_gender.dart';
import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/services/firebase_storage_service.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_dropdown.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;
  const EditPetScreen({ Key? key, required this.pet}) : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = PetStatus.surrender;
  String _selectedCategory = PetCategory.dog;
  String _selectedGender = PetGender.m;

  final _petNameController = TextEditingController();
  final _petAgeController = TextEditingController();
  final _petDescriptionController = TextEditingController();
  final _breedController = TextEditingController();

  final _petController = Get.put(PetController());
  final _userController = Get.put(UserController());

  List<File> _newImages=[];
  List<String> _oldImages=[];
  @override
  void initState() {
    super.initState();
    if(PetGender.list.contains(widget.pet.gender)){
      _selectedGender=widget.pet.gender!;
    }
    if(PetCategory.list.contains(widget.pet.category)){
      _selectedCategory=widget.pet.category!;
    }

    _oldImages=widget.pet.photos.map((e) => e).toList();
    _petNameController.text=widget.pet.petName??"";
    _petAgeController.text=(widget.pet.age??"").toString();
    _breedController.text=widget.pet.breed??"";
    _petDescriptionController.text=widget.pet.petInfo??"";
  }

  
  @override
  void dispose() {
    _petNameController.dispose();
    _petAgeController.dispose();
    _petDescriptionController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("${widget.pet.gender==null}");
    log("${widget.pet.category}");
    return GestureDetector(
      onTap: ()=>unfocus(context),
      child: Scaffold(
        backgroundColor: Themes.backgroundColor,
        appBar: AppBar(title: const Text("Edit Pet"),),
        body: SingleChildScrollView(
          child: petProfileForm()
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomElevatedButton(
            onPressed: ()async {
              unfocus(context);
              bool petUpdated=false;
              if(!_userController.isSignedIn){
                return CustomSnackbar.error(error: "Not Signed In");
              }
              if(!_formKey.currentState!.validate()){
                log("Invalid form");
                return;
              }
              if(_oldImages.isEmpty && _newImages.isEmpty){
                return CustomSnackbar.error(error: "Upload Pet Image");
              }
              customLoadingIndicator(context: context,dismissOnTap : false);
              // Upload pet images to firebase
              var newImgUrls = await Future.wait(
                _newImages.map((img)async{
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
              log("newImgUrls : $newImgUrls");
              if(_oldImages.isNotEmpty || newImgUrls.isNotEmpty){
                petUpdated = await _petController.editPet({
                  "petId" : widget.pet.petId,
                  "userId" : _userController.user!.userId,
                  "petName" : _petNameController.text,
                  "breed" : _breedController.text,
                  "age" : _petAgeController.text,
                  "photos" : [..._oldImages,...newImgUrls],
                  "petStatus" : _selectedStatus,
                  "gender" : _selectedGender,
                  "petInfo" : _petDescriptionController.text,
                  "category" : _selectedCategory
                });
              }
              if(mounted){
                Navigator.pop(context); //Dismiss loading indicator
                if(petUpdated){
                  CustomSnackbar.message(msg: "Pet profile updated successfully");
                  //Operation successful
                  // Delete removed images from firebase storage
                  List imgsToRemove = [];
                  for(var img in widget.pet.photos){
                    if(!_oldImages.contains(img)){
                      imgsToRemove.add(img);
                    }
                  }
                  log("imgsToRemove : $imgsToRemove");
                  FirebaseStorageService.deleteMultipleFiles(fileUrls: imgsToRemove);
                 
                  Navigator.pop(context);
                }else{
                  //Operation unsuccessful
                  // Delete new images from firebase storage
                  FirebaseStorageService.deleteMultipleFiles(fileUrls: newImgUrls);
                  
                }
              }
            },
            text: "Update",
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
            // CustomRadioButton(
            //   options: PetStatus.getList,
            //   selectionOption: _selectedStatus,
            //   onChanged: (val){
            //     setState(() {
            //       _selectedStatus = val!;
            //     });
            //   },
            // ),
            // const SizedBox(height: 18),
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
            if(_selectedStatus!=PetStatus.abandoned)
              Column(
                children: [
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
                  
                ],
              ),
            const SizedBox(height: 18,),
            CustomTextField(
              controller: _breedController,
              hintText: " Breed",
            ),
            const SizedBox(height: 18,),
            CustomTextField(
              controller: _petDescriptionController,
              hintText: " Description",
              maxLines: 7,
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
                  // Existing Images (Image Url)
                  for(int i=0;i<_oldImages.length;i++)
                    imageTile(imgUrl: _oldImages[i]),
                  // New Images (Image File)
                  for(int i=0;i<_newImages.length;i++)
                    imageTile(imgFile: _newImages[i]),
                  if(_oldImages.length + _newImages.length<5)
                    InkWell(
                      onTap: ()async{
                        FileUtils.pickImageFromGallery().then((pickedImage){
                          if(pickedImage==null) return;
                          final File img = File(pickedImage.path);
                          double fileSize = FileUtils.fileSizeKB(img);
                          log("File : ${pickedImage.path} size $fileSize KB");
                          if (fileSize <= 2048) {
                            _newImages.add(img);
                            setState(() {});
                          } else {
                            CustomSnackbar.message(
                              msg: "Image size can't be greater than 2Mb."
                            );
                          }
                        });
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


  Widget imageTile({String? imgUrl, File? imgFile}){
    return Stack(
      alignment: Alignment.topRight,
      children: [
        imgUrl!=null
        ? CachedImageContainer(
            imgUrl: imgUrl,
            borderRadius: BorderRadius.circular(8),
            width: 100,
            height: 100,
          )
        :  ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.file(
                imgFile!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        InkWell(
          onTap: (){
            if(imgUrl!=null){
              _oldImages.remove(imgUrl);
            }else if(imgFile!=null){
              _newImages.remove(imgFile);
            }
            setState(() {});
            // _petImages.remove(img);
            // setState(() {
              
            // });
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
