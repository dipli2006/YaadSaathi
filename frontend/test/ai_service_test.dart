import 'package:flutter_test/flutter_test.dart';
import 'package:yaadsaathi_app/features/assistant/models/assistant_models.dart';
import 'package:yaadsaathi_app/features/assistant/services/ai_service.dart';

void main() {
  final service = MockAIService();

  test('routes a trusted person lookup and never invents unknown people', () async {
    final known = await service.respond(
      const AssistantRequest(message: 'Who is Ravi?', languageCode: 'en'),
    );
    final unknown = await service.respond(
      const AssistantRequest(message: 'Who is Meera?', languageCode: 'en'),
    );

    expect(known.intent, AssistantIntent.personLookup);
    expect(known.reply, 'Ravi is your son.');
    expect(unknown.reply, "I don't have that information.");
  });

  test('retrieves reminders from trusted structured data', () async {
    final response = await service.respond(
      const AssistantRequest(message: 'What is my next reminder?', languageCode: 'en'),
    );

    expect(response.intent, AssistantIntent.reminderLookup);
    expect(response.reply, contains('Morning medicine'));
  });

  test('returns Hindi responses when Hindi is selected', () async {
    final response = await service.respond(
      const AssistantRequest(message: 'नमस्ते', languageCode: 'hi'),
    );

    expect(response.intent, AssistantIntent.generalConversation);
    expect(response.reply, contains('यह बहुत अच्छा है'));
  });

  test('blocks unsafe medical and diagnosis requests', () async {
    final response = await service.respond(
      const AssistantRequest(message: 'Can you diagnose dementia?', languageCode: 'en'),
    );

    expect(response.isSafe, isTrue);
    expect(response.reply, contains('medical advice'));
  });

  test('handles empty and unknown messages safely', () async {
    final empty = await service.respond(
      const AssistantRequest(message: '  ', languageCode: 'en'),
    );
    final unknown = await service.respond(
      const AssistantRequest(message: 'Tell me the weather on Mars', languageCode: 'en'),
    );

    expect(empty.intent, AssistantIntent.unknown);
    expect(unknown.intent, AssistantIntent.unknown);
  });
}