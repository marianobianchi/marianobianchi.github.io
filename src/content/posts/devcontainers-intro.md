---
title: "Devcontainers: introducción"
author: Mariano Bianchi
description: Devcontainers es una forma moderna y eficiente de usar contenedores Docker para crear entornos de desarrollo consistentes y portables. En este post te cuento lo esencial para empezar a usarlos y aprovecharlos con la mínima configuración.
pubDate: 2025-09-08
draft: false
---

## Devcontainers: introducción

Los devcontainers son una forma sencilla y estandarizada de definir entornos de desarrollo reproducibles usando contenedores. Permiten que cualquier persona pueda levantar el mismo entorno de desarrollo, sin importar el sistema operativo o las dependencias locales.

### Instalación de la CLI de devcontainers

Para usar devcontainers fuera de un IDE, podés instalar la CLI oficial. Asumiendo que ya sabés cómo instalar paquetes con npm, yarn o pnpm, el comando es:

```bash
npm install -g @devcontainers/cli
```

Esto te permite ejecutar comandos como `devcontainer up` para levantar el entorno definido.

### Archivo mínimo de configuración

El archivo mínimo necesario para definir un devcontainer es `.devcontainer/devcontainer.json`. Un ejemplo básico:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:debian"
}
```

Con esto, al ejecutar `devcontainer up`, se levanta un contenedor con Debian listo para usar como entorno de desarrollo.

### Idea principal detrás de devcontainers

La idea principal es separar el entorno de desarrollo del entorno de producción. Así, podés tener todas las herramientas y configuraciones necesarias para desarrollar, sin afectar la imagen final que se usará en producción. Esto facilita la colaboración y reduce los problemas de "en mi máquina funciona".

### Ejemplo: simplificando el Dockerfile

Supongamos que tenés un proyecto Node.js y usás un Dockerfile multi-stage para separar desarrollo y producción:

```dockerfile
# Dockerfile multi-stage tradicional
FROM node:20 AS dev
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm", "run", "dev"]

FROM node:20 AS prod
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

Con devcontainers, podés tener un Dockerfile mucho más simple para producción y usar el devcontainer para el entorno de desarrollo:

**Dockerfile para producción:**

```dockerfile
FROM node:20
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

**Archivo `.devcontainer/devcontainer.json`:**

```json
{
  "image": "node:20",
  "features": {
    "ghcr.io/devcontainers/features/npm:1": {}
  },
  "mounts": ["source=${localWorkspaceFolder},target=/app,type=bind"],
  "postCreateCommand": "npm install"
}
```

De esta forma, el entorno de desarrollo queda separado y podés mantener la imagen de producción lo más simple posible.

---

¿Te parece una buena herramienta? Si querés profundizar, te recomiendo estos links:

- [Documentación oficial de Dev Containers](https://containers.dev/)
- [Guía de la CLI de devcontainers](https://github.com/devcontainers/cli)
- [Ejemplos de devcontainers](https://github.com/devcontainers/templates)
- [Artículo: Why Dev Containers?](https://containers.dev/supporting/why-dev-containers/)
