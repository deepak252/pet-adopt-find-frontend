
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class RequestService{
  static final _debug = DebugUtils("RequestService");

  static Future<bool?> sendAdoptRequest({
    required String token,
    required String petId
  }) async {
    return await HttpUtils.post(
      methodName: "sendAdoptRequest : $petId", 
      api: "${ApiPath.adoptRequest}/$petId",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          
        }
        return null;
      },
      debug: _debug,
    );
  }
 
  // static Future<bool?> sendAdoptRequest({
  //   required String token,
  //   required String petId
  // }) async {
  //   return await HttpUtils.post(
  //     methodName: "sendAdoptRequest : $petId", 
  //     api: "${ApiPath.adoptRequest}/$petId",
  //     token: token,
  //     onSuccess: (res)async{
  //       if(res?['data']!=null){
  //         // List<Pet> pets = [];
  //         // for(var petJson in res?['data']){
  //         //   try{
  //         //     pets.add(Pet.fromJson(petJson));
  //         //   }catch(e,s){
  //         //     _debug.error("sendAdoptRequest (Invalid json pet)", error: e, stackTrace: s);
  //         //   }
  //         // }
  //         // return pets;
  //       }
  //       return null;
  //     },
  //     debug: _debug,
  //   );
  // }


 
}