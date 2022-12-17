
import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:adopt_us/utils/http_utils.dart';

abstract class PetService{
  static final _debug = DebugUtils("PetService");
 
  static Future getAllPets({
    required String token
  }) async {
    return await HttpUtils.get(
      methodName: "getAllPets", 
      token: token,
      api: ApiPath.getAllPets,
      onSuccess: (res)async{
        if(res?['data']!=null){
          // return User.fromJson(res['data']);
        }
        return null;
      },
      debug: _debug,
    );
  }

  static Future<User?> create({
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
          return User.fromJson(res['data']);
        }
        return null;
      },
      debug: _debug,
    );
  }

 
}