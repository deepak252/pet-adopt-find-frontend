import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:flutter/material.dart';

class PetWidget extends StatelessWidget {
  final Pet pet;
  const PetWidget({ Key? key, required this.pet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  imgUrl: pet.pic!,
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
                      pet.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "Age : ${pet.age!} year",
                      style: const TextStyle(
                        fontSize: 13
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_pin,size: 16,),
                        Text(
                          "${pet.address}",
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Icon(
                Icons.favorite_outline_outlined,
                color: Themes.colorSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}