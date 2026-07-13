FROM python:3.11-slim

# Instalar solo lo necesario + limpiar
RUN apt-get update && apt-get install -y curl zstd && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

WORKDIR /app

# Instalar dependencias Python mínimas
RUN pip install --no-cache-dir fastapi uvicorn python-multipart && \
    pip cache purge

# Crear directorio para modelos
RUN mkdir -p /root/.ollama/models

# Copiar código
COPY . .

# Exponer puertos
EXPOSE 11434 8000

# Comando: Ollama + descarga phi + FastAPI
# phi es ~500MB (mucho más pequeño)
CMD ollama serve & sleep 3 && \
    ollama pull phi && \
    python -c "import sys; sys.exit(0)" && \
    uvicorn main:app --host 0.0.0.0 --port 8000 || true
