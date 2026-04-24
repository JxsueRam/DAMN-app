-- =============================================================
--  SACAD — Sistema para la Gestión de ETS
--  Base de datos: MySQL 8.x
--  Escuela Superior de Cómputo - IPN
--
--  Convenciones (PDF §5.4):
--    - Nombres en minúsculas y singular
--    - snake_case para columnas
--    - IDs como claves primarias autoincrementales
-- =============================================================

-- NOTA: Aiven crea la base `defaultdb` automáticamente.
--       No necesitas ejecutar CREATE DATABASE.
--       Si usas XAMPP local, descomenta las 3 líneas siguientes:

-- CREATE DATABASE IF NOT EXISTS sacad_db
--     CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE sacad_db;


-- -------------------------------------------------------------
-- TABLA: usuario
-- Administradores del sistema (PDF §B.1)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario       INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario   VARCHAR(50)  NOT NULL UNIQUE,
    correo           VARCHAR(100) NOT NULL UNIQUE,
    password_hash    VARCHAR(255) NOT NULL,
    nombre_completo  VARCHAR(150) NOT NULL,
    rol              ENUM('admin', 'superadmin') NOT NULL DEFAULT 'admin',
    activo           BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso    TIMESTAMP NULL,
    INDEX idx_usuario_correo (correo),
    INDEX idx_usuario_activo (activo)
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: carrera
-- Catálogo de carreras de ESCOM (PDF §B.4)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS carrera (
    id_carrera  INT AUTO_INCREMENT PRIMARY KEY,
    clave       VARCHAR(10)  NOT NULL UNIQUE,
    nombre      VARCHAR(150) NOT NULL,
    activo      BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: edificio
-- Catálogo de edificios (PDF §B.4)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS edificio (
    id_edificio INT AUTO_INCREMENT PRIMARY KEY,
    clave       VARCHAR(10)  NOT NULL UNIQUE,
    nombre      VARCHAR(100) NOT NULL,
    activo      BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: salon
-- Cada salón pertenece a un edificio
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS salon (
    id_salon    INT AUTO_INCREMENT PRIMARY KEY,
    id_edificio INT NOT NULL,
    numero      VARCHAR(20) NOT NULL,
    capacidad   INT DEFAULT 30,
    activo      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_salon_edificio
        FOREIGN KEY (id_edificio) REFERENCES edificio(id_edificio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uk_salon_edificio_numero (id_edificio, numero)
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: profesor
-- Profesores evaluadores (PDF §A.2)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS profesor (
    id_profesor       INT AUTO_INCREMENT PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    apellido_paterno  VARCHAR(50)  NOT NULL,
    apellido_materno  VARCHAR(50),
    correo            VARCHAR(100),
    activo            BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX idx_profesor_nombre (apellido_paterno, apellido_materno, nombre)
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: unidad_aprendizaje
-- Materias, pertenecen a una carrera (PDF §A.1)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS unidad_aprendizaje (
    id_unidad    INT AUTO_INCREMENT PRIMARY KEY,
    id_carrera   INT NOT NULL,
    clave        VARCHAR(20)  NOT NULL UNIQUE,
    nombre       VARCHAR(150) NOT NULL,
    semestre     TINYINT NOT NULL CHECK (semestre BETWEEN 1 AND 10),
    creditos     TINYINT,
    activo       BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_unidad_carrera
        FOREIGN KEY (id_carrera) REFERENCES carrera(id_carrera)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_unidad_semestre (semestre),
    INDEX idx_unidad_carrera (id_carrera)
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: examen
-- Tabla central: cada registro es un ETS programado (PDF §A.2)
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS examen (
    id_examen             INT AUTO_INCREMENT PRIMARY KEY,
    id_unidad             INT  NOT NULL,
    id_profesor           INT  NOT NULL,
    id_salon              INT  NOT NULL,
    fecha                 DATE NOT NULL,
    hora_inicio           TIME NOT NULL,
    hora_fin              TIME NOT NULL,
    turno                 ENUM('matutino', 'vespertino') NOT NULL,
    periodo               VARCHAR(10) NOT NULL,
    cupo_maximo           INT DEFAULT 30,
    observaciones         TEXT,
    fecha_creacion        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_examen_unidad
        FOREIGN KEY (id_unidad) REFERENCES unidad_aprendizaje(id_unidad)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_examen_profesor
        FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_examen_salon
        FOREIGN KEY (id_salon) REFERENCES salon(id_salon)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_examen_horas CHECK (hora_fin > hora_inicio),
    INDEX idx_examen_fecha   (fecha),
    INDEX idx_examen_periodo (periodo),
    INDEX idx_examen_turno   (turno)
) ENGINE=InnoDB;


-- -------------------------------------------------------------
-- TABLA: sesion_token
-- Tokens de autenticación para la app móvil
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sesion_token (
    id_token        INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT NOT NULL,
    token           VARCHAR(255) NOT NULL UNIQUE,
    fecha_emision   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_expira    TIMESTAMP NOT NULL,
    revocado        BOOLEAN NOT NULL DEFAULT FALSE,
    user_agent      VARCHAR(255),
    ip_origen       VARCHAR(45),
    CONSTRAINT fk_token_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,
    INDEX idx_token_valor (token),
    INDEX idx_token_vigencia (fecha_expira, revocado)
) ENGINE=InnoDB;
