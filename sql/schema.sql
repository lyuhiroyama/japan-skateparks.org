-- Japan Skateparks Database Schema
-- Run: mysql -u root -p < sql/schema.sql

CREATE DATABASE IF NOT EXISTS japan_skateparks CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE japan_skateparks;

-- Prefectures
CREATE TABLE IF NOT EXISTS prefectures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_ja VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL
);

-- Main skateparks table
CREATE TABLE IF NOT EXISTS skateparks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    name_ja VARCHAR(255),
    prefecture_id INT,
    city VARCHAR(100),
    address TEXT,
    description TEXT,
    history TEXT,
    facilities TEXT,
    surface_type VARCHAR(100),
    park_type ENUM('indoor', 'outdoor', 'both') DEFAULT 'outdoor',
    opening_hours TEXT,
    closed_days TEXT,
    admission_fee TEXT,
    website VARCHAR(255),
    phone VARCHAR(50),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    image_url VARCHAR(255),
    featured TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (prefecture_id) REFERENCES prefectures(id)
);

-- Tags / Categories
CREATE TABLE IF NOT EXISTS tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL
);

-- Many-to-many: skateparks <-> tags
CREATE TABLE IF NOT EXISTS skatepark_tags (
    skatepark_id INT,
    tag_id INT,
    PRIMARY KEY (skatepark_id, tag_id),
    FOREIGN KEY (skatepark_id) REFERENCES skateparks(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO prefectures (name, name_ja, region) VALUES
('Tokyo', '東京都', 'Kanto'),
('Osaka', '大阪府', 'Kansai'),
('Kanagawa', '神奈川県', 'Kanto'),
('Chiba', '千葉県', 'Kanto'),
('Aichi', '愛知県', 'Chubu'),
('Fukuoka', '福岡県', 'Kyushu'),
('Hyogo', '兵庫県', 'Kansai'),
('Kyoto', '京都府', 'Kansai'),
('Saitama', '埼玉県', 'Kanto'),
('Hokkaido', '北海道', 'Hokkaido'),
('Miyagi', '宮城県', 'Tohoku'),
('Hiroshima', '広島県', 'Chugoku'),
('Okinawa', '沖縄県', 'Kyushu');

INSERT INTO tags (name, slug) VALUES
('Olympic Venue', 'olympic-venue'),
('Indoor', 'indoor'),
('Outdoor', 'outdoor'),
('Free', 'free'),
('Street', 'street'),
('Vert', 'vert'),
('Park', 'park'),
('Beginner Friendly', 'beginner-friendly'),
('Professional', 'professional'),
('Public', 'public');

INSERT INTO skateparks (slug, name, name_ja, prefecture_id, city, address, description, history, facilities, surface_type, park_type, opening_hours, closed_days, admission_fee, website, latitude, longitude, featured) VALUES

('ariake-urban-sports-park',
'Ariake Urban Sports Park',
'有明アーバンスポーツパーク',
1, 'Koto', '2-2 Ariake, Koto-ku, Tokyo 135-0063',
'Ariake Urban Sports Park is a world-class skateboarding and urban sports facility located in Ariake, Koto, Tokyo. Built as one of the main venues for the Tokyo 2020 Olympic and Paralympic Games, the park hosted the skateboarding competitions for both Street and Park disciplines. It remains one of the most technically advanced skateparks in Japan, featuring competition-grade courses used by top professionals worldwide.',
'The park was constructed in 2020 as part of the Tokyo 2020 Olympic Games infrastructure. The Street course hosted the Men''s and Women''s Street events on July 25–26, 2021, while the Park course hosted the Park events on August 4–5, 2021. Following the Games, the facility was repurposed as a permanent public urban sports park, opening to the general public in 2022. It has since hosted numerous national and international competitions.',
'Olympic-grade Street course, Olympic-grade Park course, Spectator seating, Changing rooms, Rental equipment, Café and refreshment stands, First aid station, Lockers',
'Smooth concrete',
'both',
'9:00 AM – 9:00 PM',
'Tuesdays (and day following public holidays)',
'Adults ¥1,000 / Students ¥500 / Children (elementary and under) ¥300',
'https://www.ariake-urban-sports-park.jp',
35.63069800, 139.78980900,
1),

('shibuya-skate-spot',
'Shibuya Skate Spot',
'渋谷スケートスポット',
1, 'Shibuya', 'Shibuya, Tokyo',
'Scattered throughout Shibuya ward, Tokyo''s Shibuya Skate Spots are a collection of informal and semi-official skating areas beloved by the local street skating community. The area around Shibuya Station, Miyashita Park, and the back streets of Daikanyama and Nakameguro have long been gathering points for skaters. Miyashita Park, reopened in 2020 after redevelopment, now features a rooftop skate spot.',
'Shibuya has been central to Tokyo skate culture since the 1990s, when the area around Shibuya Station became a hub for young skaters. The redevelopment of Miyashita Park in 2020 into a vertical park with retail, hotel, and sports facilities included a dedicated rooftop skate spot, giving the community a sanctioned space in the heart of the city.',
'Rooftop skate area at Miyashita Park, Stairs and ledges, Manual pads',
'Concrete and tile',
'outdoor',
'11:00 AM – 11:00 PM (Miyashita Park)',
'None',
'Free (Miyashita Park rooftop)',
NULL,
35.66170000, 139.70280000,
0),

('komazawa-olympic-park-skatepark',
'Komazawa Olympic Park Skatepark',
'駒沢オリンピック公園スケートパーク',
1, 'Setagaya', '1-1 Komazawa Koen, Setagaya-ku, Tokyo',
'Komazawa Olympic Park Skatepark is one of Tokyo''s most iconic outdoor skateparks, located within the historic Komazawa Olympic Park in Setagaya-ku. The park offers a relaxed, community-oriented atmosphere and caters to skaters of all levels. Easy-going banks provide a welcoming entry point for beginners, while launch boxes, quarter-pipe hips, a row of mini half-pipes, manny pads, and benches serve the more experienced street and transition skaters. Entrance is free, making it one of the most accessible public skateparks in the city.',
'Komazawa Olympic Park was constructed as a competition venue for the 1964 Tokyo Summer Olympics, hosting volleyball events. Following the Games, the park''s extensive grounds were converted into a permanent public sports facility. The skatepark grew organically from the park''s athletic legacy over subsequent decades, eventually becoming a central gathering point for Tokyo''s skateboarding community. Today it remains one of the most well-known free outdoor skateparks in the greater Tokyo area.',
'Banks, launch boxes, quarter-pipe hips, mini half-pipes, manny pads, benches, nearby refreshment stand',
'Concrete',
'outdoor',
'10:00 AM – 4:30–7:00 PM (closing time varies by month)',
'None',
'Free',
NULL,
35.64080000, 139.65310000,
0),

('jonanjima-seaside-park-skatepark',
'Jonanjima Seaside Park Skatepark',
'城南島海浜公園スケートパーク',
1, 'Ota', '4-2-2 Jonanjima, Ota-ku, Tokyo 140-0003',
'Jonanjima Seaside Park Skatepark is one of Tokyo''s most distinctive outdoor skateparks, set on the man-made Jonanjima peninsula in Ota-ku with sweeping views of Tokyo Bay. Skaters can watch large cargo ships docking at the Port of Tokyo and aircraft descending into nearby Haneda Airport while they skate. The spacious layout accommodates a broad range of styles, from technical street skating on the grind boxes and rails to transition riding on the half-pipes and quarter pipes.',
'The broader Jonanjima Seaside Park opened on July 6, 1991, as part of Tokyo Metropolitan Government''s waterfront development programme for the reclaimed islands of southern Tokyo Bay. The skatepark has been a fixture of the local community for over three decades, drawing skaters from across Ota-ku and beyond. Its unique coastal setting — rare for an urban Tokyo park — has made it a beloved destination for those who prefer skating with a sea breeze.',
'Half-pipes, bank-to-banks, spines, quarter pipes, grind boxes, flat rails, open flat ground',
'Concrete',
'outdoor',
'Mar–Apr & Sep–Oct: 7:00 AM – 6:00 PM / May–Aug: 7:00 AM – 7:00 PM / Nov–Feb: 7:00 AM – 5:00 PM',
'Wednesdays (or Thursday if Wednesday is a public holiday); December 29 – January 3',
'Free',
'https://seaside-park.jp/park_jonan-en/',
35.57340000, 139.74710000,
0),

('setagaya-park-skatepark',
'Setagaya Park Skatepark',
'世田谷公園スケートパーク',
1, 'Setagaya', '1-5-27 Ikejiri, Setagaya-ku, Tokyo',
'Setagaya Park Skatepark, known locally as SL Park, is a dedicated multi-discipline outdoor skate facility within one of Setagaya-ku''s most popular public parks. The facility is divided into three zones: Section Area 1 and Section Area 2 serve skateboarding and inline skating, while the Flat Area provides open space for BMX and flat-ground skating. The park is family-friendly, welcoming skaters of all ages and experience levels in a well-maintained public setting.',
'Setagaya Park is a long-established public recreational space in Ikejiri, known for its iconic miniature steam locomotive display. The dedicated skate facility — branded SL Park in reference to the locomotive — was developed as part of the park''s broader expansion to accommodate active sports. Over the years it has become a neighbourhood hub for local youth and the skateboarding community of central Setagaya ward.',
'Skateboarding section (Area 1), skateboarding section (Area 2), flat area for BMX',
'Concrete',
'outdoor',
'Daytime hours (seasonal)',
'None',
'Free',
NULL,
35.65060000, 139.67520000,
0),

('kinuta-park-skatepark',
'Kinuta Park Skatepark',
'砧公園スケートパーク',
1, 'Setagaya', '1-1 Kinutakoen, Setagaya-ku, Tokyo 157-0075',
'Kinuta Park Skatepark is a compact outdoor skatepark located within the sprawling 39-hectare Kinuta Park in Setagaya-ku, positioned near the pay parking lot at the scenery gate entrance. Despite its modest footprint, the facility features multiple dedicated skating sections used exclusively for skateboarding and inline skating. Free admission and its location within one of western Setagaya''s largest green spaces make it a well-used spot for the local skating community.',
'Kinuta Park is a major metropolitan park managed by the Tokyo Metropolitan Government, known for its wide open lawns, cherry blossom groves, and the adjacent Setagaya Art Museum. The skateboarding area was established to provide the residential communities of western Setagaya — including Yoga and Futako-tamagawa — with a dedicated free-to-use skating facility. It has served the local skateboarding community as a low-key, neighbourhood-level skatepark.',
'Multiple skating sections, dedicated skateboarding and inline skating area',
'Concrete',
'outdoor',
'Dawn to dusk',
'None',
'Free',
NULL,
35.62740000, 139.62000000,
0),

('tamachi-skate-board-space',
'Tamachi Skate Board Space',
'田町スケートボードスペース',
1, 'Minato', '4-20 Shibaura, Minato-ku, Tokyo',
'Tamachi Skate Board Space is a compact urban skatepark located beneath the Yunagibashi bridge along the Shibaura Canal in Minato-ku. Also known as the Yunagibashi Bridge Playground, the facility includes a skateboarding rink alongside a basketball court, offering a rare sanctioned skating space in the dense urban fabric of central Minato. The sheltered position under the bridge provides some protection from rain. Its central location near Tamachi Station and free admission make it popular with local youth and office workers.',
'The Yunagibashi area was developed as part of Minato-ku''s ongoing waterfront canal improvement works. The playground and skate space beneath the bridge was established to provide residents of the densely urban Shibaura district — an area undergoing significant redevelopment — with accessible recreational facilities. The unusual under-bridge setting is characteristic of Tokyo''s creative approach to urban recreational planning.',
'Skateboarding rink, basketball court',
'Smooth concrete',
'outdoor',
'May–October: 9:00 AM – 9:00 PM / November–April: 9:00 AM – 7:00 PM',
'None',
'Free',
NULL,
35.64220000, 139.74730000,
0),

('miyashita-park-skatepark',
'Miyashita Park Skatepark',
'宮下パークスケートパーク',
1, 'Shibuya', '6-20-10 Jingumae, Shibuya-ku, Tokyo',
'Miyashita Park Skatepark is a premium rooftop skatepark perched atop the Miyashita Park complex in the heart of Shibuya. Redesigned and opened in 2020 in collaboration with Nike, the park was co-designed by professional skateboarders Paul Rodriguez (P-Rod) and Lance Mountain. The facility features a smooth concrete bowl, multiple stair sets including a 7-step, rails, ledges, and manual pads, catering to both street and transition disciplines. Helmets are mandatory and can be borrowed free of charge from the clubhouse. The park is a short walk from Shibuya Station and sits above a multi-storey complex of shops, restaurants, and a hotel.',
'Miyashita Park has a long history as a public recreational space in Shibuya, first opening in 1953. After decades of use, the original park underwent comprehensive redevelopment by Mitsui Fudosan in partnership with Shibuya-ku, reopening in June 2020 as a vertical multi-use complex. The skateboarding facility was a centrepiece of the redevelopment, created with direct input from professional skateboarders to ensure competition-grade design. The collaboration with Nike and the involvement of P-Rod and Lance Mountain brought international attention to the park upon its opening.',
'Smooth concrete bowl, 7-step stairset, additional stair sets, rails, ledges, manual pads, free helmet loan',
'Smooth concrete',
'outdoor',
'9:00 AM – 10:00 PM',
'Year-end and New Year holidays',
'Adults ¥200 per 2 hours / Students ¥100 per 2 hours',
NULL,
35.66280000, 139.70270000,
0),

('sumida-skateboard-park',
'Sumida Skateboard Park',
'すみだスケートボードパーク',
1, 'Mukojima', '5-9-1 Mukojima, Sumida-ku, Tokyo',
'Sumida Skateboard Park is a modern public skatepark that opened in April 2024, tucked beneath an elevated highway structure in Dozo-bori Park along the Sumida River in Mukojima. The under-highway position shelters skaters from direct sunlight, making it one of the more comfortable parks to use in Tokyo''s hot summers. The facility is divided into a beginner area featuring low curved boxes and an intermediate area stocked with a full range of obstacles. The surface was upgraded shortly after opening with a seal hard coating over the concrete, resulting in a notably smooth riding surface. Registration and a wristband from the nearby Tsutsumi-dori Park Management Office are required before first use, and helmets are mandatory for all riders.',
'Sumida Ward had long lacked a dedicated skateboarding facility despite being home to a passionate local skate community. Following advocacy from local skaters and growing national interest in skateboarding after the Tokyo 2020 Olympics, the ward government developed the park as part of a broader initiative to provide youth sports infrastructure. Sumida Skateboard Park opened in April 2024. An initial issue with concrete dust on the surface was resolved when seal hard coating was applied, significantly improving ride quality. The helmet mandate introduced on June 1, 2024 reflects the ward''s commitment to safety at the facility.',
'Manual pads, flat rail, curve boxes, bank-to-bank section, quarter ramp, long bank, stair-bank with handrails, beginner zone',
'Concrete with seal hard coating',
'outdoor',
'10:00 AM – 7:30 PM',
'December 29 – January 3',
'Free (advance registration and wristband required)',
'https://www.city.sumida.lg.jp/sisetu_info/kouen/kanren/sumidaskateboardpark.html',
35.70850000, 139.81350000,
0),

('ramp-zero',
'Ramp Zero',
'ランプゼロ',
1, 'Minamisenju', '4-2-3 Minamisenju, Arakawa-ku, Tokyo',
'Ramp Zero (ランプゼロ) is a private indoor skatepark and skateboarding school located directly beneath the elevated Tokyo Metro Hibiya Line tracks in Minamisenju, Arakawa-ku. The facility covers approximately 300 square metres and is equipped with three mini ramps of varying heights (H650, H800, H1200) alongside a flat section stocked with boxes, rails, and other street obstacles. Its position under the elevated tracks provides full shelter from rain and sun, allowing year-round use in all weather. Entry is via smart lock after online reservation through the membership system, making it one of Tokyo''s more modern park-access setups. Equipment rental including boards, helmets, and protectors is provided free of charge, and the park runs structured lessons for ages five and up.',
'Ramp Zero was established to serve the skateboarding community of Arakawa ward and the surrounding Minamisenju area, a district historically underserved by skate infrastructure. Located under the Hibiya Line elevated structure, the facility makes creative use of otherwise underutilised urban space — a model increasingly common in Tokyo. The park operates both as a drop-in freestyle facility and as a structured school, offering beginner through advanced classes. Its proximity to Minamisenju Station (30 seconds on foot from the north exit) has made it a convenient stop-off for skaters commuting from across the east side of Tokyo.',
'Three mini ramps (H650, H800, H1200), flat section with boxes and rails, free equipment rental (board, helmet, protectors)',
'Smooth concrete',
'indoor',
'Varies — check website for current session times',
'Varies',
'Paid (lesson ¥3,500 per session; monthly school membership ¥9,900 for 3 sessions; free skate via online reservation)',
'https://www.ramp0.jp',
35.73400000, 139.80400000,
0);

-- Tag relationships
INSERT INTO skatepark_tags (skatepark_id, tag_id) VALUES
(1, 1), (1, 3), (1, 5), (1, 7), (1, 9),  -- Ariake: Olympic, Outdoor, Street, Park, Professional
(2, 3), (2, 4), (2, 5),                   -- Shibuya Skate Spot: Outdoor, Free, Street
(3, 3), (3, 4), (3, 5), (3, 8), (3, 10), -- Komazawa: Outdoor, Free, Street, Beginner Friendly, Public
(4, 3), (4, 4), (4, 6), (4, 10),         -- Jonanjima: Outdoor, Free, Vert, Public
(5, 3), (5, 4), (5, 8), (5, 10),         -- Setagaya Park: Outdoor, Free, Beginner Friendly, Public
(6, 3), (6, 4), (6, 8), (6, 10),         -- Kinuta Park: Outdoor, Free, Beginner Friendly, Public
(7, 3), (7, 4), (7, 10),                 -- Tamachi: Outdoor, Free, Public
(8, 3), (8, 5), (8, 7), (8, 8), (8, 9), -- Miyashita: Outdoor, Street, Park, Beginner Friendly, Professional
(9, 3), (9, 4), (9, 5), (9, 8), (9, 10), -- Sumida: Outdoor, Free, Street, Beginner Friendly, Public
(10, 2), (10, 5), (10, 6), (10, 8);      -- Ramp Zero: Indoor, Street, Vert, Beginner Friendly

