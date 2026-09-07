from pydantic import BaseModel


class PatientProfileCreate(BaseModel):
    name: str
    age: int
    condition_notes: str | None = None


class PatientProfileResponse(BaseModel):
    id: int
    user_id: int
    name: str
    age: int
    condition_notes: str | None = None

    model_config = {"from_attributes": True}
