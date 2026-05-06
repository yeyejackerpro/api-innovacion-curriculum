"""Contrato para obtener información de conexixón a DB."""

from typing import Protocol


class IProveedorConexion(Protocol):
    """Contrato para clases que proveen información de conexión."""

    @property
    def proveedor_actual(self) -> str:
        """Nombre del proveedor activo."""
        ...

    def obtener_cadena_conexion(self) -> str:
        """Cadena de conexión del proveedor activo."""
        ...