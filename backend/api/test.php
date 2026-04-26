<?php
/**
 * GET /api/test.php
 *
 * Endpoint de prueba que confirma:
 *  1. PHP esta funcionando.
 *  2. El archivo .env carga bien.
 *  3. La conexion SSL a Aiven es correcta.
 *  4. Las tablas existen y tienen datos.
 */

require_once __DIR__ . '/../utils/response.php';
require_once __DIR__ . '/../config/db.php';

try {
    // Consulta simple para validar lectura
    $stmt = $pdo->query('
        SELECT
            (SELECT COUNT(*) FROM carrera)            AS total_carreras,
            (SELECT COUNT(*) FROM unidad_aprendizaje) AS total_materias,
            (SELECT COUNT(*) FROM examen)             AS total_examenes,
            (SELECT COUNT(*) FROM usuario)            AS total_usuarios
    ');
    $stats = $stmt->fetch();

    // Consulta con JOIN para validar relaciones
    $stmt = $pdo->query('
        SELECT
            c.clave    AS carrera_clave,
            c.nombre   AS carrera_nombre,
            COUNT(ua.id_unidad) AS total_materias
        FROM carrera c
        LEFT JOIN unidad_aprendizaje ua ON ua.id_carrera = c.id_carrera
        GROUP BY c.id_carrera, c.clave, c.nombre
        ORDER BY c.clave
    ');
    $carrerasConMaterias = $stmt->fetchAll();

    Response::ok([
        'mensaje'   => 'Backend funcionando correctamente',
        'php'       => PHP_VERSION,
        'mysql'     => $pdo->getAttribute(PDO::ATTR_SERVER_VERSION),
        'estadisticas' => $stats,
        'carreras'  => $carrerasConMaterias,
        'timestamp' => date('Y-m-d H:i:s'),
    ]);

} catch (PDOException $e) {
    error_log('[TEST] Error de query: ' . $e->getMessage());
    Response::error('Error consultando la base de datos', 500);
}