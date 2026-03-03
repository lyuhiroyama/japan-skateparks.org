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
0);

-- Tag relationships
INSERT INTO skatepark_tags (skatepark_id, tag_id) VALUES
(1, 1), (1, 3), (1, 5), (1, 7), (1, 9),  -- Ariake: Olympic, Outdoor, Street, Park, Professional
(2, 3), (2, 4), (2, 5);                   -- Shibuya: Outdoor, Free, Street

