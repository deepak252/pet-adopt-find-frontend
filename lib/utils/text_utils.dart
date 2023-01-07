import 'dart:developer';

class TextUtils{
  static String capitalizeFirstLetter(String str) {
    return str.length <= 1
    ? str.toUpperCase()
    : '${str[0].toUpperCase()}${str.substring(1)}';
  }

  static String capitalizeFirstLetterWithSpaces(String input) {
    try{
      final List<String> splitStr = input.split(' ');
      for (int i = 0; i < splitStr.length; i++) {
        splitStr[i] = capitalizeFirstLetter(splitStr[i]);
      }
      return splitStr.join(' ');
    }catch(e){
      log("ERROR, capitalizeFirstLetterWithSpaces : $e");
    }
    //if some error occured return input
    return input;
  }
}