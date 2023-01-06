
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/models/request.dart';
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
      api: "${ApiPath.createRequest}/$petId",
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          return true;
        }
      },
      debug: _debug,
    );
  }

  static Future<List<Request>?> getRequestsReceived({required String token}) async {
    return await HttpUtils.get(
      methodName: "getRequestsReceived", 
      api: ApiPath.requestsReceived,
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Request> requests = [];
          for(var req in res?['data']){
            try{
              requests.add(Request.fromJson(req));
            }catch(e,s){
              _debug.error("getRequestsReceived (Invalid json request)", error: e, stackTrace: s);
            }
          }
          return requests;
        }
        return null;
      },
      debug: _debug,
    );
  }

  static Future<List<Request>?> getRequestsMade({required String token}) async {
    return await HttpUtils.get(
      methodName: "getRequestsMade", 
      api: ApiPath.requestsMade,
      token: token,
      onSuccess: (res)async{
        if(res?['data']!=null){
          List<Request> requests = [];
          for(var req in res?['data']){
            try{
              requests.add(Request.fromJson(req));
            }catch(e,s){
              _debug.error("getRequestsMade (Invalid json request)", error: e, stackTrace: s);
            }
          }
          return requests;
        }
        return null;
      },
      debug: _debug,
    );
  }
 
 

 
}