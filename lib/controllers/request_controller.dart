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
  
  final _token = UserPrefs.token;

  bool isRequested(int petId){
    return reqMade.indexWhere((r) => petId==r.pet?.petId)!=-1;
  }
  
  @override
  void onInit() {
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

  


}