import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/screens/pet/missing_pet_details.dart';
import 'package:adopt_us/screens/pet/my_pet_details.dart';
import 'package:adopt_us/screens/pet/surrended_pet_details.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/pet_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class FavoritePetsScreen extends StatelessWidget {
  FavoritePetsScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    _petController.fetchFavPets();
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Pets"),
      ),
      body : Obx((){
        if(_petController.loadingFavPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.favPets.isEmpty){
          return NoResultWidget(
            title: "No Pets Found!",
            onRefresh: ()async{
              _petController.fetchFavPets(enableLoading: true);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchFavPets(enableLoading: true);
          },
          child: GridView.builder(
            itemCount: _petController.favPets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: 0.8
            ),
            itemBuilder: (BuildContext context, int index){
              final pet = _petController.favPets[index];
              return PetTile(
                pet: _petController.favPets[index],
                onTap: (){
                  if(pet.petStatus==PetStatus.missing){
                    AppNavigator.push(context, MissingPetDetailsScreen(
                      pet: _petController.favPets[index],
                    ));
                  }
                  if(pet.petStatus==PetStatus.surrender){
                      AppNavigator.push(context, SurrendedPetDetailsScreen(
                        pet: _petController.favPets[index],
                      ));
                  }
                },

              );
            },
          ),
        );
      }),
    );
  }
}