# YaadSaathi — Testing Strategy

## 1. Purpose
Ensure the system is reliable, safe, and independently testable.

## 2. Testing Levels
```text
Unit
 ↓
Service
 ↓
API
 ↓
Integration
 ↓
Frontend
 ↓
End-to-End
```

## 3. Unit Tests
Test pure logic independently.

Priority:
- adaptive rules
- authorization helpers
- validation
- intent classification logic
- reminder calculations
- data transformations

## 4. Adaptive Difficulty Tests
Required:
- >80%
- exactly 80%
- 50%
- <50%
- EASY boundary
- HARD boundary

Example:
```text
MEDIUM + 90% → HARD
MEDIUM + 65% → MEDIUM
MEDIUM + 30% → EASY
```

## 5. Service Tests
Test:
- game service
- memory service
- family service
- reminder service
- assistant service
- authentication
- caregiver authorization

## 6. API Tests
Verify:
- status codes
- request validation
- authentication
- authorization
- response structure
- error structure

## 7. Security Tests
Verify:
- unauthorized caregiver access fails
- unauthenticated requests fail
- secrets are not returned
- protected data is not exposed
- invalid input is rejected

## 8. AI Safety Tests
Test:
- fabricated personal information prevention
- missing-data responses
- medical safety
- unknown intents
- provider failures

## 9. Voice Tests
Test:
- STT success/failure
- TTS success/failure
- English
- Hindi
- text fallback

## 10. Frontend Tests
Test:
- navigation
- large controls
- game interactions
- caregiver workflows
- language switching
- session persistence
- error messages

## 11. Integration Tests
Verify complete flows:
- caregiver creates memory → elderly retrieves it
- caregiver creates reminder → elderly receives/view reminder
- elderly completes game → rule engine updates difficulty
- elderly asks assistant → relevant stored data returned

## 12. End-to-End Tests
Test the main user journeys on realistic client/backend environments.

## 13. Regression Testing
After major changes, rerun:
- authentication
- authorization
- games
- adaptive rules
- memories
- reminders
- assistant
- English/Hindi
- voice fallback

## 14. Test Data
Use synthetic/test data.

Do not use unnecessary real personal information.

## 15. Current Scope
Do not create tests for ML difficulty or RAG until those features are officially added.

> A feature is not complete until its important behavior can be tested.
