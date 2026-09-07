from datetime import datetime

from pydantic import BaseModel, EmailStr

from app.schemas.patient import PatientProfileResponse


class LinkCaregiverRequest(BaseModel):
    patient_email: EmailStr


class CaregiverPatientLinkResponse(BaseModel):
    id: int
    caregiver_id: int
    patient_id: int

    model_config = {"from_attributes": True}


class PatientDetailResponse(BaseModel):
    id: int
    email: EmailStr
    role: str
    created_at: datetime
    profile: PatientProfileResponse | None = None

    model_config = {"from_attributes": True}
