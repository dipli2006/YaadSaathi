class AuthService {
  AuthService._();

  static LinkedCareRelationship? _relationship;

  static bool get hasLinkedAccounts => _relationship != null;

  static LinkedCareRelationship? get relationship => _relationship;

  static Future<bool> signUp({
    required String caregiverName,
    required String caregiverEmail,
    required String caregiverPassword,
    required String patientName,
    required String relationship,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (_relationship != null) {
      return false;
    }
    _relationship = LinkedCareRelationship(
      caregiverName: caregiverName.trim(),
      caregiverEmail: caregiverEmail.trim().toLowerCase(),
      caregiverPassword: caregiverPassword,
      patientName: patientName.trim(),
      relationship: relationship.trim(),
    );
    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _relationship?.caregiverEmail == email.trim().toLowerCase() &&
        _relationship?.caregiverPassword == password;
  }

  static String get caregiverName => _relationship?.caregiverName ?? 'Caregiver';

  static String get patientName => _relationship?.patientName ?? 'your loved one';

  static String get patientRelationship => _relationship?.relationship ?? 'family member';
}

class LinkedCareRelationship {
  const LinkedCareRelationship({
    required this.caregiverName,
    required this.caregiverEmail,
    required this.caregiverPassword,
    required this.patientName,
    required this.relationship,
  });

  final String caregiverName;
  final String caregiverEmail;
  final String caregiverPassword;
  final String patientName;
  final String relationship;
}