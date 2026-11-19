<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login3 - Đăng nhập hệ thống GaraMan</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 360px; }
        .login-card h2 { color: #003366; text-align: center; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: bold; color: #444; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 12px; background: #003366; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }
        .btn-submit:hover { background: #002244; }
        .hint { font-size: 12px; color: #666; margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>ĐĂNG NHẬP GaraMan</h2>
        <% 
            String err = request.getParameter("err");
            if ("1".equals(err)) {
        %>
            <p style="color: red; text-align: center;">Sai tên đăng nhập hoặc mật khẩu!</p>
        <%  } %>
        <form action="doLogin3.jsp" method="post">
            <div class="form-group">
                <label>Tên đăng nhập:</label>
                <input type="text" name="username" class="form-control" required placeholder="Nhập username" />
            </div>
            <div class="form-group">
                <label>Mật khẩu:</label>
                <input type="password" name="password" class="form-control" required placeholder="Nhập password" />
            </div>
            <button type="submit" class="btn-submit">Đăng nhập</button>
        </form>
        <div class="hint">
            <strong>Tài khoản mẫu:</strong><br/>
            - Quản lý: <code>quanly1</code> / <code>123456</code><br/>
            - Khách hàng: <code>khachhang1</code> / <code>123456</code>
        </div>
    </div>
</body>
</html>
