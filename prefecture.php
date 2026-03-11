<?php
require_once __DIR__ . '/config/db.php';

$name   = isset($_GET['name'])   ? trim($_GET['name'])   : '';
$region = isset($_GET['region']) ? trim($_GET['region']) : '';

if ($name) {
    // ---- Single prefecture article ----
    $pref = db_run("
        SELECT p.*, COUNT(s.id) as park_count
        FROM prefectures p
        LEFT JOIN skateparks s ON s.prefecture_id = p.id
        WHERE p.name = ?
        GROUP BY p.id
    ", [$name])->get_result()->fetch_assoc();

    if (!$pref) {
        header('Location: ' . BASE_URL . '/prefecture.php');
        exit;
    }

    // Parks in this prefecture
    $parks = db_run("
        SELECT s.slug, s.name, s.name_ja, s.city, s.park_type, s.surface_type, s.admission_fee
        FROM skateparks s
        WHERE s.prefecture_id = ?
        ORDER BY s.name ASC
    ", [$pref['id']])->get_result()->fetch_all(MYSQLI_ASSOC);

    $page_title = $pref['name'] . ' Skateparks';

    require_once __DIR__ . '/includes/header.php';
?>
<!-- Page tabs -->
<div class="page-tabs" style="margin-bottom:.8rem;">
    <span class="page-tab active"><?= __('tab_category') ?></span>
    <a class="page-tab" href="<?= BASE_URL ?>/prefecture.php"><?= __('all_prefectures_tab') ?></a>
</div>

<h1 class="article-title">
    <?= __('skateparks_in') ?> <?= htmlspecialchars($pref['name']) ?>
    <small><?= htmlspecialchars($pref['name_ja']) ?> · <?= htmlspecialchars($pref['region']) ?> <?= __('region_suffix') ?></small>
</h1>

<div class="hatnote">
    <?= __('pref_hatnote_pre') ?> <strong><?= htmlspecialchars($pref['name']) ?></strong>.
    <?= $pref['park_count'] == 1
        ? sprintf(__('pref_hatnote_singular'), $pref['park_count'])
        : sprintf(__('pref_hatnote_plural'), $pref['park_count']) ?>
</div>

<?php if (empty($parks)): ?>
<div class="notice-box">
    <span class="notice-icon">📭</span>
    <span><?= __('no_parks_for') ?> <?= htmlspecialchars($pref['name']) ?> <?= __('no_parks_yet') ?>
    <a href="<?= BASE_URL ?>/admin/add.php"><?= __('add_one') ?></a></span>
</div>
<?php else: ?>
<ul class="article-list">
<?php foreach ($parks as $sp):
    $display = ($GLOBALS['current_lang'] === 'ja' && !empty($sp['name_ja'])) ? $sp['name_ja'] : $sp['name'];
    $alt     = ($GLOBALS['current_lang'] === 'ja') ? $sp['name'] : ($sp['name_ja'] ?? '');
?>
<li class="article-list-item">
    <div class="article-list-icon">🛹</div>
    <div class="article-list-info">
        <h4>
            <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($display) ?></a>
            <?php if ($alt && $alt !== $display): ?>
            <small style="font-size:.78rem;color:#777;font-weight:normal;"> — <?= htmlspecialchars($alt) ?></small>
            <?php endif; ?>
        </h4>
        <p class="article-list-meta">
            <?= htmlspecialchars($sp['city'] ?? '') ?>
            · <?= ucfirst(htmlspecialchars($sp['park_type'])) ?>
            <?= $sp['surface_type'] ? '· ' . htmlspecialchars($sp['surface_type']) : '' ?>
            <?= $sp['admission_fee'] ? '· ' . htmlspecialchars(mb_substr($sp['admission_fee'], 0, 50)) : '' ?>
        </p>
    </div>
</li>
<?php endforeach; ?>
</ul>
<?php endif; ?>

<div class="article-categories" style="margin-top:1.2rem;">
    <strong><?= __('see_also') ?></strong>
    <a href="<?= BASE_URL ?>/prefecture.php"><?= __('all_prefectures_link') ?></a> ·
    <a href="<?= BASE_URL ?>/prefecture.php?region=<?= urlencode($pref['region']) ?>"><?= htmlspecialchars($pref['region']) ?> <?= __('region_suffix') ?></a>
</div>

<?php

} elseif ($region) {
    // ---- Region listing ----
    $prefs = db_run("
        SELECT p.name, p.name_ja, p.region, COUNT(s.id) as cnt
        FROM prefectures p
        LEFT JOIN skateparks s ON s.prefecture_id = p.id
        WHERE p.region = ?
        GROUP BY p.id
        ORDER BY p.name ASC
    ", [$region])->get_result()->fetch_all(MYSQLI_ASSOC);

    $page_title = $region . ' Region Skateparks';
    require_once __DIR__ . '/includes/header.php';
?>
<h1 class="article-title">
    <?= htmlspecialchars($region) ?> <?= __('region_suffix') ?>
    <small><?= __('prefectures_and_parks') ?></small>
</h1>

<div class="prefecture-grid" style="margin-top:.8rem;">
<?php foreach ($prefs as $p): ?>
<a class="prefecture-card" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($p['name']) ?>">
    <span class="pref-name-ja"><?= htmlspecialchars($p['name_ja']) ?></span>
    <?= htmlspecialchars($p['name']) ?>
    <span class="pref-count"><?= $p['cnt'] ?> <?= $p['cnt'] != 1 ? __('park_plural') : __('park_singular') ?></span>
</a>
<?php endforeach; ?>
</div>

<?php

} else {
    // ---- All prefectures overview ----
    $all = db()->query("
        SELECT p.name, p.name_ja, p.region, COUNT(s.id) as cnt
        FROM prefectures p
        LEFT JOIN skateparks s ON s.prefecture_id = p.id
        GROUP BY p.id
        ORDER BY p.region, p.name ASC
    ")->fetch_all(MYSQLI_ASSOC);

    // Group by region
    $by_region = [];
    foreach ($all as $row) {
        $by_region[$row['region']][] = $row;
    }

    $page_title = 'Skateparks by Prefecture';
    require_once __DIR__ . '/includes/header.php';
?>
<h1 class="article-title"><?= __('skateparks_by_prefecture') ?></h1>

<div class="hatnote">
    <?= __('japan_47_prefs') ?>
</div>

<?php foreach ($by_region as $reg => $prefs): ?>
<h2><?= htmlspecialchars($reg) ?> <?= __('region_suffix') ?></h2>
<div class="prefecture-grid">
    <?php foreach ($prefs as $p): ?>
    <a class="prefecture-card" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($p['name']) ?>">
        <span class="pref-name-ja"><?= htmlspecialchars($p['name_ja']) ?></span>
        <?= htmlspecialchars($p['name']) ?>
        <span class="pref-count">
            <?= $p['cnt'] ?> <?= $p['cnt'] != 1 ? __('park_plural') : __('park_singular') ?>
        </span>
    </a>
    <?php endforeach; ?>
</div>
<?php endforeach; ?>

<?php } // end if/elseif/else ?>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
