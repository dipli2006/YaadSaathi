from sqlalchemy.orm import Session

from app.models.memory import Memory
from app.schemas.memory import MemoryCreate


def create_memory(
    db: Session, patient_id: int, memory_data: MemoryCreate
) -> Memory:
    """Create a new memory entry for a patient."""
    memory = Memory(
        patient_id=patient_id,
        title=memory_data.title,
        content=memory_data.content,
    )
    db.add(memory)
    db.commit()
    db.refresh(memory)
    return memory


def get_patient_memories(db: Session, patient_id: int) -> list[Memory]:
    """Retrieve all memories for a given patient ordered by creation time (descending)."""
    return (
        db.query(Memory)
        .filter(Memory.patient_id == patient_id)
        .order_by(Memory.created_at.desc())
        .all()
    )
