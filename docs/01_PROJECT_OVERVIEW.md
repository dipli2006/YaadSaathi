# YaadSaathi — Project Overview

## 1. Introduction
YaadSaathi is an AI-assisted cognitive care and memory-support platform designed for elderly people living with dementia and their caregivers.

The system combines simple cognitive games, personal memory assistance, family information, reminders, multilingual interaction, voice assistance, and caregiver support.

The platform is designed to be technically intelligent while remaining emotionally simple and easy to use.

## 2. Problem Addressed
People living with dementia may experience difficulty remembering people, events, routines, and everyday information. Caregivers also need a simple way to support them remotely.

YaadSaathi aims to provide a safe digital companion that supports memory, cognitive engagement, routine assistance, and caregiver involvement.

## 3. Target Users
### Elderly User
The elderly user receives:
- cognitive games
- memory assistance
- family information
- reminders
- AI assistance
- voice interaction
- simple multilingual interaction

### Caregiver
The caregiver receives:
- elderly-user management
- memory management
- family information management
- reminder management
- permitted activity information
- supported settings

The elderly user and caregiver use separate devices and separate authenticated sessions.

## 4. Core Features
- Elderly-friendly home interface
- Cognitive games
- Rule-based adaptive difficulty
- Personal memories
- Family members and photos
- Reminders
- AI assistant
- Hindi and English support
- Voice interaction
- Caregiver dashboard
- Authentication and persistent elderly sessions
- Privacy and security

## 5. Cognitive Games
Initial games:
1. Memory Match
2. Remember the Objects
3. Sequence
4. Object/Word Association

The elderly user should not see marks, rankings, or game-history displays.

Game performance may be stored internally for adaptive difficulty, caregiver awareness, and future analysis.

## 6. Adaptive Difficulty
The MVP uses a rule-based approach.

Initial rules:
- Success rate >80% → increase difficulty
- Success rate 50–80% → keep difficulty
- Success rate <50% → decrease difficulty

Difficulty levels:
- EASY
- MEDIUM
- HARD

ML-based difficulty modification is not implemented in the current version.

## 7. Personal Memory Assistance
Users/caregivers can store approved personal memories and information.

The AI assistant must use stored information as the source of truth and must not invent memories, relationships, or events.

## 8. Family Information
Family information may include:
- name
- relationship
- photo
- optional additional information

## 9. Reminders
The system supports reminders for important activities and routines.

## 10. AI Assistant
Initial intent categories:
- PERSON_LOOKUP
- MEMORY_LOOKUP
- REMINDER_LOOKUP
- GENERAL_CONVERSATION
- UNKNOWN

The AI assistant is an interface and explanation layer, not the source of truth for personal information.

## 11. AI Safety
The assistant must not:
- diagnose dementia
- claim to cure dementia
- fabricate memories or relationships
- provide unsafe medical instructions
- unnecessarily expose private information

## 12. Languages
The current implementation supports only:
- English
- Hindi

Bengali and Assamese are future possibilities and are not current implementation requirements.

## 13. Voice
Voice pipeline:
Speech-to-Text → AI Assistant → Text-to-Speech

Text input/output remains available as a fallback.

## 14. Authentication
The elderly experience should minimize repeated password entry. A secure persistent/trusted session approach should be used.

Caregivers authenticate separately on their own devices.

## 15. Technology Stack
- Frontend: Flutter
- Backend: Python + FastAPI
- Database: PostgreSQL
- AI/voice services: provider abstractions

## 16. MVP Scope
The MVP focuses on reliable core functionality, including:
- elderly and caregiver clients
- authentication
- cognitive games
- rule-based adaptive difficulty
- memories
- family information
- reminders
- AI assistant
- English and Hindi
- voice support
- caregiver functionality
- privacy/security foundations

## 17. Explicitly Deferred
The following are not current MVP implementation requirements:
- ML-based adaptive difficulty
- RAG
- Bengali
- Assamese
- advanced analytics
- advanced personalization

These may be considered after core features are complete.

## 18. Team
- Divya — AI/ML
- Deepsheekha — AI/ML
- Divakar — Frontend
- Kapil — Frontend
- Chun Chun — Backend
- Bhavana — Backend/security

## 19. Development Principle
The repository documentation is the shared source of truth so team members can work independently.

## 20. Success Definition
YaadSaathi succeeds when it provides a reliable, safe, simple, accessible experience for elderly users while giving caregivers useful remote support.

> Technically intelligent, emotionally simple.
