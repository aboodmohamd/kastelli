class Validators {
  static bool isName(String value) => value.trim().length >= 2;

  static bool isEmail(String value) =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$').hasMatch(value.trim());

  static bool isPhone(String value) =>
      RegExp(r'^\d{9,10}$').hasMatch(value.trim());

  static bool isDate(String value) => value.trim().isNotEmpty;
}
