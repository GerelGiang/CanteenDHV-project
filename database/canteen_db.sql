-- ============================================================
-- DHV Canteen Management Database
-- ============================================================

-- Drop existing database if it exists and create new one
DROP DATABASE IF EXISTS canteen_db;
CREATE DATABASE canteen_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE canteen_db;

-- ============================================================
-- USERS TABLE (users)
-- role: admin = administrator, student = student
-- status: 1 = active, 0 = locked
-- ============================================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('admin', 'student') DEFAULT 'student',
    status TINYINT DEFAULT 1 COMMENT '1 = active, 0 = locked',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- FOOD CATEGORIES TABLE (categories)
-- ============================================================
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- FOODS TABLE (foods)
-- status: 1 = available, 0 = sold out/discontinued
-- is_deleted: 0 = normal, 1 = soft deleted
-- ============================================================
CREATE TABLE foods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image VARCHAR(255),
    status TINYINT DEFAULT 1 COMMENT '1 = available, 0 = sold out/discontinued',
    is_deleted TINYINT DEFAULT 0 COMMENT '0 = normal, 1 = soft deleted',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- ORDERS TABLE (orders)
-- user_id NULL = counter order (no login required)
-- status: pending = awaiting confirmation, confirmed = confirmed,
--         preparing = being prepared, completed = completed,
--         cancelled = cancelled
-- order_type: online = online order, counter = in-store purchase
-- ============================================================
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NULL COMMENT 'NULL = counter order',
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'preparing', 'completed', 'cancelled') DEFAULT 'pending',
    order_type ENUM('online', 'counter') DEFAULT 'online',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- ORDER DETAILS TABLE (order_details)
-- price: price at the time of order
-- subtotal = quantity * price
-- ============================================================
CREATE TABLE order_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    food_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL COMMENT 'Price at the time of order',
    subtotal DECIMAL(10, 2) NOT NULL COMMENT 'quantity * price',
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (food_id) REFERENCES foods(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- ------------------------------------------------------------
-- 1. USERS
-- Password admin123  -> SHA-256: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- Password student123 -> SHA-256: 703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b
-- ------------------------------------------------------------
INSERT INTO users (full_name, email, password, phone, role, status) VALUES
('Administrator', 'admin@canteen.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '0901000000', 'admin', 1),
('Nguyen Van An', 'sv1@student.edu.vn', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', '0912000001', 'student', 1),
('Tran Thi Bich', 'sv2@student.edu.vn', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', '0912000002', 'student', 1),
('Le Hoang Cuong', 'sv3@student.edu.vn', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', '0912000003', 'student', 1);

-- ------------------------------------------------------------
-- 2. FOOD CATEGORIES
-- ------------------------------------------------------------
INSERT INTO categories (name, description, image) VALUES
('Món cơm', 'Các món cơm và suất cơm', 'rice_dishes.jpg'),
('Món nước', 'Phở, bún và hủ tiếu', 'noodles.jpg'),
('Đồ uống', 'Nước ngọt, trà, cà phê', 'beverages.jpg'),
('Đồ ăn nhẹ', 'Bánh mì, bánh ngọt và đồ ăn vặt', 'snacks.jpg'),
('Trái cây', 'Trái cây tươi và trái cây cắt sẵn', 'fruits.jpg');

-- ------------------------------------------------------------
-- 3. FOODS (15-20 items, prices in VND from 15,000 - 55,000)
-- ------------------------------------------------------------

-- Category: Rice Dishes (category_id = 1)
INSERT INTO foods (category_id, name, description, price, image, status) VALUES
(1, 'Cơm thịt heo xào', 'Cơm xào cùng với thịt heo cắt hạt lựu và cà chua bi', 35000.00, 'com_suon_nuong.jpg', 1),
(1, 'Cơm gà chiên', 'Cơm trắng ăn kèm đùi gà chiên giòn và salad', 30000.00, 'com_ga_chien.jpg', 1),
(1, 'Cơm chiên Dương Châu', 'Cơm chiên với trứng, lạp xưởng và đậu Hà Lan', 28000.00, 'com_chien_duong_chau.jpg', 1),
(1, 'Cơm xào hải sản', 'Cơm xào cùng tôm, mực và cua xay nhuyễn', 32000.00, 'com_tam_bi_cha.jpg', 1);

-- Category: Noodles (category_id = 2)
INSERT INTO foods (category_id, name, description, price, image, status) VALUES
(2, 'Phở bò tái', 'Phở bò với thịt bò tái, hành lá và giá đỗ', 35000.00, 'pho_bo_tai.jpg', 1),
(2, 'Mì tôm', 'Mì nước ăn kèm cùng tôm và trứng', 38000.00, 'bun_bo_hue.jpg', 1),
(2, 'Bún riêu cua', 'Bún riêu cua với đậu hũ và rau sống', 30000.00, 'bun_rieu_cua.jpg', 1),
(2, 'Hủ tiếu xào', 'Hủ tiếu với tôm, thịt băm và gan heo', 33000.00, 'hu_tieu_nam_vang.jpg', 1);

-- Category: Beverages (category_id = 3)
INSERT INTO foods (category_id, name, description, price, image, status) VALUES
(3, 'Trà đào cam sả', 'Trà đào mát lạnh với cam tươi và sả', 20000.00, 'tra_dao_cam_sa.jpg', 1),
(3, 'Cà phê sữa đá', 'Cà phê phin truyền thống pha cùng sữa đặc', 18000.00, 'ca_phe_sua_da.jpg', 1),
(3, 'Nước ép cam', 'Nước cam tươi nguyên chất', 22000.00, 'nuoc_ep_cam.jpg', 1),
(3, 'Socola đá xay', 'Socola đá xay cùng sữa đặc béo ngậy', 25000.00, 'sinh_to_bo.jpg', 1);

-- Category: Snacks (category_id = 4)
INSERT INTO foods (category_id, name, description, price, image, status) VALUES
(4, 'Bánh mì thịt', 'Bánh mì Việt Nam với pate, thịt nguội và rau', 20000.00, 'banh_mi_thit.jpg', 1),
(4, 'Thịt bò nướng', 'Thịt bò nướng ngũ vị', 15000.00, 'banh_trang_tron.jpg', 1),
(4, 'Nước súp cà ri', 'nước súp nóng', 22000.00, 'xoi_ga.jpg', 1);

-- Category: Fruits (category_id = 5)
INSERT INTO foods (category_id, name, description, price, image, status) VALUES
(5, 'Trái cây thập cẩm', 'Dưa hấu, ổi, xoài và thanh long cắt sẵn', 20000.00, 'trai_cay_thap_cam.jpg', 1),
(5, 'Chuối sấy dẻo', 'Chuối sấy dẻo tự nhiên, không thêm đường', 15000.00, 'chuoi_say_deo.jpg', 1),
(5, 'Nho tươi', 'Nho xanh không hạt nhập khẩu, ngọt và mọng nước', 55000.00, 'nho_xanh.jpg', 1);

-- ------------------------------------------------------------
-- 4. SAMPLE ORDERS
-- ------------------------------------------------------------

-- Order 1: Student An orders online - completed
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(2, 55000.00, 'completed', 'online', 'Not spicy');
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(1, 1, 1, 35000.00, 35000.00),  -- Grilled Pork Chop Rice
(1, 10, 1, 20000.00, 20000.00); -- Peach Lemongrass Tea

-- Order 2: Student Bich orders online - preparing
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(3, 73000.00, 'preparing', 'online', NULL);
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(2, 5, 1, 35000.00, 35000.00),  -- Rare Beef Pho
(2, 6, 1, 38000.00, 38000.00);  -- Hue Spicy Beef Noodle Soup

-- Order 3: Counter order (no user required) - completed
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(NULL, 50000.00, 'completed', 'counter', 'Takeaway');
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(3, 2, 1, 30000.00, 30000.00),  -- Fried Chicken Rice
(3, 14, 1, 20000.00, 20000.00); -- Vietnamese Banh Mi Sandwich

-- Order 4: Student Cuong orders online - pending confirmation
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(4, 60000.00, 'pending', 'online', 'Deliver at 11:30 AM');
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(4, 4, 1, 32000.00, 32000.00),  -- Broken Rice with Pork Skin & Meat Roll
(4, 3, 1, 28000.00, 28000.00);  -- Yang Chow Fried Rice

-- Order 5: Student An places another order - confirmed
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(2, 40000.00, 'confirmed', 'online', NULL);
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(5, 15, 1, 15000.00, 15000.00), -- Mixed Rice Paper Salad
(5, 13, 1, 25000.00, 25000.00); -- Avocado Smoothie

-- Order 6: Counter order - completed
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(NULL, 46000.00, 'completed', 'counter', NULL);
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(6, 10, 2, 18000.00, 36000.00), -- 2x Iced Vietnamese Coffee
(6, 17, 1, 15000.00, 15000.00); -- Dried Banana Chips (actual total = 36000+15000=51000, fixing total)

-- Fix total_amount for order 6
UPDATE orders SET total_amount = 51000.00 WHERE id = 6;

-- Order 7: Student Bich - cancelled
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(3, 35000.00, 'cancelled', 'online', 'Cancelled due to change of mind');
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(7, 7, 1, 30000.00, 30000.00),  -- Crab Paste Noodle Soup
(7, 12, 1, 22000.00, 22000.00); -- Orange Juice (total = 52000, fixing total)

-- Fix total_amount for order 7
UPDATE orders SET total_amount = 52000.00 WHERE id = 7;

-- Order 8: Student Cuong orders online - completed
INSERT INTO orders (user_id, total_amount, status, order_type, note) VALUES
(4, 57000.00, 'completed', 'online', 'Extra chili sauce');
INSERT INTO order_details (order_id, food_id, quantity, price, subtotal) VALUES
(8, 1, 1, 35000.00, 35000.00),  -- Grilled Pork Chop Rice
(8, 16, 1, 22000.00, 22000.00); -- Chicken Sticky Rice

-- ============================================================
-- COMPLETE - Database canteen_db is ready to use
-- ============================================================
