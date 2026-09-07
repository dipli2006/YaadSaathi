from datetime import datetime
from typing import Literal

from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    email: EmailStr
    password: str
    role: Literal["patient", "caregiver"]


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    id: int
    email: EmailStr
    role: str
    created_at: datetime

    model_config = {"from_attributes": True}  # enables ORM mode


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

