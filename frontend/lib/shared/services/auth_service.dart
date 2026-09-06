class AuthService {
  AuthService._();

  static String? _name;
  static String? _email;
  static String? _password;

  static Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (_email != null) {
      return false;
    }
    _name = name.trim();
    _email = email.trim().toLowerCase();
    _password = password;
    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _email == email.trim().toLowerCase() && _password == password;
  }

  static String get caregiverName => _name ?? 'Caregiver';
}