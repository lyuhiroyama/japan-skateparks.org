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
    city_ja VARCHAR(100),
    address TEXT,
    address_ja TEXT,
    description TEXT,
    description_ja TEXT,
    history TEXT,
    history_ja TEXT,
    facilities TEXT,
    facilities_ja TEXT,
    surface_type VARCHAR(100),
    surface_type_ja VARCHAR(100),
    park_type ENUM('indoor', 'outdoor', 'both') DEFAULT 'outdoor',
    opening_hours TEXT,
    closed_days TEXT,
    closed_days_ja TEXT,
    admission_fee TEXT,
    admission_fee_ja TEXT,
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
-- Hokkaido
('Hokkaido', '北海道', 'Hokkaido'),
-- Tohoku
('Aomori', '青森県', 'Tohoku'),
('Iwate', '岩手県', 'Tohoku'),
('Miyagi', '宮城県', 'Tohoku'),
('Akita', '秋田県', 'Tohoku'),
('Yamagata', '山形県', 'Tohoku'),
('Fukushima', '福島県', 'Tohoku'),
-- Kanto
('Ibaraki', '茨城県', 'Kanto'),
('Tochigi', '栃木県', 'Kanto'),
('Gunma', '群馬県', 'Kanto'),
('Saitama', '埼玉県', 'Kanto'),
('Chiba', '千葉県', 'Kanto'),
('Tokyo', '東京都', 'Kanto'),
('Kanagawa', '神奈川県', 'Kanto'),
-- Chubu
('Niigata', '新潟県', 'Chubu'),
('Toyama', '富山県', 'Chubu'),
('Ishikawa', '石川県', 'Chubu'),
('Fukui', '福井県', 'Chubu'),
('Yamanashi', '山梨県', 'Chubu'),
('Nagano', '長野県', 'Chubu'),
('Gifu', '岐阜県', 'Chubu'),
('Shizuoka', '静岡県', 'Chubu'),
('Aichi', '愛知県', 'Chubu'),
-- Kansai
('Mie', '三重県', 'Kansai'),
('Shiga', '滋賀県', 'Kansai'),
('Kyoto', '京都府', 'Kansai'),
('Osaka', '大阪府', 'Kansai'),
('Hyogo', '兵庫県', 'Kansai'),
('Nara', '奈良県', 'Kansai'),
('Wakayama', '和歌山県', 'Kansai'),
-- Chugoku
('Tottori', '鳥取県', 'Chugoku'),
('Shimane', '島根県', 'Chugoku'),
('Okayama', '岡山県', 'Chugoku'),
('Hiroshima', '広島県', 'Chugoku'),
('Yamaguchi', '山口県', 'Chugoku'),
-- Shikoku
('Tokushima', '徳島県', 'Shikoku'),
('Kagawa', '香川県', 'Shikoku'),
('Ehime', '愛媛県', 'Shikoku'),
('Kochi', '高知県', 'Shikoku'),
-- Kyushu
('Fukuoka', '福岡県', 'Kyushu'),
('Saga', '佐賀県', 'Kyushu'),
('Nagasaki', '長崎県', 'Kyushu'),
('Kumamoto', '熊本県', 'Kyushu'),
('Oita', '大分県', 'Kyushu'),
('Miyazaki', '宮崎県', 'Kyushu'),
('Kagoshima', '鹿児島県', 'Kyushu'),
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

INSERT INTO skateparks (slug, name, name_ja, prefecture_id, city, address, description, history, facilities, surface_type, park_type, opening_hours, closed_days, admission_fee, website, latitude, longitude, image_url, featured) VALUES

('ariake-urban-sports-park',
'Ariake Urban Sports Park',
'有明アーバンスポーツパーク',
13, 'Koto', '2-2 Ariake, Koto-ku, Tokyo 135-0063',
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
NULL,
1),

('shibuya-skate-spot',
'Shibuya Skate Spot',
'渋谷スケートスポット',
13, 'Shibuya', 'Shibuya, Tokyo',
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
NULL,
0),

('komazawa-olympic-park-skatepark',
'Komazawa Olympic Park Skatepark',
'駒沢オリンピック公園スケートパーク',
13, 'Setagaya', '1-1 Komazawa Koen, Setagaya-ku, Tokyo',
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
'/images/skateparks/komazawa_olympic_park_skatepark.jpg',
0),

('jonanjima-seaside-park-skatepark',
'Jonanjima Seaside Park Skatepark',
'城南島海浜公園スケートパーク',
13, 'Ota', '4-2-2 Jonanjima, Ota-ku, Tokyo 140-0003',
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
NULL,
0),

('setagaya-park-skatepark',
'Setagaya Park Skatepark',
'世田谷公園スケートパーク',
13, 'Setagaya', '1-5-27 Ikejiri, Setagaya-ku, Tokyo',
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
'/images/skateparks/setagaya_park_skatepark.jpg',
0),

('kinuta-park-skatepark',
'Kinuta Park Skatepark',
'砧公園スケートパーク',
13, 'Setagaya', '1-1 Kinutakoen, Setagaya-ku, Tokyo 157-0075',
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
NULL,
0),

('tamachi-skate-board-space',
'Tamachi Skate Board Space',
'田町スケートボードスペース',
13, 'Minato', '4-20 Shibaura, Minato-ku, Tokyo',
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
NULL,
0),

('miyashita-park-skatepark',
'Miyashita Park Skatepark',
'宮下パークスケートパーク',
13, 'Shibuya', '6-20-10 Jingumae, Shibuya-ku, Tokyo',
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
NULL,
0),

('sumida-skateboard-park',
'Sumida Skateboard Park',
'すみだスケートボードパーク',
13, 'Mukojima', '5-9-1 Mukojima, Sumida-ku, Tokyo',
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
'/images/skateparks/sumida_skatepark.jpg',
0),

('ramp-zero',
'Ramp Zero',
'ランプゼロ',
13, 'Minamisenju', '4-2-3 Minamisenju, Arakawa-ku, Tokyo',
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
'/images/skateparks/ramp_zero_skatepark.jpg',
0),

('yoyogi-park-urban-sports-park',
'Yoyogi Park Urban Sports Park',
'代々木公園屋外アーバンスポーツパーク',
13, 'Shibuya', '1-1-1 Yoyogi Kamizonocho, Shibuya-ku, Tokyo',
'Yoyogi Park Urban Sports Park is a free outdoor skate facility set within the expansive grounds of Yoyogi Park in Shibuya-ku, close to Harajuku Station. The park offers a simple but accessible layout focused on flat-ground skating and box obstacles, making it particularly welcoming for beginners and those looking for open space to practise basics. The surrounding parkland provides a relaxed, green environment that sets it apart from more urban skate spots in central Tokyo.',
'Yoyogi Park was developed on the site of the Washington Heights US military housing complex and the athletes'' village for the 1964 Tokyo Summer Olympics. After the Games the land was returned to Tokyo Metropolitan Government and opened as a public park in 1967. The urban sports area was added in later years as demand for skateboarding facilities in the Harajuku and Shibuya district grew. Section renovations are planned for the facility in coming years.',
'Flat ground area, box sections',
'Concrete',
'outdoor',
'Dawn to dusk',
'None',
'Free',
NULL,
35.66990000, 139.69520000,
NULL,
0),

('yashio-kita-park-skatepark',
'Yashio Kita Park Skatepark',
'八潮北公園スケートボード場',
13, 'Shinagawa', '1-3-1 Yashio, Shinagawa-ku, Tokyo',
'Yashio Kita Park Skatepark is a dedicated outdoor skateboarding facility in the waterfront Yashio district of Shinagawa-ku, accessible from Shinagawa Seaside Station. The park features a well-rounded selection of street obstacles including boxes, curved ledges, arcs, banks, and down rails, catering to a range from beginners to intermediate and advanced skaters. A monthly skateboarding school is held on the fourth Saturday of each month, making it a good destination for those learning the sport.',
'The skatepark was developed by Shinagawa ward as part of the Yashio waterfront area''s public recreational infrastructure. The Yashio district, built on reclaimed land along Tokyo Bay, is home to a number of public sports facilities. The skatepark at Yashio Kita Park has served the local community in this relatively residential corner of Shinagawa-ku, providing a structured, paid facility with management and safety requirements.',
'Boxes, curved ledges, arcs, banks, down rails',
'Concrete',
'outdoor',
'Daytime hours (seasonal)',
'None',
'Adults ¥400 / day; Students ¥200 / day; Shinagawa residents: adults ¥200, students ¥100 / day',
NULL,
35.59410000, 139.75080000,
NULL,
0),

('raizin-sky-garden',
'RAIZIN SKY GARDEN by H.L.N.A',
'レイジンスカイガーデン',
13, 'Koto', '1-1-10 Aomi, Koto-ku, Tokyo',
'RAIZIN SKY GARDEN by H.L.N.A is an open-air skatepark and urban sports facility in the Aomi district of Koto-ku, in the heart of the Odaiba waterfront area. The park offers sweeping views across Odaiba and Tokyo Bay and features a comprehensive range of obstacles — curves, manual pads, arcs, banks, ramps, stairsets, down rails, and down ledges — catering to skaters of all levels. Operated by H.L.N.A, the facility runs a regular schedule of professional-led skate schools including girls'' and adult classes, a Kento class, and an H.L.N.A class. An annual membership card is required.',
'The park was developed in the Aomi district of the Odaiba waterfront, an area that has seen significant urban development since its reclamation in the late twentieth century. Operating under the H.L.N.A brand, the facility became one of the premier commercial outdoor skateparks in the greater Tokyo area, known for the quality of its surface and the breadth of its obstacle selection. The collaboration with energy drink brand RAIZIN in the park''s branding reflects the commercial skate sponsorship culture that has grown alongside skateboarding''s Olympic profile.',
'Curved ledges, manual pads, arcs, banks, ramps, stairsets, down rails, down ledges',
'Smooth concrete',
'outdoor',
'Varies — check website for current session hours',
'Varies',
'Adults (16+) ¥420 / hr; Youth (13–15) ¥210 / hr; Children (under 12) free; Annual membership ¥330',
'https://hlna.jp/skygarden/',
35.62580000, 139.77450000,
NULL,
0),

('the-yago-skateboard-park',
'The Yago Skateboard Park',
'ザヤゴスケートボードパーク',
13, 'Ota', '3-39-5 Omori-kita, Ota-ku, Tokyo (B1)',
'The Yago Skateboard Park is a compact underground indoor skatepark located in the basement of a building in Omori-kita, Ota-ku, accessible from Heiwajima and Omori Kaigan stations. The facility houses three ramps of varying sizes — large, medium, and small — all featuring gentle arcs that invite skaters to attempt a wide range of tricks across skill levels. The venue is known for its welcoming atmosphere and the approachable, hands-on teaching style of the manager, referred to affectionately by regulars as ''Baba-chan''.',
'The Yago was established as a small private indoor ramp park in the Omori area of Ota-ku, a densely residential and industrial ward in southern Tokyo. The park fills a gap in public skateboarding infrastructure in the area and has cultivated a loyal local following since its opening. Equipment rental and periodic skill sessions are available, making it accessible to those new to transition skating.',
'Large ramp, medium ramp, small ramp',
'Smooth wood and concrete',
'indoor',
'Varies — check Instagram for current hours',
'Varies',
'¥1,000 / hr (extension ¥100 per 15 min); Initial registration ¥500',
'https://theyagoskate.com/',
35.58360000, 139.73160000,
NULL,
0),

('ikebukuro-skatepark',
'Ikebukuro Skatepark',
'池袋スケートパーク',
13, 'Toshima', '1-44-15 Higashi-Ikebukuro, Toshima-ku, Tokyo',
'Ikebukuro Skatepark is a free outdoor skatepark situated beneath the elevated Ikebukuro Ohashi bridge in Higashi-Ikebukuro, Toshima-ku. The under-highway position provides shade from the summer sun and limited protection from light rain, making it usable in a wider range of weather conditions than a fully exposed park. The facility features curves, manual pads, arcs, and banks suited to street skaters of beginner to intermediate level. A wristband for access must be collected from the nearby HIGHSOX SKATE SHOP, located approximately one kilometre from the park.',
'A previous skateboarding facility existed at Ikebukuro Eki-mae Park (Ikebukuro Station Front Park) and was relocated and expanded to the current under-bridge location approximately fifty metres further along the elevated structure. The park is one of a small number of free public skateparks along the northern arc of the Yamanote Line, filling an important gap in skateboarding infrastructure for Toshima ward and the wider Ikebukuro area.',
'Curved ledges, manual pads, arcs, banks',
'Concrete',
'outdoor',
'Dawn to dusk',
'None',
'Free (wristband required from HIGHSOX SKATE SHOP)',
NULL,
35.72810000, 139.71870000,
NULL,
0),

('soshigaya-park-skatepark',
'Soshigaya Park Skatepark',
'祖師谷公園スケートパーク',
13, 'Setagaya', '3-22-19 Kami-Soshigaya, Setagaya-ku, Tokyo',
'Soshigaya Park Skatepark is a community-managed outdoor skate spot within Soshigaya Park in the western reaches of Setagaya-ku, near Soshigaya-Okura and Chitose-Karasuyama stations. The facility''s obstacles — boxes, rails, banks, arcs, and ramps — are largely built and maintained by the local skateboarding community on a voluntary basis, giving the park a grassroots character distinct from municipally operated facilities. The local crew is known for being welcoming to visitors, and the wooded park setting creates a pleasant skating environment.',
'The skatepark at Soshigaya Park grew organically from the initiative of local skaters in the Soshigaya and Kitami areas of Setagaya ward, who over time established a DIY presence within the park. Operating informally under local community management, the park''s hours are not fixed and can vary. It represents a model of skate-community-led infrastructure development that is not uncommon in Tokyo''s residential western wards.',
'Boxes, rails, banks, arcs, ramps (DIY community-built and maintained)',
'Concrete',
'outdoor',
'Irregular (community managed — check local social media)',
'Irregular',
'Free',
NULL,
35.65110000, 139.58660000,
NULL,
0),

('diorama-skate-lounge',
'DIORAMA Skate Lounge',
'ジオラマスケートラウンジ',
13, 'Itabashi', '1-48-8 Itabashi, Itabashi-ku, Tokyo (Dia Palace Shin-Itabashi B1)',
'DIORAMA Skate Lounge is a stylish underground indoor skatepark and café in Itabashi, Itabashi-ku, located in the basement of the Dia Palace Shin-Itabashi building. The facility combines a well-appointed skate space — featuring boxes, manual pads, banks, ramps, and a bowl — with a café where skaters can rest and socialise after their session. The ramp sizes are considered well-suited to skill progression, earning the park praise for its thoughtful layout. Helmets are not required for adults, though mandatory for children under thirteen.',
'DIORAMA was established in Itabashi ward to serve the skateboarding community in the northern part of Tokyo''s 23 wards, an area with relatively fewer dedicated skating facilities than the more central or southern wards. The basement location in a residential building is characteristic of Tokyo''s creative approach to finding space for indoor sports in a dense urban environment. The integrated café format has helped DIORAMA cultivate a social, lifestyle-oriented identity within Tokyo''s skateboarding scene.',
'Boxes, manual pads, banks, ramps, bowl, café',
'Smooth concrete and wood',
'indoor',
'Varies — check website for current session times',
'Varies',
'General: ¥1,000 / 2 hr, ¥1,500 / 3 hr (ext. ¥300 / hr); Women & under 18: ¥800 / 2 hr, ¥1,000 / 3 hr; Registration ¥1,000 (first time)',
NULL,
35.74700000, 139.71390000,
NULL,
0),

('adachi-miyagi-family-park',
'Adachi Miyagi Family Park',
'足立区宮城ファミリー公園',
13, 'Adachi', '2-2 Miyagi, Adachi-ku, Tokyo',
'Adachi Miyagi Family Park''s skating area is a community-driven outdoor skate spot in the Miyagi district of Adachi-ku, near Adachi-Odai Station on the Tokyo Sakura Tram (Toden Arakawa Line). The facility''s skatable obstacles — boxes, manual pads, arcs, flat rails, and cones — are largely DIY-built and maintained by the local skateboarding community, giving the spot an informal, neighbourhood character. Entry is free and no registration or helmet is required, making it one of the more accessible spots in the eastern 23 wards.',
'Adachi ward''s Miyagi Family Park has long served as a community recreation space. The skating area emerged informally as local skaters began building and maintaining DIY sections within the park. This pattern of community-led skate infrastructure is common in Adachi-ku, one of Tokyo''s more working-class northern wards, where municipal investment in dedicated skateparks has historically been limited. The local skaters who maintain the spot are known for being welcoming to all levels.',
'Boxes, manual pads, arcs, flat rails, cones (DIY community-built)',
'Asphalt and concrete',
'outdoor',
'Dawn to dusk',
'None',
'Free',
NULL,
35.77450000, 139.78470000,
NULL,
0),

('8times-corner-store',
'8Times Corner Store',
'エイトタイムズコーナーストア',
13, 'Adachi', '4-12 Shimane, Adachi-ku, Tokyo',
'8Times Corner Store is a compact private indoor skatepark in the Shimane district of Adachi-ku, operating on a fully reservation-based model via telephone booking. The facility houses two mini ramps of different sizes — a standard mini ramp and a smaller beginner-friendly version — providing a focused transition skating environment. The intimate scale of the park makes it particularly well suited to dedicated practice sessions for skaters working on ramp technique.',
'8Times Corner Store was established to serve the skateboarding community in western Adachi-ku, near Nishi-Arai Station on the Tobu Daishi Line. The park fills a gap in accessible, affordable indoor transition skating in the eastern 23 wards. Its reservation-only model ensures manageable session sizes and a controlled environment. Equipment is available on-site.',
'Mini ramp (standard), mini ramp (beginner size)',
'Smooth concrete and wood',
'indoor',
'Varies — reservation required by phone: 050-7561-0399',
'Varies',
'¥500 / 2 hr (extension ¥200 / hr)',
NULL,
35.78080000, 139.76800000,
NULL,
0),

('trinity-b3-park',
'TRINITY B3 PARK',
'トリニティB3パーク',
13, 'Itabashi', '4-12-20 Funado, Itabashi-ku, Tokyo',
'TRINITY B3 PARK is one of the larger indoor skateparks in northwest Tokyo, located in the basement of a warehouse-style building in Funado, Itabashi-ku, near Nishi-Dai and Ukimafunado stations. The spacious facility features boxes, rails, arcs, banks, bank-to-bank sections, and ramps, with obstacles that can be repositioned to change the park layout. An adjacent pro skate shop, TRINITY, sells hardware and apparel on-site. Monthly skateboarding schools are held for all levels. Helmets are not required for adults but are mandatory for skaters under eighteen.',
'TRINITY B3 PARK was established as part of the TRINITY skateboarding brand''s presence in Tokyo, combining retail and skating under one roof. Located in Funado, a district in the northwest of Itabashi ward near the Nishi-Dai area, the park was designed to serve the skateboarding community in a part of the city with limited access to public skating facilities. The adjoining shop has helped the venue develop as a hub for the local scene, with regular school programming building a sustained community around the facility.',
'Boxes, rails, arcs, banks, bank-to-bank section, ramps, repositionable obstacles, adjacent pro shop',
'Smooth concrete and wood',
'indoor',
'Varies — check website for current session times',
'Varies',
'General: ¥1,100 / 3 hr or ¥1,500 / day; Under 12: ¥800 / 3 hr or ¥1,000 / day',
'https://www.trinitytokyo.com/',
35.78490000, 139.69580000,
NULL,
0),

('yumenoshima-skateboard-park',
'Yumenoshima Skateboard Park',
'夢の島スケートボードパーク',
13, 'Koto', '1-1 Yumenoshima, Koto-ku, Tokyo',
'Yumenoshima Skateboard Park is one of Tokyo''s most comprehensive public outdoor skateparks, situated on the man-made Yumenoshima island in Koto-ku. Opened in November 2022, the park is divided into beginner and intermediate-to-advanced areas and features an unusually broad selection of obstacles for a public facility, including a full vertical ramp — rare among publicly managed parks in Tokyo. The park is informally nicknamed ''Horiume Park'' (堀米パーク) in honour of Japanese professional skateboarder Yuto Horiime, Olympic gold medallist in men''s street at both the Tokyo 2020 and Paris 2024 Games.',
'Yumenoshima (Dream Island / 夢の島) is an artificial island in eastern Koto-ku, developed on a former waste landfill that was constructed primarily from household rubbish generated by central Tokyo between the 1950s and 1970s. Following its conversion to a public park, the island became home to several sports facilities. Yumenoshima Skateboard Park opened in November 2022 as part of the sustained public investment in skateboarding infrastructure that followed the sport''s Olympic debut at Tokyo 2020. The facility''s nickname referencing Yuto Horiime reflects the cultural impact of his gold medal on skateboarding''s public profile in Japan.',
'Beginner area, intermediate and advanced area, curved ledges, manual pads, flat rails, down rails, banks, bank-to-banks, arcs, stairsets, knobs, mini ramp, vertical ramp',
'Concrete',
'outdoor',
'Daytime hours (seasonal) — check website',
'None (wristband from management building required)',
'Adults ¥450 / day; Junior and high school students ¥150 / day',
NULL,
35.64510000, 139.83110000,
NULL,
0),

('tsutsumidori-park-skatepark',
'Tsutsumidori Park Skatepark',
'堤通公園内交通公園スケートパーク',
13, 'Sumida', '1-8-1 Tsutsumidori, Sumida-ku, Tokyo',
'Tsutsumidori Park Skatepark is a provisional outdoor skate spot occupying space beneath an elevated railway structure within Tsutsumidori Park in Sumida-ku, accessible from Hikifune and Higashi-Mukojima stations. The under-track location offers partial protection from light rain, making it usable in conditions that would rule out a fully exposed park. The obstacle selection — boxes, rails, and banks — keeps the layout simple and street-focused. Skaters are expected to pack up sections and remove rubbish after each session as part of the community effort to demonstrate the spot''s viability as a permanent facility.',
'Tsutsumidori Park Skatepark emerged as a grassroots, provisional skate spot under an elevated railway structure in Sumida ward. Its informal, community-managed status means that continued access depends on skaters maintaining the space responsibly. The under-track location is characteristic of creative space-use in Tokyo''s densely built eastern wards, where dedicated skateparks are scarce. The local community''s commitment to tidying up after sessions reflects the broader effort to convert the spot into a recognised, permanent facility.',
'Boxes, rails, banks',
'Asphalt',
'outdoor',
'Irregular (community managed)',
'Irregular',
'Free',
NULL,
35.71830000, 139.82140000,
NULL,
0),

('umikaze-park-skatepark',
'Umikaze Park Skatepark',
'うみかぜ公園スケートパーク',
14, 'Yokosuka', '3-23 Heiseicho, Yokosuka, Kanagawa 238-0013',
'Umikaze Park Skatepark is one of the largest and most storied public skateparks in the Kanto region, occupying over 3,400 square metres within the seaside Umikaze Park in Yokosuka, Kanagawa. Long regarded as a sacred ground of Japanese skateboarding, the facility has produced numerous professional skaters over its three-decade history.',
'Umikaze Park opened in 1996 as part of Yokosuka City''s waterfront development along Tokyo Bay. After decades of heavy use, the skatepark underwent a full renovation in March 2018 with rebuilt concrete sections and improved surfaces.',
'Bowl, mini ramps, quarter pipes, spines, pyramids, rails, ledges, banks, bank-to-banks, curves, manual pads, stair sets, extensive flat ground, night lighting',
'Concrete with all-weather coating',
'outdoor',
'Dawn to 10:00 PM (lights off at 22:00)',
'None',
'Free',
'https://www.kanagawaparks.com/umikaze/',
35.27671800, 139.68289800,
'/images/skateparks/umikaze_park_skatepark.jpg',
0);

-- Tag relationships
INSERT INTO skatepark_tags (skatepark_id, tag_id) VALUES
(1, 1), (1, 3), (1, 5), (1, 7), (1, 9),   -- Ariake: Olympic, Outdoor, Street, Park, Professional
(2, 3), (2, 4), (2, 5),                    -- Shibuya Skate Spot: Outdoor, Free, Street
(3, 3), (3, 4), (3, 5), (3, 8), (3, 10),  -- Komazawa: Outdoor, Free, Street, Beginner Friendly, Public
(4, 3), (4, 4), (4, 6), (4, 10),          -- Jonanjima: Outdoor, Free, Vert, Public
(5, 3), (5, 4), (5, 8), (5, 10),          -- Setagaya Park: Outdoor, Free, Beginner Friendly, Public
(6, 3), (6, 4), (6, 8), (6, 10),          -- Kinuta Park: Outdoor, Free, Beginner Friendly, Public
(7, 3), (7, 4), (7, 10),                  -- Tamachi: Outdoor, Free, Public
(8, 3), (8, 5), (8, 7), (8, 8), (8, 9),  -- Miyashita: Outdoor, Street, Park, Beginner Friendly, Professional
(9, 3), (9, 4), (9, 5), (9, 8), (9, 10), -- Sumida: Outdoor, Free, Street, Beginner Friendly, Public
(10, 2), (10, 5), (10, 6), (10, 8),       -- Ramp Zero: Indoor, Street, Vert, Beginner Friendly
(11, 3), (11, 4), (11, 5), (11, 8), (11, 10), -- Yoyogi: Outdoor, Free, Street, Beginner Friendly, Public
(12, 3), (12, 5), (12, 8), (12, 10),          -- Yashio Kita: Outdoor, Street, Beginner Friendly, Public
(13, 3), (13, 5), (13, 7), (13, 8), (13, 9),  -- RAIZIN Sky Garden: Outdoor, Street, Park, Beginner Friendly, Professional
(14, 2), (14, 6), (14, 8),                    -- The Yago: Indoor, Vert, Beginner Friendly
(15, 3), (15, 4), (15, 5), (15, 8), (15, 10), -- Ikebukuro: Outdoor, Free, Street, Beginner Friendly, Public
(16, 3), (16, 4), (16, 5), (16, 8), (16, 10), -- Soshigaya: Outdoor, Free, Street, Beginner Friendly, Public
(17, 2), (17, 5), (17, 6), (17, 7), (17, 8),  -- DIORAMA: Indoor, Street, Vert, Park, Beginner Friendly
(18, 3), (18, 4), (18, 5), (18, 8), (18, 10), -- Miyagi Family: Outdoor, Free, Street, Beginner Friendly, Public
(19, 2), (19, 6), (19, 8),                    -- 8Times: Indoor, Vert, Beginner Friendly
(20, 2), (20, 5), (20, 6), (20, 8),           -- TRINITY B3: Indoor, Street, Vert, Beginner Friendly
(21, 3), (21, 5), (21, 6), (21, 8), (21, 9), (21, 10), -- Yumenoshima: Outdoor, Street, Vert, Beginner Friendly, Professional, Public
(22, 3), (22, 4), (22, 5), (22, 8), (22, 10),          -- Tsutsumidori: Outdoor, Free, Street, Beginner Friendly, Public
(23, 3), (23, 4), (23, 5), (23, 6), (23, 7), (23, 8), (23, 9), (23, 10); -- Umikaze: Outdoor, Free, Street, Vert, Park, Beginner Friendly, Professional, Public


-- Japanese fields for skateparks (excludes sumida-skateboard-park, edias-skatepark)
UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒135-0063 東京都江東区有明2-2',
  description_ja = '有明アーバンスポーツパークは、東京2020オリンピック・パラリンピックのメイン会場の一つとして建設された、有明（江東区）の世界水準のスケートボード・アーバンスポーツ施設です。ストリート・パーク両種目の競技会場となり、現在も国内外のトップ選手が使う競技レベルのコースを一般に公開しています。',
  history_ja = '2020年の東京大会向けに整備され、2021年7月25〜26日にストリート、8月4〜5日にパークの男女競技が開催されました。大会後は恒久施設として再編され、2022年から一般利用が可能になり、以降も国内外の大会が開かれています。',
  facilities_ja = 'オリンピック規格のストリートコース、パークコース、観客席、更衣室、レンタル、飲食、救護、ロッカー',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '火曜日（祝日の場合は翌平日）、祝日の翌日',
  admission_fee_ja = '大人1,000円／学生500円／小学生以下300円（料金は変更の場合あり）'
WHERE slug = 'ariake-urban-sports-park';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '東京都渋谷区（渋谷駅周辺・宮下パークほか）',
  description_ja = '渋谷区内外に点在する、ストリートスケートの聖地的スポット群です。渋谷駅周辺、宮下パーク、代官山・中目黒方面など、長年スケーターのたまり場になってきました。2020年に再開発で開業した宮下パークには屋上の公認スケートエリアがあります。',
  history_ja = '1990年代から渋谷駅前は若者スケーターの中心地の一つでした。2020年、三井不動産等による宮下パークの再開発で商業・ホテル・スポーツが一体となった縦型公園が誕生し、屋上にスケートスペースが設けられました。',
  facilities_ja = '宮下パーク屋上スケートエリア、階段・レッジ、マニュアル台など（エリアにより異なる）',
  surface_type_ja = 'コンクリート・タイル',
  closed_days_ja = 'なし（宮下パーク屋上の場合は施設に準ずる）',
  admission_fee_ja = '無料（宮下パーク屋上エリア）'
WHERE slug = 'shibuya-skate-spot';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒154-0012 東京都世田谷区駒沢公園1-1',
  description_ja = '1964年東京オリンピックの会場となった駒沢オリンピック公園内にある、都内有数の屋外スケートパークです。緩やかなバンクからランチボックス、クォーター・ヒップ、ミニハーフ、マニーパッド、ベンチまで揃い、初心者から上級者まで幅広く利用できます。入場無料でアクセスしやすい公園施設です。',
  history_ja = '駒沢公園は1964年大会のバレーボール会場として造られ、その後都民のスポーツ・レクリエーション拠点となりました。スケートエリアは長年かけて拡充され、首都圏スケートシーンの定番スポットの一つになっています。',
  facilities_ja = 'バンク、ランチボックス、クォーターパイプヒップ、ミニハーフ複数、マニーパッド、ベンチ、売店近接',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'komazawa-olympic-park-skatepark';

UPDATE skateparks SET
  city_ja = '大田区',
  address_ja = '〒140-0003 東京都大田区城南島4-2-2',
  description_ja = '埋め立て地の城南島・城南島海浜公園内にあり、東京湾や東京港の貨物船、羽田への着陸機を眺めながら滑れる開放的な屋外パークです。ハーフパイプ、クォーター、グラインドボックス、レール、フラットなど、ストリートからトランジションまで幅広く楽しめます。',
  history_ja = '1991年7月、首都圏の埋立整備の一環として城南島海浜公園が開園。スケートエリアは30年以上にわたり地元・首都圏のスケーターに利用され、湾岸ならではのロケーションが人気です。',
  facilities_ja = 'ハーフパイプ、バンクツーバンク、スパイン、クォーター、ボックス、フラットレール、フラット',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '水曜（祝日の場合は翌平日）、12月29日〜1月3日',
  admission_fee_ja = '無料'
WHERE slug = 'jonanjima-seaside-park-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒154-0001 東京都世田谷区池尻1-5-27',
  description_ja = '世田谷公園内の通称「SLパーク」。スケートボード・インライン用エリアが2つと、BMX・フラット向けゾーンに分かれた多目的屋外施設です。家族連れにも馴染みやすく、区立公園として整備された環境で滑れます。',
  history_ja = '公園内のSL（蒸気機関車）展示で知られる池尻の世田谷公園に、スポーツ拡充の一環として設置されました。地域の若者やスケートコミュニティの拠点の一つです。',
  facilities_ja = 'スケートエリア1・2（スケボー・インライン）、BMX・フラット用エリア',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'setagaya-park-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒157-0075 東京都世田谷区砧公園1-1',
  description_ja = '都立砧公園（約39ha）内、有料駐車場近くの景観門側にあるコンパクトな屋外パークです。スケートボード・インライン専用のセクションが複数あり、無料で西部世田谷（用賀・二子玉川方面）の滑り手に利用されています。',
  history_ja = '都が管理する砧公園は広い芝生や桜、隣接する世田谷美術館でも知られます。住宅地に近いスケート環境を提供するためのエリアとして設けられました。',
  facilities_ja = '複数のスケートセクション（スケボー・インライン専用）',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'kinuta-park-skatepark';

UPDATE skateparks SET
  city_ja = '港区',
  address_ja = '〒108-0023 東京都港区芝浦4-20',
  description_ja = '芝浦運河沿い・湊橋（ゆなぎばし）高架下にある小さなスケートスペース。バスケコートと併設され、都心の再開発が進む芝浦エリアでは貴重な公認の滑走スペースです。橋の下なので日射や小雨を多少しのげます。',
  history_ja = '港区の運河沿い整備の一環として、高架下遊具・スポーツスペースとして整備されました。密集市街地での遊び場確保の工夫の一例です。',
  facilities_ja = 'スケート用リング、バスケットコート',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'tamachi-skate-board-space';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '〒150-0001 東京都渋谷区神宮前6-20-10',
  description_ja = '渋谷駅至近の宮下パーク複合施設屋上にある有料のプレミアムスケートパーク。Nike協力のもと、プロのポール・ロドリゲスとランス・マウンテンがデザインに関与。コンクリートボウル、7段含むステア、レール、レッジ、マニュアル台などを備え、クラブハウスでヘルメット無料貸出（着用必須）。',
  history_ja = '1953年開園の宮下公園が、三井不動産と渋谷区の再開発で2020年6月に立体複合施設として再オープン。スケート施設はプロ監修で話題となり、Nikeとの協業でも注目を集めました。',
  facilities_ja = 'スムーズなコンクリートボウル、7段ステア、その他ステア、レール、レッジ、マニュアル台、ヘルメット貸出',
  surface_type_ja = '高品質コンクリート',
  closed_days_ja = '年末年始',
  admission_fee_ja = '大人2時間200円／学生2時間100円（変更の場合あり）'
WHERE slug = 'miyashita-park-skatepark';

UPDATE skateparks SET
  city_ja = '荒川区',
  address_ja = '〒116-0003 東京都荒川区南千住4-2-3',
  description_ja = '東京メトロ日比谷線高架直下にある屋内スケートパーク兼スクール。延床約300㎡、高さ650・800・1200mmのミニランプ3基と、ボックス・レール付きフラットエリア。会員制オンライン予約とスマートロック入館。ボード・ヘルメット・プロテクター無料レンタル。5歳からのレッスンあり。',
  history_ja = 'スケート施設が少なかった南千住・荒川周辺向けに開業。高架下のデッドスペース活用モデルとして、雨天・猛暑に強い屋内練習場として定着しています。',
  facilities_ja = 'ミニランプ3（H650/800/1200）、フラット＋ボックス・レール、無料レンタル',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '有料（レッスン・フリースケ等、サイト参照）'
WHERE slug = 'ramp-zero';

UPDATE skateparks SET
  city_ja = '渋谷区',
  address_ja = '〒151-0052 東京都渋谷区代々木神園町1-1-1',
  description_ja = '代々木公園内の無料屋外アーバンスポーツエリア。フラットとボックス中心のシンプルな構成で、基礎練習や初心者に向きます。原宿・渋谷に近く、緑地に囲まれた落ち着いた環境です。',
  history_ja = '公園の地は元ワシントンハイツおよび1964年選手村跡地で、1967年に都立公園として開園。ハラジュク方面のスケート需要に応じてアーバンスポーツエリアが後年整備され、今後の区画改修も計画されています。',
  facilities_ja = 'フラットエリア、ボックス系セクション',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'yoyogi-park-urban-sports-park';

UPDATE skateparks SET
  city_ja = '品川区',
  address_ja = '〒140-0001 東京都品川区八潮1-3-1',
  description_ja = '東京湾岸の八潮地区、品川シーサイド駅からアクセスできる屋外スケボー場。ボックス、カーブレッジ、アーク、バンク、ダウンレールなどストリート系が充実。初心者向けスクールが毎月第4土曜に開かれることもあります。',
  history_ja = '埋立て地を含む八潮の公園整備の一環として品川区が整備。湾岸の住宅・業務エリアにスケートの拠点を提供しています。',
  facilities_ja = 'ボックス、カーブレッジ、アーク、バンク、ダウンレール',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '大人400円／日、学生200円／日（品川区民は割引）'
WHERE slug = 'yashio-kita-park-skatepark';

UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒135-0064 東京都江東区青海1-1-10',
  description_ja = 'お台場青海エリアの屋外スケート・アーバンスポーツ施設（H.L.N.A運営）。東京湾・お台場の眺望と、カーブレッジ、マニュアル台、アーク、バンク、ランプ、ステア、ダウンレール・レッジなど多彩なセクション。女子・大人向けスクールや年会費制の会員カード制度あり。',
  history_ja = 'お台場の再開発とともに整備された商業系屋外パークの一つ。エナジードリンクRAIZINとのネーミング協業でも知られ、オリンピック後のスケート人気とともに利用が広がりました。',
  facilities_ja = 'カーブレッジ、マニュアル台、アーク、バンク、ランプ、ステア、ダウンレール、ダウンレッジ',
  surface_type_ja = '滑らかなコンクリート',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '時間制・年会費あり（サイト参照）'
WHERE slug = 'raizin-sky-garden';

UPDATE skateparks SET
  city_ja = '大田区',
  address_ja = '〒143-0016 東京都大田区大森北3-39-5 B1',
  description_ja = '大森北のビル地下にあるコンパクトな屋内ランプパーク。大・中・小の3ランプは緩やかなアールで幅広いトリに向く設計。平和島・大森海岸駅からアクセス。店主「ばばちゃん」の人柄でも知られるローカル向けスポット。',
  history_ja = '大田区南部の住宅・工業地帯で屋内施設が不足していたエリア向けに開業。ランプ特化でトランジション練習に適しています。',
  facilities_ja = '大・中・小ランプ',
  surface_type_ja = '木材・コンクリート',
  closed_days_ja = 'Instagram等で要確認',
  admission_fee_ja = '1時間1,000円（延長15分100円）、初回登録500円'
WHERE slug = 'the-yago-skateboard-park';

UPDATE skateparks SET
  city_ja = '豊島区',
  address_ja = '〒170-0013 東京都豊島区東池袋1-44-15',
  description_ja = '池袋大橋高架下の無料屋外パーク。夏の日陰や小雨時の利用に有利。カーブ、マニュアル台、アーク、バンクなど中級未満のストリート向き。利用には約1km離れたHIGHSOX SKATE SHOPでリストバンド取得が必要。',
  history_ja = '以前は池袋駅前公園にあった施設が、高架下に移設・拡張されました。山手線北側で数少ない無料公園パークの一つです。',
  facilities_ja = 'カーブレッジ、マニュアル台、アーク、バンク',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料（HIGHSOXでリストバンド必須）'
WHERE slug = 'ikebukuro-skatepark';

UPDATE skateparks SET
  city_ja = '世田谷区',
  address_ja = '〒157-0062 東京都世田谷区上祖師谷3-22-19',
  description_ja = '祖師谷公園内のコミュニティ主導型屋外スポット。ボックス、レール、バンク、アーク、ランプなどは地元スケーターがDIYで整備・維持するスタイル。緑の多い公園で雰囲気が良く、訪問者にも開放的な現場です。',
  history_ja = '祖師谷・喜多見エリアのスケーターが公園内に段階的にセクションを作り、自主管理してきました。時間は固定せず、SNS等で確認する必要があります。',
  facilities_ja = 'ボックス、レール、バンク、アーク、ランプ（DIY・コミュニティ維持）',
  surface_type_ja = 'コンクリート',
  closed_days_ja = '不定',
  admission_fee_ja = '無料'
WHERE slug = 'soshigaya-park-skatepark';

UPDATE skateparks SET
  city_ja = '板橋区',
  address_ja = '〒173-0004 東京都板橋区板橋1-48-8 ダイアパレス新板橋 B1',
  description_ja = '新板橋のマンション地下にある屋内パーク＆カフェ。ボックス、マニュアル台、バンク、ランプ、ボウルを備え、段階的に技を積み上げやすいレイアウトで評価。13歳未満はヘルメット必須、大人は任意。',
  history_ja = '都心北部では屋内施設が限られる中、板橋区で地下室スペースを活用して開業。セッション後のカフェで交流できるスタイルが特徴です。',
  facilities_ja = 'ボックス、マニュアル台、バンク、ランプ、ボウル、カフェ',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '施設・サイトで要確認',
  admission_fee_ja = '一般2時間1,000円〜、女性・18歳未満割引、初回登録1,000円（要確認）'
WHERE slug = 'diorama-skate-lounge';

UPDATE skateparks SET
  city_ja = '足立区',
  address_ja = '〒121-0833 東京都足立区宮城2-2',
  description_ja = '宮城ファミリー公園内のDIY中心スポット。都電荒川線小台駅近く。ボックス、マニュアル台、アーク、フラットレール、コーン等を地元が手作り・維持。無料・登録不要・ヘルメット非義務で敷居が低い東部23区の貴重な場所です。',
  history_ja = '足立区では公設パークが少ない中、公園内にコミュニティがセクションを作り広げてきた例です。',
  facilities_ja = 'ボックス、マニュアル台、アーク、フラットレール、コーン（DIY）',
  surface_type_ja = 'アスファルト・コンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'adachi-miyagi-family-park';

UPDATE skateparks SET
  city_ja = '足立区',
  address_ja = '〒123-0864 東京都足立区島根4-12',
  description_ja = '西新井方面の島根にある超コンパクトな予約制屋内パーク。標準と初心者向けの2つのミニランプでランプ練習に特化。電話予約のみ。東部での手頃な屋内トランジション練習場として利用されています。',
  history_ja = '足立区西部で屋内施設の空白を埋める形で開業。定員管理のため完全予約制です。',
  facilities_ja = 'ミニランプ（標準・小）',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = '要確認',
  admission_fee_ja = '2時間500円（延長1時間200円）'
WHERE slug = '8times-corner-store';

UPDATE skateparks SET
  city_ja = '板橋区',
  address_ja = '〒175-0082 東京都板橋区舟渡4-12-20',
  description_ja = '板橋区西北部・舟渡の倉庫型ビル地下にある大規模屋内パーク。ボックス、レール、アーク、バンク、バンクツーバンク、移動可能オバケとプロショップTRINITY併設。月例スクールあり。18歳未満はヘルメット必須。',
  history_ja = 'TRINITYブランドの店舗一体型として、板橋北西部の滑り手コミュニティのハブになっています。',
  facilities_ja = 'ボックス、レール、アーク、バンク、バンクツーバンク、ランプ、可動式障害物、隣接プロショップ',
  surface_type_ja = 'コンクリート・木材',
  closed_days_ja = 'サイト要確認',
  admission_fee_ja = '一般3時間1,100円または終日1,500円、12歳以下割引（サイト参照）'
WHERE slug = 'trinity-b3-park';

UPDATE skateparks SET
  city_ja = '江東区',
  address_ja = '〒136-0081 東京都江東区夢の島1-1',
  description_ja = '夢の島（埋立ゴミ地を緑化した人工島）にある都屈指の規模の公設屋外パーク。2022年11月開業。初心者ゾーンと中上級ゾーンに分かれ、バーティカルを含む多彩な障害物を備えます。堀米雄斗選手にちなみ「堀米パーク」の通称でも親しまれます。',
  history_ja = '東京2020でスケートがオリンピック種目になった流れで、夢の島の公園整備の一環として開業。メダリストの影響で国内のスケート人気が高まる中、象徴的な施設となりました。',
  facilities_ja = '初心者・中上級エリア、カーブレッジ、マニュアル台、レール、バンク、ステア、ミニランプ、バーティカル等',
  surface_type_ja = 'コンクリート',
  closed_days_ja = 'なし（管理棟でリストバンド取得）',
  admission_fee_ja = '大人450円／日、中高生150円／日（要確認）'
WHERE slug = 'yumenoshima-skateboard-park';

UPDATE skateparks SET
  city_ja = '墨田区',
  address_ja = '〒131-0033 東京都墨田区堤通1-8-1',
  description_ja = '堤通公園内・高架下の暫定ストリートスポット。曳舟・東向島方面。ボックス、レール、バンクのみのシンプル構成。雨を多少しのげる。常設化を目指し、利用後の片付けとマナーが継続の鍵とされています。',
  history_ja = '墨田区では公設パークが少ない中、線路下空間をコミュニティが活用する形で生まれました。公式な常設施設ではない点に注意が必要です。',
  facilities_ja = 'ボックス、レール、バンク',
  surface_type_ja = 'アスファルト',
  closed_days_ja = '不定',
  admission_fee_ja = '無料'
WHERE slug = 'tsutsumidori-park-skatepark';

UPDATE skateparks SET
  city_ja = '横須賀市',
  address_ja = '〒238-0013 神奈川県横須賀市平成町3-23',
  description_ja = '海辺のうみかぜ公園内、延床約3,400㎡超の大型公設屋外パーク。日本スケート史上有名で多くのプロを輩出。ボウル、ミニランプ、クォーター、スパイン、ピラミッド、レール、レッジ、バンク、ステア、広いフラット、夜間照明あり。2018年3月に全面改修。',
  history_ja = '1996年、横須賀市の東京湾岸開発の一環として開園。長年の使用で老朽化したため2018年にリニューアルし、現行の高品質コンクリート面となりました。',
  facilities_ja = 'ボウル、ミニランプ、クォーター、スパイン、ピラミッド、レール、レッジ、バンク、カーブ、マニュアル台、ステア、フラット、照明',
  surface_type_ja = '全天候型コーティングのコンクリート',
  closed_days_ja = 'なし',
  admission_fee_ja = '無料'
WHERE slug = 'umikaze-park-skatepark';
