from datetime import datetime
from pydantic import BaseModel


class ReminderCreate(BaseModel):
    patient_id: int
    text: str
    scheduled_time: datetime


class ReminderResponse(BaseModel):
    id: int
    patient_id: int
    text: str
    scheduled_time: datetime
    created_by: int
    is_completed: bool

    model_config = {"from_attributes": True}
