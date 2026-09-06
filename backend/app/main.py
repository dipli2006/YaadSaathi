from fastapi import FastAPI

from app.api.v1 import auth as auth_router
from app.api.v1 import caregiver as caregiver_router
from app.api.v1 import health as health_router
from app.api.v1 import memory as memory_router
from app.api.v1 import patient as patient_router
from app.api.v1 import reminder as reminder_router
from app.api.v1 import users
from app.db.init_db import init_db

app = FastAPI(
    title="YaadSaathi API",
    description="Backend API for YaadSaathi – your memory companion.",
    version="0.1.0",
)


@app.on_event("startup")
def on_startup() -> None:
    """Run database initialisation when the server starts."""
    init_db()


# ── Routers ────────────────────────────────────────────────────────────────────
app.include_router(health_router.router, prefix="/api/v1")
app.include_router(auth_router.router, prefix="/api/v1/auth")
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(patient_router.router, prefix="/api/v1/patients", tags=["patients"])
app.include_router(caregiver_router.router, prefix="/api/v1/caregiver", tags=["caregiver"])
app.include_router(memory_router.router, prefix="/api/v1/memories", tags=["memories"])
app.include_router(reminder_router.router, prefix="/api/v1/reminders", tags=["reminders"])



