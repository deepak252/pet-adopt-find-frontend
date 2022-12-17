abstract class ApiPath{

  // static const String _baseUrl = "http://192.168.43.138:8000";
  static const String _baseUrl = "https://adopt-us-backend.vercel.app";
  //Auth
  static const String signIn = "$_baseUrl/auth/signin";
  static const String signUp = "$_baseUrl/auth/signup";
  static const String resetPassword = "$_baseUrl/auth/resetPassword";

  static const String getProfile = "$_baseUrl/user/getProfile";
  static const String updateProfile = "$_baseUrl/user/updateProfile";

  static const String getAllPets = "$_baseUrl/pet/getAllPets";
  static const String createPet = "$_baseUrl/pet/create";

}