from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.caregiver_patient import CaregiverPatient
from app.models.user import User
from app.schemas.reminder import ReminderCreate, ReminderResponse
from app.services.reminder_service import (
    create_reminder,
    get_patient_reminders,
    mark_reminder_complete,
)

router = APIRouter(tags=["reminders"])


@router.post(
    "",
    response_model=ReminderResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a reminder for a patient (Caregiver only)",
)
def add_reminder(
    reminder_data: ReminderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Caregivers can set reminders for linked patients."""
    if current_user.role != "caregiver":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only caregivers can set reminders.",
        )

    # Access control: verify caregiver is linked to target patient
    link = (
        db.query(CaregiverPatient)
        .filter(
            CaregiverPatient.caregiver_id == current_user.id,
            CaregiverPatient.patient_id == reminder_data.patient_id,
        )
        .first()
    )
    if not link:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: You are not linked to this patient.",
        )

    return create_reminder(db, current_user.id, reminder_data)


@router.get(
    "/me",
    response_model=list[ReminderResponse],
    summary="Get own reminders (Patient only)",
)
def get_my_reminders(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Patients can view their scheduled reminders."""
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only patients can access their reminders.",
        )
    return get_patient_reminders(db, current_user.id)


@router.patch(
    "/{id}/complete",
    response_model=ReminderResponse,
    summary="Mark reminder as complete (Patient only)",
)
def complete_reminder(
    id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Patients can mark a reminder as completed."""
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only patients can complete reminders.",
        )
    return mark_reminder_complete(db, reminder_id=id, patient_id=current_user.id)
