"""
YaadSaathi Voice Pipeline
Speech in -> Text -> AI Response -> Speech out (auto-plays the reply)

Uses speech_client.py (Groq Whisper + gTTS) for the voice parts,
and a simple rule-based AI response for now.

NOTE: .m4a files work directly with Groq's Whisper — no conversion needed.
"""

import os
import platform
import subprocess

from speech_client import transcribe, speak

# Caregiver-provided facts — the AI should ONLY answer from this,
# never invent information beyond what's here.
FAMILY_INFO = {
    "anu": "Anu is your daughter.",
    "ravi": "Ravi is your son.",
}

# Words that should trigger a safe refusal instead of an answer.
# Includes both English and Hindi phrasing — the English-only version
# missed Hindi diagnosis/medical requests during testing.
UNSAFE_WORDS = [
    # English
    "diagnose", "disease", "dementia", "cure", "stop taking", "dosage",
    # Hindi (Devanagari script)
    "डिमेंशिया",   # dementia
    "बीमारी",       # disease
    "इलाज",         # cure/treatment
    "दवा बंद",      # stop medicine
    "निदान",        # diagnosis
]


def get_ai_response(user_text):
    """
    Decides how to respond to what the patient said.
    Checks safety first, then looks for a known family member,
    otherwise honestly says it doesn't know.
    """
    text = user_text.lower()

    for word in UNSAFE_WORDS:
        if word.lower() in text:
            return "I'm not able to help with that. Please speak with a doctor about this."

    for name, fact in FAMILY_INFO.items():
        if name in text:
            return fact

    return "I don't have that information right now."


def play_audio(path):
    """
    Plays an audio file automatically using the OS's default player.
    Works on Windows, Mac, and Linux without extra packages.
    """
    system = platform.system()
    try:
        if system == "Windows":
            os.startfile(path)
        elif system == "Darwin":  # Mac
            subprocess.run(["open", path])
        else:  # Linux
            subprocess.run(["xdg-open", path])
    except Exception as e:
        print(f"(Could not auto-play audio: {e}. Open {path} manually.)")


def run_pipeline(audio_path, lang):
    """
    Runs one full loop: audio file in -> transcript -> AI response ->
    spoken reply out -> auto-plays the reply.
    audio_path: path to a real short audio recording (.m4a, .wav, .mp3 all work)
    lang: "en" or "hi"
    """
    transcript = transcribe(audio_path, lang)
    print("You said:", transcript)

    response = get_ai_response(transcript)
    print("AI response:", response)

    output_file = speak(response, lang, output_path=f"reply_{lang}.mp3")
    print("Spoken reply saved to:", output_file)

    print("Playing reply...")
    play_audio(output_file)

    return transcript, response, output_file


if __name__ == "__main__":
    # Point this at your actual recorded file — .m4a works directly
    run_pipeline("testing_audios/hindi_diagnosis_test.mp3", "en")