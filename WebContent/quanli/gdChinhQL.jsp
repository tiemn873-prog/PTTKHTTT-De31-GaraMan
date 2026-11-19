<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GaraMan - Trang chủ Quản lý</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 40px;">
    <h2>Xin chào: <span style="color:#003366;"><%= user.getName() %></span> (Nhân viên Quản lý)</h2>
    <hr/>
    <h3>MENU CHỨC NĂNG DÀNH CHO QUẢN LÝ</h3>
    <ul>
        <li><a href="gdChonTK.jsp" style="font-size:16px; font-weight:bold; color:#0055aa;">Thống kê nhà cung cấp theo lượng hàng nhập</a></li>
        <li><a href="#" style="font-size:16px; color:#555;">Thống kê dịch vụ & doanh thu</a></li>
        <li><a href="#" style="font-size:16px; color:#555;">Quản lý thông tin phụ tùng</a></li>
        <li><a href="../gddangnhap.jsp" style="font-size:16px; color:red;">Đăng xuất</a></li>
    </ul>
</body>
</html>
