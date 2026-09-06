from fastapi import FastAPI

from app.api.v1 import auth as auth_router
from app.api.v1 import health as health_router
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
