<?php
require_once __DIR__ . '/../config/db.php';

$errors = [];
$data   = [
    'name' => '', 'name_ja' => '', 'slug' => '', 'prefecture_id' => '',
    'city' => '', 'address' => '', 'description' => '', 'history' => '',
    'facilities' => '', 'surface_type' => '', 'park_type' => 'outdoor',
    'opening_hours' => '', 'closed_days' => '', 'admission_fee' => '',
    'website' => '', 'phone' => '', 'latitude' => '', 'longitude' => '',
    'image_url' => '', 'featured' => 0,
];

$prefectures = db()->query("SELECT id, name, name_ja FROM prefectures ORDER BY name")->fetch_all(MYSQLI_ASSOC);
$all_tags    = db()->query("SELECT id, name, slug FROM tags ORDER BY name")->fetch_all(MYSQLI_ASSOC);

// Helper: generate slug from name
function make_slug(string $str): string {
    $str = mb_strtolower($str);
    $str = preg_replace('/[^a-z0-9\s-]/', '', $str);
    $str = preg_replace('/[\s-]+/', '-', trim($str));
    return $str;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    foreach (array_keys($data) as $k) {
        $data[$k] = isset($_POST[$k]) ? trim($_POST[$k]) : '';
    }
    $data['featured'] = isset($_POST['featured']) ? 1 : 0;
    $selected_tags = isset($_POST['tags']) ? array_map('intval', $_POST['tags']) : [];

    // Auto-generate slug if not provided
    if (empty($data['slug'])) {
        $data['slug'] = make_slug($data['name']);
    }

    // Validation
    if (empty($data['name']))          $errors[] = 'Name is required.';
    if (empty($data['slug']))          $errors[] = 'Slug is required.';
    if (empty($data['prefecture_id'])) $errors[] = 'Prefecture is required.';
    if (empty($data['description']))   $errors[] = 'Overview/Description is required.';

    // Check slug uniqueness
    if (empty($errors)) {
        $dup_count = (int) db_run("SELECT COUNT(*) FROM skateparks WHERE slug = ?", [$data['slug']])->get_result()->fetch_row()[0];
        if ($dup_count > 0) {
            $errors[] = 'Slug "' . htmlspecialchars($data['slug']) . '" already exists. Choose a different one.';
        }
    }

    if (empty($errors)) {
        $park_type = in_array($data['park_type'], ['indoor','outdoor','both']) ? $data['park_type'] : 'outdoor';
        db_run("
            INSERT INTO skateparks
                (slug, name, name_ja, prefecture_id, city, address, description, history,
                 facilities, surface_type, park_type, opening_hours, closed_days, admission_fee,
                 website, phone, latitude, longitude, image_url, featured)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ", [
            $data['slug'],
            $data['name'],
            $data['name_ja']       ?: null,
            $data['prefecture_id'],
            $data['city']          ?: null,
            $data['address']       ?: null,
            $data['description'],
            $data['history']       ?: null,
            $data['facilities']    ?: null,
            $data['surface_type']  ?: null,
            $park_type,
            $data['opening_hours'] ?: null,
            $data['closed_days']   ?: null,
            $data['admission_fee'] ?: null,
            $data['website']       ?: null,
            $data['phone']         ?: null,
            $data['latitude']  !== '' ? (float)$data['latitude']  : null,
            $data['longitude'] !== '' ? (float)$data['longitude'] : null,
            $data['image_url']     ?: null,
            (int)$data['featured'],
        ]);
        $new_id = (int) db()->insert_id;

        // Insert tags
        if ($selected_tags) {
            foreach ($selected_tags as $tid) {
                db_run("INSERT IGNORE INTO skatepark_tags (skatepark_id, tag_id) VALUES (?, ?)", [$new_id, (int)$tid]);
            }
        }

        header('Location: ' . BASE_URL . '/skatepark.php?slug=' . urlencode($data['slug']));
        exit;
    }
}

$page_title = 'Add Skatepark';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="admin-header">
    <h1>🛹 Add New Skatepark</h1>
    <nav>
        <a href="<?= BASE_URL ?>/admin/index.php">← Admin</a>
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
            <input type="text" id="name" name="name" value="<?= htmlspecialchars($data['name']) ?>" required placeholder="e.g. Ariake Urban Sports Park">
        </div>
        <div class="form-group">
            <label for="name_ja">Name (Japanese)</label>
            <input type="text" id="name_ja" name="name_ja" value="<?= htmlspecialchars($data['name_ja']) ?>" placeholder="e.g. 有明アーバンスポーツパーク">
        </div>
        <div class="form-group">
            <label for="slug">URL Slug <span style="color:#d33;">*</span></label>
            <input type="text" id="slug" name="slug" value="<?= htmlspecialchars($data['slug']) ?>" placeholder="auto-generated from name">
            <small style="color:#777;font-size:.75rem;">Leave blank to auto-generate. Only lowercase letters, numbers, hyphens.</small>
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
            <input type="text" id="city" name="city" value="<?= htmlspecialchars($data['city']) ?>">
        </div>
        <div class="form-group">
            <label for="park_type">Park Type</label>
            <select id="park_type" name="park_type">
                <option value="outdoor" <?= $data['park_type'] === 'outdoor' ? 'selected' : '' ?>>Outdoor</option>
                <option value="indoor"  <?= $data['park_type'] === 'indoor'  ? 'selected' : '' ?>>Indoor</option>
                <option value="both"    <?= $data['park_type'] === 'both'    ? 'selected' : '' ?>>Both</option>
            </select>
        </div>
        <div class="form-group full-width">
            <label for="address">Address</label>
            <input type="text" id="address" name="address" value="<?= htmlspecialchars($data['address']) ?>" placeholder="Full address">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Article Content</h2>

    <div class="form-group">
        <label for="description">Overview / Description <span style="color:#d33;">*</span></label>
        <textarea id="description" name="description" rows="5" placeholder="Introductory description of the skatepark…"><?= htmlspecialchars($data['description']) ?></textarea>
    </div>
    <div class="form-group">
        <label for="history">History</label>
        <textarea id="history" name="history" rows="4" placeholder="Historical background, when it was built, notable events…"><?= htmlspecialchars($data['history']) ?></textarea>
    </div>
    <div class="form-group">
        <label for="facilities">Facilities</label>
        <textarea id="facilities" name="facilities" rows="3" placeholder="Comma-separated list or paragraph, e.g. Street course, Bowl, Lockers, Café"><?= htmlspecialchars($data['facilities']) ?></textarea>
        <small style="color:#777;font-size:.75rem;">Separate items with commas to display as a bullet list.</small>
    </div>
    <div class="form-group">
        <label for="surface_type">Surface Type</label>
        <input type="text" id="surface_type" name="surface_type" value="<?= htmlspecialchars($data['surface_type']) ?>" placeholder="e.g. Smooth concrete, Asphalt">
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Access & Operations</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="opening_hours">Opening Hours</label>
            <input type="text" id="opening_hours" name="opening_hours" value="<?= htmlspecialchars($data['opening_hours']) ?>" placeholder="e.g. 9:00 AM – 9:00 PM">
        </div>
        <div class="form-group">
            <label for="closed_days">Closed Days</label>
            <input type="text" id="closed_days" name="closed_days" value="<?= htmlspecialchars($data['closed_days']) ?>" placeholder="e.g. Mondays">
        </div>
        <div class="form-group full-width">
            <label for="admission_fee">Admission Fee</label>
            <textarea id="admission_fee" name="admission_fee" rows="2" placeholder="e.g. Adults ¥500 / Students ¥300 / Children Free"><?= htmlspecialchars($data['admission_fee']) ?></textarea>
        </div>
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="tel" id="phone" name="phone" value="<?= htmlspecialchars($data['phone']) ?>" placeholder="e.g. 03-XXXX-XXXX">
        </div>
        <div class="form-group">
            <label for="website">Website URL</label>
            <input type="url" id="website" name="website" value="<?= htmlspecialchars($data['website']) ?>" placeholder="https://…">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Location & Media</h2>
    <div class="form-grid">
        <div class="form-group">
            <label for="latitude">Latitude</label>
            <input type="number" id="latitude" name="latitude" value="<?= htmlspecialchars($data['latitude']) ?>" step="0.000001" placeholder="e.g. 35.6303">
        </div>
        <div class="form-group">
            <label for="longitude">Longitude</label>
            <input type="number" id="longitude" name="longitude" value="<?= htmlspecialchars($data['longitude']) ?>" step="0.000001" placeholder="e.g. 139.7781">
        </div>
        <div class="form-group full-width">
            <label for="image_url">Image URL</label>
            <input type="url" id="image_url" name="image_url" value="<?= htmlspecialchars($data['image_url']) ?>" placeholder="https://…/image.jpg">
        </div>
    </div>

    <h2 style="font-family:var(--font-serif);font-size:1.2rem;font-weight:normal;border-bottom:1px solid #eaecf0;padding-bottom:.3rem;margin:1.2rem 0 1rem;">Categories & Tags</h2>
    <div class="form-group">
        <label>Tags</label>
        <div style="display:flex;flex-wrap:wrap;gap:.4rem;">
            <?php foreach ($all_tags as $t): ?>
            <label style="display:flex;align-items:center;gap:.25rem;font-weight:normal;font-size:.85rem;background:#f8f9fa;border:1px solid #eaecf0;padding:.2rem .5rem;border-radius:2px;cursor:pointer;">
                <input type="checkbox" name="tags[]" value="<?= $t['id'] ?>"
                    <?= in_array($t['id'], $selected_tags ?? []) ? 'checked' : '' ?>>
                <?= htmlspecialchars($t['name']) ?>
            </label>
            <?php endforeach; ?>
        </div>
    </div>

    <div class="form-group">
        <label style="display:flex;align-items:center;gap:.4rem;font-weight:normal;cursor:pointer;">
            <input type="checkbox" name="featured" value="1" <?= $data['featured'] ? 'checked' : '' ?>>
            <strong>Feature this skatepark</strong> on the main page
        </label>
    </div>

    <div style="margin-top:1.2rem;display:flex;gap:.6rem;">
        <button type="submit" class="btn btn-primary">Save Skatepark</button>
        <a href="<?= BASE_URL ?>/admin/index.php" class="btn btn-secondary">Cancel</a>
    </div>

</form>

<!-- Auto-slug JS -->
<script>
document.getElementById('name').addEventListener('input', function() {
    const slug_field = document.getElementById('slug');
    if (!slug_field._manually_set) {
        slug_field.value = this.value
            .toLowerCase()
            .replace(/[^a-z0-9\s-]/g, '')
            .replace(/[\s-]+/g, '-')
            .replace(/^-+|-+$/g, '');
    }
});
document.getElementById('slug').addEventListener('input', function() {
    this._manually_set = this.value !== '';
});
</script>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>

