import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/request_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/create_pet_screen.dart';
import 'package:adopt_us/screens/pet/surrended_pet_details.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());
  final _userController = Get.put(UserController());
  final _requestController = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    _petController.fetchSurrendedPets();
    return Scaffold(
      body : Obx((){
        if(_petController.loadingSurrenderPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.surrenderedPets.isEmpty){
          return NoResultWidget(
            title: "No Pets Found!",
            onRefresh: ()async{
              _petController.fetchSurrendedPets(enableLoading: true);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchSurrendedPets(enableLoading: true);
          },
          child: GridView.builder(
            itemCount: _petController.surrenderedPets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: 0.8
            ),
            itemBuilder: (BuildContext context, int index){
              return PetWidget(
                pet: _petController.surrenderedPets[index],
              );
            },
          ),
        );
      }),
     
      floatingActionButton: Obx((){
        if(_userController.isSignedIn){
          return FloatingActionButton(
            onPressed: ()=>Get.to(()=>const CreatePetScreen()),
            child: const Icon(Icons.add),
          );
        }
        return const SizedBox();
      })
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
        Get.to(()=>SurrendedPetDetailsScreen(
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
              // child: Card(
              //   child: Icon(
              //     Icons.favorite_outline_outlined,
              //     color: Themes.colorSecondary,
              //   ),
              // ),
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