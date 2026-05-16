"""Lee DB_PROVIDER y las cadenas de conexión desde .env."""

from config import Settings, get_settings


class ProveedorConexion:
    """Lee el proveedor activo y entrega la cadena de conexión."""

    def __init__(self, settings: Settings | None = None):
        self.settings = settings or get_settings()

    @property
    def proveedor_actual(self) -> str:
        """Proveedor activo según DB_PROVIDER."""
        return self.settings.database.provider.lower().strip()
    
    def obtener_cadena_conexion(self) -> str:
        """Cadena de conexión del proveedor activo."""
        provider = self.proveedor_actual
        db_config = self.settings.database

        cadenas = {
            "postgres": db_config.postgres,
            "postgresql": db_config.postgres,
            "sqlserver": db_config.sqlserver,
            "sqlserverexpress": db_config.sqlserverexpress,
            "localdb": db_config.localdb,
            "mysql": db_config.mysql,
            "mariadb": db_config.mariadb,
        }

        if provider not in cadenas:
            raise ValueError(f"Proveedor '{provider}' no soportado. "
                             f"Opciones: {list(cadenas.keys())}")
        
        cadena = cadenas[provider]
        if not cadena:
            raise ValueError(f"Cadena de conexión vacía para proveedor '{provider}'")
        
        # Intento rápido de reachability al host de BD (fallar rápido si es inaccesible).
        try:
            from urllib.parse import urlparse
            import socket
            parsed = urlparse(cadena)
            host = parsed.hostname
            port = parsed.port
            # Puerto por defecto según esquema
            if not port:
                if parsed.scheme and 'postgres' in parsed.scheme:
                    port = 5432
                elif parsed.scheme and ('mysql' in parsed.scheme or 'mariadb' in parsed.scheme):
                    port = 3306
                elif parsed.scheme and 'sqlserver' in parsed.scheme:
                    port = 1433
            if host:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(3.0)
                try:
                    s.connect((host, port))
                    s.close()
                except Exception as ex:
                    raise ValueError(f"No se puede alcanzar host DB {host}:{port} — {ex}")
        except Exception:
            # Si la comprobación falla por parsing o permisos, no impedir la ejecución;
            # devolvemos la cadena y dejamos que el engine maneje el error real.
            pass

        return cadena