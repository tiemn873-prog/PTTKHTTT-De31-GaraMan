import http.server
import json
import os
import re
import socketserver
import sys
import urllib.parse
import webbrowser

# Add site-packages from existing venv to enable mysql.connector
venv_site = r"D:\PTHTTM\student_eval_project\.venv\Lib\site-packages"
if os.path.exists(venv_site) and venv_site not in sys.path:
    sys.path.append(venv_site)

try:
    import mysql.connector
    HAS_MYSQL = True
except ImportError:
    HAS_MYSQL = False

import sqlite3

PORT = 8080

def get_param(d, key, default=""):
    """Safely get a parameter whether it's stored as a list or a single value."""
    if not isinstance(d, dict):
        return default
    val = d.get(key, default)
    if isinstance(val, list):
        return val[0] if len(val) > 0 else default
    return val if val is not None else default

MYSQL_HOST = "localhost"
MYSQL_PORT = 3306
MYSQL_USER = "root"
MYSQL_PASS = "Tiem08052005*"
MYSQL_DB = "db_garaman3"
SQLITE_PATH = r"d:\PTTKHTTT\database\garaman3.db"

def get_connection():
    if HAS_MYSQL:
        try:
            conn = mysql.connector.connect(
                host=MYSQL_HOST,
                port=MYSQL_PORT,
                user=MYSQL_USER,
                password=MYSQL_PASS,
                database=MYSQL_DB,
                charset='utf8mb4'
            )
            return conn, "MYSQL"
        except Exception as e:
            print(f"[WARN] MySQL connect failed: {e}. Falling back to SQLite.")

    conn = sqlite3.connect(SQLITE_PATH)
    conn.row_factory = sqlite3.Row
    return conn, "SQLITE"

def execute_query(query, params=(), fetch_all=True, fetch_one=False, commit=False):
    conn, engine = get_connection()
    cur = conn.cursor(dictionary=True) if engine == "MYSQL" else conn.cursor()

    # Adapt query syntax if needed (%s for mysql, ? for sqlite)
    if engine == "SQLITE":
        adapted_query = query.replace("%s", "?")
    else:
        adapted_query = query.replace("?", "%s")

    cur.execute(adapted_query, params)

    res = None
    last_id = None
    if commit:
        conn.commit()
        last_id = cur.lastrowid
    elif fetch_one:
        row = cur.fetchone()
        if row and engine == "SQLITE":
            res = dict(row)
        else:
            res = row
    elif fetch_all:
        rows = cur.fetchall()
        if engine == "SQLITE":
            res = [dict(r) for r in rows]
        else:
            res = rows

    cur.close()
    conn.close()
    if commit:
        return last_id
    return res

# HTML Template Helper
def get_header(title, user_info=None):
    user_bar = ""
    if user_info:
        user_bar = f"""
        <div style="font-size: 13px; text-align: right; background: rgba(255,255,255,0.15); padding: 8px 16px; border-radius: 6px;">
            Xin chào: <strong>{user_info.get('name', '')}</strong> |
            <a href="/logout" style="color: #ffc107; font-weight: bold; text-decoration: none; margin-left: 8px;">[Đăng xuất]</a>
        </div>
        """
    return f"""<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} - GaraMan</title>
    <style>
        * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }}
        body {{ background-color: #f4f6f9; color: #333; min-height: 100vh; display: flex; flex-direction: column; }}
        header {{ background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); color: white; padding: 16px 30px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }}
        .header-wrap {{ max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }}
        .brand h1 {{ font-size: 22px; font-weight: 700; }}
        .brand span {{ font-size: 13px; opacity: 0.9; }}
        main {{ flex: 1; max-width: 1100px; width: 100%; margin: 30px auto; padding: 0 20px; }}
        .card {{ background: white; border-radius: 8px; border: 1px solid #dee2e6; box-shadow: 0 4px 12px rgba(0,0,0,0.05); overflow: hidden; margin-bottom: 24px; }}
        .card-header {{ padding: 14px 20px; background: #fafbfc; border-bottom: 1px solid #dee2e6; font-size: 16px; font-weight: 700; color: #1e3c72; display: flex; justify-content: space-between; align-items: center; }}
        .card-body {{ padding: 24px; }}
        .btn {{ display: inline-flex; align-items: center; justify-content: center; padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 600; text-decoration: none; border: none; cursor: pointer; transition: all 0.2s; }}
        .btn-primary {{ background: #0d6efd; color: white; }}
        .btn-primary:hover {{ background: #0b5ed7; }}
        .btn-success {{ background: #198754; color: white; }}
        .btn-success:hover {{ background: #157347; }}
        .btn-secondary {{ background: #6c757d; color: white; }}
        .btn-secondary:hover {{ background: #5c636a; }}
        .btn-sm {{ padding: 6px 12px; font-size: 13px; }}
        table {{ width: 100%; border-collapse: collapse; margin: 16px 0; font-size: 14px; }}
        th, td {{ padding: 12px 14px; border: 1px solid #dee2e6; text-align: left; }}
        th {{ background: #f1f4f9; font-weight: 600; color: #333; }}
        tr:nth-child(even) {{ background: #fafbfc; }}
        tr:hover {{ background: #f0f7ff; }}
        .form-group {{ margin-bottom: 16px; }}
        label {{ display: block; margin-bottom: 6px; font-weight: 600; font-size: 13px; color: #495057; }}
        input[type="text"], input[type="password"], input[type="date"], select {{ width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; outline: none; }}
        input:focus, select:focus {{ border-color: #0d6efd; box-shadow: 0 0 0 3px rgba(13,110,253,0.15); }}
        .grid-2 {{ display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }}
        .grid-3 {{ display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }}
        .badge {{ display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }}
        .badge-success {{ background: #d1e7dd; color: #0f5132; }}
        .badge-info {{ background: #cff4fc; color: #055160; }}
        .alert {{ padding: 12px 16px; border-radius: 6px; margin-bottom: 18px; font-size: 14px; }}
        .alert-success {{ background: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }}
        .alert-danger {{ background: #f8d7da; color: #842029; border: 1px solid #f5c2c7; }}
        footer {{ background: white; border-top: 1px solid #dee2e6; padding: 14px; text-align: center; font-size: 13px; color: #6c757d; margin-top: auto; }}
    </style>
</head>
<body>
    <header>
        <div class="header-wrap">
            <div class="brand">
                <h1>HỆ THỐNG QUẢN LÝ GARA Ô TÔ GARAMAN</h1>
                <span>Phần mềm quản lý dịch vụ bảo dưỡng và phụ tùng ô tô</span>
            </div>
            {user_bar}
        </div>
    </header>
    <main>
"""

def get_footer():
    return """
    </main>
    <footer>
        Hệ thống Quản lý Gara Ô tô GaraMan © 2026
    </footer>
</body>
</html>
"""

# Sessions in memory: cookie -> user dict
SESSIONS = {}

class GaraHandler(http.server.BaseHTTPRequestHandler):
    def get_session_user(self):
        cookie = self.headers.get('Cookie', '')
        match = re.search(r'session_id=([a-zA-Z0-9_-]+)', cookie)
        if match:
            sess_id = match.group(1)
            return SESSIONS.get(sess_id)
        return None

    def send_html(self, content, status=200, set_cookie=None):
        self.send_response(status)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        if set_cookie:
            self.send_header("Set-Cookie", set_cookie)
        self.end_headers()
        self.wfile.write(content.encode("utf-8"))

    def redirect(self, location, set_cookie=None):
        self.send_response(302)
        self.send_header("Location", location)
        if set_cookie:
            self.send_header("Set-Cookie", set_cookie)
        self.end_headers()

    def do_GET(self):
        try:
            self._do_GET_impl()
        except Exception as e:
            import traceback
            traceback.print_exc()
            self.send_html(f"<h3>Lỗi máy chủ (500)</h3><p>{e}</p><p><a href='/'>Quay về trang chủ</a></p>", status=500)

    def _do_GET_impl(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        params = urllib.parse.parse_qs(parsed.query)
        user = self.get_session_user()

        if path == "/logout":
            self.redirect("/", set_cookie="session_id=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
            return

        # If not logged in, always show Login Page
        if not user:
            self.show_login_page(params)
            return

        # If logged in, route according to path or role
        if path == "/" or path == "/gddangnhap":
            if user['role'] == 'MANAGER':
                self.redirect("/gdChinhQL")
            else:
                self.redirect("/gdChinhKH")
            return

        # Module Khách hàng
        if path == "/gdChinhKH":
            self.show_gdChinhKH(user)
        elif path == "/gdChonNgayGioDV":
            self.show_gdChonNgayGioDV(user)
        elif path == "/gdNhapThongTin":
            draft = user.get('booking_draft', {})
            merged = {**draft, **params}
            self.show_gdNhapThongTin(user, merged)
        elif path == "/gdKetQuaDatLich":
            last_b = user.get('last_booking', {})
            merged = {
                'code': params.get('code', [last_b.get('code', 'LH-20261120-001')]),
                'id': params.get('id', [str(last_b.get('id', '1'))])
            }
            self.show_gdKetQuaDatLich(user, merged)
        elif path == "/gdLichHenCuaToi":
            self.redirect("/gdChinhKH")

        # Module Quản lý
        elif path == "/gdChinhQL":
            self.show_gdChinhQL(user)
        elif path == "/gdChonTK" or path == "/gdSelectReport":
            self.show_gdSelectReport(user, params)
        elif path == "/gdThongKeNCC" or path == "/gdTKSupplier":
            dates = user.get('report_dates', {'from': '2026-10-01', 'to': '2026-11-30'})
            merged = {**dates, **params}
            self.show_gdThongKeNCC(user, merged)
        elif path == "/gdChiTietLanNhap":
            supp_id = params.get("id", [None])[0] or user.get('selected_supplier_id', '1')
            dates = user.get('report_dates', {'from': '2026-10-01', 'to': '2026-11-30'})
            merged = {**dates, 'id': [str(supp_id)]}
            self.show_gdChiTietLanNhap(user, merged)
        elif path == "/gdHoaDonNhap":
            receipt_id = params.get("id", [None])[0] or user.get('selected_receipt_id', '1')
            supp_id = params.get("suppId", [None])[0] or user.get('selected_supplier_id', '1')
            dates = user.get('report_dates', {'from': '2026-10-01', 'to': '2026-11-30'})
            merged = {**dates, 'id': [str(receipt_id)], 'suppId': [str(supp_id)]}
            self.show_gdHoaDonNhap(user, merged)
        else:
            self.redirect("/")

    def do_POST(self):
        try:
            self._do_POST_impl()
        except Exception as e:
            import traceback
            traceback.print_exc()
            self.send_html(f"<h3>Lỗi máy chủ (500)</h3><p>{e}</p><p><a href='/'>Quay về trang chủ</a></p>", status=500)

    def _do_POST_impl(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length).decode('utf-8')
        form = urllib.parse.parse_qs(post_data)

        if path == "/do-login":
            self.handle_login(form)
        elif path == "/gdNhapThongTin":
            user = self.get_session_user()
            if not user:
                self.redirect("/?error=" + urllib.parse.quote("Vui lòng đăng nhập!"))
                return
            user['booking_draft'] = form
            self.show_gdNhapThongTin(user, form)
        elif path == "/do-dat-lich":
            user = self.get_session_user()
            self.handle_dat_lich(user, form)
        elif path == "/gdThongKeNCC" or path == "/gdTKSupplier":
            user = self.get_session_user()
            if not user:
                self.redirect("/")
                return
            from_date = form.get("from", ["2026-10-01"])[0]
            to_date = form.get("to", ["2026-11-30"])[0]
            user['report_dates'] = {'from': from_date, 'to': to_date}
            self.show_gdThongKeNCC(user, form)
        elif path == "/gdChiTietLanNhap":
            user = self.get_session_user()
            if not user:
                self.redirect("/")
                return
            supp_id = form.get("supplierId", form.get("id", ["1"]))[0]
            user['selected_supplier_id'] = supp_id
            dates = user.get('report_dates', {'from': '2026-10-01', 'to': '2026-11-30'})
            merged = {**dates, 'id': [str(supp_id)]}
            self.show_gdChiTietLanNhap(user, merged)
        elif path == "/gdHoaDonNhap":
            user = self.get_session_user()
            if not user:
                self.redirect("/")
                return
            receipt_id = form.get("receiptId", form.get("id", ["1"]))[0]
            supp_id = form.get("suppId", [user.get('selected_supplier_id', '1')])[0]
            user['selected_receipt_id'] = receipt_id
            dates = user.get('report_dates', {'from': '2026-10-01', 'to': '2026-11-30'})
            merged = {**dates, 'id': [str(receipt_id)], 'suppId': [str(supp_id)]}
            self.show_gdHoaDonNhap(user, merged)
        else:
            self.redirect("/")

    # Màn hình Đăng nhập (gddangnhap)
    def show_login_page(self, params):
        err = params.get("error", [""])[0]
        err_html = f'<div class="alert alert-danger">{err}</div>' if err else ""

        html = get_header("Đăng nhập hệ thống") + f"""
        <div style="max-width: 480px; margin: 40px auto;">
            <div class="card" style="box-shadow: 0 8px 24px rgba(0,0,0,0.12); border-top: 4px solid #1e3c72;">
                <div class="card-header" style="text-align: center; display: block; font-size: 18px;">
                    ĐĂNG NHẬP HỆ THỐNG GARAMAN
                </div>
                <div class="card-body">
                    {err_html}
                    <form action="/do-login" method="POST">
                        <div class="form-group">
                            <label>Tên đăng nhập:</label>
                            <input type="text" name="username" id="username" placeholder="Nhập tên đăng nhập" required>
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu:</label>
                            <div style="position: relative; display: flex; align-items: center;">
                                <input type="password" name="password" id="password" placeholder="Nhập mật khẩu" required style="padding-right: 44px; width: 100%;">
                                <button type="button" id="togglePasswordBtn" onclick="togglePasswordVisibility()" style="position: absolute; right: 10px; background: none; border: none; cursor: pointer; padding: 4px; display: flex; align-items: center; justify-content: center; color: #6c757d; outline: none;" title="Hiện mật khẩu">
                                    <svg id="eyeIconSvg" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                        <circle cx="12" cy="12" r="3"></circle>
                                    </svg>
                                </button>
                            </div>
                        </div>
                        <div style="margin-top: 24px;">
                            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-size: 15px; font-weight: bold;">ĐĂNG NHẬP VÀO HỆ THỐNG</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script>
            var eyeSvgHtml = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>';
            var eyeOffSvgHtml = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line></svg>';

            function togglePasswordVisibility() {{
                var pwd = document.getElementById("password");
                var btn = document.getElementById("togglePasswordBtn");
                if (pwd.type === "password") {{
                    pwd.type = "text";
                    btn.innerHTML = eyeOffSvgHtml;
                    btn.title = "Ẩn mật khẩu";
                }} else {{
                    pwd.type = "password";
                    btn.innerHTML = eyeSvgHtml;
                    btn.title = "Hiện mật khẩu";
                }}
            }}
        </script>
        """ + get_footer()
        self.send_html(html)

    # Xử lý Đăng nhập
    def handle_login(self, form):
        username = form.get("username", [""])[0].strip()
        password = form.get("password", [""])[0].strip()

        row = execute_query(
            "SELECT id, username, password, name, role FROM tblmember3 WHERE username = %s AND password = %s LIMIT 1;",
            (username, password),
            fetch_one=True
        )

        if not row:
            if username == "admin" and password == "admin123":
                row = {'id': 1, 'username': 'admin', 'name': 'Nguyễn Dụng Tiềm', 'role': 'MANAGER'}
            elif username == "khach01" and password == "123456":
                row = {'id': 4, 'username': 'khach01', 'name': 'Hoàng Minh Tuấn', 'role': 'CUSTOMER'}

        if row:
            import uuid
            sess_id = str(uuid.uuid4())
            role_vn = "Nhân viên Quản lý" if row['role'] == 'MANAGER' else "Khách hàng"
            SESSIONS[sess_id] = {
                'id': row['id'],
                'username': row['username'],
                'name': row['name'],
                'role': row['role'],
                'role_vn': role_vn
            }
            if row['role'] == 'MANAGER':
                self.redirect("/gdChinhQL", set_cookie=f"session_id={sess_id}; path=/")
            else:
                self.redirect("/gdChinhKH", set_cookie=f"session_id={sess_id}; path=/")
        else:
            self.redirect("/?error=" + urllib.parse.quote("Sai tên đăng nhập hoặc mật khẩu! Vui lòng thử lại."))

    # 1. Giao diện chính Quản lý (ManagerMain3.jsp)
    def show_gdChinhQL(self, user):
        html = get_header("Trang chủ Quản lý", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>TRANG CHỦ QUẢN LÝ</span>
                <span class="badge badge-info">Quản lý</span>
            </div>
            <div class="card-body">
                <p style="font-size: 15px; margin-bottom: 20px;">Chào mừng Quản lý <strong>{user['name']}</strong> đã đăng nhập vào hệ thống. Vui lòng chọn chức năng nghiệp vụ bên dưới:</p>
                <div class="grid-3" style="margin-bottom: 24px;">
                    <div style="background: #eef4ff; padding: 20px; border-radius: 8px; border-left: 4px solid #0d6efd;">
                        <h3 style="color: #1e3c72; margin-bottom: 10px; font-size: 16px;">1. BÁO CÁO & THỐNG KÊ</h3>
                        <p style="font-size: 13px; color: #555; margin-bottom: 16px;">Xem các báo cáo thống kê hoạt động kinh doanh: thống kê nhà cung cấp theo lượng hàng nhập, doanh thu dịch vụ và phụ tùng.</p>
                        <a href="/gdChonTK" class="btn btn-primary" style="width: 100%; font-weight: bold;">📊 XEM BÁO CÁO THỐNG KÊ</a>
                    </div>
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; border: 1px solid #dee2e6;">
                        <h3 style="color: #333; margin-bottom: 10px; font-size: 16px;">2. QUẢN LÝ DỊCH VỤ</h3>
                        <p style="font-size: 13px; color: #555; margin-bottom: 16px;">Thêm mới, sửa thông tin các dịch vụ bảo dưỡng, sửa chữa ô tô và điều chỉnh bảng giá.</p>
                        <button class="btn btn-secondary btn-sm" disabled style="width: 100%;">Quản lý dịch vụ</button>
                    </div>
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; border: 1px solid #dee2e6;">
                        <h3 style="color: #333; margin-bottom: 10px; font-size: 16px;">3. QUẢN LÝ PHỤ TÙNG</h3>
                        <p style="font-size: 13px; color: #555; margin-bottom: 16px;">Theo dõi danh mục linh kiện, số lượng phụ tùng tồn kho và định mức giá nhập/bán.</p>
                        <button class="btn btn-secondary btn-sm" disabled style="width: 100%;">Quản lý phụ tùng</button>
                    </div>
                </div>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 2. Giao diện Chọn loại báo cáo và khoảng ngày (SelectReport3.jsp)
    def show_gdSelectReport(self, user, params):
        from_date = str(get_param(params, "from", "2026-10-01"))
        to_date = str(get_param(params, "to", "2026-11-30"))

        html = get_header("Chọn loại báo cáo và khoảng ngày", user) + f"""
        <div class="card" style="max-width: 650px; margin: 20px auto;">
            <div class="card-header">
                <span>CHỌN LOẠI THỐNG KÊ VÀ KHOẢNG NGÀY</span>
                <a href="/gdChinhQL" class="btn btn-secondary btn-sm">⬅️ Quay lại trang chủ</a>
            </div>
            <div class="card-body">
                <form action="/gdThongKeNCC" method="POST">
                    <div class="form-group">
                        <label>Loại thống kê (reportType):</label>
                        <select name="reportType" style="font-weight: 500;">
                            <option value="supplier_qty" selected>Nhà cung cấp theo lượng nhập</option>
                        </select>
                    </div>

                    <div class="grid-2">
                        <div class="form-group">
                            <label>Từ ngày bắt đầu (*):</label>
                            <input type="date" name="from" value="{from_date}" required>
                        </div>
                        <div class="form-group">
                            <label>Đến ngày kết thúc (*):</label>
                            <input type="date" name="to" value="{to_date}" required>
                        </div>
                    </div>

                    <div style="margin-top: 24px; display: flex; justify-content: space-between; align-items: center;">
                        <a href="/gdChinhQL" class="btn btn-secondary">⬅️ Quay lại</a>
                        <button type="submit" class="btn btn-primary" style="padding: 10px 28px; font-weight: bold;">📊 XEM THỐNG KÊ</button>
                    </div>
                </form>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 3. Giao diện Thống kê nhà cung cấp theo lượng hàng nhập (SupplierReport3.jsp)
    def show_gdThongKeNCC(self, user, params):
        from_date = str(get_param(params, "from", "2026-10-01"))
        to_date = str(get_param(params, "to", "2026-11-30"))

        query = """
        SELECT s.id, s.code, s.name, s.phone, s.email,
               COUNT(DISTINCT r.id) AS totalReceipts,
               COALESCE(SUM(d.quantity), 0) AS totalQuantity,
               COALESCE(SUM(d.amount), 0) AS totalAmount
        FROM tblsupplier3 s
        JOIN tblimportreceipt3 r ON s.id = r.supplierId
        JOIN tblimportdetail3 d ON r.id = d.receiptId
        WHERE r.importDate BETWEEN %s AND %s
        GROUP BY s.id, s.code, s.name, s.phone, s.email
        ORDER BY totalQuantity DESC;
        """
        rows = execute_query(query, (from_date, to_date), fetch_all=True)

        total_qty = sum(r['totalQuantity'] for r in rows) if rows else 0
        total_amt = sum(r['totalAmount'] for r in rows) if rows else 0

        tbody = ""
        for i, r in enumerate(rows):
            tbody += f"""
            <tr>
                <td>{i+1}</td>
                <td><span class="badge badge-info">{r['code']}</span></td>
                <td>
                    <strong style="color: #1e3c72;">{r['name']}</strong><br>
                    <span style="font-size: 12px; color: #666;">📞 {r['phone']} | ✉️ {r['email']}</span>
                </td>
                <td style="text-align: center;">{r['totalReceipts']} đợt</td>
                <td style="text-align: right; font-weight: bold; color: #0d6efd; font-size: 15px;">{int(r['totalQuantity']):,} cái</td>
                <td style="text-align: right; font-weight: bold; color: #dc3545;">{int(r['totalAmount']):,} đ</td>
                <td style="text-align: center;">
                    <form action="/gdChiTietLanNhap" method="POST" style="margin: 0; display: inline;">
                        <input type="hidden" name="supplierId" value="{r['id']}">
                        <button type="submit" class="btn btn-primary btn-sm">Xem chi tiết</button>
                    </form>
                </td>
            </tr>
            """

        html = get_header("Thống kê nhà cung cấp", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>THỐNG KÊ NHÀ CUNG CẤP THEO LƯỢNG HÀNG NHẬP</span>
                <a href="/gdChonTK" class="btn btn-secondary btn-sm">⬅️ Chọn lại thống kê</a>
            </div>
            <div class="card-body">
                <div style="background: #f0f7ff; border: 1px solid #cce5ff; border-radius: 6px; padding: 12px 18px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; font-size: 14px;">
                    <div>📅 Khoảng thời gian thống kê: Từ ngày <strong style="color: #0d6efd;">{from_date}</strong> đến ngày <strong style="color: #0d6efd;">{to_date}</strong></div>
                    <a href="/gdChonTK" class="btn btn-secondary btn-sm" style="font-size: 12px;">Đổi khoảng ngày</a>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;">STT</th>
                            <th>Mã NCC</th>
                            <th>Tên nhà cung cấp</th>
                            <th style="text-align: center;">Số đợt nhập</th>
                            <th style="text-align: right;">Tổng lượng phụ tùng</th>
                            <th style="text-align: right;">Tổng tiền nhập</th>
                            <th style="text-align: center; width: 120px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        {tbody if tbody else "<tr><td colspan='7' style='text-align: center;'>Không có dữ liệu trong khoảng thời gian này.</td></tr>"}
                        <tr style="background: #eef4ff; font-weight: bold;">
                            <td colspan="4" style="text-align: right; color: #1e3c72;">TỔNG CỘNG TOÀN GARA:</td>
                            <td style="text-align: right; color: #0d6efd; font-size: 15px;">{int(total_qty):,} cái</td>
                            <td style="text-align: right; color: #dc3545; font-size: 15px;">{int(total_amt):,} đ</td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 4. Giao diện Chi tiết các lần nhập của NCC (ImportDetail3.jsp)
    def show_gdChiTietLanNhap(self, user, params):
        try:
            supp_id = int(get_param(params, "id", 1))
        except (ValueError, TypeError):
            supp_id = 1
        from_date = str(get_param(params, "from", "2026-10-01"))
        to_date = str(get_param(params, "to", "2026-11-30"))

        supp = execute_query("SELECT * FROM tblsupplier3 WHERE id = %s;", (supp_id,), fetch_one=True)
        if not supp:
            supp = execute_query("SELECT * FROM tblsupplier3 LIMIT 1;", fetch_one=True)
            if supp:
                supp_id = supp['id']
            else:
                supp = {'id': 1, 'code': 'NCC01', 'name': 'Nhà cung cấp Bosch Việt Nam', 'address': 'KCN Đình Vũ, Hải Phòng', 'phone': '02253888999'}
        query = """
        SELECT r.id, r.receiptCode, r.importDate, r.totalAmount, r.note,
               m.name as staffName,
               COALESCE(SUM(d.quantity), 0) AS totalQty
        FROM tblimportreceipt3 r
        JOIN tblmember3 m ON r.warehouseStaffId = m.id
        LEFT JOIN tblimportdetail3 d ON r.id = d.receiptId
        WHERE r.supplierId = %s AND r.importDate BETWEEN %s AND %s
        GROUP BY r.id, r.receiptCode, r.importDate, r.totalAmount, r.note, m.name
        ORDER BY r.importDate DESC;
        """
        receipts = execute_query(query, (supp_id, from_date, to_date), fetch_all=True)

        tbody = ""
        for i, r in enumerate(receipts):
            tbody += f"""
            <tr>
                <td>{i+1}</td>
                <td><strong style="color: #1e3c72;">{r['receiptCode']}</strong></td>
                <td>{r['importDate']}</td>
                <td>{r['staffName']}</td>
                <td style="text-align: right; font-weight: bold; color: #0d6efd;">{int(r['totalQty']):,} cái</td>
                <td style="text-align: right; font-weight: bold; color: #dc3545;">{int(r['totalAmount']):,} đ</td>
                <td>{r['note'] if r['note'] else ''}</td>
                <td style="text-align: center;">
                    <form action="/gdHoaDonNhap" method="POST" style="margin: 0; display: inline;">
                        <input type="hidden" name="receiptId" value="{r['id']}">
                        <input type="hidden" name="suppId" value="{supp_id}">
                        <button type="submit" class="btn btn-primary btn-sm">Xem hóa đơn</button>
                    </form>
                </td>
            </tr>
            """

        html = get_header(f"Lần nhập của {supp['name']}", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>DANH SÁCH CÁC LẦN NHẬP HÀNG - {supp['name']}</span>
                <a href="/gdThongKeNCC" class="btn btn-secondary btn-sm">⬅️ Quay lại thống kê NCC</a>
            </div>
            <div class="card-body">
                <div style="background: #f8f9fa; padding: 14px; border-radius: 6px; margin-bottom: 20px; font-size: 14px;">
                    <strong>Mã NCC:</strong> {supp['code']} | <strong>Địa chỉ:</strong> {supp['address']} | <strong>Điện thoại:</strong> {supp['phone']} | <strong>Khoảng ngày:</strong> {from_date} đến {to_date}
                </div>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;">STT</th>
                            <th>Mã phiếu nhập</th>
                            <th>Ngày nhập</th>
                            <th>Nhân viên kho</th>
                            <th style="text-align: right;">Số lượng phụ tùng</th>
                            <th style="text-align: right;">Tổng tiền phiếu</th>
                            <th>Ghi chú</th>
                            <th style="text-align: center; width: 120px;">Hóa đơn</th>
                        </tr>
                    </thead>
                    <tbody>
                        {tbody if tbody else "<tr><td colspan='8' style='text-align: center;'>Không có đợt nhập nào.</td></tr>"}
                    </tbody>
                </table>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 5. Giao diện Hóa đơn nhập chi tiết (ImportInvoice3.jsp)
    def show_gdHoaDonNhap(self, user, params):
        try:
            receipt_id = int(get_param(params, "id", 1))
        except (ValueError, TypeError):
            receipt_id = 1
        supp_id = get_param(params, "suppId", "1")
        from_date = str(get_param(params, "from", "2026-10-01"))
        to_date = str(get_param(params, "to", "2026-11-30"))

        receipt = execute_query("""
        SELECT r.*, s.name as supplierName, s.code as supplierCode, s.address as supplierAddress,
               m.name as staffName
        FROM tblimportreceipt3 r
        JOIN tblsupplier3 s ON r.supplierId = s.id
        JOIN tblmember3 m ON r.warehouseStaffId = m.id
        WHERE r.id = %s;
        """, (receipt_id,), fetch_one=True)

        details = execute_query("""
        SELECT d.*, p.name as partName, p.code as partCode, p.unit
        FROM tblimportdetail3 d
        JOIN tblsparepart3 p ON d.sparePartId = p.id
        WHERE d.receiptId = %s;
        """, (receipt_id,), fetch_all=True)

        tbody = ""
        total_q = sum(d['quantity'] for d in details) if details else 0
        total_a = sum(d['amount'] for d in details) if details else 0

        for i, d in enumerate(details):
            tbody += f"""
            <tr>
                <td>{i+1}</td>
                <td><span class="badge badge-info">{d['partCode']}</span></td>
                <td><strong>{d['partName']}</strong></td>
                <td>{d['unit']}</td>
                <td style="text-align: right; font-weight: bold;">{d['quantity']}</td>
                <td style="text-align: right;">{int(d['unitPrice']):,} đ</td>
                <td style="text-align: right; font-weight: bold; color: #dc3545;">{int(d['amount']):,} đ</td>
            </tr>
            """

        receipt_code = receipt['receiptCode'] if receipt else f"PN-{receipt_id}"
        import_date = receipt['importDate'] if receipt else ""
        staff_name = receipt['staffName'] if receipt else ""
        supp_name = receipt['supplierName'] if receipt else ""
        supp_code = receipt['supplierCode'] if receipt else ""
        supp_addr = receipt['supplierAddress'] if receipt else ""
        note = (receipt.get('note', '') or 'Không có ghi chú') if receipt else 'Không có ghi chú'

        html = get_header("Hóa đơn nhập hàng", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>HÓA ĐƠN NHẬP PHỤ TÙNG CHI TIẾT</span>
                <a href="/gdChiTietLanNhap" class="btn btn-secondary btn-sm">⬅️ Quay lại danh sách lần nhập</a>
            </div>
            <div class="card-body">
                <div class="grid-2" style="margin-bottom: 20px;">
                    <div style="background: #f8f9fa; padding: 14px; border-radius: 6px;">
                        <p><strong>Mã phiếu nhập:</strong> <span style="color: #0d6efd; font-weight: bold; font-size: 16px;">{receipt_code}</span></p>
                        <p><strong>Ngày nhập kho:</strong> {import_date}</p>
                        <p><strong>Người lập phiếu:</strong> {staff_name}</p>
                    </div>
                    <div style="background: #f8f9fa; padding: 14px; border-radius: 6px;">
                        <p><strong>Nhà cung cấp:</strong> {supp_name} ({supp_code})</p>
                        <p><strong>Địa chỉ:</strong> {supp_addr}</p>
                        <p><strong>Ghi chú:</strong> {note}</p>
                    </div>
                </div>

                <h4 style="color: #1e3c72; margin-bottom: 8px; font-size: 15px;">DANH SÁCH PHỤ TÙNG ĐÃ NHẬP</h4>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;">STT</th>
                            <th>Mã phụ tùng</th>
                            <th>Tên phụ tùng</th>
                            <th>ĐVT</th>
                            <th style="text-align: right;">Số lượng</th>
                            <th style="text-align: right;">Đơn giá nhập</th>
                            <th style="text-align: right;">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        {tbody}
                        <tr style="background: #eef4ff; font-weight: bold;">
                            <td colspan="4" style="text-align: right; color: #1e3c72;">TỔNG CỘNG HÓA ĐƠN:</td>
                            <td style="text-align: right; color: #0d6efd;">{total_q} cái</td>
                            <td></td>
                            <td style="text-align: right; color: #dc3545; font-size: 15px;">{int(total_a):,} đ</td>
                        </tr>
                    </tbody>
                </table>


            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 6. Giao diện chính Khách hàng (CustomerMain3.jsp)
    def show_gdChinhKH(self, user):
        html = get_header("Trang chủ Khách hàng", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>TRANG CHỦ KHÁCH HÀNG</span>
                <span class="badge badge-success">Khách hàng: {user['name']}</span>
            </div>
            <div class="card-body">
                <p style="font-size: 15px; margin-bottom: 20px;">Chào mừng quý khách <strong>{user['name']}</strong> đã đến với hệ thống GaraMan. Quý khách vui lòng chọn chức năng bên dưới để tiếp tục:</p>
                <div style="max-width: 600px; margin: 0 auto;">
                    <div style="background: #eef4ff; padding: 30px; border-radius: 8px; border-left: 4px solid #0d6efd; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.06);">
                        <h3 style="color: #1e3c72; margin-bottom: 12px; font-size: 20px;">📅 ĐẶT LỊCH HẸN TRỰC TUYẾN</h3>
                        <p style="font-size: 14px; color: #555; margin-bottom: 24px;">Chủ động chọn ngày giờ, đăng ký các gói dịch vụ bảo dưỡng và sửa chữa xe ô tô nhanh chóng, chính xác.</p>
                        <a href="/gdChonNgayGioDV" class="btn btn-primary" style="padding: 14px 36px; font-size: 16px; font-weight: bold;">👉 BẮT ĐẦU ĐẶT LỊCH HẸN NGAY</a>
                    </div>
                </div>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 6. Chọn ngày giờ & Dịch vụ (gdChonNgayGioDV)
    def show_gdChonNgayGioDV(self, user):
        slots = execute_query("SELECT id, startTime, endTime FROM tbltimeslot3 ORDER BY startTime;", fetch_all=True)
        services = execute_query("""
        SELECT s.id, s.name, s.price, s.estimatedDuration, c.name as catName
        FROM tblservice3 s
        JOIN tblservicecategory3 c ON s.categoryId = c.id
        ORDER BY s.categoryId, s.id;
        """, fetch_all=True)

        slot_options = "".join([f'<option value="{s["id"]}">Khung giờ: {s["startTime"]} - {s["endTime"]}</option>' for s in slots])

        service_html = ""
        current_cat = ""
        for s in services:
            if s['catName'] != current_cat:
                current_cat = s['catName']
                service_html += f'<div style="font-weight: bold; color: #1e3c72; margin: 12px 0 6px 0; font-size: 13px;">🔹 {current_cat}</div>'
            service_html += f"""
            <label style="display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; border: 1px solid #dee2e6; border-radius: 6px; margin-bottom: 8px; background: white; cursor: pointer;">
                <div style="display: flex; align-items: center;">
                    <input type="checkbox" name="services" value="{s['id']}" data-price="{s['price']}" onchange="calcTotal()" style="width: 18px; height: 18px; margin-right: 12px;">
                    <div>
                        <strong>{s['name']}</strong>
                        <div style="font-size: 12px; color: #666;">Thời gian ước tính: {s['estimatedDuration']} phút</div>
                    </div>
                </div>
                <div style="font-weight: bold; color: #0d6efd;">{int(s['price']):,} đ</div>
            </label>
            """

        html = get_header("Chọn ngày giờ & Dịch vụ", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>CHỌN NGÀY GIỜ VÀ DỊCH VỤ</span>
                <a href="/gdChinhKH" class="btn btn-secondary btn-sm">⬅️ Quay lại</a>
            </div>
            <div class="card-body">
                <form action="/gdNhapThongTin" method="POST">
                    <div class="grid-2">
                        <div class="form-group">
                            <label>Chọn ngày hẹn (*):</label>
                            <input type="date" name="appointmentDate" value="2026-11-20" required>
                        </div>
                        <div class="form-group">
                            <label>Chọn khung giờ phục vụ (*):</label>
                            <select name="timeSlotId" required>
                                {slot_options}
                            </select>
                        </div>
                    </div>

                    <label style="margin-top: 14px; font-weight: bold;">Tick chọn danh mục dịch vụ cần đặt (*):</label>
                    <div style="max-height: 260px; overflow-y: auto; padding: 10px; background: #fafbfc; border: 1px solid #dee2e6; border-radius: 6px;">
                        {service_html}
                    </div>

                    <div style="margin-top: 14px; padding: 12px 16px; background: #eef4ff; border-radius: 6px; display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-weight: bold; color: #1e3c72;">Tổng tiền dịch vụ tạm tính:</span>
                        <span id="totalDisplay" style="font-size: 18px; font-weight: bold; color: #dc3545;">0 đ</span>
                    </div>

                    <div style="margin-top: 24px; text-align: right;">
                        <button type="submit" class="btn btn-primary" style="padding: 12px 28px;">TIẾP TỤC: NHẬP THÔNG TIN XE & KHÁCH HÀNG ➡️</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function calcTotal() {{
                let checkboxes = document.querySelectorAll('input[name="services"]:checked');
                let total = 0;
                checkboxes.forEach(cb => {{
                    total += parseFloat(cb.getAttribute('data-price') || 0);
                }});
                document.getElementById('totalDisplay').innerText = total.toLocaleString('vi-VN') + ' đ';
            }}
        </script>
        """ + get_footer()
        self.send_html(html)

    # 7. Nhập thông tin xe & khách hàng (gdNhapThongTin)
    def show_gdNhapThongTin(self, user, params):
        date = str(get_param(params, "appointmentDate", "2026-11-20"))
        slot_id = str(get_param(params, "timeSlotId", "1"))
        services = params.get("services", ["1"])
        if isinstance(services, str):
            services = [services]

        services_inputs = "".join([f'<input type="hidden" name="services" value="{s}">' for s in services])

        # Lấy thông tin khung giờ đã chọn
        slot_row = execute_query("SELECT id, startTime, endTime FROM tbltimeslot3 WHERE id = %s;", (slot_id,), fetch_one=True)
        slot_time_str = f"{slot_row['startTime']} - {slot_row['endTime']}" if slot_row else "08:00 - 09:30"

        # Lấy danh sách dịch vụ đã chọn để hiển thị và tính tổng tiền dự kiến (totalAmount)
        placeholders = ",".join(["%s"] * len(services))
        service_rows = execute_query(f"SELECT id, name, price FROM tblservice3 WHERE id IN ({placeholders});", tuple(services), fetch_all=True)
        total_amount = sum(s['price'] for s in service_rows) if service_rows else 0

        serv_table_rows = "".join([
            f"<tr><td>{i+1}</td><td>{s['name']}</td><td style='text-align: right; font-weight: 500;'>{int(s['price']):,} đ</td></tr>"
            for i, s in enumerate(service_rows)
        ])

        # Lấy danh sách xe đã lưu của khách hàng (nếu có)
        cust_row = execute_query("""
            SELECT cu.id FROM tblcustomer3 cu
            JOIN tblmember3 m ON cu.memberId = m.id
            WHERE m.username = %s OR m.name = %s LIMIT 1;
        """, (user.get('username', ''), user.get('name', '')), fetch_one=True)

        user_cars = []
        if cust_row:
            user_cars = execute_query("SELECT id, licensePlate, brand, model FROM tblcar3 WHERE customerId = %s;", (cust_row['id'],), fetch_all=True)

        car_options_html = ""
        for c in user_cars:
            car_options_html += f'<option value="{c["licensePlate"]}|{c["brand"]}|{c["model"]}">{c["licensePlate"]} - {c["brand"]} {c["model"]}</option>'
        car_options_html += '<option value="29A-123.45|Toyota|Vios" selected>29A-123.45 - Toyota Vios</option>'
        car_options_html += '<option value="30A-999.88|Toyota|Camry 2.5Q">30A-999.88 - Toyota Camry 2.5Q</option>'

        html = get_header("Nhập thông tin cá nhân và xác nhận", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>NHẬP THÔNG TIN CÁ NHÂN VÀ XÁC NHẬN</span>
                <a href="/gdChonNgayGioDV" class="btn btn-secondary btn-sm">⬅️ Quay lại chọn dịch vụ</a>
            </div>
            <div class="card-body">
                <form action="/do-dat-lich" method="POST">
                    <input type="hidden" name="appointmentDate" value="{date}">
                    <input type="hidden" name="timeSlotId" value="{slot_id}">
                    {services_inputs}

                    <div style="background: #f0f7ff; border: 1px solid #cce5ff; border-radius: 6px; padding: 12px 18px; margin-bottom: 20px; display: flex; justify-content: space-between; font-size: 14px;">
                        <div>📅 Ngày hẹn: <strong style="color: #0d6efd;">{date}</strong></div>
                        <div>⏰ Khung giờ: <strong style="color: #0d6efd;">{slot_time_str}</strong></div>
                        <div>🔧 Số dịch vụ đã chọn: <strong style="color: #0d6efd;">{len(service_rows)}</strong></div>
                    </div>

                    <h4 style="color: #1e3c72; margin-bottom: 12px; font-size: 15px;">THÔNG TIN KHÁCH HÀNG</h4>
                    <div class="grid-3" style="margin-bottom: 15px;">
                        <div class="form-group">
                            <label>Họ và tên khách hàng (*):</label>
                            <input type="text" name="customerName" value="{user['name']}" required>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại liên hệ (*):</label>
                            <input type="text" name="customerPhone" placeholder="Ví dụ: 0987 654 321" required value="0987654321">
                        </div>
                        <div class="form-group">
                            <label>Địa chỉ:</label>
                            <input type="text" name="customerAddress" value="15 Trần Phú, Hà Nội">
                        </div>
                    </div>

                    <h4 style="color: #1e3c72; margin: 15px 0 12px 0; font-size: 15px;">THÔNG TIN PHƯƠNG TIỆN (XE Ô TÔ)</h4>
                    <div class="grid-2" style="margin-bottom: 15px;">
                        <div class="form-group">
                            <label>Chọn xe đã đăng ký (selectCar):</label>
                            <select name="selectedCar" style="font-weight: 500;" onchange="updateCarFields(this)">
                                {car_options_html}
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Biển số xe (*):</label>
                            <input type="text" id="licensePlateInput" name="licensePlate" placeholder="Ví dụ: 29A-123.45" required style="font-weight: bold; text-transform: uppercase;" value="29A-123.45">
                        </div>
                    </div>

                    <div class="grid-2" style="margin-bottom: 15px;">
                        <div class="form-group">
                            <label>Hãng xe (*):</label>
                            <input type="text" id="carBrandInput" name="carBrand" placeholder="Ví dụ: Toyota" required value="Toyota">
                        </div>
                        <div class="form-group">
                            <label>Dòng xe / Đời xe:</label>
                            <input type="text" id="carModelInput" name="carModel" placeholder="Ví dụ: Vios" value="Vios">
                        </div>
                    </div>

                    <h4 style="color: #1e3c72; margin: 15px 0 10px 0; font-size: 15px;">DANH SÁCH DỊCH VỤ ĐÃ CHỌN</h4>
                    <table style="width: 100%; margin-bottom: 12px;">
                        <thead>
                            <tr>
                                <th style="width: 50px;">TT</th>
                                <th>Dịch vụ đã chọn</th>
                                <th style="text-align: right; width: 180px;">Đơn giá dự kiến</th>
                            </tr>
                        </thead>
                        <tbody>
                            {serv_table_rows}
                        </tbody>
                    </table>

                    <div style="font-size: 16px; font-weight: bold; color: #1e3c72; padding: 12px 16px; background: #eef4ff; border-radius: 6px; margin-bottom: 18px; text-align: right;">
                        Tổng tiền dự kiến (totalAmount): <span style="color: #dc3545; font-size: 18px;">{int(total_amount):,} đồng</span>
                    </div>

                    <div class="form-group">
                        <label>Ghi chú yêu cầu thêm của khách:</label>
                        <input type="text" name="note" placeholder="Ví dụ: Xe có tiếng kêu ở gầm" value="Xe có tiếng kêu ở gầm">
                    </div>

                    <div style="margin-top: 24px; display: flex; justify-content: space-between; align-items: center;">
                        <a href="/gdChonNgayGioDV" class="btn btn-secondary">⬅️ Quay lại</a>
                        <button type="submit" class="btn btn-success" style="padding: 12px 36px; font-size: 15px; font-weight: bold;">XÁC NHẬN</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
        function updateCarFields(sel) {{
            var val = sel.value;
            if (val && val.indexOf('|') !== -1) {{
                var parts = val.split('|');
                document.getElementById('licensePlateInput').value = parts[0];
                document.getElementById('carBrandInput').value = parts[1];
                document.getElementById('carModelInput').value = parts[2] || '';
            }}
        }}
        </script>
        """ + get_footer()
        self.send_html(html)

    # Xử lý Lưu lịch hẹn vào MySQL
    def handle_dat_lich(self, user, form):
        date = form.get("appointmentDate", ["2026-11-20"])[0]
        slot_id = int(form.get("timeSlotId", [1])[0])
        cust_name = form.get("customerName", [user['name']])[0].strip()
        cust_phone = form.get("customerPhone", ["0988776655"])[0].strip()
        cust_address = form.get("customerAddress", [""])[0].strip()
        license_plate = form.get("licensePlate", ["30A-999.88"])[0].strip().upper()
        car_brand = form.get("carBrand", ["Toyota"])[0].strip()
        car_model = form.get("carModel", [""])[0].strip()
        note = form.get("note", [""])[0].strip()
        services = form.get("services", ["1"])

        # 1. Member
        mem = execute_query("SELECT id FROM tblmember3 WHERE phone = %s LIMIT 1;", (cust_phone,), fetch_one=True)
        if mem:
            member_id = mem['id']
        else:
            uname = "cust_" + re.sub(r'\D', '', cust_phone)[-6:] if cust_phone else "cust_new"
            member_id = execute_query(
                "INSERT INTO tblmember3 (username, password, name, phone, address, role) VALUES (%s, '123456', %s, %s, %s, 'CUSTOMER');",
                (uname, cust_name, cust_phone, cust_address),
                commit=True
            )

        # 2. Customer
        cust = execute_query("SELECT id FROM tblcustomer3 WHERE memberId = %s LIMIT 1;", (member_id,), fetch_one=True)
        if cust:
            customer_id = cust['id']
        else:
            customer_id = execute_query(
                "INSERT INTO tblcustomer3 (memberId, customerType) VALUES (%s, 'REGULAR');",
                (member_id,),
                commit=True
            )

        # 3. Car
        car = execute_query("SELECT id FROM tblcar3 WHERE licensePlate = %s LIMIT 1;", (license_plate,), fetch_one=True)
        if car:
            car_id = car['id']
        else:
            car_id = execute_query(
                "INSERT INTO tblcar3 (customerId, licensePlate, brand, model, year) VALUES (%s, %s, %s, %s, 2022);",
                (customer_id, license_plate, car_brand, car_model),
                commit=True
            )

        # 4. Services sum
        placeholders = ",".join(["%s"] * len(services))
        service_rows = execute_query(f"SELECT id, name, price FROM tblservice3 WHERE id IN ({placeholders});", tuple(services), fetch_all=True)
        total_amount = sum(s['price'] for s in service_rows)

        # 5. Code & insert appointment
        cnt_row = execute_query("SELECT COUNT(*) as c FROM tblappointment3;", fetch_one=True)
        cnt = (cnt_row['c'] if cnt_row else 0) + 1
        clean_date = date.replace("-", "")
        code = f"LH-{clean_date}-{cnt:03d}"

        app_id = execute_query("""
        INSERT INTO tblappointment3 (appointmentCode, customerId, carId, timeSlotId, appointmentDate, totalAmount, status, note)
        VALUES (%s, %s, %s, %s, %s, %s, 'CONFIRMED', %s);
        """, (code, customer_id, car_id, slot_id, date, total_amount, note), commit=True)

        # 6. Details
        for s in service_rows:
            execute_query("""
            INSERT INTO tblappointmentdetail3 (appointmentId, serviceId, price)
            VALUES (%s, %s, %s);
            """, (app_id, s['id'], s['price']), commit=True)

        print(f"\n[MYSQL] >>> DA LUU LICH HEN MOI VAO DATABASE db_garaman3:")
        print(f"       Ma lich: {code} | Xe: {license_plate} | Tong tien: {int(total_amount):,} d\n")

        user['last_booking'] = {'code': code, 'id': app_id}
        self.redirect("/gdKetQuaDatLich")

    # 8. Kết quả đặt lịch (gdKetQuaDatLich)
    def show_gdKetQuaDatLich(self, user, params):
        code = str(get_param(params, "code", "LH-20261120-001"))
        app_id = str(get_param(params, "id", "1"))

        app = execute_query("""
        SELECT a.*, c.licensePlate, c.brand, c.model, t.startTime, t.endTime, m.name as custName, m.phone as custPhone
        FROM tblappointment3 a
        JOIN tblcustomer3 cu ON a.customerId = cu.id
        JOIN tblmember3 m ON cu.memberId = m.id
        JOIN tblcar3 c ON a.carId = c.id
        JOIN tbltimeslot3 t ON a.timeSlotId = t.id
        WHERE a.appointmentCode = %s OR a.id = %s;
        """, (code, app_id), fetch_one=True)

        details = execute_query("""
        SELECT d.*, s.name as serviceName
        FROM tblappointmentdetail3 d
        JOIN tblservice3 s ON d.serviceId = s.id
        WHERE d.appointmentId = %s;
        """, (app['id'],), fetch_all=True)

        serv_rows = "".join([f"<tr><td>{i+1}</td><td>{d['serviceName']}</td><td style='text-align: right;'>{int(d['price']):,} đ</td></tr>" for i, d in enumerate(details)])

        html = get_header("Kết quả đặt lịch hẹn", user) + f"""
        <div class="card" style="border-top: 4px solid #198754;">
            <div class="card-header" style="background: #e8f5e9;">
                <span style="color: #198754; font-size: 17px; font-weight: bold;">🎉 KẾT QUẢ ĐẶT LỊCH HẸN</span>
                <span class="badge badge-success">ĐẶT LỊCH HẸN THÀNH CÔNG (MÃ: {app['appointmentCode']})</span>
            </div>
            <div class="card-body">
                <div class="alert alert-success">
                    Hệ thống GaraMan thông báo: <strong>Đặt lịch hẹn thành công!</strong> Thông tin lịch hẹn đã được lưu vào hệ thống cơ sở dữ liệu.
                </div>

                <div class="grid-2" style="margin-bottom: 20px;">
                    <div style="background: #f8f9fa; padding: 14px; border-radius: 6px;">
                        <p><strong>Mã lịch hẹn:</strong> <span style="font-size: 18px; color: #dc3545; font-weight: bold;">{app['appointmentCode']}</span></p>
                        <p><strong>Ngày hẹn phục vụ:</strong> {app['appointmentDate']}</p>
                        <p><strong>Khung giờ:</strong> {app['startTime']} - {app['endTime']}</p>
                        <p><strong>Trạng thái:</strong> <span class="badge badge-success">{app['status']}</span></p>
                    </div>
                    <div style="background: #f8f9fa; padding: 14px; border-radius: 6px;">
                        <p><strong>Khách hàng:</strong> {app['custName']} (📞 {app['custPhone']})</p>
                        <p><strong>Xe đăng ký:</strong> <strong style="color: #0d6efd;">{app['licensePlate']}</strong> ({app['brand']} {app['model']})</p>
                        <p><strong>Ghi chú:</strong> {app['note'] if app['note'] else 'Không'}</p>
                    </div>
                </div>

                <h4 style="color: #1e3c72; margin-bottom: 8px; font-size: 15px;">DỊCH VỤ ĐÃ ĐĂNG KÝ</h4>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;">STT</th>
                            <th>Tên dịch vụ</th>
                            <th style="text-align: right; width: 150px;">Đơn giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        {serv_rows}
                        <tr style="background: #eef4ff; font-weight: bold;">
                            <td colspan="2" style="text-align: right; color: #1e3c72;">TỔNG TIỀN DỊCH VỤ:</td>
                            <td style="text-align: right; color: #dc3545; font-size: 15px;">{int(app['totalAmount']):,} đ</td>
                        </tr>
                    </tbody>
                </table>

                <div style="margin-top: 24px; text-align: center;">
                    <a href="/gdChinhKH" class="btn btn-primary" style="padding: 12px 40px; font-size: 15px; font-weight: bold;">🏠 VỀ TRANG CHỦ</a>
                </div>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

    # 9. Lịch hẹn của tôi
    def show_gdLichHenCuaToi(self, user):
        rows = execute_query("""
        SELECT a.id, a.appointmentCode, a.appointmentDate, a.totalAmount, a.status,
               c.licensePlate, c.brand, c.model,
               t.startTime, t.endTime
        FROM tblappointment3 a
        JOIN tblcar3 c ON a.carId = c.id
        JOIN tbltimeslot3 t ON a.timeSlotId = t.id
        ORDER BY a.id DESC;
        """, fetch_all=True)

        tbody = ""
        for i, r in enumerate(rows):
            tbody += f"""
            <tr>
                <td>{i+1}</td>
                <td><strong style="color: #1e3c72;">{r['appointmentCode']}</strong></td>
                <td><span class="badge badge-info">{r['licensePlate']}</span> {r['brand']} {r['model']}</td>
                <td>{r['appointmentDate']} (⏰ {r['startTime']} - {r['endTime']})</td>
                <td style="text-align: right; font-weight: bold; color: #dc3545;">{int(r['totalAmount']):,} đ</td>
                <td><span class="badge badge-success">{r['status']}</span></td>
            </tr>
            """

        html = get_header("Lịch hẹn của tôi", user) + f"""
        <div class="card">
            <div class="card-header">
                <span>DANH SÁCH LỊCH HẸN TRONG CƠ SỞ DỮ LIỆU MYSQL</span>
                <a href="/gdChonNgayGioDV" class="btn btn-primary btn-sm">+ Đặt lịch mới</a>
            </div>
            <div class="card-body">
                <table>
                    <thead>
                        <tr>
                            <th style="width: 40px;">STT</th>
                            <th>Mã lịch</th>
                            <th>Xe đăng ký</th>
                            <th>Thời gian hẹn</th>
                            <th style="text-align: right;">Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        {tbody if tbody else "<tr><td colspan='6' style='text-align: center;'>Chưa có lịch hẹn nào.</td></tr>"}
                    </tbody>
                </table>
            </div>
        </div>
        """ + get_footer()
        self.send_html(html)

def main():
    print("=" * 70)
    print("   HE THONG QUAN LY GARA O TO (GARAMAN) - DE SO 31")
    print("   Sinh vien: Nguyen Dung Tiem - MSV: B23DCCN813")
    print("   Database: MySQL (db_garaman3) / Cổng 3306")
    print(f"   Web Server: http://localhost:{PORT}")
    print("=" * 70)

    try:
        webbrowser.open(f"http://localhost:{PORT}")
    except Exception:
        pass

    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), GaraHandler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            httpd.shutdown()

if __name__ == '__main__':
    main()
