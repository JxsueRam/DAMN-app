<?php
/**
 * Configuracion central de la base de datos.
 *
 * Crea una unica conexion PDO al iniciar y la expone como $pdo.
 * Usa sentencias preparadas (PDO) — cumple PDF §2 contra inyeccion SQL.
 * Conexion cifrada con SSL — Aiven exige TLS.
 *
 * Uso desde un endpoint:
 *   require_once __DIR__ . '/../config/db.php';
 *   $stmt = $pdo->prepare('SELECT * FROM carrera WHERE id_carrera = :id');
 *   $stmt->execute([':id' => 1]);
 */

require_once __DIR__ . '/../utils/env.php';

// Cargar variables de entorno
try {
    Env::load(__DIR__ . '/../.env');
} catch (Throwable $e) {
    // No mostrar el path real al usuario (PDF §5.2: errores amigables)
    error_log('[ENV] ' . $e->getMessage());
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => false,
        'message' => 'Error de configuracion del servidor',
    ]);
    exit;
}

// Construir el DSN de PDO
$host     = Env::required('DB_HOST');
$port     = Env::required('DB_PORT');
$database = Env::required('DB_NAME');
$user     = Env::required('DB_USER');
$password = Env::required('DB_PASSWORD');
$sslCa    = Env::required('DB_SSL_CA');

$dsn = "mysql:host=$host;port=$port;dbname=$database;charset=utf8mb4";

// Resolver la ruta absoluta del certificado
// (la variable .env tiene una ruta relativa al proyecto)
$sslCaPath = realpath(__DIR__ . '/../../' . $sslCa);
if ($sslCaPath === false) {
    error_log('[DB] Certificado SSL no encontrado en: ' . $sslCa);
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => false,
        'message' => 'Error de configuracion del servidor',
    ]);
    exit;
}

$options = [
    // Lanzar excepciones cuando algo sale mal (mejor para debugging)
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,

    // fetch() devuelve arrays asociativos por defecto
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,

    // No emular sentencias preparadas — usar las nativas de MySQL
    PDO::ATTR_EMULATE_PREPARES   => false,

    // SSL obligatorio para Aiven
    PDO::MYSQL_ATTR_SSL_CA       => $sslCaPath,
    PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => true,
];

try {
    $pdo = new PDO($dsn, $user, $password, $options);
} catch (PDOException $e) {
    // Loguear el error real, pero al usuario solo mensaje amigable
    error_log('[DB] Conexion fallida: ' . $e->getMessage());
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => false,
        'message' => 'No se pudo conectar a la base de datos',
    ]);
    exit;
}
