from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from controllers.routers import router as api_router
from controllers.views import router as views_router

# Instancia del Backend FastAPI
app = FastAPI(
    title="API Innovación Curricular", 
    description="Backend en desarrollo para conectar DB Postgre con el Frontend.", 
    version="1.0.0"
)

# CORS: Fundamental para que el HTML pueda comunicarse con el Backend (No bloqueos web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Conectando los routers
app.include_router(api_router, prefix="/api")
app.include_router(views_router)

@app.get("/")
def home():
    return {"message": "API Backend Iniciada - Todo conectado correctamente."}
