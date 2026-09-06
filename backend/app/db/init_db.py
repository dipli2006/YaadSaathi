from app.db.base import Base
from app.db.session import engine

# Import all models here so Base.metadata is populated before create_all().
from app.models import caregiver_patient, memory, patient_profile, reminder, user  # noqa: F401


def init_db() -> None:
    """Create all tables that don't yet exist in the database."""
    Base.metadata.create_all(bind=engine)


