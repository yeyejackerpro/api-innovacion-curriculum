-- ============================================================
--  MÓDULO: Innovación Curricular
--  Base de datos: innovacion_curricular
--  Motor: MySQL / MariaDB
-- ============================================================

CREATE DATABASE IF NOT EXISTS innovacion_curricular
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE innovacion_curricular;

-- ============================================================
-- 1. TABLAS INDEPENDIENTES (sin claves foráneas)
-- ============================================================

CREATE TABLE IF NOT EXISTS area_conocimiento (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    gran_area   VARCHAR(255),
    area        VARCHAR(255),
    disciplina  VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS universidad (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    nombre  VARCHAR(255),
    tipo    VARCHAR(100),
    ciudad  VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS aspecto_normativo (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    tipo        VARCHAR(100),
    descripcion TEXT,
    fuente      VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS practica_estrategia (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    tipo        VARCHAR(100),
    nombre      VARCHAR(255),
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS enfoque (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(255),
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS car_innovacion (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(255),
    descripcion TEXT,
    tipo        VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS aliado (
    nit             VARCHAR(20)  PRIMARY KEY,
    razon_social    VARCHAR(255),
    nombre_contacto VARCHAR(255),
    correo          VARCHAR(255),
    telefono        VARCHAR(50),
    ciudad          VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2. TABLAS DE GESTIÓN DE USUARIOS
-- ============================================================

CREATE TABLE IF NOT EXISTS rol (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100),
    descripcion    TEXT,
    activo         BOOLEAN      DEFAULT TRUE,
    fecha_creacion DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS usuario (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(100) UNIQUE,
    password       VARCHAR(255),
    email          VARCHAR(255),
    nombre_completo VARCHAR(255),
    activo         BOOLEAN      DEFAULT TRUE,
    fecha_creacion DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS rol_usuario (
    usuario_id INT NOT NULL,
    rol_id     INT NOT NULL,
    PRIMARY KEY (usuario_id, rol_id),
    CONSTRAINT fk_rolusu_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    CONSTRAINT fk_rolusu_rol     FOREIGN KEY (rol_id)     REFERENCES rol(id)     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. TABLAS CON CLAVES FORÁNEAS (dependencias)
-- ============================================================

CREATE TABLE IF NOT EXISTS facultad (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(255),
    tipo           VARCHAR(100),
    fecha_fun      DATE,
    universidad_id INT,
    CONSTRAINT fk_fac_universidad FOREIGN KEY (universidad_id) REFERENCES universidad(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS programa (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    nombre             VARCHAR(255),
    tipo               VARCHAR(100),
    nivel              VARCHAR(100),
    fecha_creacion     DATE,
    fecha_cierre       DATE,
    numero_cohortes    INT,
    cant_graduados     INT,
    fecha_actualizacion DATE,
    ciudad             VARCHAR(100),
    facultad_id        INT,
    CONSTRAINT fk_prog_facultad FOREIGN KEY (facultad_id) REFERENCES facultad(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS acreditacion (
    resolucion  VARCHAR(100) PRIMARY KEY,
    tipo        VARCHAR(100),
    calificacion VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin    DATE,
    programa_id  INT,
    CONSTRAINT fk_acred_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS registro_calificado (
    codigo              VARCHAR(100) PRIMARY KEY,
    cant_creditos       INT,
    hora_acom           INT,
    hora_ind            INT,
    metodologia         VARCHAR(255),
    fecha_inicio        DATE,
    fecha_fin           DATE,
    duracion_anios      INT,
    duracion_semestres  INT,
    tipo_titulacion     VARCHAR(100),
    programa_id         INT,
    CONSTRAINT fk_rc_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS activ_academica (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(255),
    num_creditos    INT,
    tipo            VARCHAR(100),
    area_formacion  VARCHAR(255),
    h_acom          INT,
    h_indep         INT,
    idioma          VARCHAR(50),
    espejo          BOOLEAN,
    entidad_espejo  VARCHAR(255),
    pais_espejo     VARCHAR(100),
    programa_id     INT,
    CONSTRAINT fk_aa_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS pasantia (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(255),
    pais        VARCHAR(100),
    empresa     VARCHAR(255),
    descripcion TEXT,
    programa_id INT,
    CONSTRAINT fk_pas_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS premio (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(255),
    descripcion      TEXT,
    fecha            DATE,
    entidad_otorgante VARCHAR(255),
    pais             VARCHAR(100),
    programa_id      INT,
    CONSTRAINT fk_pre_programa FOREIGN KEY (programa_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4. TABLAS PUENTE (relaciones muchos a muchos)
-- ============================================================

CREATE TABLE IF NOT EXISTS programa_ac (
    programa_id         INT NOT NULL,
    area_conocimiento_id INT NOT NULL,
    PRIMARY KEY (programa_id, area_conocimiento_id),
    CONSTRAINT fk_pac_programa FOREIGN KEY (programa_id)          REFERENCES programa(id)          ON DELETE CASCADE,
    CONSTRAINT fk_pac_area     FOREIGN KEY (area_conocimiento_id)  REFERENCES area_conocimiento(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS programa_pe (
    programa_id           INT NOT NULL,
    practica_estrategia_id INT NOT NULL,
    PRIMARY KEY (programa_id, practica_estrategia_id),
    CONSTRAINT fk_ppe_programa  FOREIGN KEY (programa_id)            REFERENCES programa(id)            ON DELETE CASCADE,
    CONSTRAINT fk_ppe_practica  FOREIGN KEY (practica_estrategia_id) REFERENCES practica_estrategia(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS programa_ci (
    programa_id      INT NOT NULL,
    car_innovacion_id INT NOT NULL,
    PRIMARY KEY (programa_id, car_innovacion_id),
    CONSTRAINT fk_pci_programa FOREIGN KEY (programa_id)       REFERENCES programa(id)       ON DELETE CASCADE,
    CONSTRAINT fk_pci_carinno  FOREIGN KEY (car_innovacion_id) REFERENCES car_innovacion(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS an_programa (
    aspecto_normativo_id INT NOT NULL,
    programa_id          INT NOT NULL,
    PRIMARY KEY (aspecto_normativo_id, programa_id),
    CONSTRAINT fk_anp_aspecto  FOREIGN KEY (aspecto_normativo_id) REFERENCES aspecto_normativo(id) ON DELETE CASCADE,
    CONSTRAINT fk_anp_programa FOREIGN KEY (programa_id)          REFERENCES programa(id)          ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS enfoque_rc (
    enfoque_id                  INT          NOT NULL,
    registro_calificado_codigo  VARCHAR(100) NOT NULL,
    PRIMARY KEY (enfoque_id, registro_calificado_codigo),
    CONSTRAINT fk_erc_enfoque  FOREIGN KEY (enfoque_id)                 REFERENCES enfoque(id)             ON DELETE CASCADE,
    CONSTRAINT fk_erc_registro FOREIGN KEY (registro_calificado_codigo) REFERENCES registro_calificado(codigo) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS aa_rc (
    id                          INT AUTO_INCREMENT PRIMARY KEY,
    activ_academicas_idcurso    INT,
    registro_calificado_codigo  VARCHAR(100),
    componente                  VARCHAR(255),
    semestre                    INT,
    CONSTRAINT fk_aarc_activ    FOREIGN KEY (activ_academicas_idcurso)   REFERENCES activ_academica(id)        ON DELETE CASCADE,
    CONSTRAINT fk_aarc_registro FOREIGN KEY (registro_calificado_codigo) REFERENCES registro_calificado(codigo) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS docente_departamento (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    docente_id       VARCHAR(50),
    departamento_id  INT,
    dedicacion       VARCHAR(100),
    modalidad        VARCHAR(100),
    fecha_ingreso    DATE,
    fecha_salida     DATE,
    CONSTRAINT fk_dd_programa FOREIGN KEY (departamento_id) REFERENCES programa(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS alianza (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    aliado_nit       VARCHAR(20),
    departamento_id  INT,
    fecha_inicio     DATE,
    fecha_fin        DATE,
    docente_id       VARCHAR(50),
    CONSTRAINT fk_ali_aliado    FOREIGN KEY (aliado_nit)      REFERENCES aliado(nit)      ON DELETE CASCADE,
    CONSTRAINT fk_ali_programa  FOREIGN KEY (departamento_id) REFERENCES programa(id)     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;