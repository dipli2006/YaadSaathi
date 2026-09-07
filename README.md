# YaadSaathi

YaadSaathi is organized as a Flutter client with room for a backend service
and project documentation.

## Repository layout

- `frontend/yaadsaathi_app/` - Flutter application.
- `backend/` - backend service boundary; implementation is not added yet.
- `docs/` - architecture and project documentation.

## Run the app

```text
cd frontend
flutter pub get
flutter run
```

## Presentation launcher on Windows

Double-click `Start YaadSaathi Presentation.bat` from the repository root.
It starts the local FastAPI backend with SQLite and launches the Flutter app in
Chrome. Close the Flutter terminal with `q` when the presentation is finished.