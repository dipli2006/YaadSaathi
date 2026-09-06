"""
YaadSaathi Speech Client — Groq (STT) + Deepgram Flux TTS via OpenRouter
STT: hosted, fast, confirmed working, free tier.
TTS: hosted, English only, confirmed working, free tier.

SETUP:
    1. pip install groq openai
    2. Get a free Groq API key: console.groq.com/keys
    3. Get an OpenRouter API key: openrouter.ai/keys
    4. In your .env file:
       GROQ_API_KEY=your_groq_key_here
       OPENROUTER_API_KEY=your_openrouter_key_here
       STT_MODEL=whisper-large-v3
       TTS_MODEL=deepgram/flux-tts:free

NOTE: Deepgram Flux TTS is English-only (all voices end in "-en").
If you need Hindi TTS later, keep gTTS as a fallback for that language.
"""

import os
from dotenv import load_dotenv
from groq import Groq
from openai import OpenAI

load_dotenv()

STT_MODEL = os.environ.get("STT_MODEL", "whisper-large-v3")
TTS_MODEL = os.environ.get("TTS_MODEL", "deepgram/flux-tts:free")
TTS_VOICE = os.environ.get("TTS_VOICE", "flux-alexis-en")

groq_client = Groq(api_key=os.environ.get("GROQ_API_KEY"))

openrouter_client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=os.environ.get("OPENROUTER_API_KEY"),
)


def transcribe(audio_path, lang="en"):
    """
    Speech -> text using Groq's hosted Whisper.
    audio_path: path to your audio file (.m4a, .wav, .mp3 all work)
    """
    with open(audio_path, "rb") as f:
        result = groq_client.audio.transcriptions.create(
            file=f,
            model=STT_MODEL,
            language=lang,
        )
    return result.text.strip()


def speak(text, lang="en", output_path="response.mp3"):
    """
    Text -> speech using Deepgram Flux TTS via OpenRouter.
    English only — lang param kept for shape-compatibility with pipeline.py.
    """
    response = openrouter_client.audio.speech.create(
        model=TTS_MODEL,
        voice=TTS_VOICE,
        input=text,
    )
    response.stream_to_file(output_path)
    return output_path