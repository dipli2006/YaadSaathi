from datetime import datetime, timedelta, timezone
import bcrypt
from jose import jwt
from passlib.context import CryptContext

from app.core.config import settings

# Fix passlib compatibility with bcrypt >= 4.0.0
if not hasattr(bcrypt, "__about__"):
    bcrypt.__about__ = type("about", (), {"__version__": getattr(bcrypt, "__version__", "4.0.0")})

if not getattr(bcrypt.hashpw, "_is_safe", False):
    _orig_hashpw = bcrypt.hashpw

    def _safe_hashpw(password, salt):
        if isinstance(password, bytes) and len(password) > 72:
            password = password[:72]
        elif isinstance(password, str) and len(password.encode("utf-8")) > 72:
            password = password.encode("utf-8")[:72].decode("utf-8", errors="ignore")
        return _orig_hashpw(password, salt)

    _safe_hashpw._is_safe = True
    bcrypt.hashpw = _safe_hashpw

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)


def hash_password(password: str) -> str:
    # bcrypt supports max 72 bytes
    password = password.encode("utf-8")[:72].decode("utf-8", errors="ignore")
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    plain_password = plain_password.encode("utf-8")[:72].decode("utf-8", errors="ignore")
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict) -> str:
    """Encode a JWT with an expiry claim, signed with SECRET_KEY."""
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    )
    to_encode["exp"] = expire
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)


def decode_access_token(token: str) -> dict:
    """Decode a JWT access token and return its payload dictionary."""
    return jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])



