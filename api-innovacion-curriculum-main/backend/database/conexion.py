import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    # Parámetros básicos para tu conexión PostgreSQL local en pgAdmin 4
    return psycopg2.connect(
        host="localhost",
        database="innovacion_curricular",
        user="postgres",  # Cambialo si usas otro usuario
        password="postgres",  # Pon aquí la clave de tu bd
        port="5432",
        cursor_factory=RealDictCursor
    )
    