# YaadSaathi — AI Assistant

## 1. Purpose
The AI Assistant provides simple conversational support while remaining controlled, safe, and grounded in application data.

## 2. Current Scope
The MVP supports:
- person lookup
- memory lookup
- reminder lookup
- general conversation
- unknown requests
- English
- Hindi

## 3. Intent Categories
```text
PERSON_LOOKUP
MEMORY_LOOKUP
REMINDER_LOOKUP
GENERAL_CONVERSATION
UNKNOWN
```

## 4. Architecture
```text
User Input
 ↓
Input Processing
 ↓
Intent Detection
 ↓
Relevant Service
 ↓
Response Builder
 ↓
Safety Validation
 ↓
Response
```

## 5. Personal Information
For personal facts:
```text
Application Data = Source of Truth
AI = Explanation Layer
```

Example:
```text
Stored:
Ravi — Son

Response:
"Ravi is your son."
```

If absent:
```text
"I don't have that information."
```

## 6. AI Provider Abstraction
The frontend now defines a swappable `AIService` interface. `MockAIService` implements the MVP contract while the backend is being integrated. The Talk screen depends on the interface, not on a model or provider.

The replacement provider must accept:
```text
AssistantRequest(message, languageCode)
```

and return:
```text
AssistantResponse(reply, intent, isSafe)
```

This keeps provider changes isolated from the user experience.

## 7. General Conversation
General conversation should remain:
- simple
- respectful
- supportive
- non-diagnostic

## 8. Safety
The assistant must not:
- diagnose dementia
- promise cures
- fabricate memories
- fabricate relationships
- fabricate events
- provide unsafe medical instructions
- unnecessarily reveal private information

## 9. Medical Questions
For medical questions beyond the safe application scope, the assistant should avoid diagnosis and unsafe instructions and encourage appropriate professional/caregiver support where suitable.

## 10. Language
Current supported languages:
- English
- Hindi

## 11. Voice
Voice is an interface layer:
```text
Speech → STT → Assistant → TTS → Speech
```

Text remains a fallback.

## 12. RAG
RAG is NOT implemented in the current MVP.

Do not add a retrieval/vector dependency unless the project scope explicitly changes.

## 13. Testing
Test:
- each intent
- missing information
- unauthorized information
- unsafe questions
- unsupported language
- provider failures
- empty input

The frontend currently tests known and unknown person lookup, reminder retrieval, Hindi responses, unsafe medical/diagnosis requests, and empty/unknown input in `frontend/test/ai_service_test.dart`.

> The assistant should be helpful without pretending to know what it does not know.
