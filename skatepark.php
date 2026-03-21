<?php
require_once __DIR__ . '/config/db.php';
require_once __DIR__ . '/lang/loader.php';

$slug = isset($_GET['slug']) ? trim($_GET['slug']) : '';

if (!$slug) {
    header('Location: ' . BASE_URL . '/index.php');
    exit;
}

// Fetch the skatepark
$sp = db_run("
    SELECT s.*, p.name AS prefecture, p.name_ja AS prefecture_ja, p.region
    FROM skateparks s
    JOIN prefectures p ON p.id = s.prefecture_id
    WHERE s.slug = ?
", [$slug])->get_result()->fetch_assoc();

if (!$sp) {
    http_response_code(404);
    $page_title = 'Not Found';
    require_once __DIR__ . '/includes/header.php';
    echo '<h1 class="article-title">' . __('not_found_title') . '</h1>';
    echo '<p>' . sprintf(__('not_found_text'), htmlspecialchars($slug)) . '</p>';
    echo '<p><a href="' . BASE_URL . '/index.php">' . __('not_found_return') . '</a> or <a href="' . BASE_URL . '/admin/add.php">' . __('not_found_add') . '</a>.</p>';
    require_once __DIR__ . '/includes/footer.php';
    exit;
}

// Fetch tags
$tags = db_run("
    SELECT t.name, t.slug
    FROM tags t
    JOIN skatepark_tags st ON st.tag_id = t.id
    WHERE st.skatepark_id = ?
    ORDER BY t.name
", [$sp['id']])->get_result()->fetch_all(MYSQLI_ASSOC);

// Fetch other parks in same prefecture (sidebar)
$nearby = db_run("
    SELECT slug, name FROM skateparks
    WHERE prefecture_id = (SELECT prefecture_id FROM skateparks WHERE id = ?)
    AND id != ?
    LIMIT 5
", [$sp['id'], $sp['id']])->get_result()->fetch_all(MYSQLI_ASSOC);

// Resolve translated content — in Japanese mode, only show Japanese if available, else show nothing
$lang          = $GLOBALS['current_lang'] ?? 'en';
$display_name  = ($lang === 'ja' && !empty($sp['name_ja']))          ? $sp['name_ja']          : $sp['name'];
$description   = $lang === 'ja' ? ($sp['description_ja']   ?? '')   : $sp['description'];
$history       = $lang === 'ja' ? ($sp['history_ja']       ?? '')   : $sp['history'];
$facilities    = $lang === 'ja' ? ($sp['facilities_ja']    ?? '')   : $sp['facilities'];
$city          = $lang === 'ja' ? ($sp['city_ja']          ?? '')   : $sp['city'];
$address       = $lang === 'ja' ? ($sp['address_ja']       ?? '')   : $sp['address'];
$surface_type  = $lang === 'ja' ? ($sp['surface_type_ja']  ?? '')   : $sp['surface_type'];
$closed_days   = $lang === 'ja' ? ($sp['closed_days_ja']   ?? '')   : $sp['closed_days'];
$admission_fee = $lang === 'ja' ? ($sp['admission_fee_ja'] ?? '')   : $sp['admission_fee'];

$page_title       = $display_name;
$meta_description = mb_substr(strip_tags($description), 0, 160);

require_once __DIR__ . '/includes/header.php';
?>

<!-- Page tabs (Wikipedia style) -->
<div class="page-tabs" style="margin-bottom: .8rem;">
    <span class="page-tab active"><?= __('tab_article') ?></span>
    <a class="page-tab" href="<?= BASE_URL ?>/admin/edit.php?id=<?= $sp['id'] ?>"><?= __('tab_edit') ?></a>
    <a class="page-tab" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>"><?= htmlspecialchars($sp['prefecture']) ?></a>
</div>

<!-- Article title -->
<h1 class="article-title">
    <?= htmlspecialchars($display_name) ?>
    <?php
    // Show the alternate name in small — English when in Japanese mode, Japanese when in English mode
    $alt_name = ($lang === 'ja') ? $sp['name'] : ($sp['name_ja'] ?? '');
    if ($alt_name && $alt_name !== $display_name):
    ?>
    <small><?= htmlspecialchars($alt_name) ?></small>
    <?php endif; ?>
</h1>

<div class="article-body clearfix">

    <!-- ============================================================
         INFOBOX
         ============================================================ -->
    <div class="infobox">
        <div class="infobox-title"><?= htmlspecialchars($display_name) ?></div>
        <div class="infobox-image">
            <?php if (!empty($sp['image_url'])): ?>
                <img src="<?= htmlspecialchars($sp['image_url']) ?>" alt="<?= htmlspecialchars($sp['name']) ?>">
            <?php else: ?>
                <div class="infobox-image-placeholder">
                    🛹<span><?= __('no_image') ?></span>
                </div>
            <?php endif; ?>
        </div>
        <table>
            <?php if ($sp['name_ja']): ?>
            <tr>
                <td><?= __('infobox_japanese') ?></td>
                <td><?= htmlspecialchars($sp['name_ja']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['prefecture']): ?>
            <tr>
                <td><?= __('infobox_prefecture') ?></td>
                <td>
                    <a href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>">
                        <?= htmlspecialchars($sp['prefecture']) ?>
                    </a>
                    <?php if ($sp['prefecture_ja']): ?>
                    (<?= htmlspecialchars($sp['prefecture_ja']) ?>)
                    <?php endif; ?>
                </td>
            </tr>
            <?php endif; ?>
            <?php if ($city): ?>
            <tr>
                <td><?= __('infobox_city') ?></td>
                <td><?= htmlspecialchars($city) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($address): ?>
            <tr>
                <td><?= __('infobox_address') ?></td>
                <td><?= htmlspecialchars($address) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['park_type']): ?>
            <tr>
                <td><?= __('infobox_type') ?></td>
                <td><?= __('park_type_' . $sp['park_type']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($surface_type): ?>
            <tr>
                <td><?= __('infobox_surface') ?></td>
                <td><?= htmlspecialchars($surface_type) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['opening_hours']): ?>
            <tr>
                <td><?= __('infobox_hours') ?></td>
                <td><?= nl2br(htmlspecialchars($sp['opening_hours'])) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($closed_days): ?>
            <tr>
                <td><?= __('infobox_closed') ?></td>
                <td><?= nl2br(htmlspecialchars($closed_days)) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($admission_fee): ?>
            <tr>
                <td><?= __('infobox_admission') ?></td>
                <td><?= nl2br(htmlspecialchars($admission_fee)) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['phone']): ?>
            <tr>
                <td><?= __('infobox_phone') ?></td>
                <td><a href="tel:<?= htmlspecialchars($sp['phone']) ?>"><?= htmlspecialchars($sp['phone']) ?></a></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['website']): ?>
            <tr>
                <td><?= __('infobox_website') ?></td>
                <td><a href="<?= htmlspecialchars($sp['website']) ?>" target="_blank" rel="noopener"><?= __('infobox_official_site') ?></a></td>
            </tr>
            <?php endif; ?>
        </table>
    </div>
    <!-- /infobox -->

    <!-- ============================================================
         TABLE OF CONTENTS
         ============================================================ -->
    <?php
    $sections = [];
    if (!empty($description)) $sections[] = ['id' => 'description', 'title' => __('section_overview')];
    if (!empty($history))     $sections[] = ['id' => 'history',     'title' => __('section_history')];
    if (!empty($facilities))  $sections[] = ['id' => 'facilities',  'title' => __('section_facilities')];
    if (!empty(trim($sp['opening_hours'] . $sp['admission_fee']))) {
        $sections[] = ['id' => 'access', 'title' => __('section_access')];
    }
    if (!empty($nearby)) $sections[] = ['id' => 'see-also', 'title' => __('section_see_also')];
    ?>
    <?php if (count($sections) >= 3): ?>
    <div class="toc">
        <div class="toc-title"><?= __('toc_contents') ?></div>
        <ol>
            <?php foreach ($sections as $sec): ?>
            <li><a href="#<?= $sec['id'] ?>"><?= htmlspecialchars($sec['title']) ?></a></li>
            <?php endforeach; ?>
        </ol>
    </div>
    <?php endif; ?>

    <!-- ============================================================
         OVERVIEW / DESCRIPTION
         ============================================================ -->
    <?php if (!empty($description)): ?>
    <p id="description"><?= nl2br(htmlspecialchars($description)) ?></p>
    <?php endif; ?>

    <!-- ============================================================
         HISTORY
         ============================================================ -->
    <?php if (!empty($history)): ?>
    <h2 id="history"><?= __('section_history') ?></h2>
    <p><?= nl2br(htmlspecialchars($history)) ?></p>
    <?php endif; ?>

    <!-- ============================================================
         FACILITIES
         ============================================================ -->
    <?php if (!empty($facilities)): ?>
    <h2 id="facilities"><?= __('section_facilities') ?></h2>
    <?php
    $fac_items = array_filter(array_map('trim', explode(',', $facilities)));
    if (count($fac_items) > 2):
    ?>
    <ul>
        <?php foreach ($fac_items as $f): ?>
        <li><?= htmlspecialchars($f) ?></li>
        <?php endforeach; ?>
    </ul>
    <?php else: ?>
    <p><?= nl2br(htmlspecialchars($facilities)) ?></p>
    <?php endif; ?>
    <?php endif; ?>

    <!-- ============================================================
         ACCESS AND FEES
         ============================================================ -->
    <?php if (!empty($sp['opening_hours']) || !empty($sp['admission_fee']) || !empty($sp['address'])): ?>
    <h2 id="access"><?= __('section_access') ?></h2>
    <table style="border-collapse:collapse;font-size:.88rem;width:100%;table-layout:fixed;">
        <?php if ($sp['address']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_address') ?></td>
            <td style="padding:.3rem 0;"><?= htmlspecialchars($sp['address']) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['opening_hours']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_hours') ?></td>
            <td style="padding:.3rem 0;"><?= nl2br(htmlspecialchars($sp['opening_hours'])) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['closed_days']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_closed') ?></td>
            <td style="padding:.3rem 0;"><?= htmlspecialchars($sp['closed_days']) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['admission_fee']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_admission') ?></td>
            <td style="padding:.3rem 0;"><?= nl2br(htmlspecialchars($sp['admission_fee'])) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['website']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_website') ?></td>
            <td style="padding:.3rem 0;overflow-wrap:break-word;word-break:break-all;"><a href="<?= htmlspecialchars($sp['website']) ?>" target="_blank" rel="noopener"><?= htmlspecialchars($sp['website']) ?></a></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['latitude'] && $sp['longitude']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;"><?= __('access_map') ?></td>
            <td style="padding:.3rem 0;">
                <a href="https://maps.google.com/?q=<?= $sp['latitude'] ?>,<?= $sp['longitude'] ?>" target="_blank" rel="noopener">
                    <?= __('view_on_maps') ?>
                </a>
            </td>
        </tr>
        <?php endif; ?>
    </table>
    <?php endif; ?>

    <!-- ============================================================
         SEE ALSO
         ============================================================ -->
    <?php if (!empty($nearby)): ?>
    <h2 id="see-also"><?= __('section_see_also') ?></h2>
    <ul>
        <?php foreach ($nearby as $nb): ?>
        <li><a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($nb['slug']) ?>"><?= htmlspecialchars($nb['name']) ?></a></li>
        <?php endforeach; ?>
    </ul>
    <?php endif; ?>

</div><!-- /article-body -->

<!-- ============================================================
     TAGS / CATEGORIES
     ============================================================ -->
<?php if (!empty($tags)): ?>
<div class="article-categories">
    <strong><?= __('categories_label') ?></strong>
    <a href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>"><?= htmlspecialchars($sp['prefecture']) ?> skateparks</a>
    <?php foreach ($tags as $tag): ?>
    · <a href="<?= BASE_URL ?>/category.php?tag=<?= urlencode($tag['slug']) ?>"><?= htmlspecialchars($tag['name']) ?></a>
    <?php endforeach; ?>
</div>
<?php endif; ?>

<!-- Edit link -->
<p style="font-size:.78rem;color:#999;margin-top:.8rem;">
    <?= __('last_updated') ?> <?= date('j F Y', strtotime($sp['updated_at'])) ?> ·
    <a href="<?= BASE_URL ?>/admin/edit.php?id=<?= $sp['id'] ?>"><?= __('edit_article') ?></a>
</p>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
