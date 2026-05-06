-- 1. Tablas sin dependencias (Entidades Independientes)
CREATE TABLE IF NOT EXISTS area_conocimiento (
    id SERIAL PRIMARY KEY,
    gran_area VARCHAR,
    area VARCHAR,
    disciplina VARCHAR
);

CREATE TABLE IF NOT EXISTS universidad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    tipo VARCHAR,
    ciudad VARCHAR
);

CREATE TABLE IF NOT EXISTS aspecto_normativo (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR,
    descripcion TEXT,
    fuente VARCHAR
);

CREATE TABLE IF NOT EXISTS practica_estrategia (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR,
    nombre VARCHAR,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS enfoque (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS car_innovacion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    descripcion TEXT,
    tipo VARCHAR
);

CREATE TABLE IF NOT EXISTS aliado (
    nit VARCHAR PRIMARY KEY,
    razon_social VARCHAR,
    nombre_contacto VARCHAR,
    correo VARCHAR,
    telefono VARCHAR,
    ciudad VARCHAR
);

-- 2. Tablas de Gestión de Usuarios
CREATE TABLE IF NOT EXISTS rol (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    descripcion TEXT,
    activo BOOLEAN DEFAULT true,
    fecha_creacion DATE
);

CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    username VARCHAR UNIQUE,
    password VARCHAR,
    email VARCHAR,
    nombre_completo VARCHAR,
    activo BOOLEAN DEFAULT true,
    fecha_creacion DATE
);

CREATE TABLE IF NOT EXISTS rol_usuario (
    usuario_id INTEGER REFERENCES usuario(id) ON DELETE CASCADE,
    rol_id INTEGER REFERENCES rol(id) ON DELETE CASCADE,
    PRIMARY KEY (usuario_id, rol_id)
);

-- 3. Tablas con Claves Foráneas (Dependencias)
CREATE TABLE IF NOT EXISTS facultad (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    tipo VARCHAR,
    fecha_fun DATE,
    universidad_id INTEGER REFERENCES universidad(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS programa (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    tipo VARCHAR,
    nivel VARCHAR,
    fecha_creacion DATE,
    fecha_cierre DATE,
    numero_cohortes INTEGER,
    cant_graduados INTEGER,
    fecha_actualizacion DATE,
    ciudad VARCHAR,
    facultad_id INTEGER REFERENCES facultad(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS acreditacion (
    resolucion VARCHAR PRIMARY KEY,
    tipo VARCHAR,
    calificacion VARCHAR,
    fecha_inicio DATE,
    fecha_fin DATE,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS registro_calificado (
    codigo VARCHAR PRIMARY KEY,
    cant_creditos INTEGER,
    hora_acom INTEGER,
    hora_ind INTEGER,
    metodologia VARCHAR,
    fecha_inicio DATE,
    fecha_fin DATE,
    duracion_anios INTEGER,
    duracion_semestres INTEGER,
    tipo_titulacion VARCHAR,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS activ_academica (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    num_creditos INTEGER,
    tipo VARCHAR,
    area_formacion VARCHAR,
    h_acom INTEGER,
    h_indep INTEGER,
    idioma VARCHAR,
    espejo BOOLEAN,
    entidad_espejo VARCHAR,
    pais_espejo VARCHAR,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pasantia (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    pais VARCHAR,
    empresa VARCHAR,
    descripcion TEXT,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS premio (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR,
    descripcion TEXT,
    fecha DATE,
    entidad_otorgante VARCHAR,
    pais VARCHAR,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE
);

-- 4. Tablas Relacionales o Puente (Muchos a Muchos)
CREATE TABLE IF NOT EXISTS programa_ac (
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    area_conocimiento_id INTEGER REFERENCES area_conocimiento(id) ON DELETE CASCADE,
    PRIMARY KEY (programa_id, area_conocimiento_id)
);

CREATE TABLE IF NOT EXISTS programa_pe (
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    practica_estrategia_id INTEGER REFERENCES practica_estrategia(id) ON DELETE CASCADE,
    PRIMARY KEY (programa_id, practica_estrategia_id)
);

CREATE TABLE IF NOT EXISTS programa_ci (
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    car_innovacion_id INTEGER REFERENCES car_innovacion(id) ON DELETE CASCADE,
    PRIMARY KEY (programa_id, car_innovacion_id)
);

CREATE TABLE IF NOT EXISTS an_programa (
    aspecto_normativo_id INTEGER REFERENCES aspecto_normativo(id) ON DELETE CASCADE,
    programa_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    PRIMARY KEY (aspecto_normativo_id, programa_id)
);

CREATE TABLE IF NOT EXISTS enfoque_rc (
    enfoque_id INTEGER REFERENCES enfoque(id) ON DELETE CASCADE,
    registro_calificado_codigo VARCHAR REFERENCES registro_calificado(codigo) ON DELETE CASCADE,
    PRIMARY KEY (enfoque_id, registro_calificado_codigo)
);

CREATE TABLE IF NOT EXISTS aa_rc (
    id SERIAL PRIMARY KEY,
    activ_academicas_idcurso INTEGER REFERENCES activ_academica(id) ON DELETE CASCADE,
    registro_calificado_codigo VARCHAR REFERENCES registro_calificado(codigo) ON DELETE CASCADE,
    componente VARCHAR,
    semestre INTEGER
);

CREATE TABLE IF NOT EXISTS docente_departamento (
    id SERIAL PRIMARY KEY,
    docente_id VARCHAR,
    departamento_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    dedicacion VARCHAR,
    modalidad VARCHAR,
    fecha_ingreso DATE,
    fecha_salida DATE
);

CREATE TABLE IF NOT EXISTS alianza (
    id SERIAL PRIMARY KEY,
    aliado_nit VARCHAR REFERENCES aliado(nit) ON DELETE CASCADE,
    departamento_id INTEGER REFERENCES programa(id) ON DELETE CASCADE,
    fecha_inicio DATE,
    fecha_fin DATE,
    docente_id VARCHAR
);
