<?php
// ============================================================
// Language loader
// Usage: require_once __DIR__ . '/../lang/loader.php';
//   - Reads ?lang=en|ja or cookie, stores cookie, sets $GLOBALS
//   - Defines __('key') helper and lang_url('ja') helper
// ============================================================

function load_lang_strings(): void {
    $allowed = ['en', 'ja'];
    $lang    = 'en';

    if (isset($_GET['lang']) && in_array($_GET['lang'], $allowed, true)) {
        $lang = $_GET['lang'];
        setcookie('lang', $lang, time() + 60 * 60 * 24 * 365, '/');
    } elseif (isset($_COOKIE['lang']) && in_array($_COOKIE['lang'], $allowed, true)) {
        $lang = $_COOKIE['lang'];
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
