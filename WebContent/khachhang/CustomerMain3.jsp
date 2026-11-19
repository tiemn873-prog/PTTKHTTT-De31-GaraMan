<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CustomerMain3 - Trang chủ Khách hàng</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 40px; background-color: #f7f9fa;">
    <div style="max-width: 700px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h2 style="color: #003366; margin-top: 0;">GaraMan - Giao diện Khách hàng</h2>
        <p>Xin chào: <strong><%= user.getName() %></strong> | SĐT: <%= user.getPhone() %> | Email: <%= user.getEmail() %></p>
        <hr style="border: 0; border-top: 1px solid #ddd; margin: 20px 0;"/>
        <h3>MENU CHỨC NĂNG</h3>
        <ul style="line-height: 2;">
            <li><a id="bookAppointment" href="SelectSlot3.jsp" style="font-size: 16px; font-weight: bold; color: #0055aa; text-decoration: none;">📅 Đặt lịch hẹn trực tuyến</a></li>
            <li><a id="viewAppointments" href="#" style="font-size: 16px; color: #555; text-decoration: none;">📋 Xem lịch hẹn của tôi</a></li>
            <li><a id="logout" href="../gddangnhap.jsp" style="font-size: 16px; color: #c00; text-decoration: none;">🚪 Đăng xuất</a></li>
        </ul>
    </div>
</body>
</html>
