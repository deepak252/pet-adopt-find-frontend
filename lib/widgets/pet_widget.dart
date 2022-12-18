import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/pet_details_screen.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetWidget extends StatelessWidget {
  final Pet pet;
  const PetWidget({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>PetDetailsScreen(
          pet: pet,
        ));
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            shadowColor: Themes.colorSecondary,
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CachedImageContainer(
                    imgUrl: pet.photos.first,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight:  Radius.circular(4),
                    ),
                    width: double.infinity,
                    height: 190,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.petName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "Age : ${pet.age!} year",
                        style: const TextStyle(
                          fontSize: 13
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_pin,size: 16,),
                          Text(
                            "${pet.address?.addressLine}",
                            style: const TextStyle(
                              fontSize: 13
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Icon(
                  Icons.favorite_outline_outlined,
                  color: Themes.colorSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}