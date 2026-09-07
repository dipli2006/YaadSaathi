from sqlalchemy import Column, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import Mapped, relationship

from app.db.base import Base


class CaregiverPatient(Base):
    __tablename__ = "caregiver_patients"

    id: Mapped[int] = Column(Integer, primary_key=True, index=True)
    caregiver_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False)
    patient_id: Mapped[int] = Column(Integer, ForeignKey("users.id"), nullable=False)

    __table_args__ = (
        UniqueConstraint("caregiver_id", "patient_id", name="uq_caregiver_patient"),
    )

    caregiver = relationship("User", foreign_keys=[caregiver_id])
    patient = relationship("User", foreign_keys=[patient_id])
