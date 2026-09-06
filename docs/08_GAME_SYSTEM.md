# YaadSaathi — Game System

## 1. Purpose
Defines the common architecture for cognitive games.

## 2. Current Games
1. Memory Match
2. Remember the Objects
3. Sequence
4. Object/Word Association

## 3. Game Architecture
```text
Game UI
  ↓
Game API
  ↓
Game Service
  ↓
Game Configuration
  ↓
Game Result
  ↓
Performance Storage
  ↓
Rule-Based Adaptive Difficulty
```

## 4. Game Session
A game session represents one attempt.

It should have:
- session ID
- user ID
- game type
- difficulty
- start time
- completion time
- status

## 5. Game Result
The backend may record:
- accuracy
- completion time
- task-specific result metadata

Do not present marks/rankings to the elderly user.

## 6. Game Types
### Memory Match
User matches related pairs.

### Remember the Objects
Objects are shown and later recalled.

### Sequence
User remembers/reproduces a sequence.

### Object/Word Association
User connects related objects/words.

Exact gameplay details may evolve during frontend implementation.

## 7. Difficulty
Current levels:
- EASY
- MEDIUM
- HARD

Difficulty is selected by the rule-based adaptive engine.

## 8. Adaptive Rules
- >80% → increase
- 50–80% → same
- <50% → decrease

Boundaries:
- EASY cannot decrease
- HARD cannot increase

## 9. ML Status
ML-based difficulty modification is NOT implemented in the current MVP.

If added later, it should replace/augment the engine behind the same interface.

## 10. User Experience
Games should:
- have clear instructions
- use large controls
- minimize unnecessary text
- avoid negative/failure-oriented wording
- provide simple positive feedback

## 11. Backend Validation
Backend should validate:
- session ownership
- result format
- allowed game type
- allowed difficulty
- session state

## 12. Testing
Test:
- game creation
- session lifecycle
- result submission
- invalid results
- difficulty boundaries
- adaptive rule correctness

> Games should challenge memory without making the user feel judged.
