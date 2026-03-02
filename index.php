<?php
require_once __DIR__ . '/config/db.php';

$page_title     = 'Main Page';
$meta_description = 'Japan Skateparks — ' . SITE_TAGLINE;

// ---- Data queries ----
$pdo = db();

// Stats
$total_parks     = (int) $pdo->query("SELECT COUNT(*) FROM skateparks")->fetchColumn();
$total_prefs     = (int) $pdo->query("SELECT COUNT(DISTINCT prefecture_id) FROM skateparks")->fetchColumn();
$total_indoor    = (int) $pdo->query("SELECT COUNT(*) FROM skateparks WHERE park_type IN ('indoor','both')")->fetchColumn();
$total_outdoor   = (int) $pdo->query("SELECT COUNT(*) FROM skateparks WHERE park_type IN ('outdoor','both')")->fetchColumn();

// Featured article
$featured = $pdo->query("SELECT s.*, p.name AS prefecture FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id WHERE s.featured = 1 LIMIT 1")->fetch();
if (!$featured) {
    $featured = $pdo->query("SELECT s.*, p.name AS prefecture FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id ORDER BY RAND() LIMIT 1")->fetch();
}

// Recently added / all parks (latest 6)
$recent = $pdo->query("
    SELECT s.*, p.name AS prefecture
    FROM skateparks s
    JOIN prefectures p ON p.id = s.prefecture_id
    ORDER BY s.created_at DESC
    LIMIT 6
")->fetchAll();

// Prefectures with count
$prefs_with_count = $pdo->query("
    SELECT p.name, p.name_ja, p.region, COUNT(s.id) as cnt
    FROM prefectures p
    LEFT JOIN skateparks s ON s.prefecture_id = p.id
    GROUP BY p.id
    HAVING cnt > 0
    ORDER BY cnt DESC, p.name ASC
")->fetchAll();

require_once __DIR__ . '/includes/header.php';
?>

<!-- ============================================================
     MAIN PAGE NOTICE
     ============================================================ -->
<div class="notice-box">
    <span class="notice-icon">ℹ️</span>
    <span>Welcome to <strong>Japan Skateparks</strong>, the free encyclopedia of skateboarding parks in Japan.
    We currently have <strong><?= $total_parks ?></strong> skatepark articles covering
    <strong><?= $total_prefs ?></strong> prefectures.
    <a href="<?= BASE_URL ?>/admin/add.php">Help us grow</a> by adding a skatepark near you.</span>
</div>

<!-- Stats bar -->
<div class="stats-bar">
    <div class="stat-item">
        <span class="stat-number"><?= $total_parks ?></span>
        <span class="stat-label">Skateparks</span>
    </div>
    <div class="stat-item">
        <span class="stat-number"><?= $total_prefs ?></span>
        <span class="stat-label">Prefectures</span>
    </div>
    <div class="stat-item">
        <span class="stat-number"><?= $total_outdoor ?></span>
        <span class="stat-label">Outdoor</span>
    </div>
    <div class="stat-item">
        <span class="stat-number"><?= $total_indoor ?></span>
        <span class="stat-label">Indoor</span>
    </div>
</div>

<!-- ============================================================
     FEATURED ARTICLE
     ============================================================ -->
<?php if ($featured): ?>
<div class="featured-article">
    <div class="featured-article-header">⭐ Featured Skatepark</div>
    <div class="featured-article-body">
        <div class="featured-article-image">
            <?php if (!empty($featured['image_url'])): ?>
                <img src="<?= htmlspecialchars($featured['image_url']) ?>" alt="<?= htmlspecialchars($featured['name']) ?>" style="width:100%;height:100%;object-fit:cover;">
            <?php else: ?>
                🛹
            <?php endif; ?>
        </div>
        <div class="featured-article-text">
            <h3><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($featured['slug']) ?>"><?= htmlspecialchars($featured['name']) ?></a></h3>
            <p><?= htmlspecialchars(mb_substr(strip_tags($featured['description']), 0, 280)) ?>…</p>
            <p><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($featured['slug']) ?>">Read full article →</a></p>
        </div>
    </div>
</div>
<?php endif; ?>

<!-- ============================================================
     TWO-COLUMN SECTION
     ============================================================ -->
<div class="main-page-columns">

    <!-- Column 1: Recent articles -->
    <div class="main-box">
        <div class="main-box-header">🕐 Recently Added</div>
        <div class="main-box-body">
            <ul class="article-list">
            <?php foreach ($recent as $sp): ?>
            <li class="article-list-item">
                <div class="article-list-icon">🛹</div>
                <div class="article-list-info">
                    <h4><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($sp['name']) ?></a></h4>
                    <p><?= htmlspecialchars($sp['prefecture']) ?> · <?= htmlspecialchars($sp['city'] ?? '') ?> ·
                        <?= ucfirst($sp['park_type']) ?></p>
                </div>
            </li>
            <?php endforeach; ?>
            </ul>
            <p class="mt-1"><a href="<?= BASE_URL ?>/search.php">View all skateparks →</a></p>
        </div>
    </div>

    <!-- Column 2: Browse by prefecture -->
    <div class="main-box">
        <div class="main-box-header">🗾 Browse by Prefecture</div>
        <div class="main-box-body">
            <div class="prefecture-grid">
            <?php foreach ($prefs_with_count as $pref): ?>
                <a class="prefecture-card" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($pref['name']) ?>">
                    <span class="pref-name-ja"><?= htmlspecialchars($pref['name_ja']) ?></span>
                    <?= htmlspecialchars($pref['name']) ?>
                    <span class="pref-count"><?= $pref['cnt'] ?> park<?= $pref['cnt'] > 1 ? 's' : '' ?></span>
                </a>
            <?php endforeach; ?>
            </div>
            <p class="mt-1"><a href="<?= BASE_URL ?>/prefecture.php">All prefectures →</a></p>
        </div>
    </div>

</div><!-- /main-page-columns -->

<!-- ============================================================
     ABOUT BOX
     ============================================================ -->
<div class="main-box" style="margin-top:1.2rem;">
    <div class="main-box-header">📖 About Japan Skateparks</div>
    <div class="main-box-body">
        <p>
            <strong>Japan Skateparks</strong> is a free, community-driven encyclopedia documenting every
            skatepark in Japan. Our goal is to compile comprehensive, accurate information about each
            facility — from Olympic-grade venues to neighbourhood DIY spots.
        </p>
        <p>
            Inspired by the model of Wikipedia, all information is freely accessible and community-contributed.
            Whether you are planning a skate trip, looking for a local park, or interested in the history
            of skateboarding infrastructure in Japan, this is your reference.
        </p>
        <p>
            Skateboarding was added to the Olympic programme at the <strong>Tokyo 2020 Games</strong>,
            marking a milestone for the sport in Japan. Since then, investment in skateboarding
            infrastructure has grown significantly across the country.
        </p>
        <p><a href="<?= BASE_URL ?>/admin/add.php">Contribute a skatepark</a> | <a href="<?= BASE_URL ?>/search.php">Browse all articles</a></p>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

