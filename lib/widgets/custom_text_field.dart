import 'package:adopt_us/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget { 
  
  final TextEditingController ? controller;
  final String ? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool? enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final Color? borderColor;
  final Color? textColor;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool? filled;
  const CustomTextField({ 
    Key? key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText=false,
    this.enabled,
    this.keyboardType,
    this.validator,
    this.maxLines=1,
    this.borderColor,
    this.fillColor,
    this.textColor,
    this.inputFormatters,
    this.textInputAction,
    this.filled=true
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      
      style: TextStyle(
        color: textColor??Themes.colorBlack,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText : hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: borderColor?? Colors.transparent, 
        //     // width: 1.0
        //   ),
        //   borderRadius: BorderRadius.circular(8)
        // ),
        // disabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: borderColor?? Colors.transparent, 
        //     width: 1.0
        //   ),
        //   borderRadius: BorderRadius.circular(8)
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: borderColor?? Themes.colorSecondary, 
        //     width: 1.0,
        //   ),
        //   borderRadius: BorderRadius.circular(8)
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(
        //     color: Colors.red,
        //   ),
        //   borderRadius: BorderRadius.circular(8)
        // ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderSide: const BorderSide(
        //     color: Colors.red,
        //   ),
        //   borderRadius: BorderRadius.circular(8)
        // ),
        
        
        errorMaxLines: 4,
        fillColor: fillColor,
        filled: filled,
      ),
      
    );
  }
}
