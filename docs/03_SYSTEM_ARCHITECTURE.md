# YaadSaathi — System Architecture

## 1. Purpose
This document defines the technical architecture of YaadSaathi and the boundaries between its clients, backend services, database, AI services, voice services, and future extension points.

## 2. Architecture Goals
1. Simple for elderly users
2. Useful for caregivers
3. Modular for developers
4. Easy to test
5. Easy to extend
6. Secure by default
7. Privacy-aware
8. Independent team development
9. Low coupling
10. Rule-based intelligence for MVP
11. Future-ready without making future features mandatory

## 3. High-Level Architecture

```text
                         YAADSAATHI SYSTEM
                                |
                 +--------------+--------------+
                 |                             |
                 v                             v
        Elderly User Device             Caregiver Device
        Flutter Application             Caregiver Application
                 |                             |
                 +-------------+---------------+
                               |
                         Internet/Network
                               |
                               v
                         FastAPI Backend
                               |
        +----------------------+----------------------+
        |                      |                      |
        v                      v                      v
   Core Services         AI Services            Security
        |                      |                      |
        +----------------------+----------------------+
                               |
                               v
                           PostgreSQL
```

The elderly user and caregiver use separate devices, accounts, and sessions. They communicate through the backend, not directly with each other.

## 4. Client Architecture
### Elderly Client
Responsible for:
- simple UI
- games
- memories
- family information
- reminders
- AI assistant
- language selection
- voice interaction
- persistent session

### Caregiver Client
Responsible for:
- caregiver authentication
- authorized elderly-user access
- memory management
- family information management
- reminders
- permitted activity information
- supported settings

## 5. User Relationship
```text
Caregiver Account
       |
       | authorized relationship
       v
Elderly User Account
```

The relationship is stored and checked by the backend.

## 6. Layered Architecture
```text
Presentation
    ↓
API
    ↓
Services
    ↓
AI/Intelligence where needed
    ↓
Repositories
    ↓
PostgreSQL
```

## 7. API Layer
Technology: Python + FastAPI.

Responsibilities:
- request handling
- validation
- authentication
- authorization
- service invocation
- response formatting
- error handling

Route handlers should remain thin.

## 8. Backend Services
Recommended services:
- Authentication Service
- User/Profile Service
- Caregiver Service
- Game Service
- Adaptive Difficulty Service
- Memory Service
- Family Service
- Reminder Service
- AI Assistant Service
- Language Service
- Voice Service

## 9. Authentication
The elderly user and caregiver authenticate independently.

The exact session/token mechanism can be finalized in the security implementation.

The elderly experience should minimize repeated password entry while maintaining security.

## 10. Authorization
Authorization is enforced by the backend.

Before protected data is returned:
1. identify requester
2. identify requested resource
3. identify owner
4. verify relationship/permission

Frontend-only authorization is insufficient.

## 11. Game Service
Initial games:
- Memory Match
- Remember the Objects
- Sequence
- Object/Word Association

The service manages game sessions, configuration, result validation, internal performance storage, and communication with the adaptive engine.

The elderly UI must not expose marks or rankings.

## 12. Adaptive Difficulty
Current MVP implementation:

```text
Game Performance
      ↓
Rule-Based Difficulty Engine
      ↓
Next Difficulty
```

Rules:
- >80% → increase
- 50–80% → same
- <50% → decrease

Levels:
- EASY
- MEDIUM
- HARD

ML-based difficulty modification is NOT implemented in the current version.

## 13. Future ML Extension
Future architecture may replace the internal rule engine with an ML engine without changing the Game Service interface.

Conceptual interface:
```text
get_next_difficulty(performance_data)
```

Possible implementations:
- RuleBasedDifficultyEngine — current
- MLDifficultyEngine — future

## 14. Memory Service
Responsible for:
- create
- retrieve
- update
- delete where authorized
- search
- access control

Stored personal information is the source of truth.

## 15. Family Service
Manages:
- name
- relationship
- photo
- optional information

The AI assistant may request family information through the service but must not invent relationships.

## 16. Reminder Service
Responsible for:
- create
- retrieve
- update
- delete
- scheduling
- notification integration

Notification providers should be abstracted.

## 17. AI Assistant
Controlled intents:
- PERSON_LOOKUP
- MEMORY_LOOKUP
- REMINDER_LOOKUP
- GENERAL_CONVERSATION
- UNKNOWN

Architecture:
```text
User Input
   ↓
Intent Detection
   ↓
Relevant Service Lookup
   ↓
Response Builder
   ↓
Safety Validation
   ↓
Response
```

The database/application services are the source of truth for personal facts.

## 18. AI Provider Abstraction
```text
AI Assistant Service
        ↓
AI Provider Interface
        ↓
External AI Provider
```

This enables provider replacement and mocking.

## 19. Language Service
Current languages:
- English
- Hindi

Bengali and Assamese are future extensions.

Language handling should remain separate from business logic.

## 20. Voice Service
```text
Speech
  ↓
Speech-to-Text
  ↓
AI Assistant
  ↓
Text-to-Speech
  ↓
Speech
```

Text input/output is always available as a fallback.

## 21. RAG
RAG is NOT implemented in the current MVP.

If introduced later:
```text
User Query
   ↓
AI Assistant
   ↓
Retrieval Layer
   ↓
Relevant Knowledge
   ↓
Response Generation
```

RAG must remain optional and must not be required for core operation.

## 22. Database
Primary database: PostgreSQL.

Expected data areas:
- users
- caregivers
- relationships
- memories
- family members
- reminders
- game sessions
- game performance
- difficulty state
- preferences

Detailed schema belongs in `05_DATABASE_SCHEMA.md`.

## 23. Data Access
Preferred:
```text
API
 ↓
Service
 ↓
Repository
 ↓
PostgreSQL
```

Frontend MUST NOT access PostgreSQL directly.

AI MUST NOT directly modify PostgreSQL.

## 24. Separate Device Data Flow
Example caregiver reminder:
```text
Caregiver Device
      ↓
Reminder API
      ↓
Authorization
      ↓
Reminder Service
      ↓
PostgreSQL
      ↓
Reminder/Notification System
      ↓
Elderly Device
```

## 25. Security
Security boundaries include:
- secure communication
- authentication
- authorization
- input validation
- protected endpoints
- controlled database access
- secrets management
- safe logging

## 26. Sensitive Data
Protected information includes:
- names
- relationships
- photos
- memories
- reminders
- caregiver information
- authentication/session information

Use minimum necessary access.

## 27. Error Handling
User-facing errors should be simple.

Do not expose:
- stack traces
- SQL errors
- API keys
- internal service names
- debugging details

## 28. Logging
Logs may contain:
- operation
- service
- success/failure
- error category
- timing
- system events

Logs should not unnecessarily contain private memories, passwords, tokens, or sensitive personal data.

## 29. Configuration
Environment-specific values must not be hardcoded.

Use environment configuration for:
- database connection
- AI keys
- voice credentials
- notification credentials
- application secrets

Never commit secrets.

## 30. Recommended Repository Structure
```text
yaadsaathi/
├── frontend/
│   ├── elderly_app/
│   └── caregiver_app/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── services/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── schemas/
│   │   ├── ai/
│   │   ├── games/
│   │   ├── voice/
│   │   ├── language/
│   │   ├── security/
│   │   └── core/
│   └── tests/
├── docs/
├── scripts/
├── .env.example
├── .gitignore
└── README.md
```

## 31. Component Independence
- UI does not own backend business rules.
- Backend services do not depend on Flutter implementation.
- AI does not directly own database access.
- Database does not depend on UI.

## 32. Mockability
Frontend may use mock APIs.
AI may use mock providers.
External services should have adapter boundaries.

## 33. API Contract
`06_API_CONTRACT.md` defines:
- endpoints
- methods
- authentication
- authorization
- requests
- responses
- errors
- status codes

The API contract is the main frontend-backend boundary.

## 34. Testing Architecture
Testing levels:
- unit
- service
- API
- integration
- frontend
- end-to-end

Adaptive rules, authorization, intent handling, memory lookup, reminder logic, and safety validation should be independently testable.

## 35. Deployment
Simplified:
```text
Elderly Device ─┐
                ├→ FastAPI Backend → PostgreSQL
Caregiver Device┘          |
                            ├→ AI Services
                            └→ Other Providers
```

The architecture should not depend on a specific cloud provider.

## 36. What Must Not Happen
- Flutter → PostgreSQL
- AI Model → PostgreSQL
- Elderly Device ↔ Caregiver Device as a required direct connection
- business rules embedded in UI
- hardcoded API keys
- fabricated personal facts
- mandatory ML for MVP
- mandatory RAG for MVP
- marks/rankings shown to elderly users

## 37. Future Extension Points
Possible later additions:
- ML adaptive difficulty
- advanced personalization
- RAG
- additional games
- analytics
- additional languages

These are not current MVP dependencies.

## 38. Team Ownership
- Divya — AI/ML architecture, adaptive intelligence, AI assistant
- Deepsheekha — multilingual and voice architecture
- Divakar — elderly frontend and game integration
- Kapil — caregiver/frontend interface
- Chun Chun — backend services, APIs, database
- Bhavana — security, authentication, testing

## 39. Integration Sequence
1. Project setup
2. Database foundation
3. API foundation
4. Authentication
5. Elderly frontend
6. Caregiver frontend
7. Core games
8. Rule-based adaptive difficulty
9. Memory/family system
10. Reminder system
11. AI assistant
12. English/Hindi support
13. Voice support
14. Caregiver integration
15. Security hardening
16. Testing
17. Full integration
18. Deployment

## 40. Architecture Acceptance Criteria
The architecture is accepted when:
- elderly and caregiver clients work independently
- separate devices and sessions are supported
- backend controls authorization
- frontend does not access PostgreSQL directly
- business logic is in backend services
- rule-based adaptive difficulty works independently
- memories/family/reminders use backend services
- AI and voice providers are abstracted
- secrets are protected
- sensitive data is protected
- elderly users do not see internal scores
- MVP works without ML
- MVP works without RAG
- MVP supports English and Hindi only

## 41. Final Principle
> A modular system where the elderly client provides simplicity, the caregiver client provides remote support, the backend provides control, the database provides reliable information storage, and AI provides assistance without becoming the source of truth.

The MVP should favor a small, reliable architecture over unnecessary technical complexity.
