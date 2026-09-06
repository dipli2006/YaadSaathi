# YaadSaathi — User Flows

## 1. Purpose
This document describes the main user journeys for elderly users and caregivers.

## 2. High-Level Flow
```text
Elderly Device ─→ Backend ←─ Caregiver Device
```

Users are independent and may use different devices.

## 3. Elderly First-Time Setup
```text
Open App
 ↓
Welcome
 ↓
Language Selection
 ↓
Account/Setup
 ↓
Secure Session Created
 ↓
Simple Home
```

Current languages:
- English
- Hindi

## 4. Elderly Returning User
```text
Open App
 ↓
Secure Persistent Session
 ↓
Home
```

Repeated password entry should be minimized.

## 5. Elderly Home
Home should provide simple access to:
- Play
- Memories
- Family
- Reminders
- Assistant
- Voice/language controls where appropriate

## 6. Cognitive Game Flow
```text
Home
 ↓
Play
 ↓
Select Game
 ↓
Game Starts
 ↓
User Plays
 ↓
Result Processed Internally
 ↓
Next Difficulty Determined
 ↓
Positive/simple feedback
 ↓
Return Home
```

No score or ranking is shown.

## 7. Memory Flow
```text
Home
 ↓
Memories
 ↓
View/search memory
 ↓
Display stored information
```

If information is unavailable, say so rather than guessing.

## 8. Family Flow
```text
Home
 ↓
Family
 ↓
Select Person
 ↓
View stored information/photo
```

## 9. Reminder Flow
```text
Home
 ↓
Reminders
 ↓
View reminder
 ↓
Reminder notification at scheduled time
```

## 10. AI Assistant Flow
```text
User speaks/types
 ↓
Input processing
 ↓
Intent detection
 ↓
Relevant service lookup when required
 ↓
Safe response
 ↓
Text and/or voice output
```

## 11. Caregiver Login Flow
```text
Open Caregiver App
 ↓
Login
 ↓
Backend authentication
 ↓
Authorized caregiver home
```

## 12. Caregiver Selects Elderly User
```text
Caregiver Home
 ↓
Select linked elderly user
 ↓
Backend authorization check
 ↓
Authorized information displayed
```

## 13. Caregiver Adds Memory
```text
Caregiver
 ↓
Select elderly user
 ↓
Memories
 ↓
Add memory
 ↓
Submit
 ↓
Backend validates authorization
 ↓
Memory stored
```

## 14. Caregiver Adds Family Member
```text
Caregiver
 ↓
Select elderly user
 ↓
Family
 ↓
Add family member
 ↓
Save
```

## 15. Caregiver Creates Reminder
```text
Caregiver
 ↓
Select elderly user
 ↓
Reminders
 ↓
Create reminder
 ↓
Schedule
 ↓
Save
 ↓
Notification system
 ↓
Elderly device
```

## 16. Separate Device Principle
The caregiver does not need physical access to the elderly user's device.

The elderly user does not need to be logged into the caregiver device.

The backend synchronizes shared application data.

## 17. Voice Flow
```text
Speak
 ↓
STT
 ↓
Assistant
 ↓
Response Text
 ↓
TTS
 ↓
Listen
```

Text fallback remains available.

## 18. Error Flow
```text
Action
 ↓
Error
 ↓
Simple user-friendly message
 ↓
Retry/Return
```

Technical details remain hidden.

## 19. Authentication Safety Flow
```text
Open App
 ↓
Check session
 ↓
Valid?
 ├─ Yes → Home
 └─ No  → Appropriate authentication/setup
```

## 20. Core UX Principle
Every elderly flow should minimize:
- unnecessary screens
- small controls
- complicated wording
- repeated authentication
- confusing errors

> Fewer steps, clearer actions, safer assistance.
