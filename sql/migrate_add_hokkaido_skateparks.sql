-- Sixteen Hokkaido skateparks (public + major private indoor/outdoor).
-- Run: mysql -u USER -p japan_skateparks < sql/migrate_add_hokkaido_skateparks.sql
-- Safe to re-run only if you DELETE these slugs first (otherwise duplicate slug error).

USE japan_skateparks;

INSERT INTO skateparks (slug, name, name_ja, prefecture_id, city, address, description, history, facilities, surface_type, park_type, opening_hours, closed_days, admission_fee, website, latitude, longitude, image_url, featured) VALUES

('sapporo-dome-skateboard-area',
'Sapporo Dome Skateboard Area',
'札幌ドーム　スケートボードエリア',
1, 'Sapporo', '1 Hitsujigaoka, Toyohira-ku, Sapporo, Hokkaido 062-0045',
'Outdoor skateboard area on the south terrace of Sapporo Dome (Premist Dome), opened in May 2023. The roughly 1,600 m² layout features a long pump-style flow line (about 60 m), manual pads, rails, boxes, and kickers suited to flow and street fundamentals. Use is free during the summer season (approximately May through October); the area closes in winter and when surfaces are wet. Skateboards, BMX, and mountain bikes are allowed in the main zone under posted rules; some other rolling devices are restricted by section. No on-site equipment rental.',
'Developed to meet demand for accessible skate space in Sapporo, the facility is operated as part of the dome complex with clear safety rules — including mandatory helmets for elementary-school-age users and younger — and carry-in, carry-out rubbish policies.',
'Long pump / flow course (~60 m), manual pads, pipe rail, boxes, kickers, flat areas',
'Concrete',
'outdoor',
'Approx. 9:30 AM until sunset (seasonal; confirm on official site)',
'Winter off-season; closed in rain / when wet',
'Free',
'https://www.sapporo-dome.co.jp/facility/enjoy/skateboard/',
43.08570000, 141.27660000,
NULL,
0),

('kutchan-skateboard-park',
'Kutchan Skateboard Park',
'倶知安スケートボードパーク',
1, 'Kutchan', 'Kutchan Town, Abuta District, Hokkaido',
'Outdoor public skateboard park in Kutchan Town (Abuta District), supporting board sports in the Niseko area alongside the town''s better-known winter tourism. Typical municipal layout with concrete street and transition elements; confirm current hours, seasonal opening, and registration rules with Kutchan Town before visiting.',
'Added as part of broader sports and youth recreation provision in a town that draws international visitors year-round.',
'Street and transition-style obstacles (confirm on site)',
'Concrete',
'outdoor',
'Confirm with Kutchan Town / facility signage',
'Seasonal or weather-dependent (confirm locally)',
'Free (public park; confirm locally)',
NULL,
42.90100000, 140.75500000,
NULL,
0),

('kushiro-street-sports-park',
'Kushiro Street Sports Park',
'釧路ストリートスポーツパーク',
1, 'Kushiro', '1 Minhamacho, Kushiro, Hokkaido',
'Kushiro City''s dedicated street-sports plaza in Minhamacho combines two street-basketball courts with a concrete zone for skateboards, inline skates, and BMX. Obstacles include quarter pipes, a spine, hips, bank-to-banks, a pyramid, grind boxes, and rails. Entry is not reservation-based; visitors register via QR at the gate. Helmets and protective gear are mandatory outside the basketball courts. Season runs approximately 1 April to 30 November with hours around 9:00–21:00, subject to snow and weather.',
'Opened as part of Kushiro''s waterfront and youth-sports development, the park gives eastern Hokkaido a purpose-built space for boards and wheels near the city centre.',
'Street basketball courts (×2), quarter pipes, spine, hips, bank-to-banks, pyramid, grind boxes, rails',
'Concrete',
'outdoor',
'Approx. 9:00 AM – 9:00 PM (April–November; confirm city notice)',
'December–March; may close in severe weather',
'Free (registration required)',
'https://www.city.kushiro.lg.jp/sangyou/umisora/1006541/1006572/1006573.html',
42.99050000, 144.37750000,
NULL,
0),

('nayoro-sun-pillar-street-sports-plaza',
'Nayoro Sun Pillar Park Street Sports Plaza',
'名寄サンピラーパーク　ストリートスポーツ広場',
1, 'Nayoro', 'Nishin, Nayoro, Hokkaido',
'Street sports plaza inside Hokkaido Prefecture''s Sun Pillar Park (San Pillar Park) in Nayoro — one of Japan''s northernmost public concrete parks. Roughly 800 m² of metal-framed, street-style obstacles including pyramids, rails, boxes, and manual-style elements, usable with skateboards, BMX, and inline skates. Open free of charge from 1 May to 31 October, 9:00–18:00, with parking on site. Helmet use is recommended rather than compulsory; riding is at your own risk.',
'Built to give northern Hokkaido riders a full-sized outdoor training ground with long summer daylight and open views over the surrounding landscape.',
'Pyramid, rails, boxes, manual pads, assorted street transitions',
'Concrete / metal sections',
'outdoor',
'9:00 AM – 6:00 PM (May 1 – October 31)',
'November – April',
'Free',
'http://www.nayoro.co.jp/sunpillarpark/09street-sports.html',
44.35100000, 142.46400000,
NULL,
0),

('kuriyama-station-south-skatepark',
'Kuriyama Station South Park Skateboard Park',
'栗山駅南公園スケートボードパーク',
1, 'Kuriyama', 'Central 3-chome, Kuriyama Town, Yubari District, Hokkaido',
'Municipal concrete skatepark completed in 2022 beside Kuriyama Station South Park in Kuriyama Town (Yubari District) — the district''s first public skate facility. About 600 m² of smooth, blue-tinted concrete with roughly eleven sections including flat banks, bank-to-banks, quarter pipes, manual pads, boxes, rails, and a small mini ramp. Free to use from late April to early November, until 8:00 PM (6:00 PM if only junior-high and younger users). Riders must sign a user register; helmets and pads are strongly recommended.',
'Developed as a flagship outdoor sports addition for the Yubari district, the park is designed for beginners through advanced skaters and also allows surf-skate, longboards, plastic-pegged BMX, inline skates, and kick bikes under posted rules.',
'Flat banks, bank-to-banks, quarters, manual pads, boxes, rails, mini ramp, flat ground',
'Concrete',
'outdoor',
'Daylight hours until 8:00 PM (6:00 PM youth-only rule; confirm town notice)',
'Roughly late November – mid-April',
'Free (registration required)',
'https://www.town.kuriyama.hokkaido.jp/soshiki/53/18283.html',
43.05600000, 141.78400000,
NULL,
0),

('memushi-park-skatepark',
'Memushi Park Skate Park',
'メムシ公園　スケートパーク',
1, 'Chitose', '2120-7 Negoshi, Chitose, Hokkaido',
'Fenced concrete skate plaza of about 300 m² inside Memushi Park in Chitose, shared with BBQ sites and playgrounds. Sections include banks, curves, ramps, rails, and arcs on a tiled concrete surface suited to street and light transition practice. Free admission 9:00–17:00; register name and contact at the park management office on entry. Helmets and protectors are mandatory. Skateboards, inline skates, and roller skates only; closed in winter and in bad weather.',
'Part of Chitose''s family-oriented park network near New Chitose Airport, giving local and visiting riders a supervised outdoor box.',
'Banks, curves, ramps, rails, arcs, flat',
'Tiled concrete',
'outdoor',
'9:00 AM – 5:00 PM',
'Winter; heavy rain / snow',
'Free (registration required)',
'https://web-ckk.com/park/memusi.html',
42.92000000, 141.65200000,
NULL,
0),

('kurisawa-central-park-skate-plaza',
'Kurisawa Central Park Skate Plaza (Kurisawa Skate Park)',
'栗沢中央公園　スケート広場【栗沢スケートパーク】',
1, 'Iwamizawa', 'Higashihoncho, Kurisawa-cho, Iwamizawa, Hokkaido',
'About 600 m² of outdoor concrete on the site of former tennis courts in Kurisawa Central Park, Iwamizawa. Banks, arcs, boxes, flat rails, and manual pads support skateboards, BMX, and inline skating with no advance registration. The spot is popular with riders from Iwamizawa and the Sorachi area and hosts occasional community events.',
'A rare mid-size public plaza for central Hokkaido outside Sapporo, maintained as open-access street terrain.',
'Banks, arcs, boxes, flat rails, manual pads, flat ground',
'Concrete',
'outdoor',
'During park open hours (confirm locally)',
'None routinely posted',
'Free',
NULL,
43.11200000, 141.75000000,
NULL,
0),

('muroran-rainbow-park-skatepark',
'Muroran Rainbow Park Skate Park',
'室蘭レインボー公園　スケートパーク',
1, 'Muroran', '1-2-1 Kaigancho, Muroran, Hokkaido',
'Roughly 1,000 m² of outdoor concrete beside Muroran Rainbow Park, one minute on foot from JR Muroran Station. The layout grew from collaboration between local skaters and the city: ramps, boxes, arcs, banks, manual pads, and flat rails aimed at beginner-to-intermediate street skating. Free to use from daytime until 22:00 (no skating before dawn or after 22:00). Sections are not treated as city-maintained street furniture — respect the space and do not remove obstacles.',
'One of Hokkaido''s early examples of a station-front public plaza shaped by rider advocacy; surface condition varies with age and weather.',
'Ramps, boxes, arcs, banks, manual pads, flat rails',
'Concrete (condition varies)',
'outdoor',
'Daytime – 10:00 PM',
'Early morning and after 22:00',
'Free',
'https://www.city.muroran.lg.jp/life/?content=750',
42.31500000, 140.97300000,
NULL,
0),

('moai-skatepark',
'MOAI SKATEPARK',
'MOAI SKATEPARK',
1, 'Sapporo', 'Takino area, Minami-ku, Sapporo, Hokkaido',
'Outdoor concrete park of about 1,500 m² opened in April 2023 behind the famous moai statues at Makomanai Takino Cemetery, Minami-ku, Sapporo. Three zones — flat, street, and mini-ramp — mix quarters, banks, pyramids, rails, boxes, and sculptural rocks. Skateboards, BMX, and inline are welcome. Paid entry: annual membership or daily ticket; rentals and lessons available. Summer hours roughly weekdays 10:00–16:30 and weekends 9:00–16:30 (confirm site). Live camera and occasional food trucks on weekends.',
'Named for its surreal moai backdrop, the park quickly became a destination for visitors combining sightseeing and riding.',
'Flat area, street obstacles, mini ramp zone, quarters, banks, pyramids, rails, boxes',
'Concrete',
'outdoor',
'Approx. 10:00 AM – 4:30 PM weekdays; 9:00 AM – 4:30 PM weekends/holidays (seasonal)',
'Confirm on official site',
'Annual membership or daily fee (see official site); rentals available',
'https://moai-skate.com/',
42.90000000, 141.31900000,
NULL,
0),

('hot-bowl-skatepark',
'HOT BOWL',
'HOT BOWL',
1, 'Sapporo', 'Shinkotoni, Kita-ku, Sapporo, Hokkaido',
'Long-running indoor skatepark in Kita-ku, Sapporo, opened in April 2008. The main bowl runs about 12 × 10 m with 150–230 cm depth, pool coping, and extension, plus a 110 cm mini ramp for learning transition. Skateboards, BMX, and inline skates are allowed. Second-floor lounge and skate shop; skate school programmes. Typical weekday evening and weekend opening; closed Mondays (or Tuesday if Monday is a holiday).',
'A staple indoor winter training spot for Hokkaido riders, including athletes who train for national and international competition.',
'Full-size wooden bowl with extension and pool coping, mini ramp, flat, shop, lounge',
'Wood / composite transitions',
'indoor',
'Weekdays approx. 4:00–9:30 PM; weekends/holidays approx. 1:00–9:30 PM',
'Monday (or following day if Monday is a public holiday)',
'Hourly and day passes (see hotbowl.life)',
'http://www.hotbowl.life/',
43.10800000, 141.32200000,
NULL,
0),

('crass-action-sports-house',
'CRASS ACTION SPORTS HOUSE',
'CRASS ACTION SPORTS HOUSE',
1, 'Sapporo', '1-6 Kita 10-jo Higashi 17-chome, Higashi-ku, Sapporo, Hokkaido 065-0010',
'Indoor wooden skatepark in Higashi-ku with four ramps plus a flat section, trampolines, and a retail floor for skate and snowboard hardware. Visitor and member pricing by the hour; night sessions until midnight most of the year. Also offers lessons in skateboarding, snowboarding, and trampoline. About eleven minutes on foot from Kanjo-dori-higashi Subway Station.',
'CRASS positions itself as a multi-discipline action-sports hub for eastern Sapporo, pairing ramp skating with trampoline training.',
'Four wooden ramps, flat area, trampolines, shop',
'Wood',
'indoor',
'Noon – midnight (except year-end holidays; confirm site)',
'See official calendar',
'Visitor and member hourly rates (see crass-1.com)',
'https://crass-1.com/',
43.08400000, 141.37000000,
NULL,
0),

('lowstar-skatepark',
'LOWSTAR',
'LOWSTAR',
1, 'Kutchan', '23-1 Kita 2-jo Nishi 2-chome, Kutchan Town, Abuta District, Hokkaido 044-0052',
'Skate and snowboard shop in Kutchan with an attached indoor wooden mini ramp and extension visible from the retail floor — popular with families who want to watch kids ride from the shop. Hourly and day tickets; evening hours (roughly 16:00–22:00). Lessons for children available. Year-round riding regardless of Niseko snow season.',
'Combines retail and a compact transition-focused indoor park for the Kutchan / Hirafu corridor.',
'Indoor wooden mini ramp with extensions, shop',
'Wood',
'indoor',
'Approx. 4:00–10:00 PM (confirm shop)',
'Irregular closures — check social media / lowstar.jp',
'Hourly and day passes',
'http://lowstar.jp/',
42.90120000, 140.75550000,
NULL,
0),

('diamond-ramp-hokuto',
'Diamond Ramp',
'ダイヤモンドランプ',
1, 'Hokuto', 'Near Tomikawa IC, Hokuto, Hokkaido',
'Indoor–outdoor facility operated alongside a surf shop near the Tomikawa interchange on the Hakodate Shindō. Outdoors: a mini ramp. Indoors: arcs, pyramid, half-bowl, spine, and other transition sections usable year-round, 13:00–22:00 with night lighting. Skateboards, inline skates, and BMX are welcome; rental decks and safety gear available. Visitor pricing by hour or day with reduced rates for younger riders.',
'Serves riders in the Hakodate–Hokuto corridor who need weatherproof transition terrain outside major cities.',
'Outdoor mini ramp; indoor arcs, pyramid, half-bowl, spine, flat',
'Concrete / wood (mixed)',
'both',
'1:00–10:00 PM',
'Confirm with shop',
'Hourly and day passes; rentals available',
NULL,
41.82400000, 140.65300000,
NULL,
0),

('spray-skatepark',
'SPRAY',
'SPRAY',
1, 'Asahikawa', '1-1-8 Toyooka 12-jo 1-chome, Asahikawa, Hokkaido',
'Large indoor concrete park in Asahikawa (~580 m²) with quarters, bowl, ramps, banks, manual pads, and boxes. Smooth, grippy concrete aimed at all levels; night lighting. Skateboards and inline skates only (no BMX or scooters on standard days — confirm house rules). Closed Wednesdays. Shop on site; occasional ladies'' days and events.',
'One of Hokkaido''s benchmark indoor training facilities outside Sapporo, drawing riders from central and northern prefectures.',
'Quarter pipes, bowl, ramps, banks, manual pads, boxes, shop',
'Concrete',
'indoor',
'Noon – 8:00 PM',
'Wednesday',
'Hourly, multi-hour, and day passes (see spray166.com)',
'http://www.spray166.com/contact/',
43.77000000, 142.44700000,
NULL,
0),

('brayz-sk8-dome',
'BRAYZ SK8 DOME',
'BRAYZ SK8 DOME',
1, 'Tomakomai', 'Ariake-cho, Tomakomai, Hokkaido',
'Indoor–outdoor complex run by BRAYZ, a Tomakomai shop covering surf, skate, and snow. Indoors: full-sized bowls, mini ramps, and park-style transitions. Outdoors: street course with banks, curves, boxes, down ledges, and rails. About eight minutes on foot from JR Itoi. Skateboards, inline skates, and BMX permitted; rentals and kids'' programmes available. Typically 12:00–20:00, closed Wednesdays.',
'Tomakomai''s flagship weatherproof setup for transition and street, popular with riders travelling between Sapporo and southern Hokkaido.',
'Indoor bowls, mini ramps, park sections; outdoor banks, boxes, ledges, rails',
'Concrete / wood',
'both',
'Noon – 8:00 PM',
'Wednesday',
'Paid session (see brayz.org)',
'http://www.brayz.org/',
42.63700000, 141.60500000,
NULL,
0),

('nuggets-skatepark',
'Nuggets',
'Nuggets',
1, 'Sapporo', '104-8 Tokiwa 5-jo 2-chome, Minami-ku, Sapporo, Hokkaido',
'Indoor skatepark on the ground floor with a skate shop and curry bar upstairs in Minami-ku, Sapporo — a social hub open late (roughly 3:00 PM – 11:45 PM) with private-hire options. Wooden indoor terrain suited to evening sessions after work or school; day-pass style pricing. Small shop dog is part of the local lore.',
'Known among Sapporo skaters as a late-night indoor alternative in a residential valley south of the city centre.',
'Indoor park, shop, food counter',
'Wood / indoor',
'indoor',
'Approx. 3:00 PM – 11:45 PM',
'Confirm with venue',
'Day pass style (see d-nuggets.com)',
'https://d-nuggets.com/hokkaido/',
42.97200000, 141.34800000,
NULL,
0);

-- Tags (by slug so IDs stay correct on any database)
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'sapporo-dome-skateboard-area';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'sapporo-dome-skateboard-area';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'sapporo-dome-skateboard-area';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 7 FROM skateparks WHERE slug = 'sapporo-dome-skateboard-area';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'sapporo-dome-skateboard-area';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'kutchan-skateboard-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'kutchan-skateboard-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'kutchan-skateboard-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'kutchan-skateboard-park';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'kushiro-street-sports-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'kushiro-street-sports-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'kushiro-street-sports-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'kushiro-street-sports-park';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'kushiro-street-sports-park';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'kuriyama-station-south-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'memushi-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'memushi-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'memushi-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'memushi-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'memushi-park-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'kurisawa-central-park-skate-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'kurisawa-central-park-skate-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'kurisawa-central-park-skate-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'kurisawa-central-park-skate-plaza';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'kurisawa-central-park-skate-plaza';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'muroran-rainbow-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 4 FROM skateparks WHERE slug = 'muroran-rainbow-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'muroran-rainbow-park-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 10 FROM skateparks WHERE slug = 'muroran-rainbow-park-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'moai-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'moai-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'moai-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 7 FROM skateparks WHERE slug = 'moai-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'moai-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'hot-bowl-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'hot-bowl-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'hot-bowl-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'hot-bowl-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'crass-action-sports-house';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'crass-action-sports-house';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'crass-action-sports-house';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'crass-action-sports-house';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'lowstar-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'lowstar-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'lowstar-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'diamond-ramp-hokuto';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'diamond-ramp-hokuto';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'diamond-ramp-hokuto';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'diamond-ramp-hokuto';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'diamond-ramp-hokuto';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'spray-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'spray-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'spray-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 7 FROM skateparks WHERE slug = 'spray-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'spray-skatepark';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'brayz-sk8-dome';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 3 FROM skateparks WHERE slug = 'brayz-sk8-dome';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'brayz-sk8-dome';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'brayz-sk8-dome';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 7 FROM skateparks WHERE slug = 'brayz-sk8-dome';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'brayz-sk8-dome';

INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 2 FROM skateparks WHERE slug = 'nuggets-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 5 FROM skateparks WHERE slug = 'nuggets-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 6 FROM skateparks WHERE slug = 'nuggets-skatepark';
INSERT INTO skatepark_tags (skatepark_id, tag_id) SELECT id, 8 FROM skateparks WHERE slug = 'nuggets-skatepark';

-- Japanese article fields (generated; verify fees/hours against official sites)
UPDATE skateparks SET
  city_ja = '札幌市豊平区',
  address_ja = '〒062-0045 北海道札幌市豊平区羊ケ丘1',
  description_ja = '札幌ドーム（プレミストドーム）2階南テラスにある屋外スケートボードエリア。2023年5月オープン、約1,600㎡に全長約60mの波状パンプコース、マニュアル台、パイプレール、ボックス、キッカーなど。5月頃〜10月頃の季節営業・無料。雨天時は利用停止。スケートボード・BMX・MTBなど可（エリアにより制限あり）。貸出なし。',
  history_ja = '札幌市内のスケート練習場の要望を受けて整備。ドームの利用ルール（小学生以下のヘルメット必須など）に従って利用する。',
  facilities_ja = 'パンプコース（約60m）、マニュアル台、パイプレール、ボックス、キッカー、フラット',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '冬期・雨天時',
  admission_fee_ja = '無料'
WHERE slug = 'sapporo-dome-skateboard-area';

UPDATE skateparks SET
  city_ja = '倶知安町',
  address_ja = '北海道虻田郡倶知安町',
  description_ja = '虻田郡倶知安町の公設屋外スケートボードパーク。ニセコエリアのボード文化を支える施設として利用される。開放時間・期間・利用方法は倶知安町（総合体育館等）の最新案内で要確認。',
  history_ja = '国際的なリゾート地として知られる倶知安において、夏季のストリート系スポーツ拠点として位置づけられている。',
  facilities_ja = 'ストリート・トランジション系セクション（現地で要確認）',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '季節・天候により変動（要確認）',
  admission_fee_ja = '無料（公園・要確認）'
WHERE slug = 'kutchan-skateboard-park';

UPDATE skateparks SET
  city_ja = '釧路市',
  address_ja = '〒085-0014 北海道釧路市南浜町1',
  description_ja = '釧路市南浜町のストリートスポーツプラザ。ストリートバスケット2面に加え、スケートボード・インライン・BMX用のコンクリートゾーン（クォーター、スパイン、ヒップ、バンクtoバンク、ピラミッド、グラインドボックス、レール等）。入口QRで利用登録。バスケ以外はヘルメット・プロテクター着用必須。4月1日〜11月30日頃、9時〜21時頃（天候で変動）。',
  history_ja = '釧路市の海辺エリア整備・青少年スポーツの一環として整備された。',
  facilities_ja = 'ストリートバスケットコート2面、クォーター、スパイン、ヒップ、バンクtoバンク、ピラミッド、ボックス、レール',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '12月〜3月頃、悪天候時',
  admission_fee_ja = '無料（登録要）'
WHERE slug = 'kushiro-street-sports-park';

UPDATE skateparks SET
  city_ja = '名寄市',
  address_ja = '北海道名寄市字日進（北海道立サンピラーパーク内）',
  description_ja = '北海道立サンピラーパーク内のストリートスポーツ広場。約800㎡にピラミッド、モヒカン、レール、ボックス、マニュアル台など金属製セクションが並ぶ。スケートボード・BMX・インライン可。5月1日〜10月31日、9:00〜18:00、無料。駐車場あり。ヘルメットは推奨。',
  history_ja = '道北・最北圏のライダー向けに、本格的な屋外ストリート環境を提供する。',
  facilities_ja = 'ピラミッド、レール、ボックス、マニュアル台、各種ストリートセクション',
  surface_type_ja = 'コンクリート・金属セクション',
  closed_days_ja = '11月〜4月',
  admission_fee_ja = '無料'
WHERE slug = 'nayoro-sun-pillar-street-sports-plaza';

UPDATE skateparks SET
  city_ja = '栗山町',
  address_ja = '北海道夕張郡栗山町中央3丁目（栗山駅南公園）',
  description_ja = '2022年完成の夕張郡初の公設スケートパーク。JR栗山駅から徒歩約5分。約600㎡の青系コンクリートにフラットバンク、バンクtoバンク、クォーター、マニュアル台、ボックス、レール、ミニランプなど計11種前後。4月下旬〜11月上旬、午後8時まで（小中学生のみは午後6時まで）。利用者名簿記入。ヘルメット等推奨。無料。',
  history_ja = '地方都市における若者・スポーツ振興のモデルケースとして整備。',
  facilities_ja = 'フラットバンク、バンクtoバンク、クォーター、マニュアル台、ボックス、レール、ミニランプ、フラット',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '11月上旬〜4月下旬頃',
  admission_fee_ja = '無料（名簿記入）'
WHERE slug = 'kuriyama-station-south-skatepark';

UPDATE skateparks SET
  city_ja = '千歳市',
  address_ja = '〒066-0066 北海道千歳市根志越2120-7',
  description_ja = 'メムシ公園内の約300㎡の囲い付きスケート広場。タイル状コンクリートにボール、カーブ、ランプ、バンク、レール、アール等。9時〜17時、無料。管理事務所で氏名等登録。ヘルメット・プロテクター必須。スケボー・インライン・ローラーのみ。冬期・雨天は閉鎖の場合あり。',
  history_ja = '家族向け公園（バーベキュー・遊具）と一体となったスケート環境。',
  facilities_ja = 'ボール、カーブ、ランプ、バンク、レール、アール',
  surface_type_ja = 'タイル状コンクリート',
  closed_days_ja = '冬期・雨天時',
  admission_fee_ja = '無料（登録要）'
WHERE slug = 'memushi-park-skatepark';

UPDATE skateparks SET
  city_ja = '岩見沢市',
  address_ja = '北海道岩見沢市栗沢町東本町（栗沢中央公園）',
  description_ja = '旧テニスコート跡を転用した約600㎡の屋外コンクリート広場。バンク、アール、ボックス、フラットレール、マニュアル台など。スケートボード・BMX・インライン可、登録不要で無料。空知・岩見沢圏の定番スポット。',
  history_ja = '道央部における公的ストリートスペースとして定着。',
  facilities_ja = 'バンク、アール、ボックス、フラットレール、マニュアル台、フラット',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '公園案内に準ずる',
  admission_fee_ja = '無料'
WHERE slug = 'kurisawa-central-park-skate-plaza';

UPDATE skateparks SET
  city_ja = '室蘭市',
  address_ja = '〒050-0084 北海道室蘭市海岸町1丁目2番1号',
  description_ja = 'レインボー公園脇、JR室蘭駅から徒歩約1分。約1,000㎡の屋外コンコース。地元スケーターと市の協働でセクションが整備された経緯がある。ランプ、ボックス、アール、バンク、マニュアル台、フラットレール等。日中〜22時まで無料。早朝・22時以降は禁止。セクションの持ち去り禁止。路面状態は経年で変化しうる。',
  history_ja = '駅前立地のパブリックスケート空間として道南で知られる。',
  facilities_ja = 'ランプ、ボックス、アール、バンク、マニュアル台、フラットレール',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '22時〜翌朝',
  admission_fee_ja = '無料'
WHERE slug = 'muroran-rainbow-park-skatepark';

UPDATE skateparks SET
  city_ja = '札幌市南区',
  address_ja = '北海道札幌市南区滝野（真駒内滝野霊園モアイ像周辺）',
  description_ja = '2023年4月オープン、約1,500㎡の屋外コンクリートパーク。フラット・ストリート・ミニランプの3ゾーン。クォーター、バンク、ピラミッド、レール、ボックス、岩オブジェ等。スケボー・BMX・インライン可。年会費またはデイパス、レンタル・レッスンあり。公式サイトで時間・料金要確認。',
  history_ja = 'モアイ像の観光地とスケートを組み合わせた札幌南部の新拠点。',
  facilities_ja = 'フラット、ストリート障害物、ミニランプ、クォーター、バンク、ピラミッド、レール、ボックス',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '公式サイト要確認',
  admission_fee_ja = '年会費またはデイ利用（サイト参照）'
WHERE slug = 'moai-skatepark';

UPDATE skateparks SET
  city_ja = '札幌市北区',
  address_ja = '北海道札幌市北区新琴似',
  description_ja = '2008年4月オープンの札幌市北区の屋内スケートパーク。本格ボウル（高さ約150〜230cm、縦約12m×横約10m）にエクステンション・プールコーピング、高さ約110cmのミニランプ。スケボー・BMX・インライン可。2階にラウンジとショップ、スクールあり。天候に左右されない。',
  history_ja = '北海道の屋内トランジション練習の拠点として定着。',
  facilities_ja = 'ボウル、ミニランプ、フラット、ショップ、ラウンジ',
  surface_type_ja = '木材等（屋内ランプ）',
  closed_days_ja = '月曜（祝日の場合は翌平日等、サイト要確認）',
  admission_fee_ja = '時間制・デイパス（公式サイト参照）'
WHERE slug = 'hot-bowl-skatepark';

UPDATE skateparks SET
  city_ja = '札幌市東区',
  address_ja = '〒065-0010 北海道札幌市東区北10条東17丁目1-6',
  description_ja = '札幌市東区の屋内ウッドパーク。ランプ4基とフラット、ナイター可。トランポリン5台併設、ショップ・レッスン（スケート・スノボ・トランポリン）あり。12時〜24時年中無休（年末年始除く要確認）。ビジター・会員の時間料金制。',
  history_ja = '環状通東エリアのアクションスポーツ複合施設として運営。',
  facilities_ja = '木製ランプ4、フラット、トランポリン、ショップ',
  surface_type_ja = '木材',
  closed_days_ja = '年末年始等（要確認）',
  admission_fee_ja = '時間制（公式サイト参照）'
WHERE slug = 'crass-action-sports-house';

UPDATE skateparks SET
  city_ja = '倶知安町',
  address_ja = '〒044-0052 北海道虻田郡倶知安町北2条西2丁目23-1',
  description_ja = '倶知安のショップ併設屋内ミニランプ施設。ウッドのランプとエクステンションでトランジション練習向き。ショップから子どもの様子が見えるレイアウト。夕方から夜中心の営業。キッズレッスンあり。通年利用可。',
  history_ja = 'ニセコ・倶知安エリアの小規模屋内拠点。',
  facilities_ja = '屋内ミニランプ、ショップ',
  surface_type_ja = '木材',
  closed_days_ja = '不定（SNS・公式要確認）',
  admission_fee_ja = '時間・デイ（店舗要確認）'
WHERE slug = 'lowstar-skatepark';

UPDATE skateparks SET
  city_ja = '北斗市',
  address_ja = '北海道北斗市（函館新道富川IC周辺・店舗併設）',
  description_ja = 'サーフショップ併設の屋内外施設。屋外にミニランプ、屋内にアール、ピラミッド、ハーフボウル、スパイン等。13時〜22時、ナイター可。スケボー・インライン・BMX可。レンタルあり。時間・デイ料金、年少割引。',
  history_ja = '函館・北斗エリアのオールシーズン対応トランジション施設。',
  facilities_ja = '屋外ミニランプ、屋内アール・ピラミッド・ハーフボウル・スパイン',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '店舗に要確認',
  admission_fee_ja = '時間・デイ（店舗要確認）'
WHERE slug = 'diamond-ramp-hokuto';

UPDATE skateparks SET
  city_ja = '旭川市',
  address_ja = '〒070-0823 北海道旭川市豊岡12条1丁目1-8',
  description_ja = '旭川市の屋内コンクリートパーク、延床約580㎡。クォーター、ボウル、ランプ、バンク、マニュアル台、ボックス等。滑走性の良いコンクリート。スケボー・インライン可（BMX・キックボード等は施設ルール要確認）。水曜定休。ショップ併設、レディースデイ等あり。',
  history_ja = '道北最大級クラスの屋内パークとして道内外から利用者あり。',
  facilities_ja = 'クォーター、ボウル、ランプ、バンク、マニュアル台、ボックス、ショップ',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '水曜',
  admission_fee_ja = '時間制・デイ（公式サイト参照）'
WHERE slug = 'spray-skatepark';

UPDATE skateparks SET
  city_ja = '苫小牧市',
  address_ja = '北海道苫小牧市有明町（JR糸井駅徒歩約8分）',
  description_ja = 'サーフ・スケート・スノーのショップBRAYZ運営。屋内に本格ボウル2、ミニランプ、パーク系セクション。屋外にバンク、カーブ、ボックス、ダウンレッジ、レールのストリート。スケボー・インライン・BMX可。レンタル・キッズスクールあり。12時〜20時、水曜休（要確認）。',
  history_ja = '苫小牧市代表の屋内外複合スケート施設。',
  facilities_ja = '屋内ボウル、ミニランプ、パーク障害物、屋外ストリートセクション',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '水曜（要確認）',
  admission_fee_ja = '有料（公式サイト参照）'
WHERE slug = 'brayz-sk8-dome';

UPDATE skateparks SET
  city_ja = '札幌市南区',
  address_ja = '〒062-0921 北海道札幌市南区常盤5条2丁目104-8',
  description_ja = '札幌市南区の1階屋内パーク＋2階ショップ兼カレーBAR。遅い時間まで営業（公式要確認）、貸切可。住宅街に近いローカル向け屋内練習スポット。',
  history_ja = '南区のナイトセッション需要に応える施設。',
  facilities_ja = '屋内パーク、ショップ、飲食カウンター',
  surface_type_ja = '木材（屋内）',
  closed_days_ja = '公式要確認',
  admission_fee_ja = 'デイパス等（公式サイト参照）'
WHERE slug = 'nuggets-skatepark';
