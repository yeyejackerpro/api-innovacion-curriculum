from fastapi import APIRouter, Depends, Request, Form
from fastapi.responses import RedirectResponse, HTMLResponse
from typing import List, Type
from pydantic import BaseModel
from servicios.conexion.db_dependencies import get_db
from servicios.abstracciones.crud_base import CRUDBase
from models.tablas import *

router = APIRouter()

def create_crud_api(prefix: str, table_name: str, schema_class: Type[BaseModel], is_string_pk: bool = False):
    id_column = "nit" if table_name == "aliado" else ("resolucion" if table_name == "acreditacion" else ("codigo" if table_name == "registro_calificado" else "id"))
    crud = CRUDBase[schema_class](table_name, id_column)
    
    if is_string_pk:
        class ResponseSchema(schema_class):
            model_config = {"from_attributes": True}
    else:
        class ResponseSchema(schema_class):
            id: int
            model_config = {"from_attributes": True}
    
    @router.get(f"/{prefix}", response_model=List[ResponseSchema], tags=[prefix.capitalize()])
    def get_all(conn = Depends(get_db)):
        return crud.get_multi(conn=conn)
        
    @router.post(f"/{prefix}", tags=[prefix.capitalize()])
    async def create(request: Request, conn = Depends(get_db)):
        # Si llega como JSON clásico de API REST
        if request.headers.get("content-type") == "application/json":
            data = await request.json()
            return crud.create(conn=conn, obj_in=schema_class(**data))
        
        # Si llega desde un formulario HTML puro sin Javascript (x-www-form-urlencoded):
        form_data = await request.form()
        obj_data = dict(form_data)
        
        # Ignorar cajas de texto en blanco o nulas
        cleaned_data = {k: v for k, v in obj_data.items() if v != ""}
        
        print("\n" + "="*40)
        print(f"1. [CAPA CONTROLLER] Datos recibidos del formulario HTML en endpoint '/api/{prefix}'. Comprobando...")
        print(cleaned_data)
        
        referer = request.headers.get("referer") or "/"
        
        try:
            # Enviamos el diccionario de datos a la capa de Servicios/Repositorio
            crud.create_raw(conn=conn, obj_data=cleaned_data)
            print("4. [ÉXITO] Todo conectado. Inserción completada de Controller -> Servicio -> Repositorio BD.")
            print("="*40 + "\n")
        except Exception as e:
            print(f"Error nativo en Postgres: {e}")
            return HTMLResponse(f"<h1>Error en BD: {e}</h1><a href='{referer}'>Volver</a>")
            
        return HTMLResponse(f'''
            <div style="font-family: Arial, sans-serif; text-align: center; margin-top: 100px;">
                <div style="font-size: 50px;">✅</div>
                <h1 style="color: #28a745;">¡Tus datos han sido agregados exitosamente!</h1>
                <p style="color: #555; font-size: 18px;">
                    El recorrido funcionó perfecto: <b>Controller -> Servicios -> Repositorio BD</b>
                </p>
                <div style="margin-top: 30px;">
                    <a href='{referer}' style="padding: 12px 25px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 16px;">
                        Volver para seguir ingresando
                    </a>
                </div>
            </div>
        ''')

# Registramos las APIs adaptadas
create_crud_api("areaconocimiento", "area_conocimiento", AreaConocimientoSchema)
create_crud_api("universidad", "universidad", UniversidadSchema)
create_crud_api("aspectonormativo", "aspecto_normativo", AspectoNormativoSchema)
create_crud_api("practicaestrategia", "practica_estrategia", PracticaEstrategiaSchema)
create_crud_api("enfoque", "enfoque", EnfoqueSchema)
create_crud_api("carinnovacion", "car_innovacion", CarInnovacionSchema)
create_crud_api("aliado", "aliado", AliadoSchema, is_string_pk=True)
create_crud_api("facultad", "facultad", FacultadSchema)
create_crud_api("programa", "programa", ProgramaSchema)
create_crud_api("acreditacion", "acreditacion", AcreditacionSchema, is_string_pk=True)
create_crud_api("registrocalificado", "registro_calificado", RegistroCalificadoSchema, is_string_pk=True)
create_crud_api("activacademica", "activ_academica", ActivAcademicaSchema)
create_crud_api("pasantia", "pasantia", PasantiaSchema)
create_crud_api("premio", "premio", PremioSchema)
create_crud_api("rol", "rol", RolSchema)
create_crud_api("usuario", "usuario", UsuarioSchema)

# Controladores faltantes
create_crud_api("aarc", "aa_rc", AARcSchema)
create_crud_api("alianza", "alianza", AlianzaSchema)
create_crud_api("anprograma", "an_programa", AnProgramaSchema)
create_crud_api("docentedepartamento", "docente_departamento", DocenteDepartamentoSchema)
create_crud_api("enfoquerc", "enfoque_rc", EnfoquercSchema)
create_crud_api("programaac", "programa_ac", ProgramaacSchema)
create_crud_api("programaci", "programa_ci", ProgramaciSchema)
create_crud_api("programape", "programa_pe", ProgramapeSchema)
create_crud_api("rolusuario", "rol_usuario", RolusuarioSchema)
