import 'package:flutter/material.dart';

abstract class Themes{
  static const ffamily1="Poppins";
  static const ffamily2="Lato";
  
  static const appColor=Colors.indigo;
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
      primary: appColor, //appbar
      secondary: appColor,
    ),
    primaryColor: appColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: appColor,
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