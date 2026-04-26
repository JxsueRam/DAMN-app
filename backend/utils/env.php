<?php
/**
 * Cargador minimo de variables de entorno desde un archivo .env
 *
 * Por que esta clase y no una libreria:
 * El PDF §5.1 prohibe librerias externas en PHP. Este parser cubre
 * lo basico que necesitamos: lineas KEY=VALUE, ignorar comentarios,
 * ignorar lineas vacias, manejar comillas opcionales.
 *
 * Uso:
 *   Env::load(__DIR__ . '/../.env');
 *   $host = Env::get('DB_HOST');
 *   $port = Env::get('DB_PORT', 3306); // con valor por defecto
 */

class Env
{
    /** @var array<string, string> */
    private static array $vars = [];

    /**
     * Carga el archivo .env en memoria.
     * Lanza una excepcion si el archivo no existe (mejor fallar rapido).
     */
    public static function load(string $path): void
    {
        if (!is_readable($path)) {
            throw new RuntimeException("No se pudo leer el archivo .env en: $path");
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

        foreach ($lines as $line) {
            $line = trim($line);

            // Ignorar comentarios y lineas sin =
            if ($line === '' || str_starts_with($line, '#') || !str_contains($line, '=')) {
                continue;
            }

            [$key, $value] = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value);

            // Quitar comillas envolventes si existen
            if (
                (str_starts_with($value, '"') && str_ends_with($value, '"')) ||
                (str_starts_with($value, "'") && str_ends_with($value, "'"))
            ) {
                $value = substr($value, 1, -1);
            }

            self::$vars[$key] = $value;
        }
    }

    /**
     * Obtiene el valor de una variable. Devuelve $default si no existe.
     */
    public static function get(string $key, $default = null)
    {
        return self::$vars[$key] ?? $default;
    }

    /**
     * Obtiene una variable obligatoria. Lanza excepcion si falta.
     * Util para credenciales que no pueden tener default.
     */
    public static function required(string $key): string
    {
        if (!isset(self::$vars[$key]) || self::$vars[$key] === '') {
            throw new RuntimeException("Variable de entorno requerida: $key");
        }
        return self::$vars[$key];
    }
}
