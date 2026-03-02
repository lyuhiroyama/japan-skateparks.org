<?php
require_once __DIR__ . '/config/db.php';

$pdo  = db();
$tag  = isset($_GET['tag']) ? trim($_GET['tag']) : '';

if ($tag) {
    // ---- Specific tag/category ----
    $tag_row = $pdo->prepare("SELECT * FROM tags WHERE slug = ?");
    $tag_row->execute([$tag]);
    $tag_row = $tag_row->fetch();

    if (!$tag_row) {
        header('Location: ' . BASE_URL . '/category.php');
        exit;
    }

    $parks = $pdo->prepare("
        SELECT s.slug, s.name, s.name_ja, s.city, s.park_type, p.name AS prefecture
        FROM skateparks s
        JOIN prefectures p ON p.id = s.prefecture_id
        JOIN skatepark_tags st ON st.skatepark_id = s.id
        WHERE st.tag_id = ?
        ORDER BY s.name ASC
    ");
    $parks->execute([$tag_row['id']]);
    $parks = $parks->fetchAll();

    $page_title = $tag_row['name'] . ' Skateparks';
    require_once __DIR__ . '/includes/header.php';
?>
<div class="page-tabs" style="margin-bottom:.8rem;">
    <span class="page-tab active">Category</span>
    <a class="page-tab" href="<?= BASE_URL ?>/category.php">All Categories</a>
</div>

<h1 class="article-title">Category: <?= htmlspecialchars($tag_row['name']) ?></h1>

<div class="hatnote">
    <?= count($parks) ?> skatepark<?= count($parks) != 1 ? 's' : '' ?> tagged as
    <strong><?= htmlspecialchars($tag_row['name']) ?></strong>.
</div>

<?php if (empty($parks)): ?>
<div class="notice-box">
    <span class="notice-icon">📭</span>
    <span>No skateparks tagged as <?= htmlspecialchars($tag_row['name']) ?> yet.</span>
</div>
<?php else: ?>
<ul class="article-list">
<?php foreach ($parks as $sp): ?>
<li class="article-list-item">
    <div class="article-list-icon">🛹</div>
    <div class="article-list-info">
        <h4>
            <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($sp['name']) ?></a>
            <?php if ($sp['name_ja']): ?>
            <small style="font-size:.78rem;color:#777;font-weight:normal;"> — <?= htmlspecialchars($sp['name_ja']) ?></small>
            <?php endif; ?>
        </h4>
        <p class="article-list-meta">
            📍 <a href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>"><?= htmlspecialchars($sp['prefecture']) ?></a>
            <?= $sp['city'] ? '· ' . htmlspecialchars($sp['city']) : '' ?>
            · <?= ucfirst(htmlspecialchars($sp['park_type'])) ?>
        </p>
    </div>
</li>
<?php endforeach; ?>
</ul>
<?php endif; ?>

<?php

} else {
    // ---- All categories ----
    $all_tags = $pdo->query("
        SELECT t.name, t.slug, COUNT(st.skatepark_id) as cnt
        FROM tags t
        LEFT JOIN skatepark_tags st ON st.tag_id = t.id
        GROUP BY t.id
        ORDER BY cnt DESC, t.name ASC
    ")->fetchAll();

    $page_title = 'Categories';
    require_once __DIR__ . '/includes/header.php';
?>
<h1 class="article-title">Skatepark Categories</h1>

<div class="hatnote">
    Browse skateparks by category. Each skatepark may belong to multiple categories.
</div>

<ul class="article-list" style="margin-top:.5rem;">
<?php foreach ($all_tags as $t): ?>
<li class="article-list-item">
    <div class="article-list-icon" style="font-size:1rem;">🏷️</div>
    <div class="article-list-info">
        <h4>
            <a href="<?= BASE_URL ?>/category.php?tag=<?= urlencode($t['slug']) ?>"><?= htmlspecialchars($t['name']) ?></a>
        </h4>
        <p class="article-list-meta"><?= $t['cnt'] ?> skatepark<?= $t['cnt'] != 1 ? 's' : '' ?></p>
    </div>
</li>
<?php endforeach; ?>
</ul>

<?php } ?>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

