<?php
// Guard: config must be loaded before header
if (!function_exists('db')) {
    require_once __DIR__ . '/../config/db.php';
}

$search_query = isset($_GET['q']) ? htmlspecialchars(trim($_GET['q'])) : '';

// Current page detection for sidebar active states
$current_page = basename($_SERVER['PHP_SELF'], '.php');
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= isset($page_title) ? htmlspecialchars($page_title) . ' — ' . SITE_NAME : SITE_NAME ?></title>
    <meta name="description" content="<?= isset($meta_description) ? htmlspecialchars($meta_description) : SITE_TAGLINE ?>">
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
                <span class="logo-title">Japan Skateparks</span>
                <span class="logo-tagline">The Free Encyclopedia of Japan's Skateparks</span>
            </span>
        </a>

        <form class="header-search" action="<?= BASE_URL ?>/search.php" method="get" role="search">
            <input
                type="search"
                name="q"
                placeholder="Search skateparks…"
                value="<?= $search_query ?>"
                aria-label="Search">
            <button type="submit">Search</button>
        </form>

        <nav class="header-nav" aria-label="Site navigation">
            <a href="<?= BASE_URL ?>/index.php">Main Page</a>
            <a href="<?= BASE_URL ?>/prefecture.php">Prefectures</a>
            <a href="<?= BASE_URL ?>/category.php">Categories</a>
            <a href="<?= BASE_URL ?>/admin/index.php">Admin</a>
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
            <h3>Navigation</h3>
            <ul>
                <li><a href="<?= BASE_URL ?>/index.php" <?= $current_page === 'index' ? 'class="active"' : '' ?>>Main Page</a></li>
                <li><a href="<?= BASE_URL ?>/prefecture.php" <?= $current_page === 'prefecture' ? 'class="active"' : '' ?>>By Prefecture</a></li>
                <li><a href="<?= BASE_URL ?>/category.php" <?= $current_page === 'category' ? 'class="active"' : '' ?>>By Category</a></li>
                <li><a href="<?= BASE_URL ?>/search.php" <?= $current_page === 'search' ? 'class="active"' : '' ?>>All Skateparks</a></li>
            </ul>
        </div>

        <div class="sidebar-portlet">
            <h3>Regions</h3>
            <ul>
                <?php
                // Fetch distinct regions with count
                try {
                    $regions = db()->query("
                        SELECT p.region, COUNT(s.id) as cnt
                        FROM prefectures p
                        JOIN skateparks s ON s.prefecture_id = p.id
                        GROUP BY p.region
                        ORDER BY cnt DESC
                    ")->fetchAll();
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
            <h3>Categories</h3>
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
                    ")->fetchAll();
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
            <h3>Tools</h3>
            <ul>
                <li><a href="<?= BASE_URL ?>/admin/add.php">Add Skatepark</a></li>
            </ul>
        </div>

    </nav>
    <!-- /sidebar -->

    <!-- ---- MAIN CONTENT ---- -->
    <main id="content">

