import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/services/pet_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:get/get.dart';

class PetController extends GetxController{

  final _loadingAllPets = false.obs;
  bool get loadingAllPets => _loadingAllPets.value;
  final  _allPets = Rxn<List<Pet>>();
  List<Pet> get allPets => _allPets.value??[];

  final _loadingAbondonedPets = false.obs;
  bool get loadingAbondonedPets => _loadingAbondonedPets.value;
  final  _abandonedPets = Rxn<List<Pet>>();
  List<Pet> get abandonedPets => _abandonedPets.value??[];

  final _loadingSurrenderPets = false.obs;
  bool get loadingSurrenderPets => _loadingSurrenderPets.value;
  final  _surrenderedPets = Rxn<List<Pet>>();
  List<Pet> get surrenderedPets => _surrenderedPets.value??[];

  final _loadingMyPets = false.obs;
  bool get loadingMyPets => _loadingMyPets.value;
  final  _myPets = Rxn<List<Pet>>();
  List<Pet> get myPets => _myPets.value??[];
  
  
  final _token = UserPrefs.token;
  
  @override
  void onInit() {
    // fetchAllPets(enableLoading: true);
    fetchAbondonedPets(enableLoading: true);
    fetchSurrendedPets(enableLoading: true);
    fetchMyPets(enableLoading: true);
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

  Future<bool> createPet(Map<String,dynamic> data)async{
    if(_token==null){
      return false;
    }
    final result = await PetService.createPet(
      token: _token!,
      data: data
    );
    if(result!=null){
      fetchAllPets();
      fetchSurrendedPets();
      fetchAbondonedPets();
      return result;
    }
    return false;
  }

  Future<bool> editPet(Map<String,dynamic> data)async{
    if(_token==null){
      return false;
    }
    final result = await PetService.editPet(
      token: _token!,
      data: data
    );
    if(result!=null){
      fetchAllPets();
      fetchSurrendedPets();
      fetchAbondonedPets();
      fetchMyPets();
      return result;
    }
    return false;
  }

  Future fetchSurrendedPets({bool enableLoading = false})async{
    if(loadingSurrenderPets){
      return;
    }
    if(enableLoading){
      _loadingSurrenderPets(true);
    }
    final pets = await PetService.getPetsByStatus(status: PetStatus.surrender);
    if(pets!=null){
      _surrenderedPets(pets);
    }
    if(enableLoading){
      _loadingSurrenderPets(false);
    }
  }


  Future fetchAbondonedPets({bool enableLoading = false})async{
    if(loadingAbondonedPets){
      return;
    }
    if(enableLoading){
      _loadingAbondonedPets(true);
    }
    final pets = await PetService.getPetsByStatus(status: PetStatus.abandoned);
    if(pets!=null){
      _abandonedPets(pets);
    }
    if(enableLoading){
      _loadingAbondonedPets(false);
    }
    
  }

  Future fetchMyPets({bool enableLoading = false})async{
    if(loadingMyPets || _token==null){
      return;
    }
    if(enableLoading){
      _loadingMyPets(true);
    }
    final pets = await PetService.getMyPets(token: _token!);
    if(pets!=null){
      _myPets(pets);
    }
    if(enableLoading){
      _loadingMyPets(false);
    }
  }


}