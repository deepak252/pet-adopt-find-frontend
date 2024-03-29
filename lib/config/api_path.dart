abstract class ApiPath{

  static const String baseUrl = "http://192.168.43.138:8000";
  // static const String baseUrl = "https://adopt-us-backend.vercel.app";
  // static const String baseUrl = "https://adoptus.onrender.com";
  //Auth
  static const String signIn = "$baseUrl/auth/signin";
  static const String signUp = "$baseUrl/auth/signup";
  static const String resetPassword = "$baseUrl/auth/resetPassword";

  static const String getProfile = "$baseUrl/user/getProfile";
  static const String updateProfile = "$baseUrl/user/updateProfile";
  static const String getNotifications = "$baseUrl/notification/getAll";
  static const String readNotification = "$baseUrl/notification/isRead";

  static const String createPet = "$baseUrl/pet/create";
  static const String editPet = "$baseUrl/pet/edit";
  static const String getAllPets = "$baseUrl/pet/getAllPets";
  static const String getPetByStatus = "$baseUrl/pet/getPets";
  static const String getPetById = "$baseUrl/pet/getPet";
  static const String myPets = "$baseUrl/pet/mypets";

  static const String getFavPets = "$baseUrl/pet/getFavPet";
  static const String removePetFromFav = "$baseUrl/pet/removeToFav";
  static const String addPetToFav = "$baseUrl/pet/addToFav";

  static const String createRequest = "$baseUrl/request/create";
  static const String requestsReceived = "$baseUrl/request/requestsReceived";
  static const String requestsMade = "$baseUrl/request/requestsMade";
  static const String requestsByPetId = "$baseUrl/request/requestsByPetId";
  static const String updateRequest = "$baseUrl/request/update";
  static const String deleteRequest = "$baseUrl/request/delete";


}