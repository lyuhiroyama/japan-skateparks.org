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
// PDO Connection (singleton)
// ============================================================

function db(): PDO {
    static $pdo = null;
    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        } catch (PDOException $e) {
            die('<div style="font-family:monospace;padding:2em;background:#fdd;border:1px solid #c00;">'
                . '<strong>Database connection failed:</strong> ' . htmlspecialchars($e->getMessage())
                . '<br><br>Please edit <code>config/db.php</code> with your MySQL credentials and make sure you have imported <code>sql/schema.sql</code>.'
                . '</div>');
        }
    }
    return $pdo;
}

// ============================================================
// Site configuration
// ============================================================

define('SITE_NAME', 'Japan Skateparks');
define('SITE_TAGLINE', 'The Free Encyclopedia of Skateboarding in Japan');
define('BASE_URL', '');   // Set to subdirectory if needed, e.g. '/japan-skateparks'

