# Video2Text

Convierte videos de internet en texto usando una canalización local:

1. Descarga el audio/video desde una URL compatible con `yt-dlp`.
2. Transcribe el audio localmente con `faster-whisper`.
3. Guarda resultados en `.txt`, `.srt` y `.json`.

> Uso responsable: usa esta herramienta solo con contenido propio, autorizado o permitido por la ley y por los términos del sitio de origen.

## Requisitos

- Python 3.10 o superior.
- Conexión a internet para descargar el video/audio.
- Conexión a internet la primera vez que se descargue el modelo de Whisper.
- Opcional: FFmpeg instalado si quieres que `yt-dlp` haga conversiones o fusiones avanzadas.

## Instalación en Windows PowerShell

```powershell
git clone https://github.com/Salamandra6/Video2Text.git
cd Video2Text
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -e .
```

## Uso básico

```powershell
video2text "https://www.youtube.com/watch?v=VIDEO_ID" --language es --model-size small
```

Los resultados quedarán en la carpeta `outputs/`.

## Instagram, TikTok u otros sitios con sesión

Algunos sitios bloquean descargas anónimas. En esos casos puedes intentar usar cookies del navegador:

```powershell
video2text "URL_DEL_VIDEO" --cookies-from-browser chrome
```

También puedes cambiar `chrome` por `edge`, `firefox`, etc., según tu navegador.

## Modelos recomendados

- `tiny`: más rápido, menor precisión.
- `base`: equilibrio básico.
- `small`: buena opción inicial en CPU.
- `medium`: más precisión, más lento.
- `large-v3`: mejor calidad, requiere más recursos.

Ejemplo:

```powershell
video2text "URL" --language es --model-size medium
```

## Modo local

La descarga del video/audio necesita internet. La transcripción se ejecuta localmente en tu computador. La primera vez que uses un modelo, `faster-whisper` puede descargarlo y guardarlo en caché; después puede reutilizarlo sin volver a descargarlo.

## Salidas generadas

Por cada video se crean:

- `transcript.txt`: texto limpio.
- `segments.json`: segmentos con tiempo de inicio y término.
- `subtitles.srt`: subtítulos.
- `metadata.json`: información básica del video.
