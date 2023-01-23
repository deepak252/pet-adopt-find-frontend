import 'package:adopt_us/config/pet_status.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/services/pet_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:get/get.dart';

class PetController extends GetxController{

  final _loadingAllPets = false.obs;
  bool get loadingAllPets => _loadingAllPets.value;
  final  _allPets = Rxn<List<Pet>>();
  List<Pet> get allPets => _allPets.value??[];


  final _loadingSurrenderPets = false.obs;
  bool get loadingSurrenderPets => _loadingSurrenderPets.value;
  final  _surrenderedPets = Rxn<List<Pet>>();
  List<Pet> get surrenderedPets => _surrenderedPets.value??[];

  final _loadingMissingPets = false.obs;
  bool get loadingMissingPets => _loadingMissingPets.value;
  final  _missingPets = Rxn<List<Pet>>();
  List<Pet> get missingPets => _missingPets.value??[];

  final _loadingMyPets = false.obs;
  bool get loadingMyPets => _loadingMyPets.value;
  final  _myPets = Rxn<List<Pet>>();
  List<Pet> get myPets => _myPets.value??[];


  final _loadingSpecificFav = {}.obs;
  bool loadingSpecificFav(int petId){
    return _loadingSpecificFav[petId]==true;
  }

  final _loadingFavPets = false.obs;
  bool get loadingFavPets => _loadingFavPets.value;
  final  _favPets = Rxn<List<Pet>>();
  List<Pet> get favPets => _favPets.value??[];

  Pet? getPetById(int petId){
    Pet? pet = surrenderedPets.firstWhereOrNull((e) => e.petId==petId);
    pet ??= myPets.firstWhereOrNull((e) => e.petId==petId);
    pet ??= missingPets.firstWhereOrNull((e) => e.petId==petId);
    return pet;
  }

  // final _loadingAbondonedPets = false.obs;
  // bool get loadingAbondonedPets => _loadingAbondonedPets.value;
  // final  _abandonedPets = Rxn<List<Pet>>();
  // List<Pet> get abandonedPets => _abandonedPets.value??[];

  final _userController = Get.put(UserController());
  String? _token = UserPrefs.token;
  
  @override
  void onInit() {
    _token = UserPrefs.token;
    // fetchAllPets(enableLoading: true);
    // fetchAbondonedPets(enableLoading: true);
    fetchMissingPets(enableLoading: true);
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
      fetchMissingPets();
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
      fetchMissingPets();
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
    final pets = await PetService.getPetsByStatus(
      token: _token??'',
      status: PetStatus.surrender
    );
    if(pets!=null){
      _surrenderedPets(pets);
    }
    if(enableLoading){
      _loadingSurrenderPets(false);
    }
  }

  Future fetchMissingPets({bool enableLoading = false})async{
    if(loadingMissingPets){
      return;
    }
    if(enableLoading){
      _loadingMissingPets(true);
    }
    final pets = await PetService.getPetsByStatus(
      token: _token??'',
      status: PetStatus.missing
    );
    if(pets!=null){
      _missingPets(pets);
    }
    if(enableLoading){
      _loadingMissingPets(false);
    }
    
  }

  // Future fetchAbondonedPets({bool enableLoading = false})async{
  //   if(loadingAbondonedPets){
  //     return;
  //   }
  //   if(enableLoading){
  //     _loadingAbondonedPets(true);
  //   }
  //   final pets = await PetService.getPetsByStatus(
  //     token: _token??'',
  //     status: PetStatus.missing
  //   );
  //   if(pets!=null){
  //     _abandonedPets(pets);
  //   }
  //   if(enableLoading){
  //     _loadingAbondonedPets(false);
  //   }
    
  // }

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

  Future fetchFavPets({bool enableLoading = false})async{
    if(loadingFavPets || _token==null){
      return;
    }
    if(enableLoading){
      _loadingFavPets(true);
    }
    final pets = await PetService.getFavPets(token: _token!);
    if(pets!=null){
      _favPets(pets);
    }
    if(enableLoading){
      _loadingFavPets(false);
    }
  }

  Future<bool> toggleFavoritePet(int petId)async{
    final user = _userController.user;
    if(_token==null || user==null || loadingSpecificFav(petId)){
      return false;
    }
    bool isFavPet = user.getFavPetIds?.contains(petId) ==true;
    if(isFavPet){
      return await removePetFromFav(petId);
    }else{
      return await addPetToFav(petId);
    }
  }

  Future<bool> addPetToFav(int petId)async{
    final result = await PetService.addPetToFav(
      token: _token!,
      petId: petId
    );
    if(result!=null){
      await _userController.fetchProfile();
      return result;
    }
    return false;
  }

  Future<bool> removePetFromFav(int petId)async{
    final result = await PetService.removePetFromFav(
      token: _token!,
      petId: petId
    );
    if(result!=null){
      await _userController.fetchProfile();
      return result;
    }
    return false;
  }

  Future fetchPetById(int petId)async{
    final pet = await PetService.getPetById(
      token: _token!,
      petId: petId
    );
    if(pet!=null){
      _allPets.update((val) {
        if(val==null){
          return;
        }
        int i=val.indexWhere((e) => e.petId==petId);
        if(i==-1){
          return;
        }
        val[i]=pet;
        _allPets(val);
      });

      _surrenderedPets.update((val) {
        if(val==null){
          return;
        }
        int i=val.indexWhere((e) => e.petId==petId);
        if(i==-1){
          return;
        }
        val[i]=pet;
        _surrenderedPets(val);
      });

      _missingPets.update((val) {
        if(val==null){
          return;
        }
        int i=val.indexWhere((e) => e.petId==petId);
        if(i==-1){
          return;
        }
        val[i]=pet;
        _missingPets(val);
      });
      _myPets.update((val) {
        if(val==null){
          return;
        }
        int i=val.indexWhere((e) => e.petId==petId);
        if(i==-1){
          return;
        }
        val[i]=pet;
        _myPets(val);
      });
    }
  }


}