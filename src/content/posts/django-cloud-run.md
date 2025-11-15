---
title: "Deploy Django en Cloud Run"
author: Mariano Bianchi
description: Un paso a paso sencillo sobre como hacer tu primer deploy de una app Django en Cloud Run
pubDate: 2025-11-17
draft: false
---

## Deploy Django en Cloud Run

En este post te muestro cómo desplegar un proyecto Django en Google Cloud Run de la forma más simple posible. Primero veremos cómo hacerlo usando la CLI de Google Cloud y luego cómo automatizar el deploy usando GitHub Actions.

---

## Requisitos previos

- Tener una cuenta de Google Cloud y un proyecto creado.
- Instalar [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) y autenticarte (`gcloud auth login`).
- Tener Docker instalado.
- Un proyecto Django listo para desplegar (puede ser uno nuevo creado con `django-admin startproject`).

---

## 1. Deploy usando la CLI de Google Cloud

### 1.1. Prepara tu proyecto Django

1. **Agrega un `Dockerfile`** en la raíz del proyecto:

   ```dockerfile
   # Dockerfile
   FROM python:3.11-slim
   ENV PYTHONDONTWRITEBYTECODE=1
   ENV PYTHONUNBUFFERED=1
   WORKDIR /app
   COPY requirements.txt .
   RUN pip install --upgrade pip && pip install -r requirements.txt
   COPY . .
   CMD gunicorn <tu_proyecto>.wsgi:application --bind 0.0.0.0:$PORT
   ```

   Cambia `<tu_proyecto>` por el nombre de tu carpeta principal de Django.

2. **Asegúrate de que tu `requirements.txt` incluya `gunicorn`.**

> **Sobre `ALLOWED_HOSTS`**
>
> Si vas a usar la URL generada por Cloud Run, podés definir el nombre de la instancia al hacer el deploy (por ejemplo, `django-app`). Así, la URL será del tipo `https://django-app-<project-number>-<region>.run.app`, donde `<project-number>` es el número de tu proyecto de Google Cloud. Podés dejar `ALLOWED_HOSTS = ["*"]` para pruebas, pero en producción es recomendable definirlo explícitamente o usar variables de entorno para mayor seguridad. Si ya sabés el nombre de la instancia y el número de proyecto, podés anticipar la URL y configurarlo así:
>
> ```python
> # settings.py
> ALLOWED_HOSTS = ["django-app-<project-number>-<region>.run.app"]
> ```

### 1.2. Construye y sube la imagen a Google Container Registry (GCR)

```bash
gcloud builds submit --tag gcr.io/<tu-proyecto-id>/django-app
```

### 1.3. Despliega en Cloud Run

```bash
gcloud run deploy django-app \
	--image gcr.io/<tu-proyecto-id>/django-app \
	--platform managed \
	--region us-central1 \
	--allow-unauthenticated \
```

Esto te dará una URL pública para tu app.

---

## Nota sobre la base de datos (Cloud SQL)

Si tu proyecto Django usa una base de datos (por ejemplo, PostgreSQL o MySQL en Cloud SQL), debes configurar la conexión entre tu servicio de Cloud Run y tu instancia de Cloud SQL. Hay dos formas comunes:

### a) Conexión por socket Unix (recomendada)

1. **Crea una instancia de Cloud SQL** y una base de datos para tu app.
2. **Agrega la variable de entorno** `DB_HOST` en Cloud Run con el valor `/cloudsql/<CONNECTION_NAME>`, donde `<CONNECTION_NAME>` es el identificador de tu instancia (lo ves en la consola de Cloud SQL).
3. **Agrega el permiso de Cloud SQL Client** a la Service Account que usa Cloud Run.
4. **Usa el driver estándar de tu base de datos** (por ejemplo, `psycopg2` para PostgreSQL, `mysqlclient` para MySQL). No es necesario instalar conectores adicionales.

### b) Conexión por IP pública o privada

1. **Habilita la IP pública o privada** en tu instancia de Cloud SQL.
2. **Agrega la IP de salida de Cloud Run** (o el rango de Google) a la lista de redes autorizadas en Cloud SQL.
3. **Configura la variable `DB_HOST`** con la IP pública o privada de la instancia.
4. **Usa el driver estándar de tu base de datos**.

Ejemplo de configuración en `settings.py`:

```python
import os
DATABASES = {
	'default': {
		'ENGINE': 'django.db.backends.postgresql',
		'HOST': os.environ.get('DB_HOST'),
		'USER': os.environ.get('DB_USER'),
		'PASSWORD': os.environ.get('DB_PASS'),
		'NAME': os.environ.get('DB_NAME'),
	}
}
```

Para que Cloud Run pueda conectarse a Cloud SQL usando el socket Unix, debes agregar la opción `--add-cloudsql-instances <your_db_instance_name>` al comando de deploy. El nombre de la instancia se obtiene desde la consola de Google Cloud y suele tener el formato `<instance>:<region>:<db_name>`.

> **Tip:** Si usas IP pública/privada, no necesitas la opción `--add-cloudsql-instances`, pero sí debes autorizar la red de salida de Cloud Run en la configuración de Cloud SQL.

---

## 2. Deploy automático con GitHub Actions

Puedes automatizar el deploy cada vez que haces push a `main` usando GitHub Actions.

### 2.1. Crea una Service Account y credenciales JSON

Te recomiendo crear una Service Account específica para GitHub Actions, por ejemplo llamada `github-actions`, y asignarle solo los permisos mínimos necesarios (por ejemplo: Cloud Run Admin, Storage Admin y Cloud SQL Client si usas base de datos). Así limitás el alcance de la clave y mejorás la seguridad.

1. En Google Cloud Console, crea la Service Account `github-actions` y asígnale los permisos necesarios.
2. Descarga la clave JSON y guárdala como secreto en tu repo de GitHub. Por convención, el secreto suele llamarse `GCP_SA_KEY`.

> **¿Qué es `GCP_SA_KEY`?**
>
> Es el secreto de GitHub que contiene el JSON de la clave privada de la Service Account. GitHub Actions lo usará para autenticarse y ejecutar los comandos de deploy en tu proyecto de Google Cloud.

### 2.2. Agrega el workflow de GitHub Actions

Crea el archivo `.github/workflows/deploy.yml` en tu repo:

```yaml
name: Deploy to Cloud Run
on:
	push:
		branches: [main]
jobs:
	deploy:
		runs-on: ubuntu-latest
		steps:
			- uses: actions/checkout@v3
			- uses: google-github-actions/auth@v2
				with:
					credentials_json: '${{ secrets.GCP_SA_KEY }}'
			- uses: google-github-actions/setup-gcloud@v2
			- run: gcloud --version
			- name: Build and push Docker image
				run: |
					gcloud builds submit --tag gcr.io/$GCP_PROJECT/django-app
				env:
					GCP_PROJECT: <tu-proyecto-id>
			- name: Deploy to Cloud Run
				run: |
					gcloud run deploy django-app \
						--image gcr.io/$GCP_PROJECT/django-app \
						--platform managed \
						--region us-central1 \
						--allow-unauthenticated \
                        --add-cloudsql-instances <your_db_instance_name>

				env:
					GCP_PROJECT: <tu-proyecto-id>
```

Reemplaza `<tu-proyecto-id>` por el ID de tu proyecto en Google Cloud.

---

## Recursos útiles

- [Documentación oficial de Cloud Run](https://cloud.google.com/run/docs/quickstarts/build-and-deploy)
- [Deploy Django en Cloud Run (Google Blog)](https://cloud.google.com/python/django/run)

---

¡Listo! Ahora tenés tu proyecto Django corriendo en Google Cloud Run, primero de forma manual y luego automatizada con GitHub Actions.
