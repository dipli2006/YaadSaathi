from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.caregiver_patient import CaregiverPatient
from app.models.user import User
from app.services.patient_service import get_patient_profile


def link_caregiver_to_patient(
    db: Session, caregiver_id: int, patient_email: str
) -> CaregiverPatient:
    """Link a caregiver to a patient via the patient's email address."""
    patient = db.query(User).filter(User.email == patient_email).first()
    if not patient:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Patient with this email not found.",
        )
    if patient.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The specified user is not a patient.",
        )

    # Check if link already exists
    existing_link = (
        db.query(CaregiverPatient)
        .filter(
            CaregiverPatient.caregiver_id == caregiver_id,
            CaregiverPatient.patient_id == patient.id,
        )
        .first()
    )
    if existing_link:
        return existing_link

    link = CaregiverPatient(caregiver_id=caregiver_id, patient_id=patient.id)
    db.add(link)
    db.commit()
    db.refresh(link)
    return link


def get_patients_for_caregiver(db: Session, caregiver_id: int) -> list[dict]:
    """Return all patients linked to a caregiver with their profile information."""
    links = (
        db.query(CaregiverPatient)
        .filter(CaregiverPatient.caregiver_id == caregiver_id)
        .all()
    )
    results = []
    for link in links:
        patient_user = db.query(User).filter(User.id == link.patient_id).first()
        if patient_user:
            profile = get_patient_profile(db, patient_user.id)
            results.append(
                {
                    "id": patient_user.id,
                    "email": patient_user.email,
                    "role": patient_user.role,
                    "created_at": patient_user.created_at,
                    "profile": profile,
                }
            )
    return results
