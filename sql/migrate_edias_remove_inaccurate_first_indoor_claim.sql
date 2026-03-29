-- Edias: remove inaccurate "first indoor (in) Sapporo" wording; keep closure + historical note.
-- Run: mysql -u portfolio_user -p japan_skateparks < sql/migrate_edias_remove_inaccurate_first_indoor_claim.sql

USE japan_skateparks;

UPDATE skateparks SET
  description = 'This facility is permanently closed. EDIAS Skatepark opened in November 2010 in Higashi-ku, Sapporo. The space housed ramps, street sections, and a skate shop, and welcomed skateboarding, inline skating, and BMX. It is documented here for historical reference.',
  description_ja = '当施設は閉鎖済みです。エディアススケートパークは2010年11月、札幌市東区にオープンした屋内専用スケートパークでした。ランプやストリート系セクション、併設のスケートショップがあり、スケートボード・インラインスケート・BMXが利用できました。歴史的記録として掲載しています。'
WHERE slug = 'edias-skatepark';
