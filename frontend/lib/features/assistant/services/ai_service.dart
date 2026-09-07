import '../models/assistant_models.dart';
import '../../../shared/services/api_client.dart';

abstract interface class AIService {
  Future<AssistantResponse> respond(AssistantRequest request);
}

class ApiAIService implements AIService {
  @override
  Future<AssistantResponse> respond(AssistantRequest request) async {
    final response = await ApiClient.post('/api/v1/assistant/message', {
      'message': request.message,
      'language': request.languageCode,
    });
    if (response is! Map<String, dynamic>) {
      throw const ApiException(502, 'The assistant returned an invalid response.');
    }
    return AssistantResponse(
      reply: response['reply'] as String,
      intent: _intentFromWireValue(response['intent'] as String),
    );
  }

  AssistantIntent _intentFromWireValue(String value) {
    switch (value) {
      case 'PERSON_LOOKUP':
        return AssistantIntent.personLookup;
      case 'MEMORY_LOOKUP':
        return AssistantIntent.memoryLookup;
      case 'REMINDER_LOOKUP':
        return AssistantIntent.reminderLookup;
      case 'GENERAL_CONVERSATION':
        return AssistantIntent.generalConversation;
      default:
        return AssistantIntent.unknown;
    }
  }
}

class MockAIService implements AIService {
  MockAIService({List<TrustedMemory>? memories, List<TrustedMemory>? reminders})
      : _memories = memories ?? defaultTrustedMemories,
        _reminders = reminders ?? defaultTrustedReminders;

  final List<TrustedMemory> _memories;
  final List<TrustedMemory> _reminders;

  @override
  Future<AssistantResponse> respond(AssistantRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final message = request.message.trim();
    if (message.isEmpty) {
      return _response('Please tell me what you would like to know.', AssistantIntent.unknown);
    }

    if (_isUnsafe(message)) {
      return _response(
        _localized(
          request.languageCode,
          'I cannot give medical advice. Please speak with your caregiver or a qualified professional.',
          'मैं चिकित्सीय सलाह नहीं दे सकता। कृपया अपने देखभालकर्ता या योग्य चिकित्सक से बात करें।',
        ),
        AssistantIntent.unknown,
      );
    }

    final intent = _classify(message);
    switch (intent) {
      case AssistantIntent.personLookup:
      case AssistantIntent.memoryLookup:
        return _lookup(message, intent, request.languageCode);
      case AssistantIntent.reminderLookup:
        return _lookupReminder(request.languageCode);
      case AssistantIntent.generalConversation:
        return _response(
          _localized(
            request.languageCode,
            'That sounds lovely. I am here to listen and keep you company.',
            'यह बहुत अच्छा है। मैं आपकी बात सुनने और आपका साथ देने के लिए यहां हूं।',
          ),
          intent,
        );
      case AssistantIntent.unknown:
        return _response(
          _localized(
            request.languageCode,
            'I do not have that information yet. You can ask me about family, memories, or reminders.',
            'मेरे पास अभी यह जानकारी नहीं है। आप परिवार, यादों या रिमाइंडर के बारे में पूछ सकते हैं।',
          ),
          intent,
        );
    }
  }

  AssistantIntent _classify(String message) {
    final normalized = message.toLowerCase();
    if (_containsAny(normalized, ['reminder', 'remind', 'medicine', 'दवा', 'याद'])) {
      return AssistantIntent.reminderLookup;
    }
    if (_containsAny(normalized, ['who is', 'son', 'daughter', 'family', 'कौन', 'बेटा', 'बेटी'])) {
      return AssistantIntent.personLookup;
    }
    if (_containsAny(normalized, ['memory', 'remember', 'photo', 'याद', 'फोटो'])) {
      return AssistantIntent.memoryLookup;
    }
    if (_containsAny(normalized, ['hello', 'hi', 'happy', 'sad', 'hello', 'नमस्ते', 'कैसे'])) {
      return AssistantIntent.generalConversation;
    }
    return AssistantIntent.unknown;
  }

  AssistantResponse _lookup(String message, AssistantIntent intent, String languageCode) {
    final normalized = message.toLowerCase();
    final match = [..._memories].cast<TrustedMemory?>().firstWhere(
          (memory) => memory != null && normalized.contains(memory.subject.toLowerCase()),
          orElse: () => null,
        );
    if (match == null) {
      return _response(
        _localized(languageCode, "I don't have that information.", 'मेरे पास यह जानकारी नहीं है।'),
        intent,
      );
    }
    return _response(
      languageCode == 'hi'
          ? '${match.subject} ${match.detail}।'
          : '${match.subject} ${match.detail}.',
      intent,
    );
  }

  AssistantResponse _lookupReminder(String languageCode) {
    if (_reminders.isEmpty) {
      return _response(
        _localized(languageCode, 'You have no reminders right now.', 'अभी कोई रिमाइंडर नहीं है।'),
        AssistantIntent.reminderLookup,
      );
    }
    final reminder = _reminders.first;
    return _response(
      languageCode == 'hi'
          ? 'आपका अगला रिमाइंडर: ${reminder.subject}, ${reminder.detail}।'
          : 'Your next reminder is ${reminder.subject}, ${reminder.detail}.',
      AssistantIntent.reminderLookup,
    );
  }

  AssistantResponse _response(String reply, AssistantIntent intent) {
    return AssistantResponse(reply: reply, intent: intent);
  }

  bool _isUnsafe(String message) {
    return _containsAny(message.toLowerCase(), [
      'diagnose',
      'dementia',
      'cure',
      'medicine dose',
      'suicide',
      'आत्महत्या',
      'इलाज',
    ]);
  }

  bool _containsAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }

  String _localized(String languageCode, String english, String hindi) {
    return languageCode == 'hi' ? hindi : english;
  }
}

const defaultTrustedMemories = [
  TrustedMemory(subject: 'Ravi', detail: 'is your son', kind: 'person'),
  TrustedMemory(subject: 'Anu', detail: 'is your daughter', kind: 'person'),
  TrustedMemory(subject: 'tea garden', detail: 'is a place in your family memories', kind: 'place'),
];

const defaultTrustedReminders = [
  TrustedMemory(subject: 'Morning medicine', detail: 'at 9:00 AM', kind: 'reminder'),
];