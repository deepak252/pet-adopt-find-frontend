
import 'package:adopt_us/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12,),
              const AppIconWidget(),
              const SizedBox(height: 36,),
              Text(
                '''
    "Adopt Us" aims to provide a platform for individuals to adopt pets in need of a loving home, as well as a way for people to report and search for lost animals. The project will include features such as a database of available pets for adoption, a system for matching pets with suitable adopters. The ultimate goal of the project is to reduce the number of homeless pets and reunite lost animals with their families.''',
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 8,),
              Text(
                '''
    Our android app, built with flutter, is designed to connect pet owners with resources and tools to care for their pets, as well as provide a platform for adopting new pets and reuniting missing pets with their owners. With a backend built using Node.js and a database powered by SQL, our app offers a reliable and efficient platform for managing pet-related information. Users can search for adoptable pets in their area, access information on proper pet care, and receive notifications about lost pets in their community. Additionally, pet owners can surrender their pets through the app, ensuring that they receive the care and attention they need. With a user-friendly interface and valuable resources, our app aims to improve the lives of pets and their owners. With an awareness of people regarding stray animals being abused, this kind of animal platform has gain interest. This is a non-profitable android app.
''',
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}