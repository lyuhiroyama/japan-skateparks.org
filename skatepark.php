<?php
require_once __DIR__ . '/config/db.php';

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
    // 404
    http_response_code(404);
    $page_title = 'Not Found';
    require_once __DIR__ . '/includes/header.php';
    echo '<h1 class="article-title">Article not found</h1>';
    echo '<p>The skatepark "<strong>' . htmlspecialchars($slug) . '</strong>" does not exist in our database.</p>';
    echo '<p><a href="' . BASE_URL . '/index.php">Return to Main Page</a> or <a href="' . BASE_URL . '/admin/add.php">add this skatepark</a>.</p>';
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

$page_title      = $sp['name'];
$meta_description = mb_substr(strip_tags($sp['description']), 0, 160);

require_once __DIR__ . '/includes/header.php';
?>

<!-- Page tabs (Wikipedia style) -->
<div class="page-tabs" style="margin-bottom: .8rem;">
    <span class="page-tab active">Article</span>
    <a class="page-tab" href="<?= BASE_URL ?>/admin/edit.php?id=<?= $sp['id'] ?>">Edit</a>
    <a class="page-tab" href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>"><?= htmlspecialchars($sp['prefecture']) ?></a>
</div>

<!-- Article title -->
<h1 class="article-title">
    <?= htmlspecialchars($sp['name']) ?>
    <?php if ($sp['name_ja']): ?>
    <small><?= htmlspecialchars($sp['name_ja']) ?></small>
    <?php endif; ?>
</h1>

<div class="article-body clearfix">

    <!-- ============================================================
         INFOBOX
         ============================================================ -->
    <div class="infobox">
        <div class="infobox-title"><?= htmlspecialchars($sp['name']) ?></div>
        <div class="infobox-image">
            <?php if (!empty($sp['image_url'])): ?>
                <img src="<?= htmlspecialchars($sp['image_url']) ?>" alt="<?= htmlspecialchars($sp['name']) ?>">
            <?php else: ?>
                <div class="infobox-image-placeholder">
                    🛹<span>No image available</span>
                </div>
            <?php endif; ?>
        </div>
        <table>
            <?php if ($sp['name_ja']): ?>
            <tr>
                <td>Japanese</td>
                <td><?= htmlspecialchars($sp['name_ja']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['prefecture']): ?>
            <tr>
                <td>Prefecture</td>
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
            <?php if ($sp['city']): ?>
            <tr>
                <td>City</td>
                <td><?= htmlspecialchars($sp['city']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['address']): ?>
            <tr>
                <td>Address</td>
                <td><?= htmlspecialchars($sp['address']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['park_type']): ?>
            <tr>
                <td>Type</td>
                <td><?= ucfirst(htmlspecialchars($sp['park_type'])) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['surface_type']): ?>
            <tr>
                <td>Surface</td>
                <td><?= htmlspecialchars($sp['surface_type']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['opening_hours']): ?>
            <tr>
                <td>Hours</td>
                <td><?= nl2br(htmlspecialchars($sp['opening_hours'])) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['closed_days']): ?>
            <tr>
                <td>Closed</td>
                <td><?= htmlspecialchars($sp['closed_days']) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['admission_fee']): ?>
            <tr>
                <td>Admission</td>
                <td><?= nl2br(htmlspecialchars($sp['admission_fee'])) ?></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['phone']): ?>
            <tr>
                <td>Phone</td>
                <td><a href="tel:<?= htmlspecialchars($sp['phone']) ?>"><?= htmlspecialchars($sp['phone']) ?></a></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['website']): ?>
            <tr>
                <td>Website</td>
                <td><a href="<?= htmlspecialchars($sp['website']) ?>" target="_blank" rel="noopener">Official site</a></td>
            </tr>
            <?php endif; ?>
            <?php if ($sp['latitude'] && $sp['longitude']): ?>
            <tr>
                <td>Coordinates</td>
                <td>
                    <a class="map-link"
                       href="https://maps.google.com/?q=<?= $sp['latitude'] ?>,<?= $sp['longitude'] ?>"
                       target="_blank" rel="noopener">
                        <?= number_format($sp['latitude'], 4) ?>°N, <?= number_format($sp['longitude'], 4) ?>°E
                    </a>
                </td>
            </tr>
            <?php endif; ?>
        </table>
    </div>
    <!-- /infobox -->

    <!-- ============================================================
         TABLE OF CONTENTS
         ============================================================ -->
    <?php
    // Build TOC sections dynamically
    $sections = [];
    if (!empty($sp['description'])) $sections[] = ['id' => 'description', 'title' => 'Overview'];
    if (!empty($sp['history']))     $sections[] = ['id' => 'history',     'title' => 'History'];
    if (!empty($sp['facilities']))  $sections[] = ['id' => 'facilities',  'title' => 'Facilities'];
    if (!empty(trim($sp['opening_hours'] . $sp['admission_fee']))) {
        $sections[] = ['id' => 'access', 'title' => 'Access and Fees'];
    }
    if (!empty($nearby)) $sections[] = ['id' => 'see-also', 'title' => 'See Also'];
    ?>
    <?php if (count($sections) >= 3): ?>
    <div class="toc">
        <div class="toc-title">Contents</div>
        <ol>
            <?php foreach ($sections as $i => $sec): ?>
            <li><a href="#<?= $sec['id'] ?>"><?= htmlspecialchars($sec['title']) ?></a></li>
            <?php endforeach; ?>
        </ol>
    </div>
    <?php endif; ?>

    <!-- ============================================================
         OVERVIEW / DESCRIPTION
         ============================================================ -->
    <?php if (!empty($sp['description'])): ?>
    <p><?= nl2br(htmlspecialchars($sp['description'])) ?></p>
    <?php endif; ?>

    <!-- ============================================================
         HISTORY
         ============================================================ -->
    <?php if (!empty($sp['history'])): ?>
    <h2 id="history">History</h2>
    <p><?= nl2br(htmlspecialchars($sp['history'])) ?></p>
    <?php endif; ?>

    <!-- ============================================================
         FACILITIES
         ============================================================ -->
    <?php if (!empty($sp['facilities'])): ?>
    <h2 id="facilities">Facilities</h2>
    <?php
    // If facilities looks like a comma-separated list, render as list
    $fac_items = array_filter(array_map('trim', explode(',', $sp['facilities'])));
    if (count($fac_items) > 2):
    ?>
    <ul>
        <?php foreach ($fac_items as $f): ?>
        <li><?= htmlspecialchars($f) ?></li>
        <?php endforeach; ?>
    </ul>
    <?php else: ?>
    <p><?= nl2br(htmlspecialchars($sp['facilities'])) ?></p>
    <?php endif; ?>
    <?php endif; ?>

    <!-- ============================================================
         ACCESS AND FEES
         ============================================================ -->
    <?php if (!empty($sp['opening_hours']) || !empty($sp['admission_fee']) || !empty($sp['address'])): ?>
    <h2 id="access">Access and Fees</h2>
    <table style="border-collapse:collapse;font-size:.88rem;width:auto;min-width:300px;">
        <?php if ($sp['address']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Address</td>
            <td style="padding:.3rem 0;"><?= htmlspecialchars($sp['address']) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['opening_hours']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Opening hours</td>
            <td style="padding:.3rem 0;"><?= nl2br(htmlspecialchars($sp['opening_hours'])) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['closed_days']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Closed days</td>
            <td style="padding:.3rem 0;"><?= htmlspecialchars($sp['closed_days']) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['admission_fee']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Admission</td>
            <td style="padding:.3rem 0;"><?= nl2br(htmlspecialchars($sp['admission_fee'])) ?></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['website']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Website</td>
            <td style="padding:.3rem 0;"><a href="<?= htmlspecialchars($sp['website']) ?>" target="_blank" rel="noopener"><?= htmlspecialchars($sp['website']) ?></a></td>
        </tr>
        <?php endif; ?>
        <?php if ($sp['latitude'] && $sp['longitude']): ?>
        <tr>
            <td style="padding:.3rem .8rem .3rem 0;font-weight:bold;white-space:nowrap;">Map</td>
            <td style="padding:.3rem 0;">
                <a href="https://maps.google.com/?q=<?= $sp['latitude'] ?>,<?= $sp['longitude'] ?>" target="_blank" rel="noopener">
                    View on Google Maps
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
    <h2 id="see-also">See Also</h2>
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
    <strong>Categories:</strong>
    <a href="<?= BASE_URL ?>/prefecture.php?name=<?= urlencode($sp['prefecture']) ?>"><?= htmlspecialchars($sp['prefecture']) ?> skateparks</a>
    <?php foreach ($tags as $tag): ?>
    · <a href="<?= BASE_URL ?>/category.php?tag=<?= urlencode($tag['slug']) ?>"><?= htmlspecialchars($tag['name']) ?></a>
    <?php endforeach; ?>
</div>
<?php endif; ?>

<!-- Edit link -->
<p style="font-size:.78rem;color:#999;margin-top:.8rem;">
    Last updated: <?= date('j F Y', strtotime($sp['updated_at'])) ?> ·
    <a href="<?= BASE_URL ?>/admin/edit.php?id=<?= $sp['id'] ?>">Edit this article</a>
</p>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

