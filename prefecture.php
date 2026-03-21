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
        SELECT s.slug, s.name, s.name_ja, s.city, s.park_type, s.surface_type, s.admission_fee, s.image_url
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
    <?= sprintf(__('skateparks_in'), htmlspecialchars($pref['name'])) ?>
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
    <a class="article-list-icon" href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>" aria-label="Open <?= htmlspecialchars($sp['name']) ?>">
        <?php if (!empty($sp['image_url'])): ?>
            <img src="<?= htmlspecialchars($sp['image_url']) ?>" alt="<?= htmlspecialchars($sp['name']) ?>" loading="lazy">
        <?php else: ?>
            🛹
        <?php endif; ?>
    </a>
    <div class="article-list-info">
        <h4>
            <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($display) ?></a>
            <?php if ($alt && $alt !== $display): ?>
            <small style="font-size:.78rem;color:#777;font-weight:normal;"> — <?= htmlspecialchars($alt) ?></small>
            <?php endif; ?>
        </h4>
        <p class="article-list-meta">
            <?= htmlspecialchars($sp['city'] ?? '') ?>
            · <?= __('park_type_' . $sp['park_type']) ?>
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

    // Build JS data: name → {count, url, name_ja}
    $pref_map_data = [];
    foreach ($all as $p) {
        $pref_map_data[$p['name']] = [
            'count'   => (int)$p['cnt'],
            'url'     => BASE_URL . '/prefecture.php?name=' . urlencode($p['name']),
            'name_ja' => $p['name_ja'],
        ];
    }

    $page_title = 'Skateparks by Prefecture';
    require_once __DIR__ . '/includes/header.php';
?>
<h1 class="article-title"><?= __('skateparks_by_prefecture') ?></h1>

<div class="hatnote">
    <?= __('japan_47_prefs') ?>
</div>

<div class="japan-map-wrap">
    <div id="japan-map-container"><p class="map-loading">Loading map…</p></div>
    <p class="map-attribution">Map data: <a href="http://www.gsi.go.jp/kankyochiri/gm_jpn.html" target="_blank" rel="noopener">地球地図日本 / Global Map Japan (GSI)</a></p>
</div>
<div id="map-tooltip" class="map-tooltip" role="tooltip"></div>

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

<script>
(function () {
    var prefData  = <?= json_encode($pref_map_data, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_QUOT) ?>;
    var container = document.getElementById('japan-map-container');
    var tooltip   = document.getElementById('map-tooltip');

    fetch('<?= BASE_URL ?>/images/japan-prefectures.svg')
        .then(function (r) { return r.text(); })
        .then(function (svgText) {
            container.innerHTML = svgText;
            var svg = container.querySelector('svg');
            svg.removeAttribute('width');
            svg.removeAttribute('height');

            // Fit the viewBox to the main islands, then inset Okinawa bottom-left
            // (same convention used on all official Japanese maps)
            var g        = svg.querySelector('#japan-prefectures');
            var okinawa  = svg.querySelector('path[data-name="Okinawa"]');
            if (g) {
                var pad = 12;

                // 1. Measure bounding box without Okinawa
                if (okinawa) okinawa.style.visibility = 'hidden';
                var bb = g.getBBox();
                if (okinawa) okinawa.style.visibility = '';

                // Clamp right + bottom edges to the main island extents.
                // Tokyo includes Minamitorishima (154°E) and the Ogasawara/Izu
                // island chains (~27°N) — both pull the raw bbox far beyond the
                // visible main islands. Kagoshima also has outlying southern islands.
                var hokkaido  = svg.querySelector('path[data-name="Hokkaido"]');
                var kagoshima = svg.querySelector('path[data-name="Kagoshima"]');
                if (hokkaido) {
                    var hkBB = hokkaido.getBBox();
                    var clampR = hkBB.x + hkBB.width + pad * 4;
                    if (bb.x + bb.width > clampR) bb.width = clampR - bb.x;
                }
                if (kagoshima) {
                    // Use Kagoshima mainland as the southern anchor —
                    // its bbox bottom is pulled down by outlying islands,
                    // so we use Kyushu's rough southern extent instead.
                    // Grab Kyushu neighbours to find a safe bottom clamp.
                    var kyushuPaths = ['Fukuoka','Saga','Nagasaki','Kumamoto','Oita','Miyazaki'];
                    var maxBottom = bb.y;
                    kyushuPaths.forEach(function (n) {
                        var p = svg.querySelector('path[data-name="' + n + '"]');
                        if (p) {
                            var pb = p.getBBox();
                            if (pb.y + pb.height > maxBottom) maxBottom = pb.y + pb.height;
                        }
                    });
                    var clampB = maxBottom + pad * 4;
                    if (bb.y + bb.height > clampB) bb.height = clampB - bb.y;
                }

                svg.setAttribute('viewBox',
                    (bb.x - pad) + ' ' + (bb.y - pad) + ' ' +
                    (bb.width  + pad * 2) + ' ' + (bb.height + pad * 2)
                );

                // Ocean background — makes empty corners read as sea, not dead space
                var ocean = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
                ocean.setAttribute('x',      bb.x - pad);
                ocean.setAttribute('y',      bb.y - pad);
                ocean.setAttribute('width',  bb.width  + pad * 2);
                ocean.setAttribute('height', bb.height + pad * 2);
                ocean.setAttribute('fill',   '#ddeeff');
                ocean.style.pointerEvents = 'none';
                g.insertBefore(ocean, g.firstChild);

                // 2. Move Okinawa into a bottom-right inset (fills the empty Pacific corner)
                if (okinawa) {
                    var ok = okinawa.getBBox();
                    var targetX = bb.x + bb.width - ok.width - pad;
                    var targetY = bb.y + bb.height - ok.height;
                    okinawa.setAttribute('transform',
                        'translate(' + (targetX - ok.x) + ',' + (targetY - ok.y) + ')'
                    );

                    // Draw a hit-area + inset border covering the full Okinawa box
                    var inset = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
                    inset.setAttribute('x',      targetX - 4);
                    inset.setAttribute('y',      targetY - 4);
                    inset.setAttribute('width',  ok.width  + 8);
                    inset.setAttribute('height', ok.height + 8);
                    inset.setAttribute('fill',   'transparent'); // captures pointer events
                    inset.setAttribute('stroke', '#a2a9b1');
                    inset.setAttribute('stroke-width', '0.8');
                    inset.setAttribute('stroke-dasharray', '3,2');
                    inset.style.cursor = 'pointer';
                    g.insertBefore(inset, okinawa);

                    // Wire the inset rect with same hover/click as the Okinawa path
                    var okInfo = prefData['Okinawa'] || null;
                    inset.addEventListener('mousemove', function (e) {
                        var count = okInfo ? okInfo.count : 0;
                        tooltip.innerHTML =
                            '<strong>Okinawa</strong>' +
                            (okInfo ? '<span class="tip-ja">' + okInfo.name_ja + '</span>' : '') +
                            '<span class="tip-count">' + count + ' skatepark' + (count !== 1 ? 's' : '') + '</span>';
                        tooltip.style.display = 'block';
                        tooltip.style.left = (e.clientX + 14) + 'px';
                        tooltip.style.top  = (e.clientY - 14) + 'px';
                        okinawa.style.fill = '#3366cc';
                    });
                    inset.addEventListener('mouseleave', function () {
                        tooltip.style.display = 'none';
                        okinawa.style.fill = '';
                    });
                    if (okInfo) {
                        inset.addEventListener('click', function () {
                            window.location.href = okInfo.url;
                        });
                    }
                }
            }

            svg.querySelectorAll('path[data-name]').forEach(function (path) {
                var name = path.getAttribute('data-name');
                var info = prefData[name] || null;

                path.classList.add(info && info.count > 0 ? 'has-parks' : 'no-parks');

                path.addEventListener('mousemove', function (e) {
                    var count = info ? info.count : 0;
                    tooltip.innerHTML =
                        '<strong>' + name + '</strong>' +
                        (info ? '<span class="tip-ja">' + info.name_ja + '</span>' : '') +
                        '<span class="tip-count">' + count + ' skatepark' + (count !== 1 ? 's' : '') + '</span>';
                    tooltip.style.display = 'block';
                    tooltip.style.left = (e.clientX + 14) + 'px';
                    tooltip.style.top  = (e.clientY - 14) + 'px';
                });

                path.addEventListener('mouseleave', function () {
                    tooltip.style.display = 'none';
                });

                if (info) {
                    path.addEventListener('click', function () {
                        window.location.href = info.url;
                    });
                }

            });
        })
        .catch(function () {
            container.innerHTML = '<p class="map-loading">Map unavailable.</p>';
        });
}());
</script>

<?php } // end if/elseif/else ?>

<?php require_once __DIR__ . '/includes/footer.php'; ?>
