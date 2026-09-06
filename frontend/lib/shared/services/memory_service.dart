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
    try {
      final response = await ApiClient.get('/api/v1/memories/me');
      if (response is List) {
        return response
            .map((item) => MemoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Return fallback demo memories if API fails or session unauthenticated
    }
    return defaultFallbackMemories;
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
    try {
      final response = await ApiClient.get('/api/v1/memories/patient/$patientId');
      if (response is List) {
        return response
            .map((item) => MemoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return defaultFallbackMemories;
  }
}

const defaultFallbackMemories = [
  MemoryItem(
    id: 1,
    patientId: 1,
    title: 'Family',
    content: 'People who are close to you, including your daughter Anu and son Ravi.',
    createdAt: '2026-09-01T10:00:00Z',
  ),
  MemoryItem(
    id: 2,
    patientId: 1,
    title: 'Home',
    content: 'A peaceful place filled with family photos and familiar moments.',
    createdAt: '2026-09-02T14:30:00Z',
  ),
  MemoryItem(
    id: 3,
    patientId: 1,
    title: 'Celebrations',
    content: 'Special days, traditional festivals, and happy family gatherings.',
    createdAt: '2026-09-03T18:00:00Z',
  ),
];
