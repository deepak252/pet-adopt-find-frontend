import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/pet/missing_pet_details.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/not_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:adopt_us/widgets/cached_image_container.dart';

class MissingPetsScreen extends StatelessWidget {
  MissingPetsScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());
  final _userController = Get.put(UserController());
 
  @override
  Widget build(BuildContext context) {
    _petController.fetchMissingPets();
    return Scaffold(
      body : Obx((){
        if(!_userController.isSignedIn){
          return const NotSignedIn();
        }
        if(_petController.loadingMissingPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.missingPets.isEmpty){
          return NoResultWidget(
            title: "No Pets Found!",
            onRefresh: ()async{
              _petController.fetchMissingPets(enableLoading: true);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchMissingPets(enableLoading: true);
          },
          child: ListView.separated(
            itemCount: _petController.missingPets.length,
            separatorBuilder: (BuildContext context, int index){
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index){
              return _MissingPet(
                pet: _petController.missingPets[index]
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await Get.bottomSheet(
            _uploadImage(),
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)
              )
            )
          );
        },
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _uploadImage(){
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          AppBar(
            title: const Text("Upload Image"),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(12),
            child: CustomElevatedButton(
              onPressed: ()async {
                await FileUtils.pickImageFromGallery();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Select Image from Gallery",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 12,),
                  Icon(Icons.image),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _MissingPet extends StatelessWidget {
  final Pet pet;
  const _MissingPet({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppNavigator.push(context, MissingPetDetailsScreen(
          pet: pet,
        ));
        
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),

        child: Column(
          // alignment: Alignment.topRight,
          children: [
            CachedImageContainer(
              imgUrl: pet.photos.first,
              borderRadius: BorderRadius.circular(6),
              width: double.infinity,
              height: 250,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4,),
                Text(
                  "Missing",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent.withOpacity(0.8)
                  ),
                ),
                const SizedBox(height: 4,),
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
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Flexible(
            //       flex: 2,
            //       child: CachedImageContainer(
            //         imgUrl: pet.photos.first,
            //         borderRadius: BorderRadius.circular(8),
            //         width: double.infinity,
            //         height: 150,
            //       ),
            //     ),
            //     const SizedBox(width: 10,),
            //     Flexible(
            //       flex: 3,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             pet.petName!,
            //             style: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 18
            //             ),
            //           ),
            //           const SizedBox(height: 8,),
            //           Row(
            //             children: [
            //               const Icon(Icons.location_pin,size: 16,),
            //               Text(
            //                 "${pet.address?.addressLine}",
            //                 style: const TextStyle(
            //                   fontSize: 13
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}