# Implementation Status

This file tracks the frontend slices published to `main`. A task is marked Done only after implementation and local validation. Backend integration and device QA remain separate checkpoints.

## Published

| Area | Status | Commit |
| --- | --- | --- |
| Flutter foundation, theme, route skeleton | Done | `bb77d02` |
| Caregiver and elderly entry flows | Done | `5cca872` |
| Reusable game metadata and session flow | Done | `f7502f3` |
| Memory Match | Done | `a8e8b8f` |
| Remember Objects and Sequence | Done | `80d23b8` |
| Elderly memories, reminders, and talk surfaces | Done | `9b8ef67` |
| English/Hindi localization framework | Done | `3cd630c` |
| Responsive caregiver dashboard | Done | `74ea0c5` |
| AI service abstraction, intent routing, trusted retrieval, and safety mock | Testing | pending commit |
| Linked caregiver + patient onboarding | Testing | `ebf9dbc` |

## Current limitations

- One signup now captures patient name, caregiver identity, relationship, caregiver email, and caregiver password. It creates a linked caregiver credential account and patient trusted-session profile in the frontend demo; FastAPI/PostgreSQL persistence is still pending.
- Game completion data is not yet submitted to a backend.
- Memory photos, reminder CRUD, adaptive recommendations, and assistant backend responses are still pending integration.
- The AI frontend currently uses a tested `MockAIService`; it is designed to be replaced by the `/assistant/message` API without changing Talk UI.
- AI language coverage currently follows the MVP decision: English and Hindi. Bengali and Assamese remain future provider-dependent work.
- RAG is intentionally not implemented because the required product features are not yet fully integrated and stable.
- The microphone control currently exposes listening state only; platform permission and speech services are pending.
- Full multilingual translation beyond the language-selection framework is pending.

## Validation

Run from `frontend/`:

```text
flutter analyze
flutter test
```

Both checks pass for the published slices.
