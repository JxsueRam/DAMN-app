-- =============================================================
--  SACAD — Datos de prueba (seeds)
--  Ejecutar DESPUÉS de schema.sql
-- =============================================================

-- -------------------------------------------------------------
-- USUARIO ADMIN DE PRUEBA
-- Password en texto plano: Admin1234
--
-- IMPORTANTE: el hash de abajo es SOLO de ejemplo y NO funciona.
-- Antes de importar, genera el hash real ejecutando en terminal:
--     php -r "echo password_hash('Admin1234', PASSWORD_BCRYPT);"
-- Copia el resultado y reemplaza el valor de password_hash.
-- -------------------------------------------------------------
INSERT INTO usuario (nombre_usuario, correo, password_hash, nombre_completo, rol)
VALUES
('admin', 'admin@ipn.mx',
 '$2y$10$REEMPLAZA_ESTE_HASH_CON_EL_QUE_GENERES_CON_PHP',
 'Administrador General', 'superadmin');


-- -------------------------------------------------------------
-- CARRERAS DE ESCOM
-- -------------------------------------------------------------
INSERT INTO carrera (clave, nombre) VALUES
('ISC', 'Ingeniería en Sistemas Computacionales'),
('IIA', 'Ingeniería en Inteligencia Artificial'),
('LCD', 'Licenciatura en Ciencia de Datos');


-- -------------------------------------------------------------
-- EDIFICIOS
-- -------------------------------------------------------------
INSERT INTO edificio (clave, nombre) VALUES
('A',    'Edificio A - Aulas'),
('LCCT', 'Laboratorio de Cómputo y Centro de Tecnologías'),
('B',    'Edificio B - Laboratorios');


-- -------------------------------------------------------------
-- SALONES (dependen del id_edificio que MySQL asignó)
-- -------------------------------------------------------------
INSERT INTO salon (id_edificio, numero, capacidad) VALUES
(1, '101', 40),
(1, '102', 40),
(1, '201', 35),
(2, 'LAB-1', 25),
(2, 'LAB-2', 25),
(3, 'B-10', 30);


-- -------------------------------------------------------------
-- PROFESORES DE EJEMPLO
-- -------------------------------------------------------------
INSERT INTO profesor (nombre, apellido_paterno, apellido_materno, correo) VALUES
('José Antonio', 'Ortiz', 'Ramírez',  'jortizr@ipn.mx'),
('María',        'López',  'Hernández','mlopezh@ipn.mx'),
('Carlos',       'Méndez', 'García',   'cmendez@ipn.mx');


-- -------------------------------------------------------------
-- UNIDADES DE APRENDIZAJE (MATERIAS)
-- -------------------------------------------------------------
INSERT INTO unidad_aprendizaje (id_carrera, clave, nombre, semestre, creditos) VALUES
(1, 'TDAW',  'Tecnologías para el Desarrollo de Aplicaciones Web', 7, 8),
(1, 'BDA',   'Bases de Datos Avanzadas',                            6, 7),
(1, 'FI',    'Fundamentos de Ingeniería',                           1, 6),
(2, 'ML',    'Aprendizaje Automático',                              6, 8),
(3, 'EST',   'Estadística Aplicada',                                3, 7);


-- -------------------------------------------------------------
-- EXÁMENES PROGRAMADOS DE EJEMPLO
-- -------------------------------------------------------------
INSERT INTO examen (id_unidad, id_profesor, id_salon, fecha, hora_inicio, hora_fin, turno, periodo, cupo_maximo) VALUES
(1, 1, 1, '2026-06-15', '09:00:00', '11:00:00', 'matutino',   '2026-2', 30),
(2, 2, 2, '2026-06-16', '10:00:00', '12:00:00', 'matutino',   '2026-2', 30),
(3, 3, 4, '2026-06-17', '15:00:00', '17:00:00', 'vespertino', '2026-2', 25),
(4, 2, 5, '2026-06-18', '09:00:00', '11:00:00', 'matutino',   '2026-2', 25),
(5, 1, 6, '2026-06-19', '14:00:00', '16:00:00', 'vespertino', '2026-2', 30);
