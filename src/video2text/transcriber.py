from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from faster_whisper import WhisperModel


def format_timestamp(seconds: float) -> str:
    """Convert seconds to SRT timestamp format."""
    milliseconds = int(round(seconds * 1000))
    hours, remainder = divmod(milliseconds, 3_600_000)
    minutes, remainder = divmod(remainder, 60_000)
    secs, millis = divmod(remainder, 1000)
    return f"{hours:02}:{minutes:02}:{secs:02},{millis:03}"


def write_srt(segments: list[dict[str, Any]], output_path: Path) -> None:
    lines: list[str] = []
    for index, segment in enumerate(segments, start=1):
        start = format_timestamp(float(segment["start"]))
        end = format_timestamp(float(segment["end"]))
        text = str(segment["text"]).strip()
        lines.extend([str(index), f"{start} --> {end}", text, ""])
    output_path.write_text("\n".join(lines), encoding="utf-8")


def transcribe_audio(
    audio_path: Path,
    output_dir: Path,
    model_size: str = "small",
    language: str | None = "es",
    device: str = "cpu",
    compute_type: str = "int8",
) -> dict[str, Any]:
    """Transcribe audio locally with faster-whisper and save TXT, JSON and SRT outputs."""
    output_dir.mkdir(parents=True, exist_ok=True)

    model = WhisperModel(model_size, device=device, compute_type=compute_type)

    segments_iter, info = model.transcribe(
        str(audio_path),
        language=language,
        vad_filter=True,
        beam_size=5,
    )

    segments: list[dict[str, Any]] = []
    full_text_parts: list[str] = []

    for segment in segments_iter:
        item = {
            "id": segment.id,
            "start": segment.start,
            "end": segment.end,
            "text": segment.text.strip(),
        }
        segments.append(item)
        full_text_parts.append(item["text"])

    transcript = "\n".join(full_text_parts).strip() + "\n"

    txt_path = output_dir / "transcript.txt"
    json_path = output_dir / "segments.json"
    srt_path = output_dir / "subtitles.srt"

    txt_path.write_text(transcript, encoding="utf-8")
    json_path.write_text(json.dumps(segments, ensure_ascii=False, indent=2), encoding="utf-8")
    write_srt(segments, srt_path)

    return {
        "language": info.language,
        "language_probability": info.language_probability,
        "duration": info.duration,
        "txt_path": str(txt_path),
        "json_path": str(json_path),
        "srt_path": str(srt_path),
        "segments": len(segments),
    }
