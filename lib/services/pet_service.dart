
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class PetService{
  static final _debug = DebugUtils("PetService");

  static Future<bool?> createPet({
    required String token,
    required Map<String,dynamic> data
  }) async {
    return await HttpUtils.post(
      methodName: "createPet", 
      token: token,
      api: ApiPath.createPet,
      body: data,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
      },
      debug: _debug,
    );
  }

  static Future<bool?> editPet({
    required String token,
    required Map<String,dynamic> data
  }) async {
    return await HttpUtils.put(
      methodName: "editPet", 
      token: token,
      api: ApiPath.editPet,
      body: data,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
      },
      debug: _debug,
    );
  }

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
      showError: false
    );
  }

  static Future<List<Pet>?> getMyPets({required String token}) async {
    return await HttpUtils.get(
      methodName: "getMyPets", 
      api: ApiPath.myPets,
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Pet> pets = [];
          for(var petJson in res?['data']){
            try{
              pets.add(Pet.fromJson(petJson));
            }catch(e,s){
              _debug.error("getMyPets (Invalid json pet)", error: e, stackTrace: s);
            }
          }
          return pets;
        }
        return null;
      },
      debug: _debug,
      
    );
  }

  static Future<List<Pet>?> getPetsByStatus({
    required String token,
    required String status
  }) async {
    return await HttpUtils.get(
      methodName: "getPetByStatus : $status", 
      api: "${ApiPath.getPetByStatus}?status=$status",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Pet> pets = [];
          for(var petJson in res?['data']){
            try{
              if(status==PetStatus.missing){
                pets.add(Pet.fromJson(petJson['pet']));
              }else{
                pets.add(Pet.fromJson(petJson));
              }
            }catch(e,s){
              _debug.error("getPetsByStatus (Invalid json pet) : $petJson", error: e, stackTrace: s);
            }
          }
          return pets;
        }
        return null;
      },
      debug: _debug,
      showError: false
    );
  }


  static Future<Pet?> getPetById({
    required String token,
    required int petId
  }) async {
    return await HttpUtils.get(
      methodName: "getPetById", 
      api: "${ApiPath.getPetById}/$petId",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return Pet.fromJson(res['data']);
        }
        return null;
      },
      debug: _debug,
      showError: false
    );
  }

  static Future<List<Pet>?> getFavPets({required String token}) async {
    return await HttpUtils.get(
      methodName: "getFavPets", 
      api: ApiPath.myPets,
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Pet> pets = [];
          for(var petJson in res?['data']){
            try{
              pets.add(Pet.fromJson(petJson));
            }catch(e,s){
              _debug.error("getFavPets (Invalid json pet)", error: e, stackTrace: s);
            }
          }
          return pets;
        }
        return null;
      },
      debug: _debug,
      
    );
  }

  static Future<bool?> addPetToFav({
    required String token,
    required int petId
  }) async {
    return await HttpUtils.post(
      methodName: "addPetToFav", 
      api: "${ApiPath.addPetToFav}/$petId",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
        return null;
      },
      debug: _debug,
      showError: false
    );
  }

  static Future<bool?> removePetFromFav({
    required String token,
    required int petId
  }) async {
    return await HttpUtils.post(
      methodName: "removePetFromFav", 
      api: "${ApiPath.removePetFromFav}/$petId",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
        return null;
      },
      debug: _debug,
      showError: false
    );
  }

 
}