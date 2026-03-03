<?php
require_once __DIR__ . '/config/db.php';

$q         = isset($_GET['q']) ? trim($_GET['q']) : '';
$type      = isset($_GET['type']) ? $_GET['type'] : '';   // indoor / outdoor / both
$pref      = isset($_GET['pref']) ? $_GET['pref'] : '';
$per_page  = 15;
$page      = max(1, (int) ($_GET['page'] ?? 1));
$offset    = ($page - 1) * $per_page;

$db = db();

// Build query
$where    = [];
$bindings = [];

if ($q !== '') {
    $where[]  = "(s.name LIKE ? OR s.name_ja LIKE ? OR s.city LIKE ? OR s.description LIKE ?)";
    $like     = '%' . $q . '%';
    $bindings = array_merge($bindings, [$like, $like, $like, $like]);
}
if ($type) {
    $where[]    = "s.park_type = ?";
    $bindings[] = $type;
}
if ($pref) {
    $where[]    = "p.name = ?";
    $bindings[] = $pref;
}

$where_sql = $where ? 'WHERE ' . implode(' AND ', $where) : '';

$count_sql = "SELECT COUNT(*) FROM skateparks s JOIN prefectures p ON p.id = s.prefecture_id $where_sql";
$total     = (int) db_run($count_sql, $bindings)->get_result()->fetch_row()[0];
$total_pages = (int) ceil($total / $per_page);

$results_sql = "
    SELECT s.slug, s.name, s.name_ja, s.city, s.park_type, s.surface_type, s.admission_fee,
           p.name AS prefecture
    FROM skateparks s
    JOIN prefectures p ON p.id = s.prefecture_id
    $where_sql
    ORDER BY s.name ASC
    LIMIT $per_page OFFSET $offset
";
$results = db_run($results_sql, $bindings)->get_result()->fetch_all(MYSQLI_ASSOC);

// Tags per result
$tags_map = [];
if ($results) {
    $ids = array_column($results, 'slug');
    $rows = db_run(
        "SELECT s.id, s.slug FROM skateparks s WHERE s.slug IN (" . implode(',', array_fill(0, count($ids), '?')) . ")",
        $ids
    )->get_result()->fetch_all(MYSQLI_ASSOC);
    $id_map = array_column($rows, 'slug', 'id'); // [id => slug]

    if ($id_map) {
        $id_list  = implode(',', array_keys($id_map));
        $tag_rows = $db->query("
            SELECT st.skatepark_id, t.name, t.slug
            FROM skatepark_tags st JOIN tags t ON t.id = st.tag_id
            WHERE st.skatepark_id IN ($id_list)
        ")->fetch_all(MYSQLI_ASSOC);
        foreach ($tag_rows as $tr) {
            $tags_map[$tr['skatepark_id']][] = $tr;
        }
        $slug_to_id = array_flip($id_map);
    }
}

$page_title = $q ? 'Search: ' . $q : 'All Skateparks';

// All prefectures for filter
$all_prefs = array_column(
    $db->query("SELECT name FROM prefectures ORDER BY name")->fetch_all(MYSQLI_ASSOC),
    'name'
);

require_once __DIR__ . '/includes/header.php';
?>

<div class="search-header">
    <h1 class="article-title" style="border:none;padding:0;margin:0;">
        <?= $q ? 'Search results for: <em>' . htmlspecialchars($q) . '</em>' : 'All Skateparks' ?>
    </h1>
    <p class="search-count">
        <?php if ($total === 0): ?>
            No results found.
        <?php else: ?>
            <?= number_format($total) ?> article<?= $total !== 1 ? 's' : '' ?> found
            <?= $q ? 'matching "<strong>' . htmlspecialchars($q) . '</strong>"' : '' ?>.
            <?php if ($total_pages > 1): ?>
                Showing page <?= $page ?> of <?= $total_pages ?>.
            <?php endif; ?>
        <?php endif; ?>
    </p>
</div>

<!-- ============================================================
     FILTER BAR
     ============================================================ -->
<form method="get" action="search.php" style="margin-bottom:1rem;font-size:.85rem;display:flex;gap:.5rem;flex-wrap:wrap;align-items:center;">
    <input type="search" name="q" value="<?= htmlspecialchars($q) ?>" placeholder="Search…" style="padding:.3rem .5rem;border:1px solid #a2a9b1;border-radius:2px;">
    <select name="pref" style="padding:.3rem .5rem;border:1px solid #a2a9b1;border-radius:2px;">
        <option value="">All Prefectures</option>
        <?php foreach ($all_prefs as $p): ?>
        <option value="<?= htmlspecialchars($p) ?>" <?= $pref === $p ? 'selected' : '' ?>>
            <?= htmlspecialchars($p) ?>
        </option>
        <?php endforeach; ?>
    </select>
    <select name="type" style="padding:.3rem .5rem;border:1px solid #a2a9b1;border-radius:2px;">
        <option value="">All Types</option>
        <option value="outdoor" <?= $type === 'outdoor' ? 'selected' : '' ?>>Outdoor</option>
        <option value="indoor"  <?= $type === 'indoor'  ? 'selected' : '' ?>>Indoor</option>
        <option value="both"    <?= $type === 'both'    ? 'selected' : '' ?>>Both</option>
    </select>
    <button type="submit" class="btn btn-primary">Filter</button>
    <?php if ($q || $type || $pref): ?>
    <a href="search.php" class="btn btn-secondary">Clear</a>
    <?php endif; ?>
</form>

<!-- ============================================================
     RESULTS LIST
     ============================================================ -->
<?php if (empty($results)): ?>
<div class="notice-box">
    <span class="notice-icon">🔍</span>
    <span>
        No skateparks found<?= $q ? ' matching "<strong>' . htmlspecialchars($q) . '</strong>"' : '' ?>.
        <?php if ($q): ?>
        Try a different search term, or <a href="<?= BASE_URL ?>/admin/add.php">add this skatepark</a>.
        <?php endif; ?>
    </span>
</div>
<?php else: ?>

<ul class="article-list">
<?php foreach ($results as $sp):
    $sp_id = isset($slug_to_id[$sp['slug']]) ? $slug_to_id[$sp['slug']] : null;
    $sp_tags = ($sp_id && isset($tags_map[$sp_id])) ? $tags_map[$sp_id] : [];
?>
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
            <?= $sp['surface_type'] ? '· ' . htmlspecialchars($sp['surface_type']) : '' ?>
            <?= $sp['admission_fee'] ? '· ' . htmlspecialchars(mb_substr($sp['admission_fee'], 0, 40)) : '' ?>
        </p>
        <?php if ($sp_tags): ?>
        <div style="margin-top:.25rem;">
            <?php foreach ($sp_tags as $tag): ?>
            <a class="tag-badge" href="<?= BASE_URL ?>/category.php?tag=<?= urlencode($tag['slug']) ?>"><?= htmlspecialchars($tag['name']) ?></a>
            <?php endforeach; ?>
        </div>
        <?php endif; ?>
    </div>
</li>
<?php endforeach; ?>
</ul>

<!-- ============================================================
     PAGINATION
     ============================================================ -->
<?php if ($total_pages > 1): ?>
<nav style="margin-top:1rem;display:flex;gap:.3rem;font-size:.85rem;" aria-label="Pagination">
    <?php if ($page > 1): ?>
    <a class="btn btn-secondary" href="?q=<?= urlencode($q) ?>&pref=<?= urlencode($pref) ?>&type=<?= urlencode($type) ?>&page=<?= $page - 1 ?>">← Previous</a>
    <?php endif; ?>
    <?php for ($i = max(1, $page - 3); $i <= min($total_pages, $page + 3); $i++): ?>
    <a class="btn <?= $i === $page ? 'btn-primary' : 'btn-secondary' ?>"
       href="?q=<?= urlencode($q) ?>&pref=<?= urlencode($pref) ?>&type=<?= urlencode($type) ?>&page=<?= $i ?>"><?= $i ?></a>
    <?php endfor; ?>
    <?php if ($page < $total_pages): ?>
    <a class="btn btn-secondary" href="?q=<?= urlencode($q) ?>&pref=<?= urlencode($pref) ?>&type=<?= urlencode($type) ?>&page=<?= $page + 1 ?>">Next →</a>
    <?php endif; ?>
</nav>
<?php endif; ?>

<?php endif; ?>

<?php require_once __DIR__ . '/includes/footer.php'; ?>

