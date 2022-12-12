import 'package:adopt_us/config/app_theme.dart';
import 'package:flutter/material.dart';

void customLoadingIndicator({
  required BuildContext context,
  bool dismissOnTap = true
}){
  showDialog(
    context: context, 
    builder: (_)=>WillPopScope(
      onWillPop: () async => dismissOnTap,
      child: const Center(child: CircularProgressIndicator(
        color: Themes.colorSecondary,
      )),
    )
  );
}