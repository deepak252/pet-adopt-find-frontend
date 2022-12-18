import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/address.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/create_pet_screen.dart';
import 'package:adopt_us/services/pet_service.dart';
import 'package:adopt_us/widgets/pet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());
  final _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body : Obx((){
        if(_petController.loadingAllPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.allPets.isEmpty){
          return const Center(
            child: Text("No Pets Found!"),
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchAllPets(enableLoading: true);
          },
          child: GridView.builder(
            itemCount: _petController.allPets.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: 0.8
            ),
            itemBuilder: (BuildContext context, int index){
              return PetWidget(
                pet: _petController.allPets[index],
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