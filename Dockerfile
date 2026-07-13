FROM python:3.11-slim

# Instalar curl y zstd
RUN apt-get update && apt-get install -y curl zstd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

WORKDIR /app

# Instalar dependencias Python
RUN pip install fastapi uvicorn python-multipart jinja2 requests

# Crear directorio para modelos
RUN mkdir -p /root/.ollama/models

# Copiar tu código (si existe)
COPY . .

# Exponer puertos
EXPOSE 11434 8000

# Comando de inicio: Ollama en background + API FastAPI
CMD ollama serve & sleep 2 && \
    ollama pull tinyllama && \
    uvicorn main:app --host 0.0.0.0 --port 8000
