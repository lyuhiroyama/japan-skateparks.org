<?php
// ============================================================
// Language loader
// Usage: require_once __DIR__ . '/../lang/loader.php';
//   - Reads ?lang=en|ja or cookie, stores cookie, sets $GLOBALS
//   - Defines __('key') helper and lang_url('ja') helper
// ============================================================

function detect_browser_lang(array $allowed): string {
    $accept = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? '';
    foreach (explode(',', $accept) as $part) {
        $code = strtolower(substr(trim($part), 0, 2));
        if (in_array($code, $allowed, true)) {
            return $code;
        }
    }
    return 'en';
}

function load_lang_strings(): void {
    $allowed = ['en', 'ja'];
    $lang    = 'en';

    if (isset($_GET['lang']) && in_array($_GET['lang'], $allowed, true)) {
        // Explicit switch via URL — save to cookie
        $lang = $_GET['lang'];
        setcookie('lang', $lang, time() + 60 * 60 * 24 * 365, '/');
    } elseif (isset($_COOKIE['lang']) && in_array($_COOKIE['lang'], $allowed, true)) {
        // Returning visitor — use saved preference
        $lang = $_COOKIE['lang'];
    } else {
        // First visit — detect from browser Accept-Language header
        $lang = detect_browser_lang($allowed);
    }

    $GLOBALS['current_lang']  = $lang;
    $GLOBALS['lang_strings']  = require __DIR__ . "/$lang.php";
}

function __(string $key, ...$args): string {
    $str = $GLOBALS['lang_strings'][$key] ?? $key;
    return $args ? vsprintf($str, $args) : $str;
}

function lang_url(string $lang): string {
    $params         = $_GET;
    $params['lang'] = $lang;
    return '?' . http_build_query($params);
}

load_lang_strings();
