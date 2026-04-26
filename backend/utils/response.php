<?php
/**
 * Helpers para responder con JSON consistente desde cualquier endpoint.
 *
 * Formato estandar:
 * {
 *   "success": true|false,
 *   "data":    { ... }       // solo en exito
 *   "message": "texto"       // solo en error
 * }
 *
 * Uso:
 *   Response::ok(['carrera' => $row]);
 *   Response::error('Credenciales invalidas', 401);
 */

class Response
{
    /**
     * Respuesta de exito con codigo 200.
     */
    public static function ok($data = null, int $status = 200): void
    {
        self::send($status, [
            'success' => true,
            'data'    => $data,
        ]);
    }

    /**
     * Respuesta de error con codigo HTTP indicado.
     */
    public static function error(string $message, int $status = 400): void
    {
        self::send($status, [
            'success' => false,
            'message' => $message,
        ]);
    }

    /**
     * Envia el JSON y termina el script.
     */
    private static function send(int $status, array $payload): void
    {
        if (!headers_sent()) {
            http_response_code($status);
            header('Content-Type: application/json; charset=utf-8');
            // CORS basico (ajustar dominios en produccion)
            header('Access-Control-Allow-Origin: *');
            header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
            header('Access-Control-Allow-Headers: Content-Type, Authorization');
        }

        echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;
    }
}

// Manejar preflight CORS automaticamente
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    Response::ok();
}
