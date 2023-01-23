import 'dart:developer';

import 'package:adopt_us/models/request.dart';
import 'package:adopt_us/services/request_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:get/get.dart';

class RequestController extends GetxController{

  final _loadingReqReceived = false.obs;
  bool get loadingReqReceived => _loadingReqReceived.value;
  final  _reqReceived = Rxn<List<Request>>();
  List<Request> get reqReceived => _reqReceived.value??[];

  final _loadingReqMade = false.obs;
  bool get loadingReqMade => _loadingReqMade.value;
  final  _reqMade = Rxn<List<Request>>();
  List<Request> get reqMade => _reqMade.value??[];
  
  final _loadingPetRequests = false.obs;
  bool get loadingPetRequests => _loadingPetRequests.value;
  final  _specificPetRequests = Rxn<Map<int,List<Request>>>();
  List<Request> specificPetRequests(int petId){
    if(_specificPetRequests.value?[petId]!=null){
      return _specificPetRequests.value![petId]??[];
    }
    return [];
  }

  String? _token = UserPrefs.token;

  bool isRequested(int petId){
    return reqMade.indexWhere((r) => petId==r.pet?.petId)!=-1;
  }
  
  @override
  void onInit() {
    _token = UserPrefs.token;
    fetchRequestsReceived(enableLoading: true);
    fetchRequestsMade(enableLoading: true);
    super.onInit();
  }

  Future fetchRequestsReceived({bool enableLoading = false})async{
    if(loadingReqReceived || _token==null){
      return;
    }
    if(enableLoading){
      _loadingReqReceived(true);
    }
    final requests = await RequestService.getRequestsReceived(
      token: _token!
    );
    log("$requests");
    _reqReceived(requests);
    if(enableLoading){
      _loadingReqReceived(false);
    }
  }

  Future fetchRequestsMade({bool enableLoading = false})async{
    if(loadingReqMade || _token==null){
      return;
    }
    if(enableLoading){
      _loadingReqMade(true);
    }
    final requests = await RequestService.getRequestsMade(
      token: _token!
    );
    _reqMade(requests);
    if(enableLoading){
      _loadingReqMade(false);
    }
  }

  Future fetchSpecificPetRequests(int petId)async{
    if(_token==null){
      return;
    }
    if(specificPetRequests(petId).isEmpty){
      _loadingPetRequests(true);
    }
    final requests = await RequestService.specificPetRequests(
      token: _token!,
      petId: petId
    );
    if(requests!=null){
      _specificPetRequests.update((val) {
        if(val==null){
          val = {petId : requests };
        }else{
          val[petId] = requests;
        }
        _specificPetRequests(val);
      });
    }
    _loadingPetRequests(false);
  }

  Future<bool> sendAdoptRequest(String petId)async{
    if(_token==null){
      return false;
    }
    final result = await RequestService.sendAdoptRequest(
      token: _token!,
      petId: petId
    );
    if(result!=null){
      fetchRequestsMade();
      fetchRequestsReceived();
      return result;
    }
    return false;
  }

  Future<bool> updateRequestStatus({
    required int requestId,
    required String status
  })async{
    if(_token==null){
      return false;
    }
    final result = await RequestService.updateRequest(
      token: _token!,
      requestId: requestId,
      status: status
    );
    if(result!=null){
      // fetchRequestsMade();
      await fetchRequestsReceived();
      return result;
    }
    return false;
  }

  Future<bool> deleteRequest({
    required int requestId,
  })async{
    if(_token==null){
      return false;
    }
    final result = await RequestService.deleteRequest(
      token: _token!,
      requestId: requestId,
    );
    if(result!=null){
      await fetchRequestsMade();
      return result;
    }
    return false;
  }

  

  


}