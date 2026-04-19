-- ═══════════════════════════════════════
-- Smart Venue — Complete Database Schema
-- Database: lgv_db
-- ═══════════════════════════════════════

CREATE DATABASE IF NOT EXISTS lgv_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lgv_db;

-- ── USERS ──
CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(40),
    role          ENUM('client','admin') DEFAULT 'client',
    created_at    DATETIME DEFAULT NOW()
);

-- Default admin user (password: Admin@1234)
INSERT IGNORE INTO users (full_name, email, password_hash, role)
VALUES ('Admin', 'admin@smartvenue.com',
'$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin');

-- ── VENUES ──
CREATE TABLE IF NOT EXISTS venues (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    location     VARCHAR(150),
    region       VARCHAR(100),
    max_guests   INT DEFAULT 200,
    price        DECIMAL(12,2) DEFAULT 0,
    description  TEXT,
    image_url    VARCHAR(500),
    badge        VARCHAR(50),
    active       TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT NOW()
);


-- ── VENUE SEED DATA (Pakistani Venues) ──
INSERT IGNORE INTO venues (id, name, location, region, max_guests, price, description, image_url, badge, active) VALUES
(1,  'Pearl Continental Banquet', 'Gulberg, Lahore',           'Gulberg',        1500, 6500,  'Premier luxury banquet hall in the heart of Gulberg with world-class facilities and dedicated event management.', 'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600&q=80', 'Luxury',     1),
(2,  'Serena Hotel Banquet',      'DHA Phase 2, Lahore',       'DHA',             1400, 7000,  'World-class banquet in a five-star environment with stunning decor, premium catering, and professional staff.',    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&q=80', 'Luxury',     1),
(3,  'Nishat Hotel Banquet',      'MM Alam Road, Lahore',      'Gulberg',         1000, 5000,  'Sophisticated venue with panoramic city views, exquisite interiors and personalised wedding packages.',             'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=600&q=80', 'Premium',    1),
(4,  'PC DHA Marquee',            'Defence Road, Lahore',      'DHA',             1200, 6500,  'Exclusive marquee in DHA with state-of-the-art facilities, elegant decor and ample parking for guests.',           'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=600&q=80', 'Premium',    1),
(5,  'Model Town Grand Marquee',  'Main Boulevard, Model Town','Model Town',      1100, 4000,  'Spacious marquee with lush garden views, beautiful floral arrangements and full wedding coordination services.',    'https://images.unsplash.com/photo-1537633552985-df8429e8048b?w=600&q=80', 'Featured',   1),
(6,  'Johar Grand Banquet',       'Main Johar Town Road',      'Johar Town',       900, 3200,  'Premium banquet hall with modern decor, full catering services, dedicated parking and professional event team.',    'https://images.unsplash.com/photo-1583939411023-c86c3c6a2ebe?w=600&q=80', 'Popular',    1),
(7,  'Expo Centre Gulberg',       'Jail Road, Lahore',         'Gulberg',         2000, 3800,  'Lahore largest exhibition and event complex — perfect for grand weddings with thousands of guests.',                'https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=600&q=80', 'Mega Venue', 1),
(8,  'Royal Marquee DHA',         'Phase 4, DHA Lahore',       'DHA',              900, 4200,  'Exclusive marquee with royal decor, professionally trained staff and outstanding culinary experience in DHA.',      'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&q=80', '',           1),
(9,  'Green Park Marquee',        'Wahdat Road, Model Town',   'Model Town',       900, 3200,  'Beautiful garden marquee surrounded by greenery with both outdoor and indoor wedding event options available.',      'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=600&q=80', '',           1),
(10, 'Gulshan Ravi Grand Marquee','Main Ravi Road, Lahore',    'Gulshan-e-Ravi',  1000, 2600,  'Elegant grand marquee ideal for large wedding receptions with great road access and affordable premium packages.',  'https://images.unsplash.com/photo-1537633552985-df8429e8048b?w=600&q=80', '',           1),
(11, 'Al-Hamra Cultural Complex', 'Mall Road, Lahore',         'Mall Road',        800, 2500,  'A historic cultural complex on Mall Road offering a unique and elegant setting for wedding ceremonies.',            'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=600&q=80', 'Heritage',   1),
(12, 'Avari Towers Banquet',      'Shahrah-e-Quaid-e-Azam',   'Mall Road',       1200, 5800,  'Five-star luxury banquet at Avari Towers with panoramic Lahore views, fine dining and world-class event services.', 'https://images.unsplash.com/photo-1583939411023-c86c3c6a2ebe?w=600&q=80', 'Luxury',     1);

-- ── BOOKINGS ──
CREATE TABLE IF NOT EXISTS bookings (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    booking_ref    VARCHAR(40) NOT NULL UNIQUE,
    user_id        INT,
    venue_id       INT,
    client_name    VARCHAR(150) NOT NULL,
    client_email   VARCHAR(180) NOT NULL,
    client_phone   VARCHAR(40),
    wedding_date   DATE,
    guest_count    INT DEFAULT 0,
    venue_price    DECIMAL(12,2) DEFAULT 0,
    grand_total    DECIMAL(12,2) DEFAULT 0,
    notes          TEXT,
    status         ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    created_at     DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ── HALL BOOKINGS ──
CREATE TABLE IF NOT EXISTS hall_bookings (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    booking_ref  VARCHAR(40) NOT NULL UNIQUE,
    user_id      INT,
    hall_id      INT DEFAULT 1,
    hall_name    VARCHAR(100),
    client_name  VARCHAR(150) NOT NULL,
    client_email VARCHAR(180) NOT NULL,
    client_phone VARCHAR(40),
    event_date   DATE,
    event_time   VARCHAR(50),
    guest_count  INT DEFAULT 0,
    event_type   VARCHAR(100),
    notes        TEXT,
    status       ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    created_at   DATETIME DEFAULT NOW()
);

-- ── HALL BLOCKED DATES (Admin Manual Control) ──
CREATE TABLE IF NOT EXISTS hall_blocked_dates (
    date         DATE PRIMARY KEY,
    blocked      TINYINT(1) DEFAULT 1,
    note         VARCHAR(255),
    updated_at   DATETIME DEFAULT NOW() ON UPDATE NOW()
);

-- Sample blocked dates
INSERT IGNORE INTO hall_blocked_dates (date, note) VALUES
    (DATE_ADD(CURDATE(), INTERVAL 5 DAY),  'Wedding booked'),
    (DATE_ADD(CURDATE(), INTERVAL 8 DAY),  'Private event'),
    (DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Wedding booked'),
    (DATE_ADD(CURDATE(), INTERVAL 19 DAY), 'Wedding booked'),
    (DATE_ADD(CURDATE(), INTERVAL 22 DAY), 'Wedding booked'),
    (DATE_ADD(CURDATE(), INTERVAL 27 DAY), 'Wedding booked');

-- ── CONTACTS ──
CREATE TABLE IF NOT EXISTS contacts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150),
    email      VARCHAR(180),
    message    TEXT,
    created_at DATETIME DEFAULT NOW()
);
