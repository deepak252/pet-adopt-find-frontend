import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;
  const PetDetailsScreen({ Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: CachedImageContainer(
              imgUrl: pet.photos.first,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight:  Radius.circular(4),
              ),
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,top: 12,right: 12,
                bottom: 84
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pet.petName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
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
                    const SizedBox(height: 8,),
                    Text(
                      "Breed : ${pet.breed}",
                      style: const TextStyle(
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      "Age : ${pet.age!} year",
                      style: const TextStyle(
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        const Icon(Icons.location_pin,size: 16,),
                        Text(
                          "${pet.address?.addressLine}",
                          style: const TextStyle(
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      "About",
                      style: TextStyle(
                        fontSize: 15,
                        color: Themes.colorBlack.withOpacity(0.8),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Text(
                      "${pet.petInfo}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Themes.colorBlack.withOpacity(0.8),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomElevatedButton(
          onPressed: (){
          },
          text: "Request to Adopt",
        ),
      )
    );
    
  }
}