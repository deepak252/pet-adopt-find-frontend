import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/screens/pet/my_pet_details.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/pet_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
              return PetTile(
                pet: _petController.myPets[index],
                onTap: (){
                  AppNavigator.push(context, MyPetDetails(
                    pet: _petController.myPets[index],
                  ));
                },

              );
            },
          ),
        );
      }),
    );
  }
}