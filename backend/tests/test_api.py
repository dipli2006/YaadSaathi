from datetime import UTC, datetime

from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def create_linked_users() -> tuple[dict, dict, str, str]:
    suffix = datetime.now(UTC).strftime("%H%M%S%f")
    caregiver_email = f"caregiver{suffix}@example.com"
    patient_email = f"patient{suffix}@example.com"
    caregiver = client.post(
        "/api/v1/auth/register",
        json={"email": caregiver_email, "password": "secret123", "role": "caregiver"},
    ).json()
    patient = client.post(
        "/api/v1/auth/register",
        json={"email": patient_email, "password": "Patient123!", "role": "patient"},
    ).json()
    login = client.post(
        "/api/v1/auth/login",
        json={"email": caregiver_email, "password": "secret123"},
    ).json()
    caregiver_headers = {"Authorization": f"Bearer {login['access_token']}"}
    link = client.post(
        "/api/v1/caregiver/link",
        headers=caregiver_headers,
        json={"patient_email": patient_email},
    )
    assert link.status_code == 201
    patient_login = client.post(
        "/api/v1/auth/login",
        json={"email": patient_email, "password": "Patient123!"},
    ).json()
    return caregiver, patient, login["access_token"], patient_login["access_token"]


def test_health_and_linked_authentication() -> None:
    assert client.get("/api/v1/health").status_code == 200
    caregiver, patient, caregiver_token, _ = create_linked_users()
    response = client.get(
        "/api/v1/caregiver/patients",
        headers={"Authorization": f"Bearer {caregiver_token}"},
    )
    assert response.status_code == 200
    assert response.json()[0]["id"] == patient["id"]
    assert caregiver["role"] == "caregiver"


def test_caregiver_can_create_memory_and_patient_can_read_it() -> None:
    _, patient, caregiver_token, patient_token = create_linked_users()
    create = client.post(
        "/api/v1/memories",
        headers={"Authorization": f"Bearer {caregiver_token}"},
        json={"title": "Tea garden", "content": "A family trip to Assam."},
    )
    assert create.status_code == 201
    memories = client.get(
        "/api/v1/memories/me",
        headers={"Authorization": f"Bearer {patient_token}"},
    )
    assert memories.status_code == 200
    assert memories.json()[0]["patient_id"] == patient["id"]


def test_caregiver_reminder_and_patient_completion() -> None:
    _, patient, caregiver_token, patient_token = create_linked_users()
    reminder = client.post(
        "/api/v1/reminders",
        headers={"Authorization": f"Bearer {caregiver_token}"},
        json={
            "patient_id": patient["id"],
            "text": "Morning medicine",
            "scheduled_time": datetime.now(UTC).isoformat(),
        },
    )
    assert reminder.status_code == 201
    completed = client.patch(
        f"/api/v1/reminders/{reminder.json()['id']}/complete",
        headers={"Authorization": f"Bearer {patient_token}"},
    )
    assert completed.status_code == 200
    assert completed.json()["is_completed"] is True


def test_database_grounded_assistant_and_safety() -> None:
    _, _, _, patient_token = create_linked_users()
    headers = {"Authorization": f"Bearer {patient_token}"}
    unsafe = client.post(
        "/api/v1/assistant/message",
        headers=headers,
        json={"message": "Can you diagnose dementia?", "language": "en"},
    )
    assert unsafe.status_code == 200
    assert unsafe.json()["intent"] == "UNKNOWN"
    reminder = client.post(
        "/api/v1/assistant/message",
        headers=headers,
        json={"message": "What is my reminder?", "language": "en"},
    )
    assert reminder.status_code == 200
    assert reminder.json()["intent"] == "REMINDER_LOOKUP"
