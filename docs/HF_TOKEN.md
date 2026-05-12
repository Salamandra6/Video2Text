# Configurar HF_TOKEN para Video2Text

Video2Text puede funcionar sin `HF_TOKEN`, pero Hugging Face puede mostrar este aviso cuando descarga modelos por primera vez:

```text
Please set a HF_TOKEN to enable higher rate limits and faster downloads
```

No es un error. Significa que puedes autenticarte para tener mejores límites de descarga y una experiencia más estable.

## 1. Crear una cuenta en Hugging Face

1. Entra a Hugging Face.
2. Crea una cuenta o inicia sesión.
3. Abre tu perfil y entra a `Settings`.
4. Busca la sección `Access Tokens`.

## 2. Crear un token

1. Presiona `New token`.
2. Asígnale un nombre, por ejemplo: `Video2Text-PC`.
3. Selecciona permiso `Read`.
4. Crea el token.
5. Copia el valor que empieza con `hf_...`.

Nunca subas tu token a GitHub ni lo compartas en capturas de pantalla.

## 3. Activarlo temporalmente en PowerShell

Esto sirve solo para la ventana actual de PowerShell:

```powershell
$env:HF_TOKEN="hf_TU_TOKEN_AQUI"
```

Luego ejecuta Video2Text normalmente:

```powershell
video2text "URL_DEL_VIDEO" --language auto --model-size small
```

## 4. Guardarlo permanentemente en Windows

Para guardarlo en tu usuario de Windows:

```powershell
setx HF_TOKEN "hf_TU_TOKEN_AQUI"
```

Después de usar `setx`, cierra PowerShell y ábrelo de nuevo.

Activa tu entorno virtual:

```powershell
.\.venv\Scripts\Activate.ps1
```

Y prueba:

```powershell
video2text --help
```

## 5. Verificar que quedó guardado

En una nueva ventana de PowerShell:

```powershell
echo $env:HF_TOKEN
```

Si aparece tu token, está activo. Si no aparece, vuelve a ejecutar `setx` y abre una nueva ventana.

## 6. Borrar el token si lo necesitas

Para quitarlo de la sesión actual:

```powershell
Remove-Item Env:HF_TOKEN
```

Para quitarlo de forma permanente desde Windows, abre:

```text
Editar las variables de entorno de tu cuenta
```

Luego elimina la variable `HF_TOKEN`.

## 7. Uso recomendado

Para videos con varios idiomas, usa detección automática:

```powershell
video2text "URL_DEL_VIDEO" --language auto --model-size small
```

Para mayor precisión, si tu computador tiene recursos suficientes:

```powershell
video2text "URL_DEL_VIDEO" --language auto --model-size medium
```

## 8. Notas importantes

- `HF_TOKEN` ayuda con límites y descargas desde Hugging Face.
- La descarga del modelo ocurre normalmente solo la primera vez.
- Después, el modelo queda en caché local.
- Video2Text sigue transcribiendo localmente en tu computador.
- No guardes tokens reales en archivos del repositorio.
