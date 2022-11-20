import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/widgets/pet_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({ Key? key }) : super(key: key);
  final _pet = Pet(
    name: "Shinti",
    age: 1,
    pic: "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313__340.jpg",
    address: "New Delhi"
  );

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      
      body : GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
          childAspectRatio: 0.8
        ),
        itemBuilder: (BuildContext context, int index) {
          return PetWidget(
            pet: _pet,
          );
        },
      )
    );
  }
}