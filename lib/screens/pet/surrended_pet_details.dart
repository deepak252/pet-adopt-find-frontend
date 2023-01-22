import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/request/specific_pet_requests_screen.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/custom_carousel.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_loading_indicator.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:adopt_us/widgets/selected_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurrendedPetDetailsScreen extends StatelessWidget {
  final Pet pet;
  SurrendedPetDetailsScreen({ Key? key, required this.pet}) : super(key: key);

  final _requestController = Get.put(RequestController());
  final _userController = Get.put(UserController());
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCarousel(
              urls: pet.photos,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,top:20,right: 12,
                  bottom: 84
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.petName??"No Name",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 6,),
                      if(pet.breed?.trim()!='')
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            "Breed : ${pet.breed}",
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                      if(pet.age!=null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            "Age : ${pet.age} year",
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                          const Icon(Icons.location_pin,size: 16,),
                          const SizedBox(width: 4,),
                          Text(
                            "${pet.address?.addressLine}",
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6,),
                      if(pet.user!=null && pet.user?.userId!= _userController.user?.userId)
                        Row(
                          children: [
                            const Icon(Icons.person,size: 16,),
                            const SizedBox(width: 4,),
                            InkWell(
                              onTap: ()async{
                                showUserProfile(pet.user!);
                              },
                              child: Text(
                                "${pet.user?.fullName}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16,),
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 15,
                          color: Themes.colorBlack.withOpacity(0.8),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 6,),
                      Text(
                        "${pet.petInfo}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.colorBlack.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() {
            if(pet.user?.userId == _userController.user?.userId){
              return CustomElevatedButton(
                onPressed: ()async{
                  _requestController.fetchSpecificPetRequests(pet.petId);
                  AppNavigator.push(
                    context, 
                    SpecificPetRequestsScreen(pet: pet)
                  );
                },
                text: "Show Requests",
              );
            }
            if(_requestController.isRequested(pet.petId)){
              return  const  CustomElevatedButton(
                onPressed: null,
                text: "Already Requested",
              );
            }
            return  CustomElevatedButton(
              onPressed: ()async{
                customLoadingIndicator(context: context,canPop: false);
                bool res =await  _requestController.sendAdoptRequest(pet.petId.toString());
                Navigator.pop(context);
                if(res){
                  CustomSnackbar.message(msg: "Request sent");
                }
              },
              text: "Request to Adopt",
            );
          })
        )
      ),
    );
    
  }

  
}