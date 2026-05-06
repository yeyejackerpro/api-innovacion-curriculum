"""
i_repositorio_lectura_tabla.py — Contrato (interfaz) para acceso a datos.

Define QUÉ operaciones puede hacer un repositorio, sin importar
qué base de datos se use por debajo. Cada proveedor (PostgreSQL,
SQL Server, MySQL) implementa estos métodos a su manera.
"""


from typing import Protocol, Optional

class IRepositorioLecturaTabla(Protocol):
    """
    Contrato para repositorios CRUD génericos.

    Cualquier clase que implemente estos métodos puede usarse
    como repositorio, sin necesidad de heredar de esta clase
    """

    async def obtener_filas(
            self,
            nombre_tabla: str,
            esquema: Optional[str] = None,
            limite: Optional[int] = None
    ) -> list[dict[str, object]]:
        """
        Obtener filas de una tabla.

        :param nombre_tabla: Nombre de la tabla a consultar.
        :param esquema: Esquema de la tabla (opcional).
        :param limite: Número máximo de filas a retornar (opcional).
        :return: Lista de diccionarios representando las filas.
        """
        ...

        async def obtener_por_clave(
                self,
                nombre_tabla: str,
                nombre_clave: str,
                valor: str,
                esquema: Optional[str] = None
        ) -> list[dict[str, object]]:
            """
            Obtener filas por clave.

            :param nombre_tabla: Nombre de la tabla a consultar.
            :param nombre_clave: Nombre de la columna clave.
            :param valor: Valor de la clave a buscar.
            :param esquema: Esquema de la tabla (opcional).
            :return: Lista de diccionarios representando las filas encontradas.
            """
            ...

        
        async def crear(
                self,
                nombre_tabla: str,
                datos: dict[str, object],
                esquema: Optional[str] = None,
                campos_encriptar: Optional[str] = None
        ) -> bool:
            """
            Crear una nueva fila en la tabla.

            :param nombre_tabla: Nombre de la tabla donde insertar.
            :param datos: Diccionario con los datos a insertar (columna: valor).
            :param esquema: Esquema de la tabla (opcional).
            :param campos_encriptar: Coma-separada de campos a encriptar (opcional).
            :return: True si se insertó correctamente, False si no.
            """
            ...
        async def actualizar(
                self,
                nombre_tabla: str,
                nombre_clave: str,
                valor_clave: str,
                datos: dict[str, object],
                esquema: Optional[str] = None,
                campos_encriptar: Optional[str] = None
        ) -> int:
            """
            Actualizar filas existentes.

            :param nombre_tabla: Nombre de la tabla a actualizar.
            :param nombre_clave: Nombre de la columna clave para identificar filas.
            :param valor_clave: Valor de la clave para identificar filas a actualizar.
            :param datos: Diccionario con los datos a actualizar (columna: nuevo valor).
            :param esquema: Esquema de la tabla (opcional).
            :param campos_encriptar: Coma-separada de campos a encriptar (opcional).
            :return: Número de filas actualizadas.
            """
            ...
        async def eliminar(
                self,
                nombre_tabla: str,
                nombre_clave: str,
                valor_clave: str,
                esquema: Optional[str] = None
        ) -> int:
            """
            Eliminar filas existentes.

            :param nombre_tabla: Nombre de la tabla a eliminar.
            :param nombre_clave: Nombre de la columna clave para identificar filas.
            :param valor_clave: Valor de la clave para identificar filas a eliminar.
            :param esquema: Esquema de la tabla (opcional).
            :return: Número de filas eliminadas.
            """
            ...
        async def eliminar_por_dos_claves(
                self,
                nombre_tabla: str,
                nombre_clave1: str,
                valor_clave1: str,
                nombre_clave2: str,
                valor_clave2: str,
                esquema: Optional[str] = None
        ) -> int:
            """
            Eliminar filas existentes usando dos claves compuestas.

            :param nombre_tabla: Nombre de la tabla a eliminar.
            :param nombre_clave1: Nombre de la primera columna clave.
            :param valor_clave1: Valor de la primera clave.
            :param nombre_clave2: Nombre de la segunda columna clave.
            :param valor_clave2: Valor de la segunda clave.
            :param esquema: Esquema de la tabla (opcional).
            :return: Número de filas eliminadas.
            """
            ...
        async def obtener_hash_contrasena(
                self,
                nombre_tabla: str,
                campo_usuario: str,
                campo_contrasena: str,
                valor_usuario: str,
                esquema: Optional[str] = None
        ) -> Optional[str]:
            """
            Obtener el hash de la contraseña para un usuario específico.

            :param nombre_tabla: Nombre de la tabla a consultar.
            :param campo_usuario: Nombre de la columna que contiene el usuario.
            :param campo_contrasena: Nombre de la columna que contiene el hash de la contraseña.
            :param valor_usuario: Valor del usuario para buscar.
            :param esquema: Esquema de la tabla (opcional).
            :return: Hash de la contraseña si se encuentra el usuario, None si no se encuentra.
            """
            ...
    
