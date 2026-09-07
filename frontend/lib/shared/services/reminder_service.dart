import 'api_client.dart';

class ReminderItem {
  const ReminderItem({
    required this.id,
    required this.patientId,
    required this.text,
    required this.scheduledTime,
    required this.createdBy,
    required this.isCompleted,
  });

  final int id;
  final int patientId;
  final String text;
  final String scheduledTime;
  final int createdBy;
  final bool isCompleted;

  factory ReminderItem.fromJson(Map<String, dynamic> json) {
    return ReminderItem(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      text: json['text'] as String,
      scheduledTime: json['scheduled_time'] as String,
      createdBy: json['created_by'] as int,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  ReminderItem copyWith({bool? isCompleted}) {
    return ReminderItem(
      id: id,
      patientId: patientId,
      text: text,
      scheduledTime: scheduledTime,
      createdBy: createdBy,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ReminderService {
  ReminderService._();

  static Future<List<ReminderItem>> getMyReminders() async {
    try {
      final response = await ApiClient.get('/api/v1/reminders/me');
      if (response is List) {
        return response
            .map((item) => ReminderItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback to default reminders if unauthenticated/demo
    }
    return defaultFallbackReminders;
  }

  static Future<ReminderItem> createReminder({
    required int patientId,
    required String text,
    required DateTime scheduledTime,
  }) async {
    final response = await ApiClient.post('/api/v1/reminders', {
      'patient_id': patientId,
      'text': text,
      'scheduled_time': scheduledTime.toUtc().toIso8601String(),
    });
    return ReminderItem.fromJson(response as Map<String, dynamic>);
  }

  static Future<ReminderItem?> completeReminder(int id) async {
    try {
      final response = await ApiClient.patch('/api/v1/reminders/$id/complete');
      if (response is Map<String, dynamic>) {
        return ReminderItem.fromJson(response);
      }
    } catch (_) {}
    return null;
  }
}

const defaultFallbackReminders = [
  ReminderItem(
    id: 1,
    patientId: 1,
    text: 'Morning medicine',
    scheduledTime: '2026-09-07T09:00:00Z',
    createdBy: 1,
    isCompleted: false,
  ),
  ReminderItem(
    id: 2,
    patientId: 1,
    text: 'Call family',
    scheduledTime: '2026-09-07T18:00:00Z',
    createdBy: 1,
    isCompleted: false,
  ),
];
