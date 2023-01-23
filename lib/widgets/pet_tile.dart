import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PetTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Pet pet;
  final bool showFav;
  PetTile({super.key, required this.pet, this.onTap, this.showFav=true});

  final _userController = Get.put(UserController());
  final _petController =  Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                        "Age : ${pet.age} year",
                        style: const TextStyle(
                          fontSize: 13
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_pin,size: 16,),
                          Text(
                            pet.address?.addressLine??'NA',
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
          if(showFav)
            Obx((){
              bool isFavorite = _userController.user?.getFavPetIds?.contains(pet.petId)==true;
              return GestureDetector(
                onTap: ()async{
                  _petController.toggleFavoritePet(pet.petId);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline_outlined,
                    color: Colors.redAccent,
                    size: 30,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}