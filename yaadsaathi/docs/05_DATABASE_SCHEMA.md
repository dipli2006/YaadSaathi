# YaadSaathi — Database Schema

## 1. Purpose
This document defines the logical PostgreSQL data model.

## 2. Core Entities
- users
- caregiver_elderly_relationships
- memories
- family_members
- reminders
- game_sessions
- game_performance
- difficulty_states
- user_preferences

## 3. Users
Conceptual fields:
```text
users
- id
- role
- name
- authentication_reference
- created_at
- updated_at
```

Roles:
- ELDERLY
- CAREGIVER

Authentication secrets should not be stored as plain text.

## 4. Caregiver-Elderly Relationship
```text
caregiver_elderly_relationships
- id
- caregiver_id → users.id
- elderly_user_id → users.id
- relationship_type
- status
- created_at
```

Used for authorization.

## 5. Memories
```text
memories
- id
- elderly_user_id → users.id
- title
- content
- created_by
- created_at
- updated_at
```

## 6. Family Members
```text
family_members
- id
- elderly_user_id → users.id
- name
- relationship
- photo_reference
- additional_information
- created_at
- updated_at
```

Photos should preferably be stored through an appropriate file/object-storage mechanism, with a safe reference in the database.

## 7. Reminders
```text
reminders
- id
- elderly_user_id → users.id
- created_by
- title
- description
- scheduled_at
- recurrence
- status
- created_at
- updated_at
```

## 8. Game Sessions
```text
game_sessions
- id
- elderly_user_id → users.id
- game_type
- difficulty
- started_at
- completed_at
- status
```

## 9. Game Performance
```text
game_performance
- id
- game_session_id → game_sessions.id
- elderly_user_id → users.id
- accuracy
- completion_time
- result_metadata
- created_at
```

Performance is for internal adaptation/authorized analysis and is not a user-facing score.

## 10. Difficulty State
```text
difficulty_states
- id
- elderly_user_id → users.id
- game_type
- difficulty
- updated_at
```

Current difficulty engine is rule-based.

## 11. User Preferences
```text
user_preferences
- id
- user_id → users.id
- language
- accessibility_preferences
- voice_preferences
- created_at
- updated_at
```

Current language values:
- en
- hi

## 12. Relationships
```text
users
  ├── memories
  ├── family_members
  ├── reminders
  ├── game_sessions
  ├── game_performance
  ├── difficulty_states
  └── preferences

caregiver
  └── caregiver_elderly_relationships
          └── elderly user
```

## 13. Data Ownership
Every protected resource must have a clear owner.

Backend authorization must verify access before reading/updating/deleting protected data.

## 14. Data Integrity
Use:
- foreign keys
- unique constraints where appropriate
- not-null constraints where appropriate
- timestamps
- controlled enums/status values
- transactions for multi-step updates

## 15. Privacy
Do not store unnecessary personal data.

Do not store passwords in plain text.

Do not store secrets in normal data fields.

## 16. Migration Principle
Schema changes should use versioned migrations rather than manual production edits.

## 17. Current MVP Notes
No database structures are required specifically for:
- ML difficulty models
- RAG/vector retrieval

Those are future extensions.

## 18. Source of Truth
This document defines the logical schema. Exact SQL/ORM implementation may be refined during development without changing ownership or relationships.

> Store only what the system needs, protect what it stores, and keep ownership explicit.
