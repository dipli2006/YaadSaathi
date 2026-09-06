# YaadSaathi — GitHub Workflow

## 1. Purpose
This document defines how the six-member team collaborates through GitHub.

## 2. Core Principle
No team member should need another member's local machine to continue development.

Use:
- documentation
- branches
- pull requests
- API contracts
- mocks
- shared environment instructions

## 3. Main Branch
Recommended:
```text
main
```

`main` should contain stable/integrated code.

Do not directly push unfinished work to `main`.

## 4. Feature Branches
Use descriptive branches.

Examples:
```text
feature/elderly-home
feature/game-memory-match
feature/adaptive-rules
feature/memory-api
feature/caregiver-dashboard
feature/voice
feature/security
```

## 5. Commit Messages
Prefer:
```text
feat: add memory match game
fix: handle empty memory response
docs: update API contract
test: add adaptive difficulty tests
refactor: separate memory repository
```

## 6. Pull Requests
A PR should explain:
- what changed
- why it changed
- how it was tested
- any documentation/API/schema changes

## 7. Review
At least one other team member should review significant changes before merging.

Security-sensitive changes should receive additional review.

## 8. Merge Rules
Before merging:
- code builds
- relevant tests pass
- no secrets are included
- related docs are updated
- API/schema changes are documented

## 9. Conflict Prevention
Before large changes:
```text
git pull origin main
```

Keep branches focused and short-lived where practical.

## 10. Shared Documentation
The `docs/` directory is the project source of truth.

If implementation changes an agreed behavior, update the relevant document.

## 11. Environment Files
Never commit:
```text
.env
```

Commit:
```text
.env.example
```

without real credentials.

## 12. Mocking
Use mock APIs/data when another component is not ready.

Do not block frontend development waiting for backend completion.

## 13. Team Ownership
- Divya — AI/ML, adaptive rules, assistant
- Deepsheekha — language/voice
- Divakar — elderly frontend/games
- Kapil — caregiver/frontend
- Chun Chun — backend/database/API
- Bhavana — security/testing

## 14. Current AI Scope
Current MVP:
- rule-based adaptive difficulty
- controlled AI assistant
- English/Hindi
- voice integration

Not current MVP:
- ML difficulty model
- RAG
- Bengali
- Assamese

## 15. Issue Tracking
Issues should contain:
- problem
- expected behavior
- reproduction steps when applicable
- acceptance criteria

## 16. Release Principle
Only tested, integrated functionality should be considered release-ready.

> Commit clearly, document changes, review safely, and keep teammates unblocked.
