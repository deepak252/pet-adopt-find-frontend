import 'dart:developer';
import 'dart:io';

import 'package:adopt_us/utils/debug_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class StoragePath{
  static const String profilePic="user/pics";
  static const String petPic="pet/pics";
}

class FirebaseStorageService{
  static final _debug = DebugUtils("FirebaseStorageService");
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Will return a download link. Path->location of file in firebase storage
  static Future<String?> uploadFile({
    required String fileName, 
    required File file, 
    required String path
  })async{
    try{
      Reference ref = _storage.ref("$path/$fileName");
      await ref.putFile(file);
      _debug.message("uploadFile", "File uploaded to storage successfully");
      return ref.getDownloadURL();
    }catch(e,s){
      _debug.error("uploadFile", error: e,stackTrace: s);
    }
    return null;
  }

  static Future<bool?> deleteFile({required String fileUrl})async{
    try{
      Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
      _debug.message("deleteFile", "File (url : $fileUrl) removed from storage");
      return true;
    }catch(e,s){
      _debug.error("deleteFile", error: e,stackTrace: s);
    }
    return null;
  }

  static void _logMessage(String method, String message){
    log("MESSAGE : FirebaseStorageService -> $method : $message ");
  }

  static void _logError(String method, String message){
    log("ERROR : FirebaseStorageService -> $method  : $message ");
  }
}