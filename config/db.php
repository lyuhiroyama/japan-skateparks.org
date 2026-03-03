<?php
// ============================================================
// Database Configuration
// ============================================================
// Edit these values to match your MySQL server settings.

define('DB_HOST', 'localhost');
define('DB_USER', 'root');       // your MySQL username
define('DB_PASS', '');           // your MySQL password
define('DB_NAME', 'japan_skateparks');
define('DB_CHARSET', 'utf8mb4');

// ============================================================
// MySQLi Connection (singleton)
// ============================================================

function db(): mysqli {
    static $mysqli = null;
    if ($mysqli === null) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        try {
            $mysqli = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
            $mysqli->set_charset(DB_CHARSET);
        } catch (mysqli_sql_exception $e) {
            die('<div style="font-family:monospace;padding:2em;background:#fdd;border:1px solid #c00;">'
                . '<strong>Database connection failed:</strong> ' . htmlspecialchars($e->getMessage())
                . '<br><br>Please edit <code>config/db.php</code> with your MySQL credentials and make sure you have imported <code>sql/schema.sql</code>.'
                . '</div>');
        }
    }
    return $mysqli;
}

// ============================================================
// Helper: prepare → bind → execute → return stmt
// All params are bound as strings; MySQL handles coercion.
// Nulls are passed through correctly.
// ============================================================

function db_run(string $sql, array $params = []): mysqli_stmt {
    $db   = db();
    $stmt = $db->prepare($sql);
    if ($params) {
        $types = str_repeat('s', count($params));
        $refs  = [&$types];
        foreach ($params as &$p) {
            $refs[] = &$p;
        }
        call_user_func_array([$stmt, 'bind_param'], $refs);
    }
    $stmt->execute();
    return $stmt;
}

// ============================================================
// Site configuration
// ============================================================

define('SITE_NAME', 'Japan Skateparks');
define('SITE_TAGLINE', 'The Free Encyclopedia of Skateboarding in Japan');
define('BASE_URL', '');   // Set to subdirectory if needed, e.g. '/japan-skateparks'
