class StringUtils {
  static bool isNullOrEmpty(String? input) {
    return input != null && input.isNotEmpty;
  }

  static bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool isValidMobileNumber(String mobileNumber) {
    final RegExp regex = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$');
    return regex.hasMatch(mobileNumber);
  }
}
