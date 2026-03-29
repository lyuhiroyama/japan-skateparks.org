-- Fix Hokkaido parks that were inserted with prefecture_id = 1 when row id 1 was NOT Hokkaido
-- (e.g. older DBs where Tokyo was first in prefectures). Run once on production.
-- mysql -u USER -p japan_skateparks < sql/migrate_fix_hokkaido_skatepark_prefectures.sql

USE japan_skateparks;

UPDATE skateparks s
JOIN prefectures h ON h.name = 'Hokkaido'
SET s.prefecture_id = h.id
WHERE s.slug IN (
  'sapporo-dome-skateboard-area',
  'kutchan-skateboard-park',
  'kushiro-street-sports-park',
  'nayoro-sun-pillar-street-sports-plaza',
  'kuriyama-station-south-skatepark',
  'memushi-park-skatepark',
  'kurisawa-central-park-skate-plaza',
  'muroran-rainbow-park-skatepark',
  'moai-skatepark',
  'hot-bowl-skatepark',
  'crass-action-sports-house',
  'lowstar-skatepark',
  'diamond-ramp-hokuto',
  'spray-skatepark',
  'brayz-sk8-dome',
  'nuggets-skatepark'
);
