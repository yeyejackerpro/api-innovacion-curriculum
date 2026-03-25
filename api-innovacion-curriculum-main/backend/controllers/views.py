import os
from fastapi import APIRouter, Request, Depends
from fastapi.templating import Jinja2Templates
from servicios.conexion.db_dependencies import get_db

router = APIRouter()

# Ubicar la carpeta 'frontend' que está junto a la carpeta 'backend'
base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
frontend_path = os.path.join(base_dir, "frontend")
templates = Jinja2Templates(directory=frontend_path)

@router.get("/universidad")
def vista_universidad(request: Request, conn = Depends(get_db)):
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM universidad ORDER BY id ASC")
        universidades = cursor.fetchall()
    return templates.TemplateResponse("universidad.html", {"request": request, "universidades": universidades})

@router.get("/programa")
def vista_programa(request: Request, conn = Depends(get_db)):
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM programa ORDER BY id ASC")
        programas = cursor.fetchall()
        
        cursor.execute("SELECT id, nombre FROM facultad ORDER BY nombre ASC")
        facultades = cursor.fetchall()
        
    return templates.TemplateResponse("programa.html", {"request": request, "programas": programas, "facultades": facultades})

@router.get("/{view_name}")
def dynamic_view(view_name: str, request: Request, conn=Depends(get_db)):
    if not view_name.endswith(".html"):
        view_name += ".html"
    try:
        return templates.TemplateResponse(view_name, {"request": request})
    except Exception as e:
        return f"Error: {e} - Probablemente plantilla no existe"
