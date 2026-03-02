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

('tsurigasaki-skatepark',
'Tsurigasaki Skatepark',
'釣ヶ崎海岸スポーツの森',
4, 'Ichinomiya', 'Ichinomiya, Chiba Prefecture',
'Tsurigasaki Skatepark, part of the Tsurigasaki Surfing Beach Sports Forest complex in Ichinomiya, Chiba, is best known as the host venue for the Surfing competitions of the Tokyo 2020 Olympics. The skate facilities within the complex cater to boardsports enthusiasts of all levels. The area is set amidst a natural coastal environment and is popular with both skaters and surfers from the greater Tokyo area.',
'Tsurigasaki (九十九里浜) has been a legendary surf spot in Japan for decades. The surrounding sports complex was developed in anticipation of the Tokyo 2020 Games. While surfing was the centrepiece, the associated skatepark facilities serve the local boardsports community year-round.',
'Skate bowl, Street section, Surf beach access, Parking, Shower facilities, Surf and skate equipment rental',
'Concrete',
'outdoor',
'Sunrise to sunset',
'Varies by season',
'Free',
NULL,
35.38120000, 140.38500000,
0),

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

('osaka-skatepark-namba',
'Namba Skate Park',
'難波スケートパーク',
2, 'Naniwa', 'Namba, Naniwa-ku, Osaka',
'Located in the vibrant Namba district of Osaka, Namba Skate Park is one of the most popular skateboarding destinations in western Japan. Centrally located and easily accessible, the park features a variety of obstacles suited to street skating, and draws a lively mix of locals and visitors. Osaka''s skating scene is known for its energy and creativity, and Namba Skate Park is at its heart.',
'The Namba area has attracted skaters for decades due to its urban architecture and flat marble plazas. The development of a dedicated skate facility in the area helped formalise the scene and provide a safe and sanctioned space for skaters of all backgrounds.',
'Street course, Manual pads, Rails and ledges, Stairsets, Flat ground area',
'Smooth concrete',
'outdoor',
'9:00 AM – 9:00 PM',
'Mondays',
'Adults ¥500 / Students ¥300',
NULL,
34.66270000, 135.50100000,
0),

('yokohama-skatepark',
'Yokohama Skatepark',
'横浜スケートパーク',
3, 'Yokohama', 'Yokohama, Kanagawa Prefecture',
'Yokohama Skatepark is one of the premier skateboarding facilities in the Kanto region, located in Japan''s second-largest city. The park features a well-designed mix of street and transition elements, and hosts regular amateur and professional competitions. Its proximity to Tokyo makes it a popular destination for the region''s vibrant skateboarding community.',
'Yokohama has a long history with action sports, and the skatepark was established to serve the city''s growing skateboarding community. The facility has been expanded and upgraded over the years, and now serves as a key competition venue for the Kanto region.',
'Large street plaza, Vert ramp, Mini ramp, Bowl section, Spectator area, Rental equipment, Changing rooms',
'Concrete',
'both',
'10:00 AM – 8:00 PM',
'Wednesdays',
'Adults ¥800 / Students ¥400 / Children ¥200',
NULL,
35.44780000, 139.64240000,
0),

('nagoya-skatepark',
'Nagoya Skate Park',
'名古屋スケートパーク',
5, 'Nagoya', 'Nagoya, Aichi Prefecture',
'Nagoya Skate Park is the central hub of skateboarding in Aichi Prefecture and the Chubu region. The park features a comprehensive range of obstacles and is known for its welcoming community. It regularly hosts competitions and events that attract skaters from across central Japan.',
'Established to meet the demands of Nagoya''s growing skate community, the park has become a cornerstone of the local scene. It has hosted regional qualifying events for national competitions.',
'Street course, Park bowl, Mini ramp, Flatground area, Beginner zone, Lockers, Snack bar',
'Concrete',
'both',
'10:00 AM – 9:00 PM',
'Tuesdays',
'Adults ¥700 / Students ¥350',
NULL,
35.18147800, 136.90664100,
0),

('fukuoka-skatepark',
'Fukuoka Skatepark',
'福岡スケートパーク',
6, 'Fukuoka', 'Fukuoka City, Fukuoka Prefecture',
'Fukuoka Skatepark serves as the main skateboarding facility for Kyushu''s largest city. The park is a gathering place for Fukuoka''s active skate scene and hosts regional events throughout the year. Its modern design caters to all disciplines of skateboarding.',
'The skatepark was developed as part of Fukuoka City''s commitment to urban sports infrastructure. It has become a central part of the city''s youth sports culture.',
'Street section, Vert ramp, Bowl, Beginner area, Pro zone, Rental shop, Café',
'Concrete',
'outdoor',
'9:00 AM – 9:00 PM',
'Mondays',
'Adults ¥600 / Students ¥300',
NULL,
33.59010000, 130.40170000,
0),

('sapporo-skatepark',
'Sapporo Skatepark',
'札幌スケートパーク',
10, 'Sapporo', 'Sapporo, Hokkaido',
'Sapporo Skatepark is the leading skateboarding facility in Hokkaido, providing an indoor facility that allows year-round skating in a region known for harsh winters. The park is a vital hub for the Hokkaido skate community, offering a warm and accessible space when outdoor conditions are unfavourable.',
'The development of an indoor skatepark in Sapporo was driven by the need to support year-round skating in Hokkaido''s cold climate. The park has grown to become an important part of the local sports community.',
'Indoor street course, Indoor bowl, Beginner zone, Pro section, Equipment rental, Changing rooms, Heated facilities',
'Smooth concrete',
'indoor',
'10:00 AM – 9:00 PM',
'Tuesdays',
'Adults ¥900 / Students ¥500 / Children ¥300',
NULL,
43.06210000, 141.35440000,
0),

('sendai-skatepark',
'Sendai Skatepark',
'仙台スケートパーク',
11, 'Sendai', 'Sendai, Miyagi Prefecture',
'Sendai Skatepark is the principal skating venue in the Tohoku region, serving the skateboarding community of Miyagi Prefecture and beyond. The park features a broad range of obstacles and is known for its community-focused atmosphere.',
'The skatepark was established to provide the Tohoku skateboarding community with a dedicated facility. It has become an important cultural space for youth in the region.',
'Street plaza, Mini ramp, Bowl, Flatground, Beginner area, Lockers',
'Concrete',
'outdoor',
'9:00 AM – 7:00 PM',
'Mondays',
'Adults ¥500 / Students ¥250',
NULL,
38.26890000, 140.87200000,
0),

('kyoto-skatepark',
'Kyoto Skatepark',
'京都スケートパーク',
8, 'Kyoto', 'Kyoto City, Kyoto Prefecture',
'Kyoto Skatepark offers a unique skating experience in one of Japan''s most culturally rich cities. The park provides a modern skating facility that coexists with Kyoto''s historical character, and is a popular destination for both local skaters and visitors to the ancient capital.',
'Skating in Kyoto has a long informal history, with skaters drawn to the city''s expansive temple plazas and smooth stone surfaces. The development of a dedicated skatepark gave the community a formal space while reducing conflict with heritage sites.',
'Street course, Mini ramp, Flat ground, Beginner area',
'Concrete',
'outdoor',
'9:00 AM – 8:00 PM',
'Wednesdays',
'Adults ¥500 / Students ¥250',
NULL,
35.01160000, 135.76800000,
0);

-- Tag relationships
INSERT INTO skatepark_tags (skatepark_id, tag_id) VALUES
(1, 1), (1, 3), (1, 5), (1, 7), (1, 9),  -- Ariake: Olympic, Outdoor, Street, Park, Professional
(2, 1), (2, 3), (2, 4),                    -- Tsurigasaki: Olympic, Outdoor, Free
(3, 3), (3, 4), (3, 5),                    -- Shibuya: Outdoor, Free, Street
(4, 3), (4, 5), (4, 10),                   -- Namba: Outdoor, Street, Public
(5, 3), (5, 6), (5, 7),                    -- Yokohama: Outdoor, Vert, Park
(6, 7), (6, 8), (6, 10),                   -- Nagoya: Park, Beginner Friendly, Public
(7, 3), (7, 9), (7, 10),                   -- Fukuoka: Outdoor, Professional, Public
(8, 2), (8, 8), (8, 10),                   -- Sapporo: Indoor, Beginner Friendly, Public
(9, 3), (9, 8), (9, 10),                   -- Sendai: Outdoor, Beginner Friendly, Public
(10, 3), (10, 8), (10, 10);                -- Kyoto: Outdoor, Beginner Friendly, Public

