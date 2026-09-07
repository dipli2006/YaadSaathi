from datetime import datetime, timezone

from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, relationship

from app.db.base import Base


class Reminder(Base):
    __tablename__ = "reminders"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    patient_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False)
    text: Mapped[str] = Column(String, nullable=False)
    scheduled_time: Mapped[datetime] = Column(DateTime(timezone=True), nullable=False)
    created_by: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False)
    is_completed: Mapped[bool] = Column(Boolean, default=False, nullable=False)

    patient = relationship("User", foreign_keys=[patient_id])
    creator = relationship("User", foreign_keys=[created_by])
