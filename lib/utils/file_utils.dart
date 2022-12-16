import 'dart:developer';
import 'dart:io';


import 'package:adopt_us/utils/debug_utils.dart';
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

  /// Open image gallery and pick an image
  static Future<File?> pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) return File(image.path);
    } catch (e,s) {
      _debug.error("pickImageFromGallery",error: e,stackTrace: s);
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

  static String? getFileNameFromPath(String filePath) {
    try {
      return File(filePath).uri.pathSegments.last;
    } catch (e,s) {
      _debug.error("getFileNameFromPath",error: e,stackTrace: s);
    }
    return null;
  }

}