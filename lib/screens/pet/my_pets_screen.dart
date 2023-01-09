import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/create_pet_screen.dart';
import 'package:adopt_us/screens/pet/my_pet_details.dart';
import 'package:adopt_us/screens/pet/surrended_pet_details.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';

class MyPetsScreen extends StatelessWidget {
  MyPetsScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    _petController.fetchMyPets();
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pets"),
      ),
      body : Obx((){
        if(_petController.loadingMyPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.myPets.isEmpty){
          return NoResultWidget(
            title: "No Pets Found!",
            onRefresh: ()async{
              _petController.fetchMyPets(enableLoading: true);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchMyPets(enableLoading: true);
          },
          child: GridView.builder(
            itemCount: _petController.myPets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: 0.8
            ),
            itemBuilder: (BuildContext context, int index){
              return PetWidget(
                pet: _petController.myPets[index],
              );
            },
          ),
        );
      }),
    );
  }
}


class PetWidget extends StatelessWidget {
  final Pet pet;
  const PetWidget({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>MyPetDetails(
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
          GestureDetector(
            onTap: (){
              
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                  Icons.favorite_outline_outlined,
                  color: Colors.redAccent,
                ),
            ),
          ),
        ],
      ),
    );
  }
}