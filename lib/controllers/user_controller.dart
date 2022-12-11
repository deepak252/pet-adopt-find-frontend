import 'package:adopt_us/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final _loading = false.obs;
  bool get isLoading => _loading.value;

  final  _user = Rxn<User>();
  

}