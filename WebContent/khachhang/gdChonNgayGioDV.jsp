<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.Service3DAO, dao.TimeSlot3DAO, model.Service3, model.TimeSlot3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String dateStr = request.getParameter("appointmentDate");
    Date chosenDate = null;
    if(dateStr != null && !dateStr.isEmpty()) {
        chosenDate = Date.valueOf(dateStr);
    } else {
        chosenDate = new Date(System.currentTimeMillis() + 86400000L);
        dateStr = chosenDate.toString();
    }
    
    Service3DAO sDAO = new Service3DAO();
    ArrayList<Service3> listService = sDAO.getServiceList();
    
    TimeSlot3DAO slotDAO = new TimeSlot3DAO();
    ArrayList<TimeSlot3> listSlot = slotDAO.getAvailableSlot(chosenDate);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch hẹn - Chọn ngày giờ và dịch vụ</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>BƯỚC 1: CHỌN NGÀY HẸN, KHUNG GIỜ VÀ DỊCH VỤ</h2>
    <form action="gdChonNgayGioDV.jsp" method="get">
        <label><b>Chọn ngày hẹn sửa chữa/bảo dưỡng:</b> </label>
        <input type="date" name="appointmentDate" value="<%= dateStr %>" onchange="this.form.submit()" style="padding:4px;" />
        <input type="submit" value="Xem khung giờ còn trống" style="padding:4px 8px;" />
    </form>
    <hr/>
    <form action="gdNhapThongTin.jsp" method="post">
        <input type="hidden" name="appointmentDate" value="<%= dateStr %>" />
        
        <h3>1. Chọn khung giờ hẹn còn trống trong ngày (<%= dateStr %>):</h3>
        <%
            if(listSlot == null || listSlot.isEmpty()) {
        %>
            <p style="color:red; font-weight:bold;">Ngày này gara đã kín lịch hẹn, vui lòng chọn ngày khác!</p>
        <%
            } else {
                for(TimeSlot3 slot : listSlot) {
        %>
            <label style="display:block; margin: 6px 0;">
                <input type="radio" name="timeSlotId" value="<%= slot.getId() %>" required />
                Khung giờ: <b><%= slot.getStartTime() %> - <%= slot.getEndTime() %></b>
            </label>
        <%
                }
            }
        %>
        
        <h3>2. Chọn các dịch vụ yêu cầu:</h3>
        <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; width:100%; max-width:800px;">
            <tr style="background-color:#003366; color:white;">
                <th>Chọn</th>
                <th>Danh mục</th>
                <th>Tên dịch vụ</th>
                <th>Đơn giá (VNĐ)</th>
                <th>Thời gian ước tính (phút)</th>
            </tr>
            <%
                for(Service3 s : listService) {
            %>
            <tr>
                <td align="center"><input type="checkbox" name="serviceIds" value="<%= s.getId() %>" /></td>
                <td><%= s.getCategory() != null ? s.getCategory().getName() : "Chung" %></td>
                <td><b><%= s.getName() %></b></td>
                <td><%= String.format("%,.0f", s.getPrice()) %></td>
                <td align="center"><%= s.getEstimatedDuration() %></td>
            </tr>
            <%
                }
            %>
        </table>
        <br/>
        <input type="submit" value="Tiếp tục: Nhập thông tin xe & Xác nhận" style="padding: 8px 16px; background-color:#28a745; color:white; border:none; font-size:14px; cursor:pointer;" />
    </form>
</body>
</html>
