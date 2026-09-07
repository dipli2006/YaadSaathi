from pydantic import BaseModel, Field


class AssistantRequest(BaseModel):
    message: str = Field(min_length=1, max_length=2000)
    language: str = Field(default="en", pattern="^(en|hi)$")


class AssistantResponse(BaseModel):
    reply: str
    intent: str
