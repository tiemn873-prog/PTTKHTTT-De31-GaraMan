# BÀI TẬP LỚN PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG THÔNG TIN (PTTKHTTT)

* **Học viện Công nghệ Bưu chính Viễn thông (PTIT)**
* **Khoa Công nghệ Thông tin**
* **Giảng viên hướng dẫn:** TS. Đỗ Thị Bích Ngọc
* **Nhóm môn học:** 09
* **Sinh viên thực hiện:** Nguyễn Dụng Tiềm
* **Mã sinh viên:** `B23DCCN813` (Đề tài theo hậu tố: `3`)
* **Đề tài:** **Đề số 31 - Hệ thống Quản lý Gara Ô tô (GaraMan)**

---

## 📌 2 MODULE NGHIỆP VỤ TRỌNG TÂM (ĐỀ 31)

1. **Module 1: Khách hàng đặt lịch hẹn trực tuyến (`Book Appointment 3`)**
   - Đăng nhập khách hàng
   - Chọn ngày hẹn, khung giờ còn trống và danh sách dịch vụ
   - Xác nhận thông tin cá nhân, thông tin xe và ghi chú
   - Lưu lịch hẹn vào CSDL và thông báo kết quả đặt lịch thành công
2. **Module 2: Nhân viên quản lý thống kê nhà cung cấp theo lượng hàng nhập (`View Report 3`)**
   - Đăng nhập quản lý
   - Chọn loại thống kê và khoảng ngày bắt đầu - kết thúc
   - Hiển thị bảng thống kê nhà cung cấp theo lượng hàng nhập (giảm dần)
   - Xem chi tiết danh sách các lần nhập của nhà cung cấp được chọn
   - Xem hóa đơn nhập và bảng phụ tùng tương ứng

---

## 🗂️ CẤU TRÚC THƯ MỤC DỰ ÁN

```text
d:\PTTKHTTT\
├── src\                               # Mã nguồn Java chuẩn hướng đối tượng
│   ├── model\                         # 19 Lớp thực thể (Entity Model) mang hậu tố 3
│   ├── dao\                           # 9 Lớp DAO kết nối CSDL và xử lý nghiệp vụ
│   └── unittest\                      # Kiểm thử đơn vị tự động JUnit
├── WebContent\                        # Tầng giao diện JSP & cấu hình Web
│   ├── khachhang\                     # Các trang JSP Module 1
│   ├── quanli\                        # Các trang JSP Module 2
│   ├── WEB-INF\web.xml                # Bộ điều hướng ứng dụng
│   └── WEB-INF\lib\                   # Thư viện MySQL Connector JDBC
├── database\
│   └── db_garaman3.sql                # Script tạo CSDL MySQL, Stored Procedures & dữ liệu mẫu
├── PlantUML_ThietKe_31B23DCCN813\     # Mã nguồn PlantUML và sơ đồ thiết kế
├── 31B23DCCN813.docx                  # Báo cáo bài tập lớn hoàn chỉnh
├── app.py                             # Bộ demo web nhanh Python
└── chay_he_thong.bat                  # Script khởi chạy nhanh hệ thống
```

---

## 🚀 HƯỚNG DẪN CHẠY DEMO HỆ THỐNG

1. **Khởi động server:**
   - Cách 1: Click đúp vào file `chay_he_thong.bat`.
   - Cách 2: Mở terminal tại thư mục dự án và chạy lệnh:
     ```bash
     python app.py
     ```
2. **Truy cập ứng dụng:** Mở trình duyệt web truy cập `http://localhost:8080`.
3. **Tài khoản đăng nhập demo:**
   - **Quản lý (Admin):** `admin` / `admin123`
   - **Khách hàng:** `khach01` / `123456`
