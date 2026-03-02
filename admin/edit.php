<?php
require_once __DIR__ . '/../config/db.php';

$pdo = db();
$id  = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if (!$id) {
    header('Location: index.php');
    exit;
}

// Load existing
$sp = $pdo->prepare("SELECT * FROM skateparks WHERE id = ?");
$sp->execute([$id]);
$sp = $sp->fetch();

if (!$sp) {
    header('Location: index.php');
    exit;
}

$prefectures = $pdo->query("SELECT id, name, name_ja FROM prefectures ORDER BY name")->fetchAll();
$all_tags    = $pdo->query("SELECT id, name, slug FROM tags ORDER BY name")->fetchAll();

// Current tags for this park
$cur_tags_stmt = $pdo->prepare("SELECT tag_id FROM skatepark_tags WHERE skatepark_id = ?");
$cur_tags_stmt->execute([$id]);
$current_tag_ids = $cur_tags_stmt->fetchAll(PDO::FETCH_COLUMN);

$errors = [];
$data   = $sp; // pre-fill from DB

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fields = ['name','name_ja','slug','prefecture_id','city','address','description',
               'history','facilities','surface_type','park_type','opening_hours',
               'closed_days','admission_fee','website','phone','latitude','longitude',
               'image_url'];
    foreach ($fields as $k) {
        $data[$k] = isset($_POST[$k]) ? trim($_POST[$k]) : '';
    }
    $data['featured'] = isset($_POST['featured']) ? 1 : 0;
    $selected_tags    = isset($_POST['tags']) ? array_map('intval', $_POST['tags']) : [];

    if (empty($data['name']))          $errors[] = 'Name is required.';
    if (empty($data['slug']))          $errors[] = 'Slug is required.';
    if (empty($data['prefecture_id'])) $errors[] = 'Prefecture is required.';
    if (empty($data['description']))   $errors[] = 'Overview/Description is required.';

    // Slug uniqueness (excluding self)
    if (empty($errors)) {
        $dup = $pdo->prepare("SELECT COUNT(*) FROM skateparks WHERE slug = ? AND id != ?");
        $dup->execute([$data['slug'], $id]);
        if ($dup->fetchColumn() > 0) {
            $errors[] = 'Slug "' . htmlspecialchars($data['slug']) . '" is already used by another skatepark.';
        }
    }

    if (empty($errors)) {
        $upd = $pdo->prepare("
            UPDATE skateparks SET
                slug=:slug, name=:name, name_ja=:name_ja, prefecture_id=:prefecture_id,
                city=:city, address=:address, description=:description, history=:history,
                facilities=:facilities, surface_type=:surface_type, park_type=:park_type,
                opening_hours=:opening_hours, closed_days=:closed_days, admission_fee=:admission_fee,
                website=:website, phone=:phone, latitude=:latitude, longitude=:longitude,
                image_url=:image_url, featured=:featured
            WHERE id=:id
        ");
        $upd->execute([
            ':slug'          => $data['slug'],
            ':name'          => $data['name'],
            ':name_ja'       => $data['name_ja']       ?: null,
            ':prefecture_id' => (int)$data['prefecture_id'],
            ':city'          => $data['city']          ?: null,
            ':address'       => $data['address']       ?: null,
            ':description'   => $data['description'],
            ':history'       => $data['history']       ?: null,
            ':facilities'    => $data['facilities']    ?: null,
            ':surface_type'  => $data['surface_type']  ?: null,
            ':park_type'     => in_array($data['park_type'], ['indoor','outdoor','both']) ? $data['park_type'] : 'outdoor',
            ':opening_hours' => $data['opening_hours'] ?: null,
            ':closed_days'   => $data['closed_days']   ?: null,
            ':admission_fee' => $data['admission_fee'] ?: null,
            ':website'       => $data['website']       ?: null,
            ':phone'         => $data['phone']         ?: null,
            ':latitude'      => $data['latitude']  !== '' ? (float)$data['latitude']  : null,
            ':longitude'     => $data['longitude'] !== '' ? (float)$data['longitude'] : null,
            ':image_url'     => $data['image_url']     ?: null,
            ':featured'      => (int)$data['featured'],
            ':id'            => $id,
        ]);

        // Update tags: delete old, insert new
        $pdo->prepare("DELETE FROM skatepark_tags WHERE skatepark_id = ?")->execute([$id]);
        if ($selected_tags) {
            $ins_tag = $pdo->prepare("INSERT IGNORE INTO skatepark_tags (skatepark_id, tag_id) VALUES (?,?)");
            foreach ($selected_tags as $tid) {
                $ins_tag->execute([$id, $tid]);
            }
        }

        header('Location: ' . BASE_URL . '/admin/index.php?saved=1');
        exit;
    }
    $current_tag_ids = $selected_tags;
}

$page_title = 'Edit: ' . $data['name'];
require_once __DIR__ . '/../includes/header.php';
?>

<div class="admin-header">
    <h1>🛹 Edit Skatepark</h1>
    <nav>
        <a href="<?= BASE_URL ?>/admin/index.php">← Admin</a>
        <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($data['slug']) ?>">View Article</a>
        <a href="<?= BASE_URL ?>/index.php">View Site</a>
    </nav>
</div>

<?php if ($errors): ?>
<div class="notice-box" style="background:#fef2f2;border-color:#f87171;margin-bottom:1rem;">
    <span class="notice-icon">⚠️</span>
    <span>
        <strong>Please fix the following errors:</strong>
        <ul style="margin:.3rem 0 0 1.2rem;">
            <?php foreach ($errors as $e): ?>
            <li><?= htmlspecialchars($e) ?></li>
            <?php endforeach; ?>
        </ul>
    </span>
</div>
<?php endif; ?>

<form method="post">

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:.5rem 0 1rem;">Basic Information</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="name">Name (English) <span style="color:#d33;">*</span></label>
            <input type="text" id="name" name="name" value="<?= htmlspecialchars($data['name']) ?>" required>
        </div>
        <div class="form-group">
            <label for="name_ja">Name (Japanese)</label>
            <input type="text" id="name_ja" name="name_ja" value="<?= htmlspecialchars($data['name_ja'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label for="slug">URL Slug <span style="color:#d33;">*</span></label>
            <input type="text" id="slug" name="slug" value="<?= htmlspecialchars($data['slug']) ?>" required>
        </div>
        <div class="form-group">
            <label for="prefecture_id">Prefecture <span style="color:#d33;">*</span></label>
            <select id="prefecture_id" name="prefecture_id" required>
                <option value="">— Select —</option>
                <?php foreach ($prefectures as $p): ?>
                <option value="<?= $p['id'] ?>" <?= $data['prefecture_id'] == $p['id'] ? 'selected' : '' ?>>
                    <?= htmlspecialchars($p['name']) ?> (<?= htmlspecialchars($p['name_ja']) ?>)
                </option>
                <?php endforeach; ?>
            </select>
        </div>
        <div class="form-group">
            <label for="city">City / Town</label>
            <input type="text" id="city" name="city" value="<?= htmlspecialchars($data['city'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label for="park_type">Park Type</label>
            <select id="park_type" name="park_type">
                <option value="outdoor" <?= ($data['park_type'] ?? '') === 'outdoor' ? 'selected' : '' ?>>Outdoor</option>
                <option value="indoor"  <?= ($data['park_type'] ?? '') === 'indoor'  ? 'selected' : '' ?>>Indoor</option>
                <option value="both"    <?= ($data['park_type'] ?? '') === 'both'    ? 'selected' : '' ?>>Both</option>
            </select>
        </div>
        <div class="form-group full-width">
            <label for="address">Address</label>
            <input type="text" id="address" name="address" value="<?= htmlspecialchars($data['address'] ?? '') ?>">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Article Content</h2>
    <div class="form-group">
        <label for="description">Overview / Description <span style="color:#d33;">*</span></label>
        <textarea id="description" name="description" rows="5"><?= htmlspecialchars($data['description'] ?? '') ?></textarea>
    </div>
    <div class="form-group">
        <label for="history">History</label>
        <textarea id="history" name="history" rows="4"><?= htmlspecialchars($data['history'] ?? '') ?></textarea>
    </div>
    <div class="form-group">
        <label for="facilities">Facilities</label>
        <textarea id="facilities" name="facilities" rows="3"><?= htmlspecialchars($data['facilities'] ?? '') ?></textarea>
        <small style="color:#777;font-size:.75rem;">Separate items with commas to display as a bullet list.</small>
    </div>
    <div class="form-group">
        <label for="surface_type">Surface Type</label>
        <input type="text" id="surface_type" name="surface_type" value="<?= htmlspecialchars($data['surface_type'] ?? '') ?>">
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Access & Operations</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="opening_hours">Opening Hours</label>
            <input type="text" id="opening_hours" name="opening_hours" value="<?= htmlspecialchars($data['opening_hours'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label for="closed_days">Closed Days</label>
            <input type="text" id="closed_days" name="closed_days" value="<?= htmlspecialchars($data['closed_days'] ?? '') ?>">
        </div>
        <div class="form-group full-width">
            <label for="admission_fee">Admission Fee</label>
            <textarea id="admission_fee" name="admission_fee" rows="2"><?= htmlspecialchars($data['admission_fee'] ?? '') ?></textarea>
        </div>
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="tel" id="phone" name="phone" value="<?= htmlspecialchars($data['phone'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label for="website">Website URL</label>
            <input type="url" id="website" name="website" value="<?= htmlspecialchars($data['website'] ?? '') ?>">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Location & Media</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="latitude">Latitude</label>
            <input type="number" id="latitude" name="latitude" value="<?= htmlspecialchars($data['latitude'] ?? '') ?>" step="0.000001">
        </div>
        <div class="form-group">
            <label for="longitude">Longitude</label>
            <input type="number" id="longitude" name="longitude" value="<?= htmlspecialchars($data['longitude'] ?? '') ?>" step="0.000001">
        </div>
        <div class="form-group full-width">
            <label for="image_url">Image URL</label>
            <input type="url" id="image_url" name="image_url" value="<?= htmlspecialchars($data['image_url'] ?? '') ?>">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Categories & Tags</h2>
    <div class="form-group">
        <label>Tags</label>
        <div style="display:flex;flex-wrap:wrap;gap:.4rem;">
            <?php foreach ($all_tags as $t): ?>
            <label style="display:flex;align-items:center;gap:.25rem;font-weight:normal;font-size:.85rem;background:#f8f9fa;border:1px solid #eaecf0;padding:.2rem .5rem;border-radius:2px;cursor:pointer;">
                <input type="checkbox" name="tags[]" value="<?= $t['id'] ?>"
                    <?= in_array($t['id'], $current_tag_ids) ? 'checked' : '' ?>>
                <?= htmlspecialchars($t['name']) ?>
            </label>
            <?php endforeach; ?>
        </div>
    </div>

    <div class="form-group">
        <label style="display:flex;align-items:center;gap:.4rem;font-weight:normal;cursor:pointer;">
            <input type="checkbox" name="featured" value="1" <?= !empty($data['featured']) ? 'checked' : '' ?>>
            <strong>Feature this skatepark</strong> on the main page
        </label>
    </div>

    <div style="margin-top:1.2rem;display:flex;gap:.6rem;">
        <button type="submit" class="btn btn-primary">Save Changes</button>
        <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($data['slug']) ?>" class="btn btn-secondary">View Article</a>
        <a href="<?= BASE_URL ?>/admin/index.php" class="btn btn-secondary">Cancel</a>
    </div>

</form>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>

