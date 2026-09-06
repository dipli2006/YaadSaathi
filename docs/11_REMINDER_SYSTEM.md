# YaadSaathi — Reminder System

## 1. Purpose
The Reminder System helps the elderly user remember scheduled activities and routines.

## 2. Reminder Data
A reminder may contain:
- title
- description
- scheduled time
- recurrence
- status
- elderly user
- creator

## 3. Core Operations
- create
- retrieve
- update
- delete
- schedule
- notify

## 4. Caregiver Flow
```text
Caregiver Device
 ↓
Select authorized elderly user
 ↓
Create reminder
 ↓
Backend authorization
 ↓
Reminder Service
 ↓
Database
 ↓
Scheduler/Notification
 ↓
Elderly Device
```

## 5. Elderly Flow
The elderly user can view upcoming reminders and receive notifications.

## 6. Authorization
Caregivers may manage reminders only for elderly users they are authorized to support.

## 7. Notification Abstraction
```text
Reminder Service
      ↓
Notification Interface
      ↓
Provider
```

The project should not tightly couple reminder logic to one provider.

## 8. Failure Handling
If notification delivery fails:
- record the failure appropriately
- avoid exposing technical details to the elderly user
- allow retry/recovery where appropriate

## 9. Time Handling
Store timestamps consistently and define timezone behavior clearly during implementation.

## 10. Testing
Test:
- creation
- update
- deletion
- scheduling
- recurrence
- authorization
- notification failure
- boundary times

> Reminders should reduce cognitive load, not add complexity.
