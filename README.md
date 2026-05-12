# Video2Text

Convierte videos de internet en texto usando una canalización local:

1. Descarga el audio/video desde una URL compatible con `yt-dlp`.
2. Transcribe el audio localmente con `faster-whisper`.
3. Guarda resultados en `.txt`, `.srt`, `.json` y `.docx`.
4. Incluye aplicación de escritorio para Windows con estilo hacker cinematográfico.

> Uso responsable: usa esta herramienta solo con contenido propio, autorizado o permitido por la ley y por los términos del sitio de origen.

## Requisitos

- Python 3.12 recomendado.
- Git.
- Conexión a internet para descargar el video/audio.
- Conexión a internet la primera vez que se descargue el modelo de Whisper.
- Opcional: FFmpeg instalado si quieres que `yt-dlp` haga conversiones o fusiones avanzadas.
- Opcional: `HF_TOKEN` de Hugging Face para mejores límites de descarga de modelos.

> Nota: Python 3.14 puede ser demasiado reciente para algunas dependencias de IA/audio. Para este proyecto se recomienda Python 3.12.

## Instalación rápida en Windows PowerShell

```powershell
git clone https://github.com/Salamandra6/Video2Text.git
cd Video2Text
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
```

Luego activa el entorno:

```powershell
.\.venv\Scripts\Activate.ps1
```

Prueba el comando:

```powershell
video2text --help
```

## Instalación manual en Windows PowerShell

```powershell
git clone https://github.com/Salamandra6/Video2Text.git
cd Video2Text
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip setuptools wheel
pip install -e .
```

## Ejecutar aplicación de escritorio

Desde la carpeta del proyecto:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run-desktop-windows.ps1
```

O manualmente:

```powershell
.\.venv\Scripts\Activate.ps1
python -m video2text.desktop_app
```

También puedes crear un acceso directo en el escritorio:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-desktop-shortcut-windows.ps1
```

La aplicación de escritorio incluye:

- `Cargar Archivo (video)`
- `Pegar URL`
- `Procesar Video`
- `Descargar TXT`
- `Descargar Word`
- Pantalla de transcripción en tiempo real

## Uso por consola

```powershell
video2text "https://www.youtube.com/watch?v=VIDEO_ID" --language es --model-size small
```

Para videos con varios idiomas, usa detección automática:

```powershell
video2text "https://www.youtube.com/watch?v=VIDEO_ID" --language auto --model-size small
```

Los resultados quedarán en la carpeta `outputs/`.

## Instagram, TikTok u otros sitios con sesión

Algunos sitios bloquean descargas anónimas. En esos casos puedes intentar usar cookies del navegador:

```powershell
video2text "URL_DEL_VIDEO" --cookies-from-browser chrome
```

También puedes cambiar `chrome` por `edge`, `firefox`, etc., según tu navegador.

## HF_TOKEN de Hugging Face

Video2Text puede funcionar sin `HF_TOKEN`, pero Hugging Face puede mostrar este aviso al descargar modelos:

```text
Please set a HF_TOKEN to enable higher rate limits and faster downloads
```

No es un error. Para configurarlo paso a paso, revisa:

```text
docs/HF_TOKEN.md
```

Uso temporal en PowerShell:

```powershell
$env:HF_TOKEN="hf_TU_TOKEN_AQUI"
```

Uso permanente en Windows:

```powershell
setx HF_TOKEN "hf_TU_TOKEN_AQUI"
```

Después de `setx`, cierra PowerShell y ábrelo de nuevo.

## Modelos recomendados

- `tiny`: más rápido, menor precisión.
- `base`: equilibrio básico.
- `small`: buena opción inicial en CPU.
- `medium`: más precisión, más lento.
- `large-v3`: mejor calidad, requiere más recursos.

Ejemplo:

```powershell
video2text "URL" --language auto --model-size medium
```

## Modo local

La descarga del video/audio necesita internet. La transcripción se ejecuta localmente en tu computador. La primera vez que uses un modelo, `faster-whisper` puede descargarlo y guardarlo en caché; después puede reutilizarlo sin volver a descargarlo.

## Salidas generadas

Por cada video se crean:

- `transcript.txt`: texto limpio.
- `segments.json`: segmentos con tiempo de inicio y término.
- `subtitles.srt`: subtítulos.
- `transcript.docx`: documento Word.
- `metadata.json`: información básica del video.

## Actualizar dependencias

Con el entorno activado:

```powershell
pip install -U yt-dlp
pip install -e .
```
