from datetime import datetime
from typing import Literal

from pydantic import BaseModel, Field


class GameSessionCreate(BaseModel):
    game_type: Literal["memory", "remember_objects", "sequence", "association"]
    difficulty: Literal["EASY", "MEDIUM", "HARD"] | None = None


class GameSessionComplete(BaseModel):
    correct_count: int = Field(default=0, ge=0)
    mistakes_count: int = Field(default=0, ge=0)
    hints_used: int = Field(default=0, ge=0)
    duration_seconds: int | None = Field(default=None, ge=0)
    status: Literal["COMPLETED", "ABANDONED"] = "COMPLETED"


class GameSessionResponse(BaseModel):
    id: int
    patient_id: int
    game_type: str
    difficulty: str
    started_at: datetime
    completed_at: datetime | None = None
    duration_seconds: int | None = None
    correct_count: int
    mistakes_count: int
    hints_used: int
    score_percentage: float | None = None
    status: str

    model_config = {"from_attributes": True}


class RecommendedDifficultyResponse(BaseModel):
    patient_id: int
    game_type: str
    recommended_difficulty: str
    updated_at: datetime

    model_config = {"from_attributes": True}


class PatientAnalyticsSummary(BaseModel):
    patient_id: int
    activities_completed_this_week: int
    hints_used_this_week: int
    recent_activities: list[GameSessionResponse]

    model_config = {"from_attributes": True}
