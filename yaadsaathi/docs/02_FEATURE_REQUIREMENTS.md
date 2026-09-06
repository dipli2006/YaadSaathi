# YaadSaathi — Feature Requirements

## 1. Requirement Priority
- MUST — required for the current MVP
- SHOULD — desirable if time permits
- FUTURE — explicitly deferred

## 2. User Roles
### Elderly User
The elderly user can use the system from their own device.

### Caregiver
The caregiver uses a separate device and authenticated account.

The backend controls the relationship and access permissions between caregivers and elderly users.

## 3. Elderly User Requirements
The system MUST provide:
- simple home screen
- accessible navigation
- cognitive games
- memories
- family information
- reminders
- AI assistant
- English and Hindi
- voice support
- persistent/trusted session behavior

The system MUST NOT display:
- marks
- rankings
- failure-oriented scoring
- game history as a user-facing feature

## 4. Game Requirements
MUST support:
1. Memory Match
2. Remember the Objects
3. Sequence
4. Object/Word Association

Game results may be stored internally.

Difficulty MUST be controlled by a rule-based engine for the current MVP.

ML-based difficulty modification is FUTURE.

## 5. Adaptive Difficulty Requirements
Initial rules:
- >80% success → increase
- 50–80% → same
- <50% → decrease

Difficulty:
- EASY
- MEDIUM
- HARD

Boundaries MUST be respected.

No ML model is required for MVP difficulty adaptation.

## 6. Memory Requirements
The system MUST support:
- create
- retrieve
- update
- delete where authorized
- search/retrieval
- controlled access

The system MUST NOT fabricate personal memories.

## 7. Family Requirements
Family records may contain:
- name
- relationship
- photo
- optional information

Only authorized users may manage/access protected records.

## 8. Reminder Requirements
MUST support:
- create
- retrieve
- update
- delete
- scheduling
- notification integration

Notification providers should be abstracted.

## 9. AI Assistant Requirements
The assistant MUST support controlled intents:
- PERSON_LOOKUP
- MEMORY_LOOKUP
- REMINDER_LOOKUP
- GENERAL_CONVERSATION
- UNKNOWN

Personal facts MUST be grounded in stored application data.

## 10. AI Safety Requirements
The assistant MUST NOT:
- diagnose
- promise a cure
- fabricate facts
- fabricate memories
- fabricate relationships
- give unsafe medical instructions
- reveal unnecessary private information

## 11. Language Requirements
Current MVP languages:
- English
- Hindi

Bengali and Assamese are FUTURE.

Language handling should be separated from core business logic.

## 12. Voice Requirements
MUST support:
Speech → STT → AI Assistant → TTS → Speech

Text fallback MUST remain available.

## 13. Authentication and Authorization
MUST provide:
- separate elderly/caregiver accounts
- separate sessions
- backend authorization
- protected API endpoints
- secure persistent elderly session behavior

## 14. Data and Privacy
Sensitive information includes:
- names
- relationships
- photos
- memories
- reminders
- caregiver information
- authentication/session information

The backend MUST enforce access control.

## 15. Architecture Requirements
- Flutter clients
- FastAPI backend
- PostgreSQL database
- service-layer business logic
- repository/data-access separation
- external provider abstractions

Frontend MUST NOT directly access PostgreSQL.

## 16. AI/ML Requirements
Current MVP:
- rule-based adaptive difficulty
- controlled AI assistant
- provider abstraction

Future:
- ML-based adaptive difficulty
- advanced personalization

## 17. RAG Requirements
RAG is NOT required for MVP.

It may be evaluated only after the core system is complete and if there is a clear use case.

## 18. Non-Functional Requirements
The system SHOULD prioritize:
- usability
- reliability
- security
- privacy
- maintainability
- testability
- modularity
- low coupling

## 19. MVP Acceptance Criteria
The MVP is acceptable when:
- elderly and caregiver clients work independently
- core games work
- rule-based adaptation works
- memories work
- family information works
- reminders work
- AI assistant works safely
- English and Hindi work
- voice works or has a text fallback
- authentication/authorization works
- sensitive data is protected

## 20. Out of Scope for Current MVP
- ML-based difficulty modification
- RAG
- Bengali
- Assamese
- advanced analytics
- advanced personalization unless separately approved

## 21. Requirement Change Policy
Requirement changes should be documented and reflected in affected architecture/API/database documents.

> Build the smallest reliable feature that satisfies the requirement.
