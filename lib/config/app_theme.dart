import 'package:flutter/material.dart';

abstract class Themes{
  static const ffamily1="Poppins";
  static const ffamily2="Lato";
  
  static const colorPrimary=Color(0xFF422383);
  static const colorSecondary=Color(0xFFFFA53E);
  static const colorBlack=Color(0xFF202020);
  static const backgroundColor=Color(0xFFEEEEEE);
  static const _textTheme = TextTheme(
    bodyText2: TextStyle( //Text widget,
      fontSize : 16
    ),
    subtitle1:  TextStyle(  //TextField text/hint text,
      fontFamily: ffamily2,
    ),
  );
  static final _iconTheme =  IconThemeData(
    color: colorBlack.withOpacity(0.8),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: colorBlack,
        fontWeight: FontWeight.w600,
        fontFamily: ffamily1,
        fontSize: 18
      ),
      iconTheme: IconThemeData(
        color: colorBlack,
        size: 22
      )
    ),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: colorPrimary, //appbar
      secondary: colorPrimary,
    ),
    primaryColor: colorPrimary,
    buttonTheme: const ButtonThemeData(
      buttonColor: colorPrimary,
      disabledColor: Colors.grey,
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontFamily: ffamily2,
        color: colorBlack.withOpacity(0.5)
      ),
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent, 
          width: 1.0
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent, 
          width: 1.0
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Themes.colorSecondary, 
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      errorStyle: TextStyle(
        color: Colors.red[400],
        fontSize: 13,
      ),
      labelStyle: const TextStyle(
        color: Themes.colorSecondary, 
      ),
      errorMaxLines: 4,
    ),   
    iconTheme: _iconTheme,
    textTheme: _textTheme,
    fontFamily: ffamily1,
    listTileTheme: ListTileThemeData(
      iconColor: colorBlack.withOpacity(0.9),
    )
    
  );
}