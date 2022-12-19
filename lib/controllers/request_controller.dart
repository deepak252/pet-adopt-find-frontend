import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/services/pet_service.dart';
import 'package:adopt_us/services/request_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:get/get.dart';

class RequestController extends GetxController{
  final _loadingAllPets = false.obs;
  bool get loadingAllPets => _loadingAllPets.value;

  final  _allPets = Rxn<List<Pet>>();
  List<Pet> get allPets => _allPets.value??[];

  
  
  final _token = UserPrefs.token;
  
  @override
  void onInit() {
    super.onInit();
  }

  Future fetchAllPets({bool enableLoading = false})async{
    if(loadingAllPets){
      return;
    }
    if(enableLoading){
      _loadingAllPets(true);
    }
    final pets = await PetService.getAllPets();
    if(pets!=null){
      _allPets(pets);
    }
    if(enableLoading){
      _loadingAllPets(false);
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
      // fetchAllPets();
      return result;
    }
    return false;
  }

  


}