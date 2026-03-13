<?php
require_once __DIR__ . '/../config/db.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if (!$id) {
    header('Location: index.php');
    exit;
}

// Load existing
$sp = db_run("SELECT * FROM skateparks WHERE id = ?", [$id])->get_result()->fetch_assoc();

if (!$sp) {
    header('Location: index.php');
    exit;
}

$prefectures = db()->query("SELECT id, name, name_ja FROM prefectures ORDER BY name")->fetch_all(MYSQLI_ASSOC);
$all_tags    = db()->query("SELECT id, name, slug FROM tags ORDER BY name")->fetch_all(MYSQLI_ASSOC);

// Current tags for this park
$current_tag_ids = array_column(
    db_run("SELECT tag_id FROM skatepark_tags WHERE skatepark_id = ?", [$id])->get_result()->fetch_all(MYSQLI_ASSOC),
    'tag_id'
);

$errors = [];
$data   = $sp; // pre-fill from DB

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fields = ['name','name_ja','slug','prefecture_id','city','city_ja','address','address_ja',
               'description','description_ja','history','history_ja',
               'facilities','facilities_ja','surface_type','surface_type_ja','park_type','opening_hours',
               'closed_days','closed_days_ja','admission_fee','admission_fee_ja',
               'website','phone','latitude','longitude','image_url'];
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
        $dup_count = (int) db_run("SELECT COUNT(*) FROM skateparks WHERE slug = ? AND id != ?", [$data['slug'], $id])->get_result()->fetch_row()[0];
        if ($dup_count > 0) {
            $errors[] = 'Slug "' . htmlspecialchars($data['slug']) . '" is already used by another skatepark.';
        }
    }

    if (empty($errors)) {
        $park_type = in_array($data['park_type'], ['indoor','outdoor','both']) ? $data['park_type'] : 'outdoor';
        db_run("
            UPDATE skateparks SET
                slug=?, name=?, name_ja=?, prefecture_id=?,
                city=?, city_ja=?, address=?, address_ja=?,
                description=?, description_ja=?,
                history=?, history_ja=?,
                facilities=?, facilities_ja=?,
                surface_type=?, surface_type_ja=?, park_type=?,
                opening_hours=?, closed_days=?, closed_days_ja=?,
                admission_fee=?, admission_fee_ja=?,
                website=?, phone=?, latitude=?, longitude=?,
                image_url=?, featured=?
            WHERE id=?
        ", [
            $data['slug'],
            $data['name'],
            $data['name_ja']           ?: null,
            $data['prefecture_id'],
            $data['city']              ?: null,
            $data['city_ja']           ?: null,
            $data['address']           ?: null,
            $data['address_ja']        ?: null,
            $data['description'],
            $data['description_ja']    ?: null,
            $data['history']           ?: null,
            $data['history_ja']        ?: null,
            $data['facilities']        ?: null,
            $data['facilities_ja']     ?: null,
            $data['surface_type']      ?: null,
            $data['surface_type_ja']   ?: null,
            $park_type,
            $data['opening_hours']     ?: null,
            $data['closed_days']       ?: null,
            $data['closed_days_ja']    ?: null,
            $data['admission_fee']     ?: null,
            $data['admission_fee_ja']  ?: null,
            $data['website']           ?: null,
            $data['phone']             ?: null,
            $data['latitude']  !== '' ? (float)$data['latitude']  : null,
            $data['longitude'] !== '' ? (float)$data['longitude'] : null,
            $data['image_url']         ?: null,
            (int)$data['featured'],
            $id,
        ]);

        // Update tags: delete old, insert new
        db_run("DELETE FROM skatepark_tags WHERE skatepark_id = ?", [$id]);
        if ($selected_tags) {
            foreach ($selected_tags as $tid) {
                db_run("INSERT IGNORE INTO skatepark_tags (skatepark_id, tag_id) VALUES (?, ?)", [$id, (int)$tid]);
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
            <label for="city_ja">City / Town (日本語)</label>
            <input type="text" id="city_ja" name="city_ja" value="<?= htmlspecialchars($data['city_ja'] ?? '') ?>" placeholder="e.g. 墨田区">
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
        <div class="form-group full-width">
            <label for="address_ja">Address (日本語)</label>
            <input type="text" id="address_ja" name="address_ja" value="<?= htmlspecialchars($data['address_ja'] ?? '') ?>" placeholder="e.g. 東京都墨田区向島5-9-1">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Article Content</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="description">Overview / Description (English) <span style="color:#d33;">*</span></label>
            <textarea id="description" name="description" rows="5"><?= htmlspecialchars($data['description'] ?? '') ?></textarea>
        </div>
        <div class="form-group">
            <label for="description_ja">Overview / Description (日本語)</label>
            <textarea id="description_ja" name="description_ja" rows="5" placeholder="スケートパークの概要…"><?= htmlspecialchars($data['description_ja'] ?? '') ?></textarea>
        </div>
        <div class="form-group">
            <label for="history">History (English)</label>
            <textarea id="history" name="history" rows="4"><?= htmlspecialchars($data['history'] ?? '') ?></textarea>
        </div>
        <div class="form-group">
            <label for="history_ja">History (日本語)</label>
            <textarea id="history_ja" name="history_ja" rows="4" placeholder="歴史的背景、建設時期、主なイベントなど…"><?= htmlspecialchars($data['history_ja'] ?? '') ?></textarea>
        </div>
        <div class="form-group">
            <label for="facilities">Facilities (English)</label>
            <textarea id="facilities" name="facilities" rows="3"><?= htmlspecialchars($data['facilities'] ?? '') ?></textarea>
            <small style="color:#777;font-size:.75rem;">Separate items with commas to display as a bullet list.</small>
        </div>
        <div class="form-group">
            <label for="facilities_ja">Facilities (日本語)</label>
            <textarea id="facilities_ja" name="facilities_ja" rows="3" placeholder="コンマ区切りまたは文章で記入"><?= htmlspecialchars($data['facilities_ja'] ?? '') ?></textarea>
        </div>
    </div>
    <div class="form-grid">
        <div class="form-group">
            <label for="surface_type">Surface Type</label>
            <input type="text" id="surface_type" name="surface_type" value="<?= htmlspecialchars($data['surface_type'] ?? '') ?>">
        </div>
        <div class="form-group">
            <label for="surface_type_ja">Surface Type (日本語)</label>
            <input type="text" id="surface_type_ja" name="surface_type_ja" value="<?= htmlspecialchars($data['surface_type_ja'] ?? '') ?>" placeholder="e.g. スムースコンクリート">
        </div>
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
        <div class="form-group">
            <label for="closed_days_ja">Closed Days (日本語)</label>
            <input type="text" id="closed_days_ja" name="closed_days_ja" value="<?= htmlspecialchars($data['closed_days_ja'] ?? '') ?>" placeholder="e.g. 毎週水曜日">
        </div>
        <div class="form-group full-width">
            <label for="admission_fee">Admission Fee</label>
            <textarea id="admission_fee" name="admission_fee" rows="2"><?= htmlspecialchars($data['admission_fee'] ?? '') ?></textarea>
        </div>
        <div class="form-group full-width">
            <label for="admission_fee_ja">Admission Fee (日本語)</label>
            <textarea id="admission_fee_ja" name="admission_fee_ja" rows="2" placeholder="e.g. 大人 ¥500 / 学生 ¥300"><?= htmlspecialchars($data['admission_fee_ja'] ?? '') ?></textarea>
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
            <input type="text" id="image_url" name="image_url" value="<?= htmlspecialchars($data['image_url'] ?? '') ?>" placeholder="e.g. /images/skateparks/sumida_skatepark.jpg or https://…">
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

