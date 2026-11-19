<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GaraMan - Đăng nhập hệ thống</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 40px;">
    <h2>ĐĂNG NHẬP HỆ THỐNG QUẢN LÝ GARA Ô TÔ (GaraMan)</h2>
    <hr/>
    <%
        String err = request.getParameter("err");
        if(err != null) {
    %>
        <p style="color:red; font-weight:bold;">Tài khoản hoặc mật khẩu không chính xác!</p>
    <%
        }
    %>
    <form action="doDangnhap.jsp" method="post">
        <table cellpadding="6">
            <tr>
                <td><b>Tên đăng nhập:</b></td>
                <td><input type="text" name="username" required style="padding: 4px; width: 220px;" /></td>
            </tr>
            <tr>
                <td><b>Mật khẩu:</b></td>
                <td><input type="password" name="password" required style="padding: 4px; width: 220px;" /></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Đăng nhập" style="padding: 6px 16px; background-color: #003366; color: white; border: none; cursor: pointer;" /></td>
            </tr>
        </table>
    </form>
</body>
</html>
