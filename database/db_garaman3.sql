-- ========================================================
-- CƠ SỞ DỮ LIỆU HỆ THỐNG QUẢN LÝ GARA Ô TÔ (GaraMan) - ĐỀ 31
-- Sinh viên: Nguyễn Dụng Tiềm - B23DCCN813 (Hậu tố 3)
-- ========================================================

CREATE DATABASE IF NOT EXISTS `db_garaman3` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_garaman3`;

-- 1. Bảng thành viên tblMember3
DROP TABLE IF EXISTS `tblAppointmentDetail3`;
DROP TABLE IF EXISTS `tblAppointment3`;
DROP TABLE IF EXISTS `tblCar3`;
DROP TABLE IF EXISTS `tblCustomer3`;
DROP TABLE IF EXISTS `tblEmployee3`;
DROP TABLE IF EXISTS `tblImportDetail3`;
DROP TABLE IF EXISTS `tblImportReceipt3`;
DROP TABLE IF EXISTS `tblSparePart3`;
DROP TABLE IF EXISTS `tblPartCategory3`;
DROP TABLE IF EXISTS `tblSupplier3`;
DROP TABLE IF EXISTS `tblTimeSlot3`;
DROP TABLE IF EXISTS `tblService3`;
DROP TABLE IF EXISTS `tblServiceCategory3`;
DROP TABLE IF EXISTS `tblMember3`;

CREATE TABLE `tblMember3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20),
    `email` VARCHAR(100),
    `address` VARCHAR(255),
    `role` VARCHAR(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Bảng khách hàng tblCustomer3
CREATE TABLE `tblCustomer3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `memberId` INT NOT NULL,
    `licenseNo` VARCHAR(50),
    `customerType` VARCHAR(50) DEFAULT 'Regular',
    FOREIGN KEY (`memberId`) REFERENCES `tblMember3`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Bảng xe tblCar3
CREATE TABLE `tblCar3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `customerId` INT NOT NULL,
    `licensePlate` VARCHAR(20) NOT NULL,
    `brand` VARCHAR(50) NOT NULL,
    `model` VARCHAR(50) NOT NULL,
    `color` VARCHAR(30),
    `year` INT,
    FOREIGN KEY (`customerId`) REFERENCES `tblCustomer3`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Bảng danh mục dịch vụ tblServiceCategory3
CREATE TABLE `tblServiceCategory3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Bảng dịch vụ tblService3
CREATE TABLE `tblService3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `categoryId` INT,
    `name` VARCHAR(100) NOT NULL,
    `price` DECIMAL(12,2) NOT NULL,
    `estimatedDuration` INT DEFAULT 60,
    `description` TEXT,
    FOREIGN KEY (`categoryId`) REFERENCES `tblServiceCategory3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Bảng khung giờ tblTimeSlot3
CREATE TABLE `tblTimeSlot3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `startTime` TIME NOT NULL,
    `endTime` TIME NOT NULL,
    `maxCapacity` INT DEFAULT 5,
    `status` VARCHAR(20) DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Bảng lịch hẹn tblAppointment3
CREATE TABLE `tblAppointment3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `appointmentCode` VARCHAR(50) NOT NULL UNIQUE,
    `customerId` INT NOT NULL,
    `carId` INT NOT NULL,
    `timeSlotId` INT NOT NULL,
    `appointmentDate` DATE NOT NULL,
    `totalAmount` DECIMAL(12,2) DEFAULT 0,
    `status` VARCHAR(30) DEFAULT 'Confirmed',
    `note` TEXT,
    `createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`customerId`) REFERENCES `tblCustomer3`(`id`),
    FOREIGN KEY (`carId`) REFERENCES `tblCar3`(`id`),
    FOREIGN KEY (`timeSlotId`) REFERENCES `tblTimeSlot3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Bảng chi tiết lịch hẹn tblAppointmentDetail3
CREATE TABLE `tblAppointmentDetail3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `appointmentId` INT NOT NULL,
    `serviceId` INT NOT NULL,
    `price` DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (`appointmentId`) REFERENCES `tblAppointment3`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`serviceId`) REFERENCES `tblService3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Bảng nhà cung cấp tblSupplier3
CREATE TABLE `tblSupplier3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(150) NOT NULL,
    `address` VARCHAR(255),
    `phone` VARCHAR(20),
    `email` VARCHAR(100),
    `taxCode` VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Bảng danh mục phụ tùng tblPartCategory3
CREATE TABLE `tblPartCategory3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Bảng phụ tùng tblSparePart3
CREATE TABLE `tblSparePart3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `categoryId` INT,
    `code` VARCHAR(50) NOT NULL UNIQUE,
    `name` VARCHAR(150) NOT NULL,
    `unit` VARCHAR(30) DEFAULT 'Cái',
    `price` DECIMAL(12,2) NOT NULL,
    `description` TEXT,
    FOREIGN KEY (`categoryId`) REFERENCES `tblPartCategory3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. Bảng phiếu nhập phụ tùng tblImportReceipt3
CREATE TABLE `tblImportReceipt3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `receiptCode` VARCHAR(50) NOT NULL UNIQUE,
    `supplierId` INT NOT NULL,
    `warehouseStaffId` INT NOT NULL,
    `importDate` DATE NOT NULL,
    `totalAmount` DECIMAL(12,2) DEFAULT 0,
    `note` TEXT,
    FOREIGN KEY (`supplierId`) REFERENCES `tblSupplier3`(`id`),
    FOREIGN KEY (`warehouseStaffId`) REFERENCES `tblMember3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 13. Bảng chi tiết phiếu nhập tblImportDetail3
CREATE TABLE `tblImportDetail3` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `receiptId` INT NOT NULL,
    `sparePartId` INT NOT NULL,
    `quantity` INT NOT NULL,
    `unitPrice` DECIMAL(12,2) NOT NULL,
    `amount` DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (`receiptId`) REFERENCES `tblImportReceipt3`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`sparePartId`) REFERENCES `tblSparePart3`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================================
-- STORED PROCEDURES
-- ========================================================

DELIMITER //

DROP PROCEDURE IF EXISTS `sp_checkLogin3`//
CREATE PROCEDURE `sp_checkLogin3`(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(50)
)
BEGIN
    SELECT id, username, password, name, phone, email, address, role
    FROM tblMember3
    WHERE username = p_username AND password = p_password;
END //

DROP PROCEDURE IF EXISTS `sp_getCustomerInfo3`//
CREATE PROCEDURE `sp_getCustomerInfo3`(
    IN p_memberId INT
)
BEGIN
    SELECT c.id AS customerId, m.id AS memberId, m.name, m.phone, m.email, 
           m.address, c.licenseNo, c.customerType
    FROM tblCustomer3 c
    JOIN tblMember3 m ON c.memberId = m.id
    WHERE m.id = p_memberId;
END //

DROP PROCEDURE IF EXISTS `sp_getCarOfCustomer3`//
CREATE PROCEDURE `sp_getCarOfCustomer3`(
    IN p_customerId INT
)
BEGIN
    SELECT id, customerId, licensePlate, brand, model, color, year
    FROM tblCar3
    WHERE customerId = p_customerId;
END //

DROP PROCEDURE IF EXISTS `sp_saveCar3`//
CREATE PROCEDURE `sp_saveCar3`(
    IN p_customerId INT,
    IN p_licensePlate VARCHAR(20),
    IN p_brand VARCHAR(50),
    IN p_model VARCHAR(50),
    IN p_color VARCHAR(30),
    IN p_year INT,
    OUT p_carId INT
)
BEGIN
    INSERT INTO tblCar3(customerId, licensePlate, brand, model, color, year)
    VALUES (p_customerId, p_licensePlate, p_brand, p_model, p_color, p_year);
    SET p_carId = LAST_INSERT_ID();
END //

DROP PROCEDURE IF EXISTS `sp_getServiceList3`//
CREATE PROCEDURE `sp_getServiceList3`()
BEGIN
    SELECT s.id, s.name, s.price, s.estimatedDuration, s.description,
           s.categoryId, c.name AS categoryName
    FROM tblService3 s
    LEFT JOIN tblServiceCategory3 c ON s.categoryId = c.id
    ORDER BY c.name ASC, s.name ASC;
END //

DROP PROCEDURE IF EXISTS `sp_getAvailableSlot3`//
CREATE PROCEDURE `sp_getAvailableSlot3`(
    IN p_date DATE
)
BEGIN
    SELECT ts.id, ts.startTime, ts.endTime, ts.maxCapacity,
           COUNT(a.id) AS bookedCount
    FROM tblTimeSlot3 ts
    LEFT JOIN tblAppointment3 a 
           ON ts.id = a.timeSlotId 
           AND a.appointmentDate = p_date 
           AND a.status != 'Cancelled'
    WHERE ts.status = 'Active'
    GROUP BY ts.id, ts.startTime, ts.endTime, ts.maxCapacity
    HAVING COUNT(a.id) < ts.maxCapacity
    ORDER BY ts.startTime ASC;
END //

DROP PROCEDURE IF EXISTS `sp_checkDuplicateSlot3`//
CREATE PROCEDURE `sp_checkDuplicateSlot3`(
    IN p_customerId INT,
    IN p_date DATE,
    IN p_slotId INT,
    OUT p_isDuplicate INT
)
BEGIN
    SELECT COUNT(*) INTO p_isDuplicate
    FROM tblAppointment3
    WHERE customerId = p_customerId 
      AND appointmentDate = p_date 
      AND timeSlotId = p_slotId 
      AND status != 'Cancelled';
END //

DROP PROCEDURE IF EXISTS `sp_saveAppointment3`//
CREATE PROCEDURE `sp_saveAppointment3`(
    IN p_customerId INT,
    IN p_carId INT,
    IN p_timeSlotId INT,
    IN p_date DATE,
    IN p_totalAmount DECIMAL(12,2),
    IN p_note TEXT,
    OUT p_appId INT,
    OUT p_appCode VARCHAR(50)
)
BEGIN
    DECLARE v_nextId INT;
    SET v_nextId = (SELECT IFNULL(MAX(id), 0) + 1 FROM tblAppointment3);
    SET p_appCode = CONCAT('AP3-', DATE_FORMAT(p_date, '%Y%m%d'), '-', LPAD(v_nextId, 4, '0'));
    
    INSERT INTO tblAppointment3(appointmentCode, customerId, carId, timeSlotId, appointmentDate, totalAmount, status, note, createdDate)
    VALUES (p_appCode, p_customerId, p_carId, p_timeSlotId, p_date, p_totalAmount, 'Confirmed', p_note, NOW());
    
    SET p_appId = LAST_INSERT_ID();
END //

DROP PROCEDURE IF EXISTS `sp_saveAppointmentDetail3`//
CREATE PROCEDURE `sp_saveAppointmentDetail3`(
    IN p_appId INT,
    IN p_serviceId INT,
    IN p_price DECIMAL(12,2)
)
BEGIN
    INSERT INTO tblAppointmentDetail3(appointmentId, serviceId, price)
    VALUES (p_appId, p_serviceId, p_price);
END //

DROP PROCEDURE IF EXISTS `sp_tkNCCtheoLuongNhap3`//
CREATE PROCEDURE `sp_tkNCCtheoLuongNhap3`(
    IN p_fromDate DATE,
    IN p_toDate DATE
)
BEGIN
    SELECT s.id, s.code, s.name, s.address, s.phone, s.email, s.taxCode,
           COUNT(DISTINCT r.id) AS totalReceipts,
           IFNULL(SUM(d.quantity), 0) AS totalQuantity,
           IFNULL(SUM(d.amount), 0) AS totalAmount
    FROM tblSupplier3 s
    LEFT JOIN tblImportReceipt3 r ON s.id = r.supplierId 
         AND r.importDate BETWEEN p_fromDate AND p_toDate
    LEFT JOIN tblImportDetail3 d ON r.id = d.receiptId
    GROUP BY s.id, s.code, s.name, s.address, s.phone, s.email, s.taxCode
    ORDER BY totalQuantity DESC, totalAmount DESC;
END //

DROP PROCEDURE IF EXISTS `sp_chiTietNhapNCC3`//
CREATE PROCEDURE `sp_chiTietNhapNCC3`(
    IN p_supplierId INT,
    IN p_fromDate DATE,
    IN p_toDate DATE
)
BEGIN
    SELECT r.id, r.receiptCode, r.importDate, r.totalAmount, r.note,
           w.name AS staffName,
           IFNULL(SUM(d.quantity), 0) AS totalPartCount
    FROM tblImportReceipt3 r
    JOIN tblMember3 w ON r.warehouseStaffId = w.id
    LEFT JOIN tblImportDetail3 d ON r.id = d.receiptId
    WHERE r.supplierId = p_supplierId 
      AND r.importDate BETWEEN p_fromDate AND p_toDate
    GROUP BY r.id, r.receiptCode, r.importDate, r.totalAmount, r.note, w.name
    ORDER BY r.importDate DESC;
END //

DROP PROCEDURE IF EXISTS `sp_hoaDonNhapChiTiet3`//
CREATE PROCEDURE `sp_hoaDonNhapChiTiet3`(
    IN p_receiptId INT
)
BEGIN
    SELECT r.id AS receiptId, r.receiptCode, r.importDate, r.totalAmount AS receiptTotalAmount,
           s.name AS supplierName, s.address AS supplierAddress,
           d.id AS detailId, d.quantity, d.unitPrice, d.amount,
           p.id AS partId, p.code AS partCode, p.name AS partName, p.unit
    FROM tblImportReceipt3 r
    JOIN tblSupplier3 s ON r.supplierId = s.id
    JOIN tblImportDetail3 d ON r.id = d.receiptId
    JOIN tblSparePart3 p ON d.sparePartId = p.id
    WHERE r.id = p_receiptId
    ORDER BY d.id ASC;
END //

DELIMITER ;

-- ========================================================
-- DỮ LIỆU MẪU BAN ĐẦU
-- ========================================================

INSERT INTO `tblMember3` (`id`, `username`, `password`, `name`, `phone`, `email`, `address`, `role`) VALUES
(1, 'khachhang1', '123456', 'Nguyễn Dụng Tiềm', '0988123456', 'tiem.nd@garaman.vn', 'Hà Đông, Hà Nội', 'Customer'),
(2, 'khachhang2', '123456', 'Trần Văn Nam', '0912345678', 'nam.tv@gmail.com', 'Cầu Giấy, Hà Nội', 'Customer'),
(3, 'quanli1', '123456', 'Đỗ Thị Bích Ngọc', '0901234567', 'ngoc.dtb@garaman.vn', 'Thanh Xuân, Hà Nội', 'Manager'),
(4, 'nhanvienkho1', '123456', 'Lê Văn Kho', '0934567890', 'kho.lv@garaman.vn', 'Hoàng Mai, Hà Nội', 'WarehouseStaff');

INSERT INTO `tblCustomer3` (`id`, `memberId`, `licenseNo`, `customerType`) VALUES
(1, 1, 'B2-998877', 'VIP'),
(2, 2, 'B2-556677', 'Regular');

INSERT INTO `tblCar3` (`id`, `customerId`, `licensePlate`, `brand`, `model`, `color`, `year`) VALUES
(1, 1, '30F-888.99', 'Toyota', 'Camry 2.5Q', 'Đen', 2021),
(2, 1, '29A-666.88', 'Mazda', 'CX-5', 'Đỏ', 2022),
(3, 2, '30E-123.45', 'Honda', 'City RS', 'Trắng', 2020);

INSERT INTO `tblServiceCategory3` (`id`, `name`, `description`) VALUES
(1, 'Bảo dưỡng định kỳ', 'Các gói bảo dưỡng tiêu chuẩn theo số km'),
(2, 'Sửa chữa động cơ & Hộp số', 'Đại tu, sửa chữa và thay thế chi tiết máy'),
(3, 'Chăm sóc xe & Làm đẹp', 'Rửa khoang máy, phủ ceramic, đánh bóng');

INSERT INTO `tblService3` (`id`, `categoryId`, `name`, `price`, `estimatedDuration`, `description`) VALUES
(1, 1, 'Bảo dưỡng cấp 1 (5.000 km)', 250000.00, 45, 'Thay dầu nhớt động cơ, vệ sinh lọc gió, kiểm tra 20 hạng mục'),
(2, 1, 'Bảo dưỡng cấp 2 (10.000 km)', 450000.00, 60, 'Thay dầu nhớt, lọc dầu, kiểm tra phanh và hệ thống gầm'),
(3, 2, 'Vệ sinh họng hút & kim phun', 350000.00, 60, 'Vệ sinh kim phun nhiên liệu và bướm ga chuyên sâu'),
(4, 2, 'Thay dầu hộp số tự động', 850000.00, 90, 'Tuần hoàn thay dầu hộp số chuyên dụng'),
(5, 3, 'Rửa chi tiết khoang máy', 300000.00, 45, 'Rửa dưỡng khoang máy bằng hóa chất Sonax chuyên dụng');

INSERT INTO `tblTimeSlot3` (`id`, `startTime`, `endTime`, `maxCapacity`, `status`) VALUES
(1, '08:00:00', '09:30:00', 4, 'Active'),
(2, '09:30:00', '11:00:00', 4, 'Active'),
(3, '13:30:00', '15:00:00', 4, 'Active'),
(4, '15:00:00', '16:30:00', 4, 'Active');

INSERT INTO `tblSupplier3` (`id`, `code`, `name`, `address`, `phone`, `email`, `taxCode`) VALUES
(1, 'NCC01', 'Công ty Phụ tùng Ô tô Bosch Việt Nam', 'KCN Đình Vũ, Hải Phòng', '02253888999', 'contact@bosch.com.vn', '0102030405'),
(2, 'NCC02', 'Tổng đại lý Dầu nhờn Motul Hà Nội', 'Mỹ Đình 2, Nam Từ Liêm, Hà Nội', '02437891234', 'sales@motulvietnam.vn', '0103040506'),
(3, 'NCC03', 'Công ty Phụ tùng Toyota Chính Hãng Vĩnh Phúc', 'Bình Xuyên, Vĩnh Phúc', '02113666777', 'parts@toyota-parts.vn', '0104050607');

INSERT INTO `tblPartCategory3` (`id`, `name`, `description`) VALUES
(1, 'Dầu nhớt & Phụ gia', 'Nhớt động cơ, dầu phanh, nước làm mát'),
(2, 'Hệ thống lọc', 'Lọc dầu, lọc gió động cơ, lọc gió điều hòa'),
(3, 'Hệ thống phanh', 'Má phanh, đĩa phanh, dầu phanh');

INSERT INTO `tblSparePart3` (`id`, `categoryId`, `code`, `name`, `unit`, `price`, `description`) VALUES
(1, 1, 'PT-MOTUL-01', 'Dầu nhớt Motul 300V 5W40 (Can 4L)', 'Can', 850000.00, 'Dầu nhớt tổng hợp cao cấp'),
(2, 2, 'PT-BOSCH-L01', 'Lọc dầu Bosch Camry/Vios', 'Cái', 95000.00, 'Lọc dầu động cơ chính hãng Bosch'),
(3, 2, 'PT-BOSCH-G01', 'Lọc gió động cơ Bosch', 'Cái', 150000.00, 'Lọc bụi bảo vệ họng nạp'),
(4, 3, 'PT-TOYOTA-P01', 'Bộ má phanh trước Toyota Camry', 'Bộ', 1250000.00, 'Má phanh gốm cao cấp');

INSERT INTO `tblImportReceipt3` (`id`, `receiptCode`, `supplierId`, `warehouseStaffId`, `importDate`, `totalAmount`, `note`) VALUES
(1, 'PN-20261010-001', 1, 4, '2026-10-10', 24500000.00, 'Nhập lô lọc dầu và lọc gió quý 4'),
(2, 'PN-20261015-002', 2, 4, '2026-10-15', 42500000.00, 'Nhập đợt nhớt Motul khuyến mại'),
(3, 'PN-20261025-003', 1, 4, '2026-10-25', 18900000.00, 'Nhập bổ sung má phanh');

INSERT INTO `tblImportDetail3` (`id`, `receiptId`, `sparePartId`, `quantity`, `unitPrice`, `amount`) VALUES
(1, 1, 2, 100, 95000.00, 9500000.00),
(2, 1, 3, 100, 150000.00, 15000000.00),
(3, 2, 1, 50, 850000.00, 42500000.00),
(4, 3, 4, 15, 1260000.00, 18900000.00);

INSERT INTO `tblAppointment3` (`id`, `appointmentCode`, `customerId`, `carId`, `timeSlotId`, `appointmentDate`, `totalAmount`, `status`, `note`) VALUES
(1, 'AP3-20261115-0001', 1, 1, 2, '2026-11-15', 700000.00, 'Confirmed', 'Khách hẹn kiểm tra tiếng kêu');

INSERT INTO `tblAppointmentDetail3` (`id`, `appointmentId`, `serviceId`, `price`) VALUES
(1, 1, 1, 250000.00),
(2, 1, 2, 450000.00);
