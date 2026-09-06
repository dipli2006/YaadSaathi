from datetime import datetime, timezone

from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, relationship

from app.db.base import Base


class Memory(Base):
    __tablename__ = "memories"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    patient_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False)
    title: Mapped[str] = Column(String, nullable=False)
    content: Mapped[str] = Column(Text, nullable=False)
    created_at: Mapped[datetime] = Column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        nullable=False,
    )

    patient = relationship("User", foreign_keys=[patient_id])
