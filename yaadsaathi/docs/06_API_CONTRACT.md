# YaadSaathi — API Contract

## 1. Purpose
This document defines the communication boundary between the elderly/caregiver clients and the FastAPI backend.

## 2. Base Principles
- JSON request/response by default
- authentication on protected endpoints
- authorization on protected resources
- consistent error format
- no direct database access from clients
- API contracts should remain stable once consumed

## 3. Example Base Path
```text
/api/v1
```

The exact deployment URL is environment-specific.

## 4. Authentication Endpoints
```text
POST /auth/login
POST /auth/setup
POST /auth/logout
GET  /auth/me
```

Exact fields depend on the final authentication mechanism.

## 5. User Endpoints
```text
GET /users/me
PATCH /users/me
GET /users/{user_id}
```

Protected by authentication and authorization.

## 6. Caregiver Relationship Endpoints
```text
GET /caregiver/elderly-users
GET /caregiver/elderly-users/{elderly_user_id}
```

The backend MUST verify the caregiver relationship.

## 7. Game Endpoints
```text
GET  /games
POST /games/sessions
GET  /games/sessions/{session_id}
POST /games/sessions/{session_id}/result
```

Game result responses should not expose competitive scoring to the elderly client.

## 8. Adaptive Difficulty
Difficulty is determined server-side.

Conceptual operation:
```text
POST /games/sessions/{session_id}/result
        ↓
Game Service
        ↓
Rule-Based Difficulty Engine
```

No ML endpoint is required for current MVP difficulty modification.

## 9. Memory Endpoints
```text
GET    /memories
POST   /memories
GET    /memories/{memory_id}
PATCH  /memories/{memory_id}
DELETE /memories/{memory_id}
```

Authorization is required.

## 10. Family Endpoints
```text
GET    /family-members
POST   /family-members
GET    /family-members/{id}
PATCH  /family-members/{id}
DELETE /family-members/{id}
```

## 11. Reminder Endpoints
```text
GET    /reminders
POST   /reminders
GET    /reminders/{id}
PATCH  /reminders/{id}
DELETE /reminders/{id}
```

## 12. AI Assistant Endpoint
```text
POST /assistant/message
```

Request concept:
```json
{
  "message": "Who is Ravi?",
  "language": "en"
}
```

Response concept:
```json
{
  "reply": "Ravi is your son.",
  "intent": "PERSON_LOOKUP"
}
```

Personal facts must be grounded in stored data.

## 13. Voice Endpoints
Possible abstraction:
```text
POST /voice/transcribe
POST /voice/synthesize
```

Exact provider and transport may be finalized later.

## 14. Language
Current supported values:
- `en`
- `hi`

Unsupported languages should produce a clear validation response.

## 15. Error Format
Preferred:
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested information could not be found."
  }
}
```

Do not expose stack traces or sensitive internals.

## 16. HTTP Status Guidance
- 200 — successful retrieval/update
- 201 — created
- 204 — successful deletion where appropriate
- 400 — invalid request
- 401 — unauthenticated
- 403 — unauthorized
- 404 — not found
- 409 — conflict
- 422 — validation error
- 500 — unexpected server error

## 17. Authorization Principle
Every protected endpoint must check:
```text
authenticated user
+
resource ownership/relationship
+
requested action
```

## 18. API Versioning
Use versioned API paths so future changes do not unnecessarily break clients.

## 19. Mock API Principle
Frontend developers may implement against mock responses matching this contract.

## 20. Current MVP Boundaries
The API does not require:
- ML model endpoints
- RAG retrieval endpoints
- Bengali/Assamese language endpoints

> The API contract is the agreement that lets frontend and backend teams work independently.
