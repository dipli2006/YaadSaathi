import 'api_client.dart';

class LinkedPatientProfile {
  const LinkedPatientProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    this.conditionNotes,
  });

  final int id;
  final int userId;
  final String name;
  final int age;
  final String? conditionNotes;

  factory LinkedPatientProfile.fromJson(Map<String, dynamic> json) {
    return LinkedPatientProfile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      conditionNotes: json['condition_notes'] as String?,
    );
  }
}

class LinkedPatientDetail {
  const LinkedPatientDetail({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
    this.profile,
  });

  final int id;
  final String email;
  final String role;
  final String createdAt;
  final LinkedPatientProfile? profile;

  factory LinkedPatientDetail.fromJson(Map<String, dynamic> json) {
    return LinkedPatientDetail(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      createdAt: json['created_at'] as String,
      profile: json['profile'] != null
          ? LinkedPatientProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CaregiverService {
  CaregiverService._();

  static Future<List<LinkedPatientDetail>> getLinkedPatients() async {
    try {
      final response = await ApiClient.get('/api/v1/caregiver/patients');
      if (response is List) {
        return response
            .map((item) => LinkedPatientDetail.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> linkPatient(String patientEmail) async {
    try {
      await ApiClient.post('/api/v1/caregiver/link', {
        'patient_email': patientEmail,
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
