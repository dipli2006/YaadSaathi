from sqlalchemy.orm import declarative_base

# All SQLAlchemy models will import and inherit from Base.
# Do NOT import models here — that causes circular imports.
# Model imports live in app/db/init_db.py instead.
Base = declarative_base()
