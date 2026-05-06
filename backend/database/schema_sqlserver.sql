-- ============================================================
--  MÓDULO: Innovación Curricular
--  Base de datos: innovacion_curricular
--  Motor: Microsoft SQL Server (2016+)
-- ============================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'innovacion_curricular')
    CREATE DATABASE innovacion_curricular;
GO

USE innovacion_curricular;
GO

-- ============================================================
-- 1. TABLAS INDEPENDIENTES (sin claves foráneas)
-- ============================================================

IF OBJECT_ID('area_conocimiento', 'U') IS NULL
CREATE TABLE area_conocimiento (
    id        INT IDENTITY(1,1) PRIMARY KEY,
    gran_area NVARCHAR(255),
    area      NVARCHAR(255),
    disciplina NVARCHAR(255)
);
GO

IF OBJECT_ID('universidad', 'U') IS NULL
CREATE TABLE universidad (
    id     INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255),
    tipo   NVARCHAR(100),
    ciudad NVARCHAR(100)
);
GO

IF OBJECT_ID('aspecto_normativo', 'U') IS NULL
CREATE TABLE aspecto_normativo (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    tipo        NVARCHAR(100),
    descripcion NVARCHAR(MAX),
    fuente      NVARCHAR(255)
);
GO

IF OBJECT_ID('practica_estrategia', 'U') IS NULL
CREATE TABLE practica_estrategia (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    tipo        NVARCHAR(100),
    nombre      NVARCHAR(255),
    descripcion NVARCHAR(MAX)
);
GO

IF OBJECT_ID('enfoque', 'U') IS NULL
CREATE TABLE enfoque (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    nombre      NVARCHAR(255),
    descripcion NVARCHAR(MAX)
);
GO

IF OBJECT_ID('car_innovacion', 'U') IS NULL
CREATE TABLE car_innovacion (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    nombre      NVARCHAR(255),
    descripcion NVARCHAR(MAX),
    tipo        NVARCHAR(100)
);
GO

IF OBJECT_ID('aliado', 'U') IS NULL
CREATE TABLE aliado (
    nit             NVARCHAR(20)  PRIMARY KEY,
    razon_social    NVARCHAR(255),
    nombre_contacto NVARCHAR(255),
    correo          NVARCHAR(255),
    telefono        NVARCHAR(50),
    ciudad          NVARCHAR(100)
);
GO

-- ============================================================
-- 2. TABLAS DE GESTIÓN DE USUARIOS
-- ============================================================

IF OBJECT_ID('rol', 'U') IS NULL
CREATE TABLE rol (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    nombre         NVARCHAR(100),
    descripcion    NVARCHAR(MAX),
    activo         BIT           DEFAULT 1,
    fecha_creacion DATE
);
GO

IF OBJECT_ID('usuario', 'U') IS NULL
CREATE TABLE usuario (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    username        NVARCHAR(100) UNIQUE,
    password        NVARCHAR(255),
    email           NVARCHAR(255),
    nombre_completo NVARCHAR(255),
    activo          BIT  DEFAULT 1,
    fecha_creacion  DATE
);
GO

IF OBJECT_ID('rol_usuario', 'U') IS NULL
CREATE TABLE rol_usuario (
    usuario_id INT NOT NULL,
    rol_id     INT NOT NULL,
    PRIMARY KEY (usuario_id, rol_id),
    CONSTRAINT fk_rolusu_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    CONSTRAINT fk_rolusu_rol     FOREIGN KEY (rol_id)     REFERENCES rol(id)
    -- SQL Server no permite ON DELETE CASCADE en ambas FK de una tabla puente;
    -- se omite CASCADE en rol para evitar múltiples rutas de eliminación en cascada.
);
GO

-- ============================================================
-- 3. TABLAS CON CLAVES FORÁNEAS (dependencias)
-- ============================================================

IF OBJECT_ID('facultad', 'U') IS NULL
CREATE TABLE facultad (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    nombre         NVARCHAR(255),
    tipo           NVARCHAR(100),
    fecha_fun      DATE,
    universidad_id INT,
    CONSTRAINT fk_fac_universidad FOREIGN KEY (universidad_id) REFERENCES universidad(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('programa', 'U') IS NULL
CREATE TABLE programa (
    id                  INT IDENTITY(1,1) PRIMARY KEY,
    nombre              NVARCHAR(255),
    tipo                NVARCHAR(100),
    nivel               NVARCHAR(100),
    fecha_creacion      DATE,
    fecha_cierre        DATE,
    numero_cohortes     INT,
    cant_graduados      INT,
    fecha_actualizacion DATE,
    ciudad              NVARCHAR(100),
    facultad_id         INT,
    CONSTRAINT fk_prog_facultad FOREIGN KEY (facultad_id) REFERENCES facultad(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('acreditacion', 'U') IS NULL
CREATE TABLE acreditacion (
    resolucion   NVARCHAR(100) PRIMARY KEY,
    tipo         NVARCHAR(100),
    calificacion NVARCHAR(100),
    fecha_inicio DATE,
    fecha_fin    DATE,
    programa_id  INT,
    CONSTRAINT fk_acred_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('registro_calificado', 'U') IS NULL
CREATE TABLE registro_calificado (
    codigo              NVARCHAR(100) PRIMARY KEY,
    cant_creditos       INT,
    hora_acom           INT,
    hora_ind            INT,
    metodologia         NVARCHAR(255),
    fecha_inicio        DATE,
    fecha_fin           DATE,
    duracion_anios      INT,
    duracion_semestres  INT,
    tipo_titulacion     NVARCHAR(100),
    programa_id         INT,
    CONSTRAINT fk_rc_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('activ_academica', 'U') IS NULL
CREATE TABLE activ_academica (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    nombre         NVARCHAR(255),
    num_creditos   INT,
    tipo           NVARCHAR(100),
    area_formacion NVARCHAR(255),
    h_acom         INT,
    h_indep        INT,
    idioma         NVARCHAR(50),
    espejo         BIT,
    entidad_espejo NVARCHAR(255),
    pais_espejo    NVARCHAR(100),
    programa_id    INT,
    CONSTRAINT fk_aa_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('pasantia', 'U') IS NULL
CREATE TABLE pasantia (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    nombre      NVARCHAR(255),
    pais        NVARCHAR(100),
    empresa     NVARCHAR(255),
    descripcion NVARCHAR(MAX),
    programa_id INT,
    CONSTRAINT fk_pas_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('premio', 'U') IS NULL
CREATE TABLE premio (
    id                INT IDENTITY(1,1) PRIMARY KEY,
    nombre            NVARCHAR(255),
    descripcion       NVARCHAR(MAX),
    fecha             DATE,
    entidad_otorgante NVARCHAR(255),
    pais              NVARCHAR(100),
    programa_id       INT,
    CONSTRAINT fk_pre_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

-- ============================================================
-- 4. TABLAS PUENTE (relaciones muchos a muchos)
-- ============================================================

IF OBJECT_ID('programa_ac', 'U') IS NULL
CREATE TABLE programa_ac (
    programa_id          INT NOT NULL,
    area_conocimiento_id INT NOT NULL,
    PRIMARY KEY (programa_id, area_conocimiento_id),
    CONSTRAINT fk_pac_programa FOREIGN KEY (programa_id)          REFERENCES programa(id)          ON DELETE CASCADE,
    CONSTRAINT fk_pac_area     FOREIGN KEY (area_conocimiento_id)  REFERENCES area_conocimiento(id)
);
GO

IF OBJECT_ID('programa_pe', 'U') IS NULL
CREATE TABLE programa_pe (
    programa_id            INT NOT NULL,
    practica_estrategia_id INT NOT NULL,
    PRIMARY KEY (programa_id, practica_estrategia_id),
    CONSTRAINT fk_ppe_programa FOREIGN KEY (programa_id)            REFERENCES programa(id)            ON DELETE CASCADE,
    CONSTRAINT fk_ppe_practica FOREIGN KEY (practica_estrategia_id) REFERENCES practica_estrategia(id)
);
GO

IF OBJECT_ID('programa_ci', 'U') IS NULL
CREATE TABLE programa_ci (
    programa_id       INT NOT NULL,
    car_innovacion_id INT NOT NULL,
    PRIMARY KEY (programa_id, car_innovacion_id),
    CONSTRAINT fk_pci_programa FOREIGN KEY (programa_id)       REFERENCES programa(id)       ON DELETE CASCADE,
    CONSTRAINT fk_pci_carinno  FOREIGN KEY (car_innovacion_id) REFERENCES car_innovacion(id)
);
GO

IF OBJECT_ID('an_programa', 'U') IS NULL
CREATE TABLE an_programa (
    aspecto_normativo_id INT NOT NULL,
    programa_id          INT NOT NULL,
    PRIMARY KEY (aspecto_normativo_id, programa_id),
    CONSTRAINT fk_anp_aspecto  FOREIGN KEY (aspecto_normativo_id) REFERENCES aspecto_normativo(id),
    CONSTRAINT fk_anp_programa FOREIGN KEY (programa_id)          REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('enfoque_rc', 'U') IS NULL
CREATE TABLE enfoque_rc (
    enfoque_id                 INT           NOT NULL,
    registro_calificado_codigo NVARCHAR(100) NOT NULL,
    PRIMARY KEY (enfoque_id, registro_calificado_codigo),
    CONSTRAINT fk_erc_enfoque  FOREIGN KEY (enfoque_id)                 REFERENCES enfoque(id),
    CONSTRAINT fk_erc_registro FOREIGN KEY (registro_calificado_codigo) REFERENCES registro_calificado(codigo) ON DELETE CASCADE
);
GO

IF OBJECT_ID('aa_rc', 'U') IS NULL
CREATE TABLE aa_rc (
    id                         INT IDENTITY(1,1) PRIMARY KEY,
    activ_academicas_idcurso   INT,
    registro_calificado_codigo NVARCHAR(100),
    componente                 NVARCHAR(255),
    semestre                   INT,
    CONSTRAINT fk_aarc_activ    FOREIGN KEY (activ_academicas_idcurso)   REFERENCES activ_academica(id)         ON DELETE NO ACTION,
    CONSTRAINT fk_aarc_registro FOREIGN KEY (registro_calificado_codigo) REFERENCES registro_calificado(codigo) ON DELETE NO ACTION
    -- Se usa NO ACTION para evitar múltiples rutas de cascada
    -- (activ_academica y registro_calificado ya tienen CASCADE desde programa)
);
GO

IF OBJECT_ID('docente_departamento', 'U') IS NULL
CREATE TABLE docente_departamento (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    docente_id      NVARCHAR(50),
    departamento_id INT,
    dedicacion      NVARCHAR(100),
    modalidad       NVARCHAR(100),
    fecha_ingreso   DATE,
    fecha_salida    DATE,
    CONSTRAINT fk_dd_programa FOREIGN KEY (departamento_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO

IF OBJECT_ID('alianza', 'U') IS NULL
CREATE TABLE alianza (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    aliado_nit      NVARCHAR(20),
    departamento_id INT,
    fecha_inicio    DATE,
    fecha_fin       DATE,
    docente_id      NVARCHAR(50),
    CONSTRAINT fk_ali_aliado   FOREIGN KEY (aliado_nit)      REFERENCES aliado(nit),
    CONSTRAINT fk_ali_programa FOREIGN KEY (departamento_id) REFERENCES programa(id) ON DELETE CASCADE
);
GO
