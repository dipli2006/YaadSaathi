# YaadSaathi — Multilingual System

## 1. Current Scope
The current MVP supports exactly two languages:
- English
- Hindi

Bengali and Assamese are future possibilities and are not current implementation requirements.

## 2. Design Goal
Language should be changeable without rewriting business logic.

## 3. Architecture
```text
UI / User Input
      ↓
Language Selection
      ↓
Language Service
      ↓
Localized Text / AI Interaction
```

## 4. Language Codes
Recommended:
```text
en = English
hi = Hindi
```

## 5. UI Localization
UI strings should be stored separately from business logic.

Avoid hardcoding user-facing text throughout application code.

## 6. Game Localization
Game logic should remain language-independent.

Only:
- instructions
- labels
- prompts
- content
should be localized.

## 7. AI Language
The assistant should respond in the selected supported language where possible.

## 8. Voice
Voice processing should use the selected language where the chosen provider supports it.

## 9. Unsupported Languages
If a future/unsupported language is requested:
- show a simple fallback
- use a supported language
- do not silently provide incorrect localization

## 10. Testing
Test:
- language selection
- persistence
- UI strings
- games
- assistant responses
- voice flows
- fallback behavior

> For the current MVP: English + Hindi only.
