class TrustedSessionService {
  TrustedSessionService._();

  static bool _isRestored = false;

  static bool get isRestored => _isRestored;

  static Future<void> restore() async {
    // Replace this local seam with persisted session/API restoration in CP-2.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _isRestored = true;
  }
}