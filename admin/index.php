<?php
require_once __DIR__ . '/../config/db.php';

// Handle delete
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['delete_id'])) {
    db_run("DELETE FROM skateparks WHERE id = ?", [(int)$_POST['delete_id']]);
    header('Location: index.php?deleted=1');
    exit;
}

$parks = db()->query("
    SELECT s.id, s.slug, s.name, s.name_ja, p.name AS prefecture, s.city, s.park_type, s.featured, s.updated_at
    FROM skateparks s
    JOIN prefectures p ON p.id = s.prefecture_id
    ORDER BY s.name ASC
")->fetch_all(MYSQLI_ASSOC);

$page_title = 'Admin — Manage Skateparks';
require_once __DIR__ . '/../includes/header.php';
?>

<div class="admin-header">
    <h1>🛹 Admin Panel</h1>
    <nav>
        <a href="<?= BASE_URL ?>/index.php">← View Site</a>
        <a href="<?= BASE_URL ?>/admin/add.php">+ Add Skatepark</a>
    </nav>
</div>

<h2 style="font-family:var(--font-serif);font-size:1.3rem;font-weight:normal;margin-bottom:.8rem;">
    Manage Skateparks
    <small style="font-size:.8rem;font-weight:normal;color:#777;">(<?= count($parks) ?> total)</small>
</h2>

<?php if (isset($_GET['deleted'])): ?>
<div class="notice-box" style="background:#fef;border-color:#d00;margin-bottom:.8rem;">
    <span class="notice-icon">✅</span>
    <span>Skatepark deleted successfully.</span>
</div>
<?php endif; ?>

<?php if (isset($_GET['saved'])): ?>
<div class="notice-box" style="background:#efe;border-color:#090;margin-bottom:.8rem;">
    <span class="notice-icon">✅</span>
    <span>Skatepark saved successfully.</span>
</div>
<?php endif; ?>

<table class="admin-table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Prefecture</th>
            <th>City</th>
            <th>Type</th>
            <th>Featured</th>
            <th>Updated</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <?php foreach ($parks as $sp): ?>
    <tr>
        <td>
            <a href="<?= BASE_URL ?>/skatepark.php?slug=<?= urlencode($sp['slug']) ?>"><?= htmlspecialchars($sp['name']) ?></a>
            <?php if ($sp['name_ja']): ?>
            <br><small style="color:#777;"><?= htmlspecialchars($sp['name_ja']) ?></small>
            <?php endif; ?>
        </td>
        <td><?= htmlspecialchars($sp['prefecture']) ?></td>
        <td><?= htmlspecialchars($sp['city'] ?? '') ?></td>
        <td><?= ucfirst(htmlspecialchars($sp['park_type'])) ?></td>
        <td><?= $sp['featured'] ? '⭐' : '—' ?></td>
        <td style="white-space:nowrap;font-size:.78rem;"><?= date('Y-m-d', strtotime($sp['updated_at'])) ?></td>
        <td style="white-space:nowrap;">
            <a class="btn btn-secondary" href="<?= BASE_URL ?>/admin/edit.php?id=<?= $sp['id'] ?>">Edit</a>
            <form method="post" style="display:inline;" onsubmit="return confirm('Delete \'<?= addslashes(htmlspecialchars($sp['name'])) ?>\'?');">
                <input type="hidden" name="delete_id" value="<?= $sp['id'] ?>">
                <button type="submit" class="btn btn-danger">Delete</button>
            </form>
        </td>
    </tr>
    <?php endforeach; ?>
    </tbody>
</table>

<p style="margin-top:.8rem;"><a class="btn btn-primary" href="<?= BASE_URL ?>/admin/add.php">+ Add New Skatepark</a></p>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>

