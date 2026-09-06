# YaadSaathi — Adaptive Difficulty

## 1. Current Implementation
The current MVP uses a **rule-based adaptive difficulty engine**.

No ML algorithm is implemented for difficulty modification.

No training dataset or model is required for the current version.

## 2. Purpose
Adapt game difficulty based on recent performance while avoiding user-facing scores.

## 3. Difficulty Levels
```text
EASY → MEDIUM → HARD
```

## 4. Initial Rules
```text
Success Rate > 80%
    → Increase difficulty

Success Rate 50%–80%
    → Keep difficulty

Success Rate < 50%
    → Decrease difficulty
```

## 5. Boundary Handling
```text
EASY + decrease → EASY
HARD + increase → HARD
```

## 6. Input
The engine may receive:
- current difficulty
- success rate
- game type
- recent performance context if required

## 7. Output
The engine returns:
- next difficulty

It should not return a user-facing score.

## 8. Example
```text
Current = MEDIUM
Success = 90%
Next = HARD
```

```text
Current = MEDIUM
Success = 65%
Next = MEDIUM
```

```text
Current = MEDIUM
Success = 30%
Next = EASY
```

## 9. Suggested Interface
```text
get_next_difficulty(
    current_difficulty,
    success_rate,
    game_type
)
```

## 10. Separation
The engine should be independent of:
- Flutter UI
- PostgreSQL implementation
- AI provider
- voice provider

## 11. Testing
Minimum tests:
- >80%
- exactly 80%
- 50%
- below 50%
- EASY lower boundary
- HARD upper boundary

## 12. Future ML
A future ML implementation may use the same conceptual interface.

Current:
```text
RuleBasedDifficultyEngine
```

Future:
```text
MLDifficultyEngine
```

Do not implement the ML engine unless the project requirements explicitly change.

> For the current MVP, simple rules are the source of adaptive behavior.
