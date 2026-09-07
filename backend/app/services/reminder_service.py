from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.reminder import Reminder
from app.schemas.reminder import ReminderCreate


def create_reminder(
    db: Session, caregiver_id: int, reminder_data: ReminderCreate
) -> Reminder:
    """Create a new reminder scheduled for a patient by a caregiver."""
    reminder = Reminder(
        patient_id=reminder_data.patient_id,
        text=reminder_data.text,
        scheduled_time=reminder_data.scheduled_time,
        created_by=caregiver_id,
        is_completed=False,
    )
    db.add(reminder)
    db.commit()
    db.refresh(reminder)
    return reminder


def get_patient_reminders(db: Session, patient_id: int) -> list[Reminder]:
    """Retrieve all reminders for a given patient ordered by scheduled time."""
    return (
        db.query(Reminder)
        .filter(Reminder.patient_id == patient_id)
        .order_by(Reminder.scheduled_time.asc())
        .all()
    )


def mark_reminder_complete(
    db: Session, reminder_id: int, patient_id: int
) -> Reminder:
    """Mark a specific reminder as completed for a patient."""
    reminder = db.query(Reminder).filter(Reminder.id == reminder_id).first()
    if not reminder:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Reminder not found.",
        )
    if reminder.patient_id != patient_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Cannot update reminders belonging to another user.",
        )
    reminder.is_completed = True
    db.commit()
    db.refresh(reminder)
    return reminder
