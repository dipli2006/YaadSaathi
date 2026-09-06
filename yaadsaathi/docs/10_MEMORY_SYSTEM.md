# YaadSaathi — Memory System

## 1. Purpose
The Memory System stores personal information that can help the elderly user remember meaningful details.

## 2. Memory Types
Examples:
- personal memories
- important events
- familiar places
- meaningful information
- caregiver-provided memory notes

## 3. Ownership
Every memory belongs to an elderly user.

A caregiver may create/manage a memory only when authorized.

## 4. CRUD
Supported operations:
- create
- read
- update
- delete
- search/retrieve

## 5. Data Model
Conceptually:
```text
Memory
- id
- elderly_user_id
- title
- content
- created_by
- timestamps
```

## 6. AI Integration
The AI assistant should request memory information through the Memory Service.

```text
User
 ↓
AI Assistant
 ↓
Memory Service
 ↓
Database
 ↓
Stored Memory
 ↓
AI Response
```

## 7. No Fabrication
If the requested memory is not stored:
```text
"I don't have that information."
```

The assistant must not invent:
- memories
- people
- events
- relationships

## 8. Privacy
Memory content is protected personal information.

Access must be authorized.

## 9. Caregiver Flow
```text
Caregiver
 ↓
Authorized elderly user
 ↓
Memory management
 ↓
Save
```

## 10. Elderly Flow
The elderly user can view/search their own memories according to the application's UX.

## 11. Future RAG
RAG is not part of the current MVP memory architecture.

If considered later, it must not replace database ownership of structured personal facts.

## 12. Testing
Test:
- ownership
- caregiver authorization
- CRUD
- empty results
- unauthorized access
- AI lookup with existing and missing memories

> Stored memory is the source of truth; AI only helps present it.
