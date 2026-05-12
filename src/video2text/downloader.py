from __future__ import annotations

from pathlib import Path
from typing import Any

from yt_dlp import YoutubeDL


def download_audio(
    url: str,
    output_dir: Path,
    cookies_from_browser: str | None = None,
) -> tuple[Path, dict[str, Any]]:
    """Download best available audio for a URL and return the local file path plus metadata."""
    output_dir.mkdir(parents=True, exist_ok=True)

    ydl_opts: dict[str, Any] = {
        "format": "bestaudio/best",
        "outtmpl": str(output_dir / "%(title).120s [%(id)s].%(ext)s"),
        "noplaylist": True,
        "quiet": False,
        "no_warnings": False,
        "restrictfilenames": True,
        "ignoreerrors": False,
    }

    if cookies_from_browser:
        ydl_opts["cookiesfrombrowser"] = (cookies_from_browser,)

    with YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        if info is None:
            raise RuntimeError("yt-dlp no pudo obtener información del video.")

        downloaded = Path(ydl.prepare_filename(info))

    if not downloaded.exists():
        # Some extractors/postprocessors may alter the extension. Search by title/id stem.
        video_id = info.get("id", "")
        candidates = sorted(output_dir.glob(f"*[{video_id}].*")) if video_id else []
        if candidates:
            downloaded = candidates[0]

    if not downloaded.exists():
        raise FileNotFoundError("No se encontró el archivo descargado.")

    return downloaded, info
