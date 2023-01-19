import 'dart:developer';
import 'dart:io';


import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class FileUtils {
  static final _debug =  DebugUtils("FileUtils");
  
  static double fileSizeKB(File file) {
    int bytes = file.readAsBytesSync().lengthInBytes;
    return bytes / 1024;
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) return File(image.path);
    } catch (e,s) {
      _debug.error("pickImageFromGallery",error: e,stackTrace: s);
    }
    return null;
  }

  /// Pick image gallery
  static Future<File?> pickImageFromGallery({int imageQuality=60}) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality
      );
      if (image != null){
        log("${image.name}");
        return File(image.path);
      }
    } catch (e,s) {
      _debug.error("pickImageFromGallery",error: e,stackTrace: s);
    }
    return null;
  }

  static Future<File?> cropImage(File imgFile) async {
    try {
      final croppedImg = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Themes.colorPrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
        ],
      );
      if(croppedImg!=null){
        return File(croppedImg.path);
      }
    } catch (e,s) {
      _debug.error("cropImage",error: e,stackTrace: s);
    }
    return null;
  }


  static String? getFileExtensionFromPath(String filePath) {
    try {
      return path.extension(filePath).substring(1).toLowerCase();
    } catch (e,s) {
      _debug.error("getFileExtensionFromPath",error: e,stackTrace: s);
    }
    return null;
  }

  /// Pick image gallery and Crop
  static Future<File?> pickAndCropImage({int imageQuality=60}) async {
    final pickedImage = await FileUtils.pickImageFromGallery();
    if(pickedImage==null){
      return null;
    }
    // log("Picked File : ${pickedImage.path}. size ${FileUtils.fileSizeKB(pickedImage)} KB");
    if(FileUtils.fileSizeKB(pickedImage)>2048){
      CustomSnackbar.error(
        error: "Image size can't be greater than 2Mb."
      );
      return null;
    }
    final croppedImage = await FileUtils.cropImage(pickedImage);
    // log("Cropped File : ${croppedImage.path}. size ${FileUtils.fileSizeKB(croppedImage)} KB");
    return croppedImage;
    
  }

  static String? getFileNameFromPath(String filePath) {
    try {
      return File(filePath).uri.pathSegments.last;
    } catch (e,s) {
      _debug.error("getFileNameFromPath",error: e,stackTrace: s);
    }
    return null;
  }

}