from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.link import (
    CaregiverPatientLinkResponse,
    LinkCaregiverRequest,
    PatientDetailResponse,
)
from app.services.link_service import (
    get_patients_for_caregiver,
    link_caregiver_to_patient,
)

router = APIRouter(tags=["caregiver"])


@router.post(
    "/link",
    response_model=CaregiverPatientLinkResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Link caregiver to a patient",
)
def link_patient(
    link_data: LinkCaregiverRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Only caregivers can link to a patient."""
    if current_user.role != "caregiver":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only caregivers can access this resource.",
        )
    return link_caregiver_to_patient(db, current_user.id, link_data.patient_email)


@router.get(
    "/patients",
    response_model=list[PatientDetailResponse],
    summary="Get all patients linked to caregiver",
)
def get_linked_patients(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Only caregivers can fetch their linked patients list."""
    if current_user.role != "caregiver":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only caregivers can access this resource.",
        )
    return get_patients_for_caregiver(db, current_user.id)
