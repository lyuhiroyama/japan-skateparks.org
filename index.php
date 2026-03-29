<?php
require_once __DIR__ . '/config/db.php';

$page_title       = 'Main Page';
$meta_description = 'Japan Skateparks — ' . 'The Free Encyclopedia of Japan\'s Skateparks';

// ---- Data queries ----
$db = db();

// Stats
$total_parks   = (int) $db->query("SELECT COUNT(*) FROM skateparks")->fetch_row()[0];
$total_prefs   = (int) $db->query("SELECT COUNT(DISTINCT prefecture_id) FROM skateparks")->fetch_row()[0];
$total_indoor  = (int) $db->query("SELECT COUNT(*) FROM skateparks WHERE park_type IN ('indoor','both')")->fetch_row()[0];
$total_outdoor = (int) $db->query("SELECT COUNT(*) FROM skateparks WHERE park_type IN ('outdoor','both')")->fetch_row()[0];

// Featured article
$featured = $db->query("SELECT s.*, p.name AS prefecture FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id WHERE s.featured = 1 AND s.image_url IS NOT NULL AND s.image_url != '' LIMIT 1")->fetch_assoc();
if (!$featured) {
    $featured = $db->query("SELECT s.*, p.name AS prefecture FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id WHERE s.image_url IS NOT NULL AND s.image_url != '' ORDER BY RAND() LIMIT 1")->fetch_assoc();
}
if (!$featured) {
    $featured = $db->query("SELECT s.*, p.name AS prefecture FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id ORDER BY RAND() LIMIT 1")->fetch_assoc();
}

// Recently added / all parks (latest 6)
$recent = $db->query("
    SELECT s.*, p.name AS prefecture
    FROM skateparks s
    JOIN prefectures p ON p.id = s.prefecture_id
    ORDER BY s.created_at DESC
    LIMIT 6
")->fetch_all(MYSQLI_ASSOC);

// Prefectures with count
$prefs_with_count = $db->query("
    SELECT p.name, p.name_ja, p.region, COUNT(s.id) as cnt
    FROM prefectures p
    LEFT JOIN skateparks s ON s.prefecture_id = p.id
    GROUP BY p.id
    HAVING cnt > 0
    ORDER BY cnt DESC, p.name ASC
")->fetch_all(MYSQLI_ASSOC);

require_once __DIR__ . '/includes/header.php';
?>

<!-- ============================================================
     MAIN PAGE NOTICE
     ============================================================ -->
<div class="notice-box">
    <span class="notice-icon">ℹ️</span>
    <div class="notice-body">
        <p class="notice-main"><?= __('welcome_notice') ?>
        <?= __('welcome_park_count', $total_parks, $total_prefs) ?>
        <a href="<?= BASE_URL ?>/admin/add.php"><?= __('help_grow') ?></a> <?= __('help_grow_suffix') ?></p>
        <p class="notice-disclaimer"><?= __('welcome_disclaimer') ?></p>
    </div>
</div>

<!-- Stats bar -->
<div class="stats-bar">
    <a class="stat-item" href="<?= BASE_URL ?>/search.php">
        <span class="stat-number"><?= $total_parks ?></span>
        <span class="stat-label"><?= __('stat_skateparks') ?></span>
    </a>
    <a class="stat-item" href="<?= BASE_URL ?>/prefecture.php">
        <span class="stat-number"><?= $total_prefs ?></span>
        <span class="stat-label"><?= __('stat_prefectures') ?></span>
    </a>
    <a class="stat-item" href="<?= BASE_URL ?>/search.php?type=outdoor">
        <span class="stat-number"><?= $total_outdoor ?></span>
        <span class="stat-label"><?= __('stat_outdoor') ?></span>
    </a>
    <a class="stat-item" href="<?= BASE_URL ?>/search.php?type=indoor">
        <span class="stat-number"><?= $total_indoor ?></span>
        <span class="stat-label"><?= __('stat_indoor') ?></span>
    </a>
</div>

<!-- ============================================================
     FEATURED ARTICLE
     ============================================================ -->
<?php if ($featured): ?>
<div class="featured-article">
    <div class="featured-article-header"><?= __('featured_skatepark') ?></div>
    <div class="featured-article-body">
        <a class="featured-article-image" href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($featured['slug']) ?>" aria-label="Open <?= htmlspecialchars($featured['name']) ?>">
            <?php if (!empty($featured['image_url'])): ?>
                <img src="<?= htmlspecialchars($featured['image_url']) ?>" alt="<?= htmlspecialchars($featured['name']) ?>" style="width:100%;height:100%;object-fit:cover;">
            <?php else: ?>
                🛹
            <?php endif; ?>
        </a>
        <div class="featured-article-text">
            <?php $feat_display = ($GLOBALS['current_lang'] === 'ja' && !empty($featured['name_ja'])) ? $featured['name_ja'] : $featured['name']; ?>
            <h3><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($featured['slug']) ?>"><?= htmlspecialchars($feat_display) ?></a></h3>
            <?php
            $desc = ($GLOBALS['current_lang'] === 'ja' && !empty($featured['description_ja']))
                ? $featured['description_ja']
                : $featured['description'];
            ?>
            <p><?= htmlspecialchars(mb_substr(strip_tags($desc), 0, 280)) ?>…</p>
            <p><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($featured['slug']) ?>"><?= __('read_full_article') ?></a></p>
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
        <div class="main-box-header"><?= __('recently_added') ?></div>
        <div class="main-box-body">
            <ul class="article-list">
            <?php foreach ($recent as $sp):
                $display = ($GLOBALS['current_lang'] === 'ja' && !empty($sp['name_ja'])) ? $sp['name_ja'] : $sp['name'];
            ?>
            <li class="article-list-item">
                <a class="article-list-icon" href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>" aria-label="Open <?= htmlspecialchars($sp['name']) ?>">
                    <?php if (!empty($sp['image_url'])): ?>
                        <img src="<?= htmlspecialchars($sp['image_url']) ?>" alt="<?= htmlspecialchars($sp['name']) ?>" loading="lazy">
                    <?php else: ?>
                        🛹
                    <?php endif; ?>
                </a>
                <div class="article-list-info">
                    <h4><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($display) ?></a></h4>
                    <p><?= htmlspecialchars($sp['prefecture']) ?> · <?= htmlspecialchars($sp['city'] ?? '') ?> ·
                        <?= __('park_type_' . $sp['park_type']) ?></p>
                </div>
            </li>
            <?php endforeach; ?>
            </ul>
            <p class="mt-1"><a href="<?= BASE_URL ?>/search.php"><?= __('view_all_skateparks') ?></a></p>
        </div>
    </div>

    <!-- Column 2: Browse by prefecture -->
    <div class="main-box">
        <div class="main-box-header"><?= __('browse_by_prefecture') ?></div>
        <div class="main-box-body">
            <div class="prefecture-grid">
            <?php foreach ($prefs_with_count as $pref): ?>
                <a class="prefecture-card" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($pref['name']) ?>">
                    <span class="pref-name-ja"><?= htmlspecialchars($pref['name_ja']) ?></span>
                    <?= htmlspecialchars($pref['name']) ?>
                    <span class="pref-count"><?= $pref['cnt'] ?> <?= $pref['cnt'] > 1 ? __('park_plural') : __('park_singular') ?></span>
                </a>
            <?php endforeach; ?>
            </div>
            <p class="mt-1"><a href="<?= BASE_URL ?>/prefecture.php"><?= __('all_prefectures_arrow') ?></a></p>
        </div>
    </div>

</div><!-- /main-page-columns -->

<!-- ============================================================
     ABOUT BOX
     ============================================================ -->
<div class="main-box" style="margin-top:1.2rem;">
    <div class="main-box-header"><?= __('about_title') ?></div>
    <div class="main-box-body">
        <p><?= __('about_p1') ?></p>
        <p><?= __('about_p2') ?></p>
        <p><?= __('about_p3') ?></p>
        <p><a href="<?= BASE_URL ?>/admin/add.php"><?= __('contribute_skatepark') ?></a> | <a href="<?= BASE_URL ?>/search.php"><?= __('browse_all_articles') ?></a></p>
    </div>
</div>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
