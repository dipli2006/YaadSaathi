from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.patient import PatientProfileCreate, PatientProfileResponse
from app.services.patient_service import create_patient_profile, get_patient_profile

router = APIRouter(tags=["patient"])


@router.post(
    "/profile",
    response_model=PatientProfileResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create or update patient profile",
)
def create_profile(
    profile_data: PatientProfileCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Only patients can create their profile."""
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only patients can access this resource.",
        )
    return create_patient_profile(db, current_user.id, profile_data)


@router.get(
    "/me",
    response_model=PatientProfileResponse,
    summary="Get own patient profile",
)
def get_my_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Only patients can fetch their own profile."""
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only patients can access this resource.",
        )
    profile = get_patient_profile(db, current_user.id)
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Patient profile not found.",
        )
    return profile
