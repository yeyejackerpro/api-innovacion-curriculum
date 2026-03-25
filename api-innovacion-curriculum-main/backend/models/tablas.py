from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import date

# ---- ESQUEMAS PYDANTIC (SIN SQLALCHEMY) ----
class AreaConocimientoSchema(BaseModel):
    gran_area: str; area: str; disciplina: str
class UniversidadSchema(BaseModel):
    nombre: str; tipo: str; ciudad: str
class AspectoNormativoSchema(BaseModel):
    tipo: str; descripcion: str; fuente: str
class PracticaEstrategiaSchema(BaseModel):
    tipo: str; nombre: str; descripcion: str
class EnfoqueSchema(BaseModel):
    nombre: str; descripcion: str
class CarInnovacionSchema(BaseModel):
    nombre: str; descripcion: str; tipo: str
class AliadoSchema(BaseModel):
    nit: str; razon_social: str; nombre_contacto: str; correo: str; telefono: str; ciudad: str
class FacultadSchema(BaseModel):
    nombre: str; tipo: str; fecha_fun: date; universidad_id: int
class ProgramaSchema(BaseModel):
    nombre: str; tipo: str; nivel: str; fecha_creacion: date; fecha_cierre: Optional[date] = None; numero_cohortes: int; cant_graduados: int; fecha_actualizacion: Optional[date] = None; ciudad: str; facultad_id: int
class AcreditacionSchema(BaseModel):
    resolucion: str; tipo: str; calificacion: str; fecha_inicio: date; fecha_fin: date; programa_id: int
class RegistroCalificadoSchema(BaseModel):
    codigo: str; cant_creditos: int; hora_acom: int; hora_ind: int; metodologia: str; fecha_inicio: date; fecha_fin: date; duracion_anios: int; duracion_semestres: int; tipo_titulacion: str; programa_id: int
class ActivAcademicaSchema(BaseModel):
    nombre: str; num_creditos: int; tipo: str; area_formacion: str; h_acom: int; h_indep: int; idioma: str; espejo: bool; entidad_espejo: Optional[str] = None; pais_espejo: Optional[str] = None; programa_id: int
class PasantiaSchema(BaseModel):
    nombre: str; pais: str; empresa: str; descripcion: str; programa_id: int
class PremioSchema(BaseModel):
    nombre: str; descripcion: str; fecha: date; entidad_otorgante: str; pais: str; programa_id: int
class RolSchema(BaseModel):
    nombre: str; descripcion: str; activo: bool; fecha_creacion: date
class UsuarioSchema(BaseModel):
    username: str; password: str; email: str; nombre_completo: str; activo: bool; fecha_creacion: date

# Faltantes (Puentes y relaciones profundas)
class AARcSchema(BaseModel):
    activ_academicas_idcurso: int; registro_calificado_codigo: str; componente: str; semestre: int
class AlianzaSchema(BaseModel):
    aliado_nit: str; departamento_id: int; fecha_inicio: date; fecha_fin: date; docente_id: str
class AnProgramaSchema(BaseModel):
    aspecto_normativo_id: int; programa_id: int
class DocenteDepartamentoSchema(BaseModel):
    docente_id: str; departamento_id: int; dedicacion: str; modalidad: str; fecha_ingreso: date; fecha_salida: Optional[date] = None
class EnfoquercSchema(BaseModel):
    enfoque_id: int; registro_calificado_codigo: str
class ProgramaacSchema(BaseModel):
    programa_id: int; area_conocimiento_id: int
class ProgramaciSchema(BaseModel):
    programa_id: int; car_innovacion_id: int
class ProgramapeSchema(BaseModel):
    programa_id: int; practica_estrategia_id: int
class RolusuarioSchema(BaseModel):
    usuario_id: int; rol_id: int
