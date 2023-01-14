import 'package:adopt_us/controllers/pet_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/screens/pet/abondoned_pet_details.dart';
import 'package:adopt_us/utils/app_router.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:adopt_us/widgets/cached_image_container.dart';

class FindScreen extends StatelessWidget {
  FindScreen({ Key? key }) : super(key: key);

  final _petController = Get.put(PetController());
 
  @override
  Widget build(BuildContext context) {
    _petController.fetchAbondonedPets();
    return Scaffold(
      body : Obx((){
        if(_petController.loadingAbondonedPets){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_petController.abandonedPets.isEmpty){
          return NoResultWidget(
            title: "No Pets Found!",
            onRefresh: ()async{
              _petController.fetchAbondonedPets(enableLoading: true);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: ()async{
            await _petController.fetchAbondonedPets(enableLoading: true);
          },
          child: ListView.separated(
            itemCount: _petController.abandonedPets.length,
            separatorBuilder: (BuildContext context, int index){
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index){
              return _AbondonedPet(
                pet: _petController.abandonedPets[index]
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


class _AbondonedPet extends StatelessWidget {
  final Pet pet;
  const _AbondonedPet({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppRouter.push(context, AbondonedPetDetailsScreen(
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
                  "Abandoned",
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