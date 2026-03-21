# Japan Skateparks

The free encyclopedia of skateboarding in Japan. A Wikipedia-style directory of all 47 prefectures, covering public and private skateparks across the country.

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
