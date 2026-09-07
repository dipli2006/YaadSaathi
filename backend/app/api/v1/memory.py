from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.caregiver_patient import CaregiverPatient
from app.models.user import User
from app.schemas.memory import MemoryCreate, MemoryResponse
from app.services.memory_service import create_memory, get_patient_memories

router = APIRouter(tags=["memories"])


@router.post(
    "",
    response_model=MemoryResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a memory (Patient only)",
)
def add_memory(
    memory_data: MemoryCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Patients or linked caregivers can store trusted memories."""
    if current_user.role == "caregiver":
        patient_id = (
            db.query(CaregiverPatient.patient_id)
            .filter(CaregiverPatient.caregiver_id == current_user.id)
            .scalar()
        )
        if patient_id is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Forbidden: You are not linked to a patient.",
            )
        return create_memory(db, patient_id, memory_data)
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Patient or linked caregiver access required.",
        )
    return create_memory(db, current_user.id, memory_data)


@router.get(
    "/me",
    response_model=list[MemoryResponse],
    summary="Get own memories (Patient only)",
)
def get_my_memories(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Patients can retrieve their own memories."""
    if current_user.role != "patient":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only patients can access their memories.",
        )
    return get_patient_memories(db, current_user.id)


@router.get(
    "/patient/{id}",
    response_model=list[MemoryResponse],
    summary="Get patient memories (Caregiver only, must be linked)",
)
def get_patient_memories_for_caregiver(
    id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Caregivers can view memories of their linked patients."""
    if current_user.role != "caregiver":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Only caregivers can access patient memories.",
        )

    # Access control: check if caregiver is linked to the patient
    link = (
        db.query(CaregiverPatient)
        .filter(
            CaregiverPatient.caregiver_id == current_user.id,
            CaregiverPatient.patient_id == id,
        )
        .first()
    )
    if not link:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: You are not linked to this patient.",
        )

    return get_patient_memories(db, id)
