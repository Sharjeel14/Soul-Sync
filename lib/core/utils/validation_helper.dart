class ValidationHelper {
  const ValidationHelper._();

  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');

  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 6;
  }

  static bool isValidName(String? name) {
    if (name == null || name.isEmpty) return false;
    return name.trim().isNotEmpty;
  }

  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    return phoneRegExp.hasMatch(phone);
  }

  static bool isValidNonEmptyString(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

extension StringValidation on String? {
  bool get isValidEmail => ValidationHelper.isValidEmail(this);

  bool get isValidPassword => ValidationHelper.isValidPassword(this);

  bool get isValidName => ValidationHelper.isValidName(this);

  bool get isValidPhone => ValidationHelper.isValidPhone(this);

  bool get isValidNonEmptyString =>
      ValidationHelper.isValidNonEmptyString(this);
}
