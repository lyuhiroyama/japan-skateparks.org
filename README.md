[日本語](#japan-skateparksorg-日本語) | [English](#japan-skateparksorg-english)

---

# japan-skateparks.org (English)  

> ⚠️ Work in progress. Content and features are actively updated.

A wikipedia-style website with skatepark info across all 47 prefectures of Japan.

## Stack

- PHP (no framework)
- MySQL
- Vanilla JS / CSS

## Setup

1. Copy `config/db.php.example` to `config/db.php` and fill in your credentials.
2. Import the schema and seed data:
   ```
   mysql -u root -p < sql/schema.sql
   ```
3. Point a web server (Apache/Nginx) at the project root.

## Database migrations

When updating an existing database, use the migration files in `sql/`:

| File | Purpose |
|------|---------|
| `sql/migrate_add_prefectures.sql` | Adds the full set of 47 prefectures (safe to run on existing DB) |

## Third-party data credits

### Prefecture map

The interactive Japan prefecture map (`images/japan-prefectures.svg`) was generated from GeoJSON data sourced via [dataofjapan/land](https://github.com/dataofjapan/land), which is derived from:

> **地球地図日本 / Global Map Japan**  
> Geospatial Information Authority of Japan (国土地理院 / GSI)  
> http://www.gsi.go.jp/kankyochiri/gm_jpn.html

License terms (per the upstream repo):
- **Non-commercial use** — free, with attribution to 地球地図日本 / GSI Japan required.
- **Commercial use** — attribution required, plus usage must be reported to the copyright holder (GSI Japan).

Attribution is displayed on the map on the Prefectures page.

---

# japan-skateparks.org (日本語)  

> ⚠️ 作成中です。コンテンツと機能は随時追加されています。

日本全国47都道府県のスケートパークを集めた、Wikipediaスタイルのサイト。

## 技術スタック

- PHP（フレームワークなし）
- MySQL
- Vanilla JS / CSS

## セットアップ

1. `config/db.php.example` を `config/db.php` にコピーし、DB接続情報を入力する。
2. スキーマとシードデータをインポートする：
   ```
   mysql -u root -p < sql/schema.sql
   ```
3. Webサーバー（Apache/Nginx）のドキュメントルートをプロジェクトのルートに設定する。

## データベースマイグレーション

既存のDBを更新する場合は `sql/` 内のマイグレーションファイルを使用する：

| ファイル | 内容 |
|---------|------|
| `sql/migrate_add_prefectures.sql` | 47都道府県を全件追加（既存DBに対して安全に実行可能） |

## サードパーティデータのクレジット

### 都道府県マップ

インタラクティブな都道府県マップ（`images/japan-prefectures.svg`）は、[dataofjapan/land](https://github.com/dataofjapan/land) 経由で取得したGeoJSONデータから生成しており、そのデータは以下に由来します：

> **地球地図日本 / Global Map Japan**  
> 国土地理院（GSI）  
> http://www.gsi.go.jp/kankyochiri/gm_jpn.html

ライセンス（upstream repoに準拠）：
- **非営利利用** — 無料。出典（地球地図日本 / GSI）の明記が必要。
- **営利利用** — 出典の明記に加え、著作権者（国土地理院）への利用報告が必要。

出典はサイトの都道府県ページのマップ下部に表示済み。
