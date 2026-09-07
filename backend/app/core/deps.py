from fastapi import Depends, HTTPException, Request, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.db.session import get_db
from app.models.user import User
from app.services.user_service import get_user_by_email

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login", auto_error=False)


def get_current_user(
    request: Request,
    token: str | None = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> User:
    """Extract and validate JWT token from HTTP-only cookie or Authorization header."""
    invalid_token_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Session expired or invalid. Please log in again.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    # Check HTTP-only cookie first, fallback to Bearer header token
    raw_token = request.cookies.get("access_token") or token
    if not raw_token:
        raise invalid_token_exception

    # Strip 'Bearer ' prefix if cookie contains prefix
    if raw_token.startswith("Bearer "):
        raw_token = raw_token.split(" ", 1)[1]

    try:
        payload = decode_access_token(raw_token)
        email: str | None = payload.get("sub")
        if email is None:
            raise invalid_token_exception
    except JWTError:
        raise invalid_token_exception

    user = get_user_by_email(db, email=email)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return user


