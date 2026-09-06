from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from app.core.security import create_access_token, verify_password
from app.db.session import get_db
from app.schemas.user import Token, UserCreate, UserLogin, UserResponse
from app.services.user_service import create_user, get_user_by_email

router = APIRouter(tags=["auth"])


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new user",
)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    """Create a new patient or caregiver account."""
    if get_user_by_email(db, user_data.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="A user with this email already exists.",
        )
    return create_user(db, user_data)


@router.post(
    "/login",
    response_model=Token,
    summary="Login and receive a JWT access token",
)
def login(user_data: UserLogin, response: Response, db: Session = Depends(get_db)):
    """Verify credentials, set an HTTP-only access_token cookie, and return JWT."""
    user = get_user_by_email(db, user_data.email)
    if not user or not verify_password(user_data.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    token = create_access_token({"sub": user.email, "role": user.role})

    # Set HTTP-only secure cookie
    response.set_cookie(
        key="access_token",
        value=f"Bearer {token}",
        httponly=True,
        secure=False,  # Set to True in production (HTTPS)
        samesite="lax",
    )
    return {"access_token": token, "token_type": "bearer"}


@router.post(
    "/logout",
    summary="Logout user and clear authentication cookie",
)
def logout(response: Response):
    """Clear access_token HTTP-only cookie."""
    response.delete_cookie(key="access_token", httponly=True, samesite="lax")
    return {"status": "success", "message": "Successfully logged out"}


