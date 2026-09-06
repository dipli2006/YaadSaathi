# YaadSaathi — AI Safety and Privacy

## 1. Purpose
This document defines safety, privacy, and responsible AI boundaries.

## 2. Core Principles
- privacy by design
- minimum necessary access
- backend authorization
- source-of-truth grounding
- no fabrication
- simple communication
- safe failure

## 3. AI Must Not Diagnose
The assistant must not diagnose dementia or another medical condition.

## 4. No Cure Claims
The assistant must not claim that YaadSaathi or its games can cure dementia.

## 5. No Fabricated Personal Information
The AI must not invent:
- people
- relationships
- memories
- events
- reminders
- personal facts

## 6. Source of Truth
For structured personal information:
```text
Database/Application Data
        ↓
Source of Truth
        ↓
AI Explanation
```

## 7. Medical Safety
The assistant must avoid unsafe medical instructions.

For medical concerns outside the application's safe scope, responses should encourage appropriate professional/caregiver support.

## 8. Authorization
Backend authorization must be checked before returning protected information.

## 9. Elderly/Caregiver Separation
Separate accounts and sessions are required.

Caregiver access is based on explicit authorization.

## 10. Data Minimization
Collect and store only information required for application functionality.

## 11. Secrets
Never expose:
- API keys
- passwords
- tokens
- internal credentials

Never commit secrets to GitHub.

## 12. Logging Privacy
Do not unnecessarily log:
- passwords
- tokens
- private memories
- sensitive user content

## 13. User-Facing Safety
Do not show technical errors to elderly users.

Use clear, calm messages.

## 14. AI Provider Boundary
External AI providers should be accessed through controlled application services.

## 15. RAG
RAG is not part of the current MVP.

If added later, retrieval must respect authorization and privacy.

## 16. ML
ML-based difficulty modification is not part of the current MVP.

## 17. Safety Testing
Test:
- hallucinated personal facts
- missing data
- unauthorized lookup
- medical requests
- unsafe instructions
- provider failures
- malicious/invalid input

> When uncertain, the system should prefer a safe limitation over a confident fabrication.
