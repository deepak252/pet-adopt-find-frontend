import 'package:flutter/material.dart';

class FindScreen extends StatelessWidget {
  const FindScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.search),
      ),
    );
  }
}