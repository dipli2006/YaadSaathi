# AI/ML Implementation Notes

## Completed frontend slice

The Flutter client now contains:

- `AIService` interface for provider swapping.
- `MockAIService` for deterministic development without a model dependency.
- The five required intents: person, memory, reminder, general conversation, and unknown.
- Trusted structured memory and reminder retrieval before response generation.
- Safe responses for diagnosis, dementia, cure, unsafe medication, and self-harm requests.
- English and Hindi response selection from the active app locale.
- Focused unit tests for routing, grounding, safety, language, and empty input.

## Integration boundary

The real provider should implement the existing API contract:

```text
POST /api/v1/assistant/message
```

Request fields:

```json
{
  "message": "Who is Ravi?",
  "language": "en"
}
```

Response fields:

```json
{
  "reply": "Ravi is your son.",
  "intent": "PERSON_LOOKUP"
}
```

The backend remains responsible for authentication, relationship authorization,
trusted memory retrieval, model execution, and final safety enforcement. The
frontend mock is only a coordination and test implementation.

## ML evaluation boundary

The MVP remains rule-based for adaptive difficulty. Future evaluation can use
success, attempts, hints, response time, game type, and current difficulty as
inputs, compare an ML recommendation against the rule-based result, and retain
the rule-based engine unless ML demonstrates a clear improvement.

## RAG decision

RAG is intentionally deferred. Structured caregiver-provided memories remain
the source of truth until required features are stable and a feasibility study
shows a clear benefit without compromising privacy or latency.