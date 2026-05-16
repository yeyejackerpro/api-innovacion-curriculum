from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import logging

from config import get_settings
from controllers import entidades_controller



# Cargar configuración desde .env
settings = get_settings()

# Configurar logging básico
logging.basicConfig(level=logging.DEBUG if settings.debug else logging.INFO)
logger = logging.getLogger("api-innovacion")
logger.info(f"Iniciando aplicación en entorno: {settings.environment}")




# Instancia del Backend FastAPI
app = FastAPI(
    title="API Innovación Curricular", 
    description="Backend en desarrollo para conectar DB Postgre con el Frontend.", 
    version="1.0.0",
    docs_url = "/swagger",
    redoc_url = "/redoc",
    openapi_url = "/openapi.json",
)

# CORS: Fundamental para que el HTML pueda comunicarse con el Backend (No bloqueos web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Cualquier origen puede consumir la API (En producción, restringir a dominios específicos)
    allow_credentials=True, # Permitir cookies y credenciales en las solicitudes
    allow_methods=["*"], # GET, POST, PUT, DELETE, etc. (Permitir todos los métodos HTTP)
    allow_headers=["*"], # Cualquier header
)

# Conectando los routers
app.include_router(entidades_controller)

# Montar el frontend estático
frontend_dir = Path(__file__).resolve().parent.parent / "frontend"
if frontend_dir.exists():
    app.mount("/", StaticFiles(directory=str(frontend_dir), html=True), name="frontend")

@app.get("/health", tags=["Diagnóstico"])
async def health():
    """Retorna un mensaje básico para verificar que la API está activa."""
    return {"message": "API CRUD Iniciada - Todo conectado correctamente.",
            "version": "1.0.0",
            "entorno": settings.environment,
            "documentación": {
                "swagger": "/swagger",
                "redoc": "/redoc"}}





if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host="127.0.0.1",
        port=8000,
        reload=settings.debug,
        log_level="debug" if settings.debug else "info"
    )

