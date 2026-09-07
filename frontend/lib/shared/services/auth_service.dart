import 'api_client.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  final int id;
  final String email;
  final String role;
  final String createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}

class AuthService {
  AuthService._();

  static UserProfile? _currentUser;
  static LinkedCareRelationship? _relationship;

  static UserProfile? get currentUser => _currentUser;
  static bool get isAuthenticated => _currentUser != null || ApiClient.hasSession;
  static bool get hasLinkedAccounts => _relationship != null;
  static LinkedCareRelationship? get relationship => _relationship;

  static Future<bool> signUp({
    required String caregiverName,
    required String caregiverEmail,
    required String caregiverPassword,
    required String patientName,
    required String relationship,
  }) async {
    final cleanCaregiverEmail = caregiverEmail.trim().toLowerCase();
    final cleanPatientName = patientName.trim();
    final sanitizedPatientName = cleanPatientName.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    final patientKey = cleanCaregiverEmail.hashCode.abs();
    final patientEmail = '$sanitizedPatientName.$patientKey@yaadsaathi.com';
    final patientPassword = 'PatientPass123!';

    try {
      await ApiClient.post('/api/v1/auth/register', {
        'email': cleanCaregiverEmail,
        'password': caregiverPassword,
        'role': 'caregiver',
      });

      await ApiClient.post('/api/v1/auth/register', {
        'email': patientEmail,
        'password': patientPassword,
        'role': 'patient',
      });

      // 3. Log in as caregiver
      final loginResp = await ApiClient.post('/api/v1/auth/login', {
        'email': cleanCaregiverEmail,
        'password': caregiverPassword,
      });

      if (loginResp is Map && loginResp.containsKey('access_token')) {
        ApiClient.setCookie('access_token=Bearer ${loginResp['access_token']}');
      }

      // 4. Fetch current caregiver profile
      final meResp = await ApiClient.get('/api/v1/users/me');
      if (meResp is Map<String, dynamic>) {
        _currentUser = UserProfile.fromJson(meResp);
      }

      await ApiClient.post('/api/v1/caregiver/link', {
        'patient_email': patientEmail,
        'relationship_type': relationship.trim(),
      });

      _relationship = LinkedCareRelationship(
        caregiverName: caregiverName.trim(),
        caregiverEmail: cleanCaregiverEmail,
        caregiverPassword: caregiverPassword,
        patientName: cleanPatientName,
        patientEmail: patientEmail,
        relationship: relationship.trim(),
      );

      return true;
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (error) {
      throw Exception('Could not create the linked accounts: $error');
    }
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    try {
      final resp = await ApiClient.post('/api/v1/auth/login', {
        'email': cleanEmail,
        'password': password,
      });

      if (resp is Map && resp.containsKey('access_token')) {
        ApiClient.setCookie('access_token=Bearer ${resp['access_token']}');
      }

      final meResp = await ApiClient.get('/api/v1/users/me');
      if (meResp is Map<String, dynamic>) {
        _currentUser = UserProfile.fromJson(meResp);
      }

      return true;
    } on ApiException catch (_) {
      // Invalid email or password returns false
      return false;
    } catch (error) {
      if (error is ApiException) {
        return false;
      }
      throw Exception('Could not reach the authentication server: $error');
    }
  }

  static Future<UserProfile?> fetchCurrentUser() async {
    try {
      final meResp = await ApiClient.get('/api/v1/users/me');
      if (meResp is Map<String, dynamic>) {
        _currentUser = UserProfile.fromJson(meResp);
        return _currentUser;
      }
    } catch (_) {
      _currentUser = null;
    }
    return null;
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post('/api/v1/auth/logout', {});
    } catch (_) {}
    ApiClient.clearCookie();
    _currentUser = null;
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
    required this.patientEmail,
    required this.relationship,
  });

  final String caregiverName;
  final String caregiverEmail;
  final String caregiverPassword;
  final String patientName;
  final String patientEmail;
  final String relationship;
}