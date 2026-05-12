# Crear instalador Windows para Video2Text

Este documento explica cómo generar un instalador tipo `Setup.exe` para instalar Video2Text en otro PC.

El flujo es:

1. PyInstaller convierte la app Python en una carpeta ejecutable con `Video2Text.exe`.
2. Inno Setup empaqueta esa carpeta en un instalador `Video2Text-Setup.exe`.
3. El usuario final ejecuta el instalador, elige carpeta y queda con acceso directo.

## Requisitos del PC donde compilarás

- Windows 10/11.
- Python 3.12.
- Git.
- Inno Setup 6.
- Conexión a internet para instalar dependencias.

Instalar Inno Setup con winget:

```powershell
winget install JRSoftware.InnoSetup
```

## 1. Actualizar el repo

Desde la carpeta del proyecto:

```powershell
git pull
```

## 2. Crear o actualizar el entorno

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-windows.ps1
```

## 3. Crear solo el EXE portable

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-exe-windows.ps1
```

Resultado:

```text
dist\Video2Text\Video2Text.exe
```

Esa carpeta se puede copiar completa a otro PC, pero todavía no es un instalador.

## 4. Crear el instalador Setup

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-installer-windows.ps1
```

Resultado:

```text
installer\Video2Text-Setup.exe
```

Ese es el archivo que puedes entregar a otra persona.

## 5. Probar el instalador

1. Abre `installer\Video2Text-Setup.exe`.
2. Elige carpeta de instalación.
3. Marca crear acceso directo en escritorio si lo deseas.
4. Al finalizar, abre Video2Text desde el menú inicio o acceso directo.

## Notas importantes

- El instalador incluye la app y sus dependencias Python.
- La primera descarga del modelo Whisper puede ocurrir en el PC del usuario final.
- La app sigue necesitando internet para descargar videos desde URL.
- Para videos protegidos por sesión, el usuario puede usar cookies del navegador desde la app.
- Si Windows SmartScreen muestra advertencia, puede ocurrir porque el instalador no está firmado digitalmente.

## Firma digital

Para distribución profesional, lo ideal es firmar el `.exe` y el instalador con un certificado de firma de código. Sin firma, Windows puede mostrar advertencias de seguridad aunque el archivo sea legítimo.
