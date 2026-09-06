enum AssistantIntent {
  personLookup,
  memoryLookup,
  reminderLookup,
  generalConversation,
  unknown,
}

extension AssistantIntentLabel on AssistantIntent {
  String get wireValue {
    switch (this) {
      case AssistantIntent.personLookup:
        return 'PERSON_LOOKUP';
      case AssistantIntent.memoryLookup:
        return 'MEMORY_LOOKUP';
      case AssistantIntent.reminderLookup:
        return 'REMINDER_LOOKUP';
      case AssistantIntent.generalConversation:
        return 'GENERAL_CONVERSATION';
      case AssistantIntent.unknown:
        return 'UNKNOWN';
    }
  }
}

class TrustedMemory {
  const TrustedMemory({
    required this.subject,
    required this.detail,
    required this.kind,
  });

  final String subject;
  final String detail;
  final String kind;
}

class AssistantRequest {
  const AssistantRequest({required this.message, required this.languageCode});

  final String message;
  final String languageCode;
}

class AssistantResponse {
  const AssistantResponse({
    required this.reply,
    required this.intent,
    this.isSafe = true,
  });

  final String reply;
  final AssistantIntent intent;
  final bool isSafe;
}