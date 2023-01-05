import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/widgets/custom_carousel.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbondonedPetDetailsScreen extends StatelessWidget {
  final Pet pet;
  AbondonedPetDetailsScreen({ Key? key, required this.pet}) : super(key: key);

  final _requestController = Get.put(RequestController());
  
  @override
  Widget build(BuildContext context) {
    log("${pet.photos}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: (){
                
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite_outline_outlined,
                  color: Colors.redAccent,
                  size : 30
                ),
              ),
            ),
          ],
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
                        pet.petName!.trim().isEmpty
                        ? "Abandoned"
                        : pet.petName!,
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
                          Text(
                            "${pet.address?.addressLine}",
                            style: const TextStyle(
                              fontSize: 16
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
          child: CustomElevatedButton(
            onPressed: ()async{
            },
            text: "Contact",
          ),
        )
      ),
    );
    
  }
}