FROM python:3.11-slim

# Instalar Ollama y dependencias
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://ollama.com/install.sh | sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Instalar librerías
RUN pip install fastapi uvicorn python-multipart jinja2

# Copiar archivos
COPY . .

# Variables obligatorias
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODEL=llama3.2:1b

EXPOSE 8080

# Arrancar todo junto
CMD ["/bin/sh", "-c", "ollama serve & sleep 10 && ollama pull $OLLAMA_MODEL && uvicorn main:app --host 0.0.0.0 --port 8080"]
