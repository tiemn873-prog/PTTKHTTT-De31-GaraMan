<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, dao.Customer3DAO, dao.Car3DAO, dao.Service3DAO, model.Member3, model.Customer3, model.Car3, model.Service3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String appointmentDate = request.getParameter("appointmentDate");
    String timeSlotId = request.getParameter("timeSlotId");
    String[] serviceIds = request.getParameterValues("serviceIds");
    
    if(timeSlotId == null || serviceIds == null || serviceIds.length == 0) {
        response.sendRedirect("gdChonNgayGioDV.jsp?appointmentDate=" + appointmentDate);
        return;
    }
    
    Customer3DAO custDAO = new Customer3DAO();
    Customer3 cust = custDAO.getCustomerInfo(user.getId());
    
    Car3DAO carDAO = new Car3DAO();
    ArrayList<Car3> listCar = carDAO.getCarOfCustomer(cust.getId());
    
    Service3DAO sDAO = new Service3DAO();
    ArrayList<Service3> allServices = sDAO.getServiceList();
    ArrayList<Service3> selectedServices = new ArrayList<>();
    double totalAmount = 0.0;
    for(String sid : serviceIds) {
        int id = Integer.parseInt(sid);
        for(Service3 s : allServices) {
            if(s.getId() == id) {
                selectedServices.add(s);
                totalAmount += s.getPrice();
                break;
            }
        }
    }
    session.setAttribute("selectedServices", selectedServices);
    session.setAttribute("currentCustomer", cust);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch hẹn - Xác nhận thông tin</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>BƯỚC 2: XÁC NHẬN THÔNG TIN KHÁCH HÀNG, XE VÀ LỊCH HẸN</h2>
    <form action="doDatLich.jsp" method="post">
        <input type="hidden" name="appointmentDate" value="<%= appointmentDate %>" />
        <input type="hidden" name="timeSlotId" value="<%= timeSlotId %>" />
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>" />
        
        <h3>1. Thông tin cá nhân khách hàng</h3>
        <p>Họ tên: <b><%= cust.getName() %></b> | Điện thoại: <b><%= cust.getPhone() %></b> | Email: <b><%= cust.getEmail() %></b></p>
        
        <h3>2. Thông tin xe thực hiện dịch vụ</h3>
        <% if(listCar != null && !listCar.isEmpty()) { %>
            <p>Chọn xe đã đăng ký:</p>
            <% for(Car3 car : listCar) { %>
                <label style="display:block; margin: 4px 0;">
                    <input type="radio" name="carOption" value="<%= car.getId() %>" checked />
                    Biển số: <b><%= car.getLicensePlate() %></b> - <%= car.getBrand() %> <%= car.getModel() %> (<%= car.getColor() %>)
                </label>
            <% } %>
            <br/>
            <label><input type="radio" name="carOption" value="new" /> Nhập xe khác:</label><br/>
        <% } else { %>
            <input type="hidden" name="carOption" value="new" />
            <p>Quý khách chưa có xe trong hệ thống, vui lòng nhập thông tin xe:</p>
        <% } %>
        
        <table border="0" cellpadding="4">
            <tr><td>Biển số xe:</td><td><input type="text" name="newLicensePlate" placeholder="VD: 30F-999.88" /></td></tr>
            <tr><td>Hãng xe:</td><td><input type="text" name="newBrand" placeholder="VD: Toyota" /></td></tr>
            <tr><td>Dòng xe:</td><td><input type="text" name="newModel" placeholder="VD: Vios" /></td></tr>
            <tr><td>Màu sắc:</td><td><input type="text" name="newColor" placeholder="VD: Trắng" /></td></tr>
            <tr><td>Năm sản xuất:</td><td><input type="number" name="newYear" value="2020" /></td></tr>
        </table>
        
        <h3>3. Dịch vụ đã đăng ký & Tổng chi phí ước tính</h3>
        <ul>
            <% for(Service3 s : selectedServices) { %>
                <li><%= s.getName() %>: <b><%= String.format("%,.0f", s.getPrice()) %> VNĐ</b></li>
            <% } %>
        </ul>
        <p>Tổng tiền dự kiến: <b style="color:red; font-size:16px;"><%= String.format("%,.0f", totalAmount) %> VNĐ</b></p>
        
        <h3>4. Ghi chú yêu cầu thêm cho kỹ thuật viên:</h3>
        <textarea name="note" rows="3" cols="50" placeholder="Yêu cầu kiểm tra thêm tiếng kêu ở gầm..."></textarea>
        <br/><br/>
        <input type="submit" value="XÁC NHẬN ĐẶT LỊCH HẸN" style="background-color:#28a745; color:white; font-size:14px; padding:8px 16px; border:none; cursor:pointer;" />
    </form>
</body>
</html>
