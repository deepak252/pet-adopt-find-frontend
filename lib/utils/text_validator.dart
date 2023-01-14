class TextValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim() == '') return 'Name is required';

    // RegExp regex = RegExp(r"[a-zA-Z]");
    // if (!regex.hasMatch(value))
    //   return 'Invalid name';
    // else
      
    return null;
  }

  static String? requiredText(String? value) {
    if (value == null || value.trim() == '') return 'This field is required';
    return null;
  }


  static String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == '' || value == null) return 'Email is required';
    
    return !regex.hasMatch(value) ? 'Invalid Email' : null;
  }

  static String? validatePhoneNumber(String? value) {
    String pattern = r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$";

    RegExp regex = RegExp(pattern);
    if (value == '' || value == null) return 'Phone number is required';

    return !regex.hasMatch(value) ? 'Invalid phone number' : null;
  }
  

  static String? validatePassword(String? value) {
    if (value == '' || value == null) return 'Enter password';
    return value.length<6 ?  'Password must contain at least 6 character' : null;
  }

  static String? validateConfirmPassword( String? confirmPassword, String? password) {
    return confirmPassword != password ? 'Password not match' : null;
  }

}