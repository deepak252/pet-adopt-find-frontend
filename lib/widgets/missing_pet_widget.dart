import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/pet_details_screen.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissingPetWidget extends StatelessWidget {
  final Pet pet;
  const MissingPetWidget({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>PetDetailsScreen(
          pet: pet,
        ));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),

        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: CachedImageContainer(
                    imgUrl: pet.photos.first,
                    borderRadius: BorderRadius.circular(8),
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                const SizedBox(width: 10,),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.petName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 8,),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}