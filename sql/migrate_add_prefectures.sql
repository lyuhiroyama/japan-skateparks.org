-- Migration: add the 34 missing prefectures to an existing database.
-- Safe to run on a live DB that already has the original 13 prefectures.
-- Existing rows and their IDs are NOT touched.
-- Run: mysql -u root -p japan_skateparks < sql/migrate_add_prefectures.sql

USE japan_skateparks;

INSERT INTO prefectures (name, name_ja, region)
SELECT n, nj, r FROM (
    SELECT 'Aomori'    n, '青森県'   nj, 'Tohoku'  r UNION ALL
    SELECT 'Iwate',       '岩手県',      'Tohoku'    UNION ALL
    SELECT 'Akita',       '秋田県',      'Tohoku'    UNION ALL
    SELECT 'Yamagata',    '山形県',      'Tohoku'    UNION ALL
    SELECT 'Fukushima',   '福島県',      'Tohoku'    UNION ALL
    SELECT 'Ibaraki',     '茨城県',      'Kanto'     UNION ALL
    SELECT 'Tochigi',     '栃木県',      'Kanto'     UNION ALL
    SELECT 'Gunma',       '群馬県',      'Kanto'     UNION ALL
    SELECT 'Niigata',     '新潟県',      'Chubu'     UNION ALL
    SELECT 'Toyama',      '富山県',      'Chubu'     UNION ALL
    SELECT 'Ishikawa',    '石川県',      'Chubu'     UNION ALL
    SELECT 'Fukui',       '福井県',      'Chubu'     UNION ALL
    SELECT 'Yamanashi',   '山梨県',      'Chubu'     UNION ALL
    SELECT 'Nagano',      '長野県',      'Chubu'     UNION ALL
    SELECT 'Gifu',        '岐阜県',      'Chubu'     UNION ALL
    SELECT 'Shizuoka',    '静岡県',      'Chubu'     UNION ALL
    SELECT 'Mie',         '三重県',      'Kansai'    UNION ALL
    SELECT 'Shiga',       '滋賀県',      'Kansai'    UNION ALL
    SELECT 'Nara',        '奈良県',      'Kansai'    UNION ALL
    SELECT 'Wakayama',    '和歌山県',    'Kansai'    UNION ALL
    SELECT 'Tottori',     '鳥取県',      'Chugoku'   UNION ALL
    SELECT 'Shimane',     '島根県',      'Chugoku'   UNION ALL
    SELECT 'Okayama',     '岡山県',      'Chugoku'   UNION ALL
    SELECT 'Yamaguchi',   '山口県',      'Chugoku'   UNION ALL
    SELECT 'Tokushima',   '徳島県',      'Shikoku'   UNION ALL
    SELECT 'Kagawa',      '香川県',      'Shikoku'   UNION ALL
    SELECT 'Ehime',       '愛媛県',      'Shikoku'   UNION ALL
    SELECT 'Kochi',       '高知県',      'Shikoku'   UNION ALL
    SELECT 'Saga',        '佐賀県',      'Kyushu'    UNION ALL
    SELECT 'Nagasaki',    '長崎県',      'Kyushu'    UNION ALL
    SELECT 'Kumamoto',    '熊本県',      'Kyushu'    UNION ALL
    SELECT 'Oita',        '大分県',      'Kyushu'    UNION ALL
    SELECT 'Miyazaki',    '宮崎県',      'Kyushu'    UNION ALL
    SELECT 'Kagoshima',   '鹿児島県',    'Kyushu'
) AS new_prefs
WHERE n NOT IN (SELECT name FROM prefectures);
