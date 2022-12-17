import 'dart:developer';
import 'dart:io';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/services/firebase_storage_service.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/utils/text_validator.dart';
import 'package:adopt_us/widgets/custom_dropdown.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePetScreen extends StatefulWidget {
  const CreatePetScreen({ Key? key }) : super(key: key);

  @override
  State<CreatePetScreen> createState() => _CreatePetScreenState();
}

class _CreatePetScreenState extends State<CreatePetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedStatus = PetStatus.adopt;

  final _formkey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _petAgeController = TextEditingController();
  final _petDescriptionController = TextEditingController();
  List<File> _petImages=[];

  
  @override
  void dispose() {
    _petNameController.dispose();
    _petAgeController.dispose();
    _petDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>unfocus(context),
      child: Scaffold(
        backgroundColor: Themes.backgroundColor,
        appBar: AppBar(title: const Text("Pet Details"),),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: petProfileForm()
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomElevatedButton(
            onPressed: ()async {
              if(!_formKey.currentState!.validate()){
                log("Invalid form");
                return;
              }
              if(_petImages.isEmpty){
                return CustomSnackbar.error(error: "Upload Pet Image");
              }

              //Upload product images
              var imageUrls = await Future.wait(
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
              log("$imageUrls");
            },
            text: "Submit",
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
            CustomDropdown(
              items: PetStatus.getList, 
              value: _selectedStatus, 
              onChanged: (val){
                _selectedStatus=val!;
              }
            ),
            if(_selectedStatus!=PetStatus.abondoned)
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
              controller: _petDescriptionController,
              hintText: " Description",
              keyboardType: TextInputType.phone,
              maxLines: 7,
              maxLength: 250,
            ),

            const SizedBox(height: 8,),
            Text(
              "Pet Pics",
              style: TextStyle(
                color: Themes.colorBlack.withOpacity(0.8),
                fontSize: 16,
              ),
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
                        FileUtils.pickImageFromGallery().then((pickedImage){
                          if(pickedImage==null) return;
                          final File img = File(pickedImage.path);
                          double fileSize = FileUtils.fileSizeKB(img);
                          log("File : ${pickedImage.path} size $fileSize KB");
                          if (fileSize < 1024) {
                            _petImages.add(img);
                            setState(() {});
                          } else {
                            CustomSnackbar.message(
                              msg: "Image size can't be greater than 1024kb."
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