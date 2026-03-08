<?php
// Guard: config must be loaded before header
if (!function_exists('db')) {
    require_once __DIR__ . '/../config/db.php';
}
require_once __DIR__ . '/../lang/loader.php';

$search_query = isset($_GET['q']) ? htmlspecialchars(trim($_GET['q'])) : '';

// Current page detection for sidebar active states
$current_page = basename($_SERVER['PHP_SELF'], '.php');
?>
<!DOCTYPE html>
<html lang="<?= $GLOBALS['current_lang'] ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= isset($page_title) ? htmlspecialchars($page_title) . ' — ' . __('site_name') : __('site_name') ?></title>
    <meta name="description" content="<?= isset($meta_description) ? htmlspecialchars($meta_description) : __('site_tagline') ?>">
    <link rel="stylesheet" href="<?= BASE_URL ?>/css/style.css">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🛹</text></svg>">
</head>
<body>

<!-- ============================================================
     SITE HEADER
     ============================================================ -->
<header id="site-header">
    <div class="header-inner">
        <a href="<?= BASE_URL ?>/index.php" class="site-logo">
            <span class="logo-icon">🛹</span>
            <span class="logo-text">
                <span class="logo-title"><?= __('site_name') ?></span>
                <span class="logo-tagline"><?= __('site_tagline') ?></span>
            </span>
        </a>

        <form class="header-search" action="<?= BASE_URL ?>/search.php" method="get" role="search">
            <?php if (!empty($GLOBALS['current_lang']) && $GLOBALS['current_lang'] !== 'en'): ?>
            <input type="hidden" name="lang" value="<?= htmlspecialchars($GLOBALS['current_lang']) ?>">
            <?php endif; ?>
            <input
                type="search"
                name="q"
                placeholder="<?= __('search_placeholder') ?>"
                value="<?= $search_query ?>"
                aria-label="<?= __('search_button') ?>">
            <button type="submit"><?= __('search_button') ?></button>
        </form>

        <nav class="header-nav" aria-label="Site navigation">
            <a href="<?= BASE_URL ?>/index.php<?= $GLOBALS['current_lang'] !== 'en' ? '?lang=' . $GLOBALS['current_lang'] : '' ?>"><?= __('nav_main_page') ?></a>
            <a href="<?= BASE_URL ?>/prefecture.php<?= $GLOBALS['current_lang'] !== 'en' ? '?lang=' . $GLOBALS['current_lang'] : '' ?>"><?= __('nav_prefectures') ?></a>
            <a href="<?= BASE_URL ?>/category.php<?= $GLOBALS['current_lang'] !== 'en' ? '?lang=' . $GLOBALS['current_lang'] : '' ?>"><?= __('nav_categories') ?></a>
            <a href="<?= BASE_URL ?>/admin/index.php"><?= __('nav_admin') ?></a>
            <span class="lang-switcher">
                <a href="<?= lang_url('en') ?>" class="<?= $GLOBALS['current_lang'] === 'en' ? 'lang-active' : '' ?>">EN</a>
                <span>|</span>
                <a href="<?= lang_url('ja') ?>" class="<?= $GLOBALS['current_lang'] === 'ja' ? 'lang-active' : '' ?>">JA</a>
            </span>
        </nav>
    </div>
</header>

<!-- ============================================================
     PAGE WRAPPER
     ============================================================ -->
<div id="page-wrapper">

    <!-- ---- LEFT SIDEBAR ---- -->
    <nav id="sidebar" aria-label="Sidebar navigation">

        <div class="sidebar-portlet">
            <h3><?= __('sidebar_navigation') ?></h3>
            <ul>
                <li><a href="<?= BASE_URL ?>/index.php" <?= $current_page === 'index' ? 'class="active"' : '' ?>><?= __('nav_main_page') ?></a></li>
                <li><a href="<?= BASE_URL ?>/prefecture.php" <?= $current_page === 'prefecture' ? 'class="active"' : '' ?>><?= __('sidebar_by_prefecture') ?></a></li>
                <li><a href="<?= BASE_URL ?>/category.php" <?= $current_page === 'category' ? 'class="active"' : '' ?>><?= __('sidebar_by_category') ?></a></li>
                <li><a href="<?= BASE_URL ?>/search.php" <?= $current_page === 'search' ? 'class="active"' : '' ?>><?= __('sidebar_all_skateparks') ?></a></li>
            </ul>
        </div>

        <div class="sidebar-portlet">
            <h3><?= __('sidebar_regions') ?></h3>
            <ul>
                <?php
                try {
                    $regions = db()->query("
                        SELECT p.region, COUNT(s.id) as cnt
                        FROM prefectures p
                        JOIN skateparks s ON s.prefecture_id = p.id
                        GROUP BY p.region
                        ORDER BY cnt DESC
                    ")->fetch_all(MYSQLI_ASSOC);
                    foreach ($regions as $r):
                ?>
                <li>
                    <a href="<?= BASE_URL ?>/prefecture.php?region=<?= urlencode($r['region']) ?>">
                        <?= htmlspecialchars($r['region']) ?>
                        <small>(<?= $r['cnt'] ?>)</small>
                    </a>
                </li>
                <?php endforeach;
                } catch (Exception $e) { echo '<li>—</li>'; } ?>
            </ul>
        </div>

        <div class="sidebar-portlet">
            <h3><?= __('sidebar_categories') ?></h3>
            <ul>
                <?php
                try {
                    $cats = db()->query("
                        SELECT t.name, t.slug, COUNT(st.skatepark_id) as cnt
                        FROM tags t
                        JOIN skatepark_tags st ON st.tag_id = t.id
                        GROUP BY t.id
                        ORDER BY cnt DESC
                        LIMIT 8
                    ")->fetch_all(MYSQLI_ASSOC);
                    foreach ($cats as $c):
                ?>
                <li>
                    <a href="<?= BASE_URL ?>/category.php?tag=<?= urlencode($c['slug']) ?>">
                        <?= htmlspecialchars($c['name']) ?>
                    </a>
                </li>
                <?php endforeach;
                } catch (Exception $e) { echo '<li>—</li>'; } ?>
            </ul>
        </div>

        <div class="sidebar-portlet">
            <h3><?= __('sidebar_tools') ?></h3>
            <ul>
                <li><a href="<?= BASE_URL ?>/admin/add.php"><?= __('sidebar_add_skatepark') ?></a></li>
            </ul>
        </div>

    </nav>
    <!-- /sidebar -->

    <!-- ---- MAIN CONTENT ---- -->
    <main id="content">

