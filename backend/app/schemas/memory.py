from datetime import datetime
from pydantic import BaseModel


class MemoryCreate(BaseModel):
    title: str
    content: str


class MemoryResponse(BaseModel):
    id: int
    patient_id: int
    title: str
    content: str
    created_at: datetime

    model_config = {"from_attributes": True}
