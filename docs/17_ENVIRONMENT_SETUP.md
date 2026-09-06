# YaadSaathi — Environment Setup

## 1. Purpose
Provide a common development environment so every team member can work independently.

## 2. Prerequisites
Recommended:
- Git
- Flutter SDK
- Python 3.x
- PostgreSQL
- IDE/editor
- access to the project repository

Exact versions should be pinned once the team finalizes them.

## 3. Repository Setup
```bash
git clone <repository-url>
cd yaadsaathi
```

## 4. Backend Setup
Create and activate a Python virtual environment.

Example:
```bash
python -m venv .venv
```

Activate according to the operating system.

Install dependencies:
```bash
pip install -r requirements.txt
```

## 5. Backend Configuration
Create:
```text
.env
```

Use `.env.example` as the template.

Typical values:
```text
DATABASE_URL=
AI_API_KEY=
VOICE_PROVIDER_KEY=
APPLICATION_SECRET=
```

Do not commit `.env`.

## 6. Database
Create a PostgreSQL database for development.

The exact database name/user should be defined by the team environment configuration.

Run migrations using the project's migration tool once configured.

## 7. Run Backend
The exact command depends on the final FastAPI entry point.

Typical development command:
```bash
uvicorn app.main:app --reload
```

## 8. Frontend Setup
From the appropriate Flutter application directory:
```bash
flutter pub get
```

Run:
```bash
flutter run
```

## 9. Two Client Applications
The project supports:
```text
elderly_app
caregiver_app
```

They may run on separate devices.

## 10. API Configuration
Frontend should use an environment/configuration value for the backend base URL.

Do not hardcode production credentials.

## 11. Mock Development
Frontend teams may use mock API responses before backend endpoints are complete.

Mocks must follow `06_API_CONTRACT.md`.

## 12. Environment Separation
Use separate:
- development
- testing
- production

configuration/data.

## 13. Secrets
Never commit:
- `.env`
- API keys
- passwords
- tokens
- private certificates

## 14. Git Ignore
Ensure `.gitignore` excludes:
```text
.env
.venv/
__pycache__/
build/
.dart_tool/
```

Adjust based on the actual stack.

## 15. Current AI Scope
Current MVP:
- rule-based adaptive difficulty
- controlled AI assistant
- English/Hindi
- voice

Not required:
- ML difficulty model
- RAG
- Bengali
- Assamese

## 16. Troubleshooting Principle
When an environment issue occurs:
1. check the error
2. check versions
3. check `.env`
4. check database/API connectivity
5. check documentation
6. document a recurring fix

> Every team member should be able to clone, configure, run, and test the project independently.
