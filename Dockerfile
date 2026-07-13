# Imagen base ligera con Python 3.11
FROM python:3.11-slim

# Instalar dependencias del sistema y Ollama (YA INCLUYE zstd que faltaba)
RUN apt-get update && apt-get install -y curl zstd && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Establecer carpeta de trabajo
WORKDIR /app

# Instalar librerías de Python necesarias
RUN pip install fastapi uvicorn python-multipart jinja2 requests

# Copiar todos los archivos del proyecto
COPY . .

# Variables de entorno obligatorias
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODEL=llama3.2:1b

# Puerto que usa Railway
EXPOSE 8080

# Comando de arranque: levanta Ollama, descarga el modelo y arranca la web
CMD ["/bin/sh", "-c", "ollama serve & sleep 15 && ollama pull $OLLAMA_MODEL && uvicorn main:app --host 0.0.0.0 --port 8080"]
