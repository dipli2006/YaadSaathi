import 'api_client.dart';

class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.patientId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final int id;
  final int patientId;
  final String title;
  final String content;
  final String createdAt;

  factory MemoryItem.fromJson(Map<String, dynamic> json) {
    return MemoryItem(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}

class MemoryService {
  MemoryService._();

  static Future<List<MemoryItem>> getMyMemories() async {
    final response = await ApiClient.get('/api/v1/memories/me');
    if (response is List) {
      return response
          .map((item) => MemoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const ApiException(502, 'The memories service returned an invalid response.');
  }

  static Future<MemoryItem> createMemory({
    required String title,
    required String content,
  }) async {
    final response = await ApiClient.post('/api/v1/memories', {
      'title': title,
      'content': content,
    });
    return MemoryItem.fromJson(response as Map<String, dynamic>);
  }

  static Future<List<MemoryItem>> getPatientMemories(int patientId) async {
    final response = await ApiClient.get('/api/v1/memories/patient/$patientId');
    if (response is List) {
      return response
          .map((item) => MemoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const ApiException(502, 'The memories service returned an invalid response.');
  }
}
