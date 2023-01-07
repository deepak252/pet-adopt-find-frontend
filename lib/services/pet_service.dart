
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class PetService{
  static final _debug = DebugUtils("PetService");
 
  static Future<List<Pet>?> getAllPets() async {
    return await HttpUtils.get(
      methodName: "getAllPets", 
      api: ApiPath.getAllPets,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Pet> pets = [];
          for(var petJson in res?['data']){
            try{
              pets.add(Pet.fromJson(petJson));
            }catch(e,s){
              _debug.error("getAllPets (Invalid json pet)", error: e, stackTrace: s);
            }
          }
          return pets;
        }
        return null;
      },
      debug: _debug,
    );
  }

  static Future<bool?> createPet({
    required String token,
    required Map<String,dynamic> data
  }) async {
    return await HttpUtils.post(
      methodName: "createPet", 
      token: token,
      api: ApiPath.createPet,
      payload: data,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
      },
      debug: _debug,
    );
  }

  static Future<List<Pet>?> getPetsByStatus({required String status}) async {
    return await HttpUtils.get(
      methodName: "getPetByStatus : $status", 
      api: "${ApiPath.getPetByStatus}?status=$status",
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Pet> pets = [];
          for(var petJson in res?['data']){
            try{
              pets.add(Pet.fromJson(petJson));
            }catch(e,s){
              _debug.error("getPetsByStatus (Invalid json pet)", error: e, stackTrace: s);
            }
          }
          return pets;
        }
        return null;
      },
      debug: _debug,
    );
  }

 
}