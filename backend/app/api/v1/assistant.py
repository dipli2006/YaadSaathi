from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.caregiver_patient import CaregiverPatient
from app.models.memory import Memory
from app.models.reminder import Reminder
from app.models.user import User
from app.schemas.assistant import AssistantRequest, AssistantResponse

router = APIRouter(tags=["assistant"])


def patient_id_for_user(user: User, db: Session) -> int:
    if user.role == "patient":
        return user.id
    link = (
        db.query(CaregiverPatient)
        .filter(CaregiverPatient.caregiver_id == user.id)
        .first()
    )
    return link.patient_id if link else user.id


def contains_any(message: str, terms: tuple[str, ...]) -> bool:
    return any(term in message for term in terms)


@router.post("/message", response_model=AssistantResponse)
def assistant_message(
    payload: AssistantRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> AssistantResponse:
    message = payload.message.strip().lower()
    language = payload.language
    patient_id = patient_id_for_user(current_user, db)

    if contains_any(
        message,
        ("diagnose", "dementia", "cure", "medicine dose", "डिमेंशिया", "निदान", "इलाज"),
    ):
        return AssistantResponse(
            reply=(
                "I cannot give medical advice. Please speak with your caregiver or a qualified professional."
                if language == "en"
                else "मैं चिकित्सीय सलाह नहीं दे सकता। कृपया अपने देखभालकर्ता या योग्य चिकित्सक से बात करें।"
            ),
            intent="UNKNOWN",
        )

    if contains_any(message, ("reminder", "remind", "medicine", "दवा")):
        reminder = (
            db.query(Reminder)
            .filter(Reminder.patient_id == patient_id, Reminder.is_completed.is_(False))
            .order_by(Reminder.scheduled_time.asc())
            .first()
        )
        if reminder is None:
            reply = "I do not have any active reminders." if language == "en" else "अभी कोई सक्रिय रिमाइंडर नहीं है।"
        else:
            reply = (
                f"Your next reminder is {reminder.text}."
                if language == "en"
                else f"आपका अगला रिमाइंडर {reminder.text} है।"
            )
        return AssistantResponse(reply=reply, intent="REMINDER_LOOKUP")

    if contains_any(message, ("memory", "remember", "photo", "याद", "फोटो")):
        memory = (
            db.query(Memory)
            .filter(Memory.patient_id == patient_id)
            .order_by(Memory.created_at.desc())
            .first()
        )
        if memory is None:
            reply = "I do not have that memory yet." if language == "en" else "मेरे पास अभी यह याद नहीं है।"
        else:
            reply = (
                f"{memory.title}: {memory.content}."
                if language == "en"
                else f"{memory.title}: {memory.content}।"
            )
        return AssistantResponse(reply=reply, intent="MEMORY_LOOKUP")

    if contains_any(message, ("who is", "family", "son", "daughter", "कौन", "बेटा", "बेटी")):
        memory = (
            db.query(Memory)
            .filter(Memory.patient_id == patient_id)
            .order_by(Memory.created_at.desc())
            .first()
        )
        reply = (
            f"{memory.content}."
            if memory is not None
            else ("I do not have that family information." if language == "en" else "मेरे पास यह परिवार की जानकारी नहीं है।")
        )
        return AssistantResponse(reply=reply, intent="PERSON_LOOKUP")

    return AssistantResponse(
        reply=(
            "I am here to listen. You can ask about family, memories, or reminders."
            if language == "en"
            else "मैं आपकी बात सुनने के लिए यहां हूं। आप परिवार, यादों या रिमाइंडर के बारे में पूछ सकते हैं।"
        ),
        intent="GENERAL_CONVERSATION",
    )
