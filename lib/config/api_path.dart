abstract class ApiPath{

  // static const String _baseUrl = "http://192.168.43.138:8000";
  static const String _baseUrl = "https://adopt-us-backend.vercel.app";
  //Auth
  static const String signIn = "$_baseUrl/auth/signin";
  static const String signUp = "$_baseUrl/auth/signup";
  static const String resetPassword = "$_baseUrl/auth/resetPassword";

  static const String getProfile = "$_baseUrl/user/getProfile";
  static const String updateProfile = "$_baseUrl/user/updateProfile";

  static const String createPet = "$_baseUrl/pet/create";
  static const String editPet = "$_baseUrl/pet/edit";
  static const String getAllPets = "$_baseUrl/pet/getAllPets";
  static const String getPetByStatus = "$_baseUrl/pet/getPets";
  static const String myPets = "$_baseUrl/pet/mypets";

  static const String createRequest = "$_baseUrl/request/create";
  static const String requestsReceived = "$_baseUrl/request/requestsReceived";
  static const String requestsMade = "$_baseUrl/request/requestsMade";


}