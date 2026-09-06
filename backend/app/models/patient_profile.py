from sqlalchemy import Column, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, relationship

from app.db.base import Base


class PatientProfile(Base):
    __tablename__ = "patient_profiles"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = Column(
        Integer, ForeignKey("users.id"), unique=True, nullable=False
    )
    name: Mapped[str] = Column(String, nullable=False)
    age: Mapped[int] = Column(Integer, nullable=False)
    condition_notes: Mapped[str | None] = Column(Text, nullable=True)

    user = relationship("User", backref="patient_profile")
