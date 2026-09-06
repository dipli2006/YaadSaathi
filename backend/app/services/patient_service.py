from sqlalchemy.orm import Session

from app.models.patient_profile import PatientProfile
from app.schemas.patient import PatientProfileCreate


def create_patient_profile(
    db: Session, user_id: int, profile_data: PatientProfileCreate
) -> PatientProfile:
    """Create or update patient profile for a user."""
    profile = (
        db.query(PatientProfile).filter(PatientProfile.user_id == user_id).first()
    )
    if profile:
        profile.name = profile_data.name
        profile.age = profile_data.age
        profile.condition_notes = profile_data.condition_notes
    else:
        profile = PatientProfile(
            user_id=user_id,
            name=profile_data.name,
            age=profile_data.age,
            condition_notes=profile_data.condition_notes,
        )
        db.add(profile)
    db.commit()
    db.refresh(profile)
    return profile


def get_patient_profile(db: Session, user_id: int) -> PatientProfile | None:
    """Fetch patient profile for a given user ID."""
    return db.query(PatientProfile).filter(PatientProfile.user_id == user_id).first()
