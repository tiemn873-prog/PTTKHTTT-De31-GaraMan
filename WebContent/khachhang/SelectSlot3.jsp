<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.ServiceDAO3, dao.TimeSlotDAO3, model.Service3, model.TimeSlot3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String dateStr = request.getParameter("appointmentDate");
    Date chosenDate = null;
    if (dateStr != null && !dateStr.isEmpty()) {
        chosenDate = Date.valueOf(dateStr);
    } else {
        chosenDate = new Date(System.currentTimeMillis() + 86400000L);
        dateStr = chosenDate.toString();
    }
    
    ServiceDAO3 sDAO = new ServiceDAO3();
    ArrayList<Service3> listService = sDAO.getAllServices();
    
    TimeSlotDAO3 slotDAO = new TimeSlotDAO3();
    ArrayList<TimeSlot3> listSlot = slotDAO.getAvailableSlots(chosenDate);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SelectSlot3 - Chọn ngày hẹn, khung giờ và dịch vụ</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .card { max-width: 900px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px 12px; }
        th { background: #003366; color: white; text-align: left; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-success { background: #28a745; color: white; font-weight: bold; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
    <script>
        function updateTotal() {
            let checkboxes = document.querySelectorAll('input[name="serviceIds"]:checked');
            let total = 0;
            checkboxes.forEach(cb => {
                let price = parseFloat(cb.getAttribute('data-price')) || 0;
                total += price;
            });
            document.getElementById('totalAmount').innerText = total.toLocaleString('vi-VN') + ' VNĐ';
            document.getElementById('totalAmountInput').value = total;
        }
    </script>
</head>
<body>
    <div class="card">
        <h2 style="color: #003366;">BƯỚC 1: CHỌN NGÀY HẸN, KHUNG GIỜ VÀ DỊCH VỤ</h2>
        
        <form action="SelectSlot3.jsp" method="get" style="margin-bottom: 20px;">
            <label><strong>Chọn ngày hẹn:</strong> </label>
            <input type="date" name="appointmentDate" value="<%= dateStr %>" onchange="this.form.submit()" style="padding: 6px; border: 1px solid #ccc; border-radius: 4px;" />
            <input type="submit" value="Xem khung giờ" class="btn btn-secondary" style="padding: 6px 12px;" />
        </form>

        <form action="ConfirmInfo3.jsp" method="post">
            <input type="hidden" name="appointmentDate" value="<%= dateStr %>" />
            <input type="hidden" name="totalAmount" id="totalAmountInput" value="0" />

            <h3>1. Khung giờ còn trống trong ngày (<%= dateStr %>)</h3>
            <table id="tblSlot">
                <thead>
                    <tr>
                        <th style="width: 60px; text-align: center;">Chọn</th>
                        <th>Giờ bắt đầu</th>
                        <th>Giờ kết thúc</th>
                        <th style="text-align: center;">Số chỗ còn lại</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (listSlot == null || listSlot.isEmpty()) {
                %>
                    <tr><td colspan="4" style="color: red; text-align: center;">Ngày này gara đã kín lịch hẹn, vui lòng chọn ngày khác!</td></tr>
                <%
                    } else {
                        for (TimeSlot3 slot : listSlot) {
                %>
                    <tr>
                        <td align="center"><input type="radio" name="timeSlotId" value="<%= slot.getId() %>" required /></td>
                        <td><%= slot.getStartTime() %></td>
                        <td><%= slot.getEndTime() %></td>
                        <td align="center"><span style="color: #28a745; font-weight: bold;"><%= slot.getMaxCapacity() %></span></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>

            <h3 style="margin-top: 25px;">2. Chọn các dịch vụ yêu cầu</h3>
            <table id="tblService">
                <thead>
                    <tr>
                        <th style="width: 60px; text-align: center;">Chọn</th>
                        <th>Tên dịch vụ</th>
                        <th>Danh mục</th>
                        <th>Đơn giá</th>
                        <th style="text-align: center;">Thời gian (phút)</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Service3 s : listService) {
                %>
                    <tr>
                        <td align="center"><input type="checkbox" name="serviceIds" value="<%= s.getId() %>" data-price="<%= s.getPrice() %>" onchange="updateTotal()" /></td>
                        <td><strong><%= s.getName() %></strong></td>
                        <td><%= s.getCategory() != null ? s.getCategory().getName() : "Chung" %></td>
                        <td><%= String.format("%,.0f", s.getPrice()) %> VNĐ</td>
                        <td align="center"><%= s.getEstimatedDuration() %></td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>

            <div style="margin-top: 15px; font-size: 16px; font-weight: bold; color: #003366;">
                Tổng tiền dịch vụ tạm tính: <span id="totalAmount" style="color: #c00;">0 VNĐ</span>
            </div>

            <div style="margin-top: 25px; display: flex; gap: 15px;">
                <a id="back" href="CustomerMain3.jsp" class="btn btn-secondary">Quay lại</a>
                <input id="btnNext" type="submit" value="Tiếp tục: Xác nhận thông tin" class="btn btn-success" />
            </div>
        </form>
    </div>
</body>
</html>
