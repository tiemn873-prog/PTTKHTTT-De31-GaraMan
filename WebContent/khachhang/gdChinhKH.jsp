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
    <title>GaraMan - Trang chủ Khách hàng</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 40px;">
    <h2>Xin chào: <span style="color:#003366;"><%= user.getName() %></span> (Khách hàng)</h2>
    <p>Số điện thoại: <%= user.getPhone() %> | Email: <%= user.getEmail() %></p>
    <hr/>
    <h3>MENU CHỨC NĂNG DÀNH CHO KHÁCH HÀNG</h3>
    <ul>
        <li><a href="gdChonNgayGioDV.jsp" style="font-size:16px; font-weight:bold; color:#0055aa;">Đặt lịch hẹn trực tuyến</a></li>
        <li><a href="#" style="font-size:16px; color:#555;">Xem lịch sử bảo dưỡng & sửa chữa</a></li>
        <li><a href="../gddangnhap.jsp" style="font-size:16px; color:red;">Đăng xuất</a></li>
    </ul>
</body>
</html>
