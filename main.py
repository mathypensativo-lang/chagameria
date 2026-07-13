from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.middleware.cors import CORSMiddleware
import requests
import os

app = FastAPI()

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Cargar plantillas
templates = Jinja2Templates(directory="templates")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3.2:1b")

# Ruta principal
@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    return templates.TemplateResponse("index.html", {"request": request, "model": OLLAMA_MODEL})

# Ruta para chatear
@app.post("/api/chat")
async def chat(data: dict):
    try:
        respuesta = requests.post(
            "http://localhost:11434/api/generate",
            json={
                "model": OLLAMA_MODEL,
                "prompt": data.get("mensaje", ""),
                "stream": False
            },
            timeout=120
        )
        return {"respuesta": respuesta.json().get("response", "")}
    except Exception as e:
        return {"error": str(e)}
