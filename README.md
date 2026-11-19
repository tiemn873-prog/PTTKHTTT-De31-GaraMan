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
   - Đăng nhập khách hàng (`Login3.jsp` / `gddangnhap.jsp`)
   - Trang chủ khách hàng (`CustomerMain3.jsp`)
   - Chọn ngày hẹn, khung giờ dạng bảng và danh sách dịch vụ (`SelectSlot3.jsp`)
   - Xác nhận thông tin khách hàng, phương tiện và ghi chú (`ConfirmInfo3.jsp`)
   - Lưu lịch hẹn vào CSDL với trạng thái *Chờ xác nhận* và hiển thị kết quả (`SaveAppointment3.jsp`)

2. **Module 2: Quản lý thống kê nhà cung cấp theo lượng hàng nhập (`View Report 3`)**
   - Đăng nhập quản lý (`Login3.jsp` / `gddangnhap.jsp`)
   - Trang chủ quản lý (`ManagerMain3.jsp`)
   - Chọn loại thống kê và khoảng ngày bắt đầu - kết thúc (`SelectReport3.jsp`)
   - Hiển thị bảng thống kê nhà cung cấp theo lượng hàng nhập giảm dần (`SupplierReport3.jsp`)
   - Xem chi tiết danh sách các lần nhập của nhà cung cấp (`ImportDetail3.jsp`)
   - Xem hóa đơn chi tiết từng lần nhập (`ImportInvoice3.jsp`)

---

## 🗂️ CẤU TRÚC MÃ NGUỒN JAVA & WEB (ECLIPSE DYNAMIC WEB PROJECT)

```text
d:\PTTKHTTT\
├── src\
│   ├── model\                         # Các lớp thực thể (Entity Model) khớp 100% Sơ đồ lớp
│   │   ├── Member3.java, FullName3.java, Address3.java
│   │   ├── Customer3.java, Car3.java
│   │   ├── Appointment3.java, AppointmentDetail3.java, TimeSlot3.java, Service3.java
│   │   ├── Supplier3.java, SupplierStatistic3.java, ImportReceipt3.java, ImportDetail3.java, SparePart3.java
│   │   └── ...
│   ├── dao\                           # Các lớp Data Access Object kế thừa DAO3
│   │   ├── DAO3.java (và DAO.java)
│   │   ├── ServiceDAO3.java (và Service3DAO.java)
│   │   ├── TimeSlotDAO3.java (và TimeSlot3DAO.java)
│   │   ├── CustomerDAO3.java (và Customer3DAO.java)
│   │   ├── CarDAO3.java (và Car3DAO.java)
│   │   ├── AppointmentDAO3.java (và Appointment3DAO.java)
│   │   ├── SupplierStatisticDAO3.java (và SupplierStatistic3DAO.java)
│   │   ├── ImportReceiptDAO3.java (và ImportReceipt3DAO.java)
│   │   └── MemberDAO3.java (và Member3DAO.java)
│   └── unittest\                      # Kiểm thử đơn vị tự động DAO
│       └── TestAppointment3DAO.java
├── WebContent\                        # Thư mục Web tiêu chuẩn chạy Apache Tomcat
│   ├── thanhvien\                     # Gói view.thanhvien (Login3.jsp, doLogin3.jsp)
│   ├── khachhang\                     # Gói view.khachhang (CustomerMain3, SelectSlot3, ConfirmInfo3, SaveAppointment3)
│   ├── quanli\                        # Gói view.quanli (ManagerMain3, SelectReport3, SupplierReport3, ImportDetail3, ImportInvoice3)
│   ├── WEB-INF\
│   │   ├── web.xml                    # Cấu hình Web Application Deployment Descriptor
│   │   └── lib\                       # Thư viện MySQL Connector JDBC (mysql-connector-j-9.1.0.jar)
│   ├── gddangnhap.jsp                 # Giao diện đăng nhập gốc
│   └── doDangnhap.jsp                 # Xử lý điều hướng đăng nhập
├── database\
│   └── db_garaman3.sql                # Script tạo Database, Bảng, Stored Procedures & Dữ liệu mẫu
└── README.md
```

---

## 🚀 HƯỚNG DẪN CÀI ĐẶT VÀ TRIỂN KHAI TRÊN TOMCAT

### 1. Cấu hình Cơ sở dữ liệu (MySQL)
1. Cài đặt MySQL 8.x hoặc 9.x (port mặc định `3306`).
2. Mở MySQL Workbench hoặc terminal, thực thi file script:
   ```sql
   source database/db_garaman3.sql;
   ```
3. CSDL `db_garaman3` sẽ được khởi tạo với đầy đủ các bảng, ràng buộc khóa ngoại, stored procedures và dữ liệu mẫu kiểm thử.

### 2. Triển khai dự án trên Eclipse IDE & Apache Tomcat
1. Mở Eclipse IDE for Enterprise Java and Web Developers.
2. Chọn `File` -> `Import` -> `Existing Projects into Workspace` và chọn thư mục dự án `d:\PTTKHTTT`.
3. Cấu hình Apache Tomcat (phiên bản 9.0 / 10.1):
   - Mở tab `Servers`, chuột phải chọn `New` -> `Server`.
   - Chọn `Apache Tomcat` tương ứng và liên kết với thư mục cài đặt Tomcat.
   - Thêm dự án vào Tomcat: `Add and Remove...` -> Chọn dự án `PTTKHTTT` -> `Add` -> `Finish`.
4. Nhấn chuột phải vào Server Tomcat -> Chọn `Start`.
5. Mở trình duyệt web truy cập:
   ```text
   http://localhost:8080/PTTKHTTT/gddangnhap.jsp
   ```
   hoặc:
   ```text
   http://localhost:8080/PTTKHTTT/thanhvien/Login3.jsp
   ```

### 3. Tài khoản đăng nhập kiểm thử
* **Tài khoản Quản lý (Manager):**
  - Tên đăng nhập: `quanly1`
  - Mật khẩu: `123456`
* **Tài khoản Khách hàng (Customer):**
  - Tên đăng nhập: `khachhang1`
  - Mật khẩu: `123456`
