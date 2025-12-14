-- Create Database
CREATE DATABASE IF NOT EXISTS hostel_mess_db;
USE hostel_mess_db;

-- ==================== MEALS TABLE ====================
-- Stores meal information for each day
CREATE TABLE IF NOT EXISTS meals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    meal_type ENUM('Breakfast', 'Lunch', 'Snacks', 'Dinner') NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_meal (day_of_week, meal_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== MENU ITEMS TABLE ====================
-- Stores individual food items for each meal
CREATE TABLE IF NOT EXISTS menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    meal_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE,
    INDEX idx_meal_id (meal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== NOTICES TABLE ====================
-- Stores mess notices and announcements
CREATE TABLE IF NOT EXISTS notices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    date_posted DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (date_posted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== FEEDBACK TABLE ====================
-- Stores student feedback
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    meal VARCHAR(100) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    date_posted DATE NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (date_posted),
    INDEX idx_rating (rating),
    INDEX idx_meal (meal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==================== INSERT SAMPLE DATA ====================

-- Insert Meals for Monday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Monday', 'Breakfast', '7:30 AM - 9:30 AM'),
('Monday', 'Lunch', '12:00 PM - 2:00 PM'),
('Monday', 'Snacks', '4:00 PM - 5:30 PM'),
('Monday', 'Dinner', '7:30 PM - 9:30 PM');

-- Insert Menu Items for Monday Breakfast
INSERT INTO menu_items (meal_id, item_name) VALUES
(1, 'Poha'),
(1, 'Sambhar'),
(1, 'Chai'),
(1, 'Banana');

-- Insert Menu Items for Monday Lunch
INSERT INTO menu_items (meal_id, item_name) VALUES
(2, 'Roti'),
(2, 'Dal Tadka'),
(2, 'Rice'),
(2, 'Mixed Veg'),
(2, 'Salad'),
(2, 'Pickle');

-- Insert Menu Items for Monday Snacks
INSERT INTO menu_items (meal_id, item_name) VALUES
(3, 'Samosa'),
(3, 'Green Chutney'),
(3, 'Tea');

-- Insert Menu Items for Monday Dinner
INSERT INTO menu_items (meal_id, item_name) VALUES
(4, 'Chapati'),
(4, 'Rajma'),
(4, 'Jeera Rice'),
(4, 'Raita'),
(4, 'Gulab Jamun');

-- Insert Meals for Tuesday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Tuesday', 'Breakfast', '7:30 AM - 9:30 AM'),
('Tuesday', 'Lunch', '12:00 PM - 2:00 PM'),
('Tuesday', 'Snacks', '4:00 PM - 5:30 PM'),
('Tuesday', 'Dinner', '7:30 PM - 9:30 PM');

-- Insert Menu Items for Tuesday
INSERT INTO menu_items (meal_id, item_name) VALUES
(5, 'Idli'), (5, 'Sambhar'), (5, 'Coconut Chutney'), (5, 'Coffee'),
(6, 'Roti'), (6, 'Chole'), (6, 'Rice'), (6, 'Aloo Gobi'), (6, 'Curd'), (6, 'Papad'),
(7, 'Bread Pakora'), (7, 'Sauce'), (7, 'Tea'),
(8, 'Paratha'), (8, 'Paneer Butter Masala'), (8, 'Dal'), (8, 'Salad'), (8, 'Ice Cream');

-- Insert Meals for Wednesday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Wednesday', 'Breakfast', '7:30 AM - 9:30 AM'),
('Wednesday', 'Lunch', '12:00 PM - 2:00 PM'),
('Wednesday', 'Snacks', '4:00 PM - 5:30 PM'),
('Wednesday', 'Dinner', '7:30 PM - 9:30 PM');

-- Insert Menu Items for Wednesday
INSERT INTO menu_items (meal_id, item_name) VALUES
(9, 'Upma'), (9, 'Chutney'), (9, 'Banana'), (9, 'Chai'),
(10, 'Roti'), (10, 'Kadhi Pakora'), (10, 'Rice'), (10, 'Bhindi Fry'), (10, 'Salad'),
(11, 'Vada Pav'), (11, 'Green Chutney'), (11, 'Tea'),
(12, 'Chapati'), (12, 'Dal Makhani'), (12, 'Veg Pulao'), (12, 'Raita'), (12, 'Kheer');

-- Insert Meals for Thursday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Thursday', 'Breakfast', '7:30 AM - 9:30 AM'),
('Thursday', 'Lunch', '12:00 PM - 2:00 PM'),
('Thursday', 'Snacks', '4:00 PM - 5:30 PM'),
('Thursday', 'Dinner', '7:30 PM - 9:30 PM');

-- Insert Menu Items for Thursday
INSERT INTO menu_items (meal_id, item_name) VALUES
(13, 'Aloo Paratha'), (13, 'Curd'), (13, 'Pickle'), (13, 'Tea'),
(14, 'Roti'), (14, 'Dal Fry'), (14, 'Rice'), (14, 'Cabbage Sabzi'), (14, 'Papad'),
(15, 'Pav Bhaji'), (15, 'Onion'), (15, 'Tea'),
(16, 'Chapati'), (16, 'Shahi Paneer'), (16, 'Jeera Rice'), (16, 'Salad'), (16, 'Fruit');

-- Insert Meals for Friday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Friday', 'Breakfast', '7:30 AM - 9:30 AM'),
('Friday', 'Lunch', '12:00 PM - 2:00 PM'),
('Friday', 'Snacks', '4:00 PM - 5:30 PM'),
('Friday', 'Dinner', '7:30 PM - 9:30 PM');

-- Insert Menu Items for Friday
INSERT INTO menu_items (meal_id, item_name) VALUES
(17, 'Dosa'), (17, 'Sambhar'), (17, 'Chutney'), (17, 'Coffee'),
(18, 'Roti'), (18, 'Matar Paneer'), (18, 'Rice'), (18, 'Dal'), (18, 'Raita'), (18, 'Pickle'),
(19, 'Aloo Tikki'), (19, 'Chutney'), (19, 'Chai'),
(20, 'Puri'), (20, 'Chole'), (20, 'Rice'), (20, 'Boondi Raita'), (20, 'Jalebi');

-- Insert Meals for Saturday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Saturday', 'Breakfast', '8:00 AM - 10:00 AM'),
('Saturday', 'Lunch', '12:30 PM - 2:30 PM'),
('Saturday', 'Snacks', '4:30 PM - 6:00 PM'),
('Saturday', 'Dinner', '8:00 PM - 10:00 PM');

-- Insert Menu Items for Saturday
INSERT INTO menu_items (meal_id, item_name) VALUES
(21, 'Chole Bhature'), (21, 'Lassi'), (21, 'Onion'),
(22, 'Roti'), (22, 'Dal'), (22, 'Veg Biryani'), (22, 'Raita'), (22, 'Papad'),
(23, 'Paneer Pakora'), (23, 'Sauce'), (23, 'Tea'),
(24, 'Chapati'), (24, 'Egg Curry'), (24, 'Rice'), (24, 'Salad'), (24, 'Rasmalai');

-- Insert Meals for Sunday
INSERT INTO meals (day_of_week, meal_type, time_slot) VALUES
('Sunday', 'Breakfast', '8:00 AM - 10:00 AM'),
('Sunday', 'Lunch', '12:30 PM - 2:30 PM'),
('Sunday', 'Snacks', '4:30 PM - 6:00 PM'),
('Sunday', 'Dinner', '8:00 PM - 10:00 PM');

-- Insert Menu Items for Sunday
INSERT INTO menu_items (meal_id, item_name) VALUES
(25, 'Puri Sabzi'), (25, 'Jalebi'), (25, 'Chai'),
(26, 'Special Thali'), (26, 'Naan'), (26, 'Paneer'), (26, 'Dal'), (26, 'Rice'), (26, 'Raita'), (26, 'Sweet'),
(27, 'Spring Roll'), (27, 'Sauce'), (27, 'Coffee'),
(28, 'Chapati'), (28, 'Mix Veg'), (28, 'Dal'), (28, 'Jeera Rice'), (28, 'Gulab Jamun');

-- Insert Sample Notices
INSERT INTO notices (title, message, date_posted) VALUES
('Menu Change Alert', 'No dinner service on 30th Oct due to Diwali', '2025-10-25'),
('Special Meal', 'Special festive lunch on Sunday', '2025-10-26'),
('Maintenance Notice', 'Mess will be closed for cleaning on Monday 8-10 AM', '2025-11-20');

-- Insert Sample Feedback
INSERT INTO feedback (student_name, meal, rating, comment, date_posted, verified) VALUES
('Rahul S.', 'Monday Lunch', 4, 'Dal Tadka was excellent!', '2025-10-26', TRUE),
('Priya K.', 'Sunday Breakfast', 3, 'Good but could be served hot', '2025-10-25', TRUE),
('Amit P.', 'Friday Dinner', 5, 'Amazing Chole and Jalebi!', '2025-10-24', TRUE),
('Sneha M.', 'Tuesday Breakfast', 5, 'Idli was soft and tasty!', '2025-11-20', TRUE),
('Vikram R.', 'Wednesday Dinner', 4, 'Dal Makhani needs more spices', '2025-11-19', FALSE);

CREATE DATABASE hostel_mess_db;
CREATE USER 'mess_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON hostel_mess_db.* TO 'mess_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;