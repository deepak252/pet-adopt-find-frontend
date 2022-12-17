import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/utils/file_utils.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/missing_pet_widget.dart';
import 'package:adopt_us/widgets/pet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindScreen extends StatelessWidget {
  FindScreen({ Key? key }) : super(key: key);

  final _pet = Pet(
    petId: 1,
    userId: 1,
    petName: "Shinti",
    age: 1,
    photos: "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313__340.jpg",
    addressLine: "New Delhi"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 12),
              indicatorColor: Themes.colorPrimary,
              unselectedLabelStyle: TextStyle(
                color: Themes.colorBlack,
                fontSize: 14,
                fontFamily: Themes.ffamily1
              ),
              labelStyle: TextStyle(
                color: Themes.colorBlack,
                fontSize: 16,
                fontFamily: Themes.ffamily1
              ),
              tabs: [
                Text(
                  "Missing",
                  style: TextStyle(
                    color: Themes.colorBlack,
                    // fontSize: 16
                    
                  ),
                ),
                Text(
                  "Abondoned",
                  style: TextStyle(
                    color: Themes.colorBlack,
                    // fontSize: 16
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index){
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index){
                      return MissingPetWidget(
                        pet: _pet,
                      );
                    },
                  ),
                  ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (BuildContext context, int index){
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index){
                      return MissingPetWidget(
                        pet: _pet,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await Get.bottomSheet(
            _searchOptions(),
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

  Widget _searchOptions(){
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