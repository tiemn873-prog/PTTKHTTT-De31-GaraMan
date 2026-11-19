<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Appointment3" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GaraMan - Kết quả đặt lịch hẹn</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 40px;">
    <%
        String status = request.getParameter("status");
        if("success".equalsIgnoreCase(status)) {
            Appointment3 app = (Appointment3) session.getAttribute("confirmedAppointment");
    %>
        <h2 style="color:green;">ĐẶT LỊCH HẸN TRỰC TUYẾN THÀNH CÔNG!</h2>
        <p>Hệ thống GaraMan đã ghi nhận lịch hẹn của quý khách:</p>
        <table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; width:100%; max-width:500px;">
            <tr><td><b>Mã lịch hẹn:</b></td><td><b style="color:blue; font-size:16px;"><%= app != null ? app.getAppointmentCode() : "" %></b></td></tr>
            <tr><td><b>Ngày hẹn:</b></td><td><%= app != null ? app.getAppointmentDate() : "" %></td></tr>
            <tr><td><b>Tổng tiền ước tính:</b></td><td><b style="color:red;"><%= app != null ? String.format("%,.0f", app.getTotalAmount()) : "0" %> VNĐ</b></td></tr>
            <tr><td><b>Ghi chú:</b></td><td><%= (app != null && app.getNote() != null) ? app.getNote() : "Không có" %></td></tr>
        </table>
        <p><i>Vui lòng có mặt trước 10 phút so với giờ hẹn để gara tiếp nhận xe chu đáo nhất.</i></p>
    <%
        } else if("duplicate".equalsIgnoreCase(status)) {
    %>
        <h2 style="color:red;">ĐẶT LỊCH HẸN THẤT BẠI</h2>
        <p>Quý khách đã có một lịch hẹn trong khung giờ này. Vui lòng chọn ngày hoặc khung giờ khác!</p>
    <%
        } else {
    %>
        <h2 style="color:red;">LỖI HỆ THỐNG</h2>
        <p>Không thể lưu lịch hẹn do lỗi kết nối cơ sở dữ liệu. Quý khách vui lòng thử lại sau!</p>
    <%
        }
    %>
    <br/>
    <a href="gdChinhKH.jsp" style="font-weight:bold; color:#003366;">Quay về Trang chủ Khách hàng</a>
</body>
</html>
