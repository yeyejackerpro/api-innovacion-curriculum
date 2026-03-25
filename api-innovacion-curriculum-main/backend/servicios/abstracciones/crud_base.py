from pydantic import BaseModel
from typing import List, TypeVar, Generic

CreateSchemaType = TypeVar("CreateSchemaType", bound=BaseModel)

class CRUDBase(Generic[CreateSchemaType]):
    def __init__(self, table_name: str, id_column: str = "id"):
        self.table_name = table_name
        self.id_column = id_column

    def get_multi(self, conn, skip: int = 0, limit: int = 100) -> List[dict]:
        with conn.cursor() as cursor:
            # Selecciona consultas raw SQL puras
            cursor.execute(f"SELECT * FROM {self.table_name} OFFSET %s LIMIT %s", (skip, limit))
            return cursor.fetchall()
            
    def create_raw(self, conn, obj_data: dict) -> None:
        print(f"2. [CAPA SERVICIOS] Preparando datos validados para la tabla '{self.table_name}'.")
        columns = ", ".join(obj_data.keys())
        values_template = ", ".join(["%s"] * len(obj_data))
        values = tuple(obj_data.values())
        
        print(f"3. [CAPA REPOSITORIO] Ejecutando Inserción nativa PostgreSQL en Base de Datos...")
        query = f"INSERT INTO {self.table_name} ({columns}) VALUES ({values_template})"
        with conn.cursor() as cursor:
            cursor.execute(query, values)
            conn.commit()
            
    def create(self, conn, obj_in: CreateSchemaType) -> dict:
        obj_data = obj_in.model_dump()
        columns = ", ".join(obj_data.keys())
        values_template = ", ".join(["%s"] * len(obj_data))
        values = tuple(obj_data.values())
        
        # INSERT básico nativo y devuelve el objeto resultante
        query = f"INSERT INTO {self.table_name} ({columns}) VALUES ({values_template}) RETURNING *"
        with conn.cursor() as cursor:
            cursor.execute(query, values)
            conn.commit()
            return cursor.fetchone()
