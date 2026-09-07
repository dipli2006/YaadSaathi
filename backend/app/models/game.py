from datetime import datetime, timezone

from sqlalchemy import (
    Column,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, relationship

from app.db.base import Base


class GameSession(Base):
    __tablename__ = "game_sessions"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    patient_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    game_type: Mapped[str] = Column(String, nullable=False, index=True)  # "memory" | "remember_objects" | "sequence" | "association"
    difficulty: Mapped[str] = Column(String, nullable=False, default="EASY")  # "EASY" | "MEDIUM" | "HARD"
    started_at: Mapped[datetime] = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
        index=True,
    )
    completed_at: Mapped[datetime | None] = Column(DateTime(timezone=True), nullable=True)
    duration_seconds: Mapped[int | None] = Column(Integer, nullable=True)
    correct_count: Mapped[int] = Column(Integer, nullable=False, default=0)
    mistakes_count: Mapped[int] = Column(Integer, nullable=False, default=0)
    hints_used: Mapped[int] = Column(Integer, nullable=False, default=0)
    score_percentage: Mapped[float | None] = Column(Float, nullable=True)
    status: Mapped[str] = Column(String, nullable=False, default="STARTED")  # "STARTED" | "COMPLETED" | "ABANDONED"

    patient = relationship("User", foreign_keys=[patient_id])


class AdaptiveDifficultyState(Base):
    __tablename__ = "adaptive_difficulty_states"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    patient_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    game_type: Mapped[str] = Column(String, nullable=False, index=True)
    current_difficulty: Mapped[str] = Column(String, nullable=False, default="EASY")
    updated_at: Mapped[datetime] = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    __table_args__ = (
        UniqueConstraint("patient_id", "game_type", name="uq_patient_game_type"),
    )

    patient = relationship("User", foreign_keys=[patient_id])
