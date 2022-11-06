import 'package:flutter/material.dart';

abstract class Themes{
  static const ffamily1="Poppins";
  static const ffamily2="Lato";
  
  static const colorPrimary=Color.fromARGB(255, 66, 35, 131);
  static const colorBlack=Color.fromARGB(255, 32, 32, 32);
  static const _textTheme = TextTheme(
    subtitle1:  TextStyle(  //TextField text/hint text,
      fontFamily: ffamily2,
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: colorPrimary, //appbar
      secondary: colorPrimary,
    ),
    primaryColor: colorPrimary,
    buttonTheme: const ButtonThemeData(
      buttonColor: colorPrimary,
      disabledColor: Colors.grey,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        fontFamily: ffamily2
      )
    ),    
    textTheme: _textTheme,
    fontFamily: ffamily1,
    
  );
}