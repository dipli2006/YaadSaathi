# YaadSaathi — Voice System

## 1. Purpose
Voice interaction helps elderly users interact with the assistant more naturally.

## 2. Pipeline
```text
Speech
  ↓
Speech-to-Text
  ↓
AI Assistant
  ↓
Response Text
  ↓
Text-to-Speech
  ↓
Speech
```

## 3. Components
- microphone/input layer
- STT adapter
- AI Assistant
- TTS adapter
- audio playback layer

## 4. Provider Abstraction
```text
Voice Service
   ↓
STT Interface → STT Provider
   ↓
TTS Interface → TTS Provider
```

Providers should be replaceable.

## 5. Languages
Current:
- English
- Hindi

## 6. Text Fallback
If voice fails or is unavailable:
```text
Voice Input
 ↓
Error
 ↓
Text Input
```

The user should still be able to use the assistant.

## 7. Error Handling
Do not expose provider/API errors directly to the elderly user.

Use simple messages such as:
"Please try again."

## 8. Privacy
Voice data should be handled according to the selected provider's capabilities and project privacy rules.

Do not store audio unnecessarily.

## 9. Testing
Test:
- successful transcription
- unsuccessful transcription
- empty speech
- language selection
- TTS failure
- network failure
- text fallback

> Voice should simplify interaction, not become a single point of failure.
