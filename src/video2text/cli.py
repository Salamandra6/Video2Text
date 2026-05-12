from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

from video2text.downloader import download_audio
from video2text.transcriber import transcribe_audio


SAFE_NAME_PATTERN = re.compile(r"[^a-zA-Z0-9._-]+")


def safe_folder_name(value: str, fallback: str = "video") -> str:
    value = value.strip() or fallback
    value = SAFE_NAME_PATTERN.sub("_", value)
    return value[:120].strip("._-") or fallback


def save_metadata(metadata: dict[str, Any], output_dir: Path) -> None:
    keep_keys = [
        "id",
        "title",
        "webpage_url",
        "extractor",
        "duration",
        "uploader",
        "upload_date",
        "description",
    ]
    clean_metadata = {key: metadata.get(key) for key in keep_keys if key in metadata}
    (output_dir / "metadata.json").write_text(
        json.dumps(clean_metadata, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="video2text",
        description="Descarga un video/audio desde internet y lo transcribe localmente.",
    )
    parser.add_argument("url", help="URL del video o audio que quieres transcribir")
    parser.add_argument(
        "--output-dir",
        default="outputs",
        help="Carpeta base donde se guardarán las descargas y transcripciones",
    )
    parser.add_argument(
        "--model-size",
        default="small",
        choices=["tiny", "base", "small", "medium", "large-v1", "large-v2", "large-v3"],
        help="Modelo local de Whisper a utilizar",
    )
    parser.add_argument(
        "--language",
        default="es",
        help="Idioma del audio. Usa 'es', 'en', 'pt', etc. Usa 'auto' para detectar.",
    )
    parser.add_argument(
        "--device",
        default="cpu",
        choices=["cpu", "cuda"],
        help="Dispositivo de transcripción. Usa cuda solo si tienes GPU NVIDIA configurada.",
    )
    parser.add_argument(
        "--compute-type",
        default="int8",
        help="Tipo de cómputo para faster-whisper. En CPU, 'int8' suele funcionar bien.",
    )
    parser.add_argument(
        "--cookies-from-browser",
        default=None,
        help="Usa cookies del navegador para sitios que requieren sesión. Ej: chrome, edge, firefox.",
    )
    return parser


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    base_output_dir = Path(args.output_dir)
    downloads_dir = base_output_dir / "downloads"

    print("[1/3] Descargando audio/video...")
    media_path, metadata = download_audio(
        args.url,
        downloads_dir,
        cookies_from_browser=args.cookies_from_browser,
    )

    title = str(metadata.get("title") or metadata.get("id") or "video")
    video_id = str(metadata.get("id") or "")
    result_folder = safe_folder_name(f"{title}_{video_id}" if video_id else title)
    final_output_dir = base_output_dir / result_folder
    final_output_dir.mkdir(parents=True, exist_ok=True)

    save_metadata(metadata, final_output_dir)

    print(f"[2/3] Transcribiendo localmente con modelo {args.model_size}...")
    language = None if args.language.lower() == "auto" else args.language
    result = transcribe_audio(
        audio_path=media_path,
        output_dir=final_output_dir,
        model_size=args.model_size,
        language=language,
        device=args.device,
        compute_type=args.compute_type,
    )

    print("[3/3] Listo.")
    print(f"Archivo descargado: {media_path}")
    print(f"Transcripción TXT: {result['txt_path']}")
    print(f"Subtítulos SRT: {result['srt_path']}")
    print(f"Segmentos JSON: {result['json_path']}")
    print(f"Idioma detectado: {result['language']} ({result['language_probability']:.2%})")


if __name__ == "__main__":
    main()
