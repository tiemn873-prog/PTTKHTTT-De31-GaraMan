<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, dao.CustomerDAO3, dao.CarDAO3, dao.ServiceDAO3, dao.TimeSlotDAO3, model.Member3, model.Customer3, model.Car3, model.Service3, model.TimeSlot3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String appointmentDate = request.getParameter("appointmentDate");
    String timeSlotIdStr = request.getParameter("timeSlotId");
    String[] serviceIds = request.getParameterValues("serviceIds");
    
    if (timeSlotIdStr == null || serviceIds == null || serviceIds.length == 0) {
        response.sendRedirect("SelectSlot3.jsp?appointmentDate=" + (appointmentDate != null ? appointmentDate : ""));
        return;
    }
    
    int timeSlotId = Integer.parseInt(timeSlotIdStr);
    
    CustomerDAO3 custDAO = new CustomerDAO3();
    Customer3 cust = custDAO.getCustomerInfo(user.getId());
    
    CarDAO3 carDAO = new CarDAO3();
    ArrayList<Car3> listCar = carDAO.getCarOfCustomer(cust != null ? cust.getId() : 0);
    
    ServiceDAO3 sDAO = new ServiceDAO3();
    ArrayList<Service3> allServices = sDAO.getAllServices();
    ArrayList<Service3> selectedServices = new ArrayList<>();
    double totalAmount = 0.0;
    for (String sid : serviceIds) {
        int id = Integer.parseInt(sid);
        for (Service3 s : allServices) {
            if (s.getId() == id) {
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
    <title>ConfirmInfo3 - Xác nhận thông tin đặt lịch hẹn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .card { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn { padding: 9px 18px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-success { background: #28a745; color: white; font-weight: bold; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h2 style="color: #003366;">BƯỚC 2: XÁC NHẬN THÔNG TIN ĐẶT LỊCH HẸN</h2>
        
        <form action="SaveAppointment3.jsp" method="post">
            <input type="hidden" name="appointmentDate" value="<%= appointmentDate %>" />
            <input type="hidden" name="timeSlotId" value="<%= timeSlotId %>" />
            <input type="hidden" name="totalAmount" value="<%= totalAmount %>" />

            <h3 style="border-bottom: 2px solid #003366; padding-bottom: 5px; color: #003366;">1. Thông tin khách hàng</h3>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label>Họ và tên:</label>
                    <input type="text" id="fullName" class="form-control" value="<%= cust != null ? cust.getName() : "" %>" readonly />
                </div>
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="text" id="phone" class="form-control" value="<%= cust != null ? cust.getPhone() : "" %>" readonly />
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="text" id="email" class="form-control" value="<%= cust != null ? cust.getEmail() : "" %>" readonly />
                </div>
                <div class="form-group">
                    <label>Địa chỉ:</label>
                    <input type="text" id="address" class="form-control" value="<%= cust != null ? cust.getAddress() : "" %>" readonly />
                </div>
            </div>

            <h3 style="border-bottom: 2px solid #003366; padding-bottom: 5px; color: #003366; margin-top: 25px;">2. Chọn xe thực hiện dịch vụ</h3>
            <div class="form-group">
                <label>Chọn xe đã đăng ký:</label>
                <select id="selectCar" name="carId" class="form-control" style="font-size: 14px;">
                    <%
                        if (listCar != null && !listCar.isEmpty()) {
                            for (Car3 car : listCar) {
                    %>
                        <option value="<%= car.getId() %>"><%= car.getLicensePlate() %> - <%= car.getBrand() %> <%= car.getModel() %> (<%= car.getColor() %>)</option>
                    <%
                            }
                        } else {
                    %>
                        <option value="0">-- Chưa có xe trong hệ thống, nhập xe mới bên dưới --</option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div style="background: #f0f4f8; padding: 15px; border-radius: 6px; margin-top: 10px;">
                <label style="font-weight: bold; color: #003366;">Hoặc đăng ký xe mới:</label>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 8px;">
                    <input type="text" name="newLicensePlate" placeholder="Biển số xe (VD: 30F-999.88)" class="form-control" />
                    <input type="text" name="newBrand" placeholder="Hãng xe (VD: Toyota)" class="form-control" />
                    <input type="text" name="newModel" placeholder="Dòng xe (VD: Vios)" class="form-control" />
                </div>
            </div>

            <h3 style="border-bottom: 2px solid #003366; padding-bottom: 5px; color: #003366; margin-top: 25px;">3. Tóm tắt lịch hẹn</h3>
            <p><strong>Ngày hẹn:</strong> <%= appointmentDate %></p>
            <p><strong>Dịch vụ đã chọn:</strong></p>
            <ul>
                <% for (Service3 s : selectedServices) { %>
                    <li><%= s.getName() %> - <span style="color: #003366;"><%= String.format("%,.0f", s.getPrice()) %> VNĐ</span></li>
                <% } %>
            </ul>
            <p style="font-size: 16px;"><strong>Tổng tiền dự kiến:</strong> <span style="color: #c00; font-size: 18px; font-weight: bold;"><%= String.format("%,.0f", totalAmount) %> VNĐ</span></p>

            <div class="form-group" style="margin-top: 20px;">
                <label>Ghi chú yêu cầu thêm:</label>
                <textarea id="note" name="note" rows="3" class="form-control" placeholder="Yêu cầu kiểm tra thêm phanh, gầm..."></textarea>
            </div>

            <div style="margin-top: 25px; display: flex; gap: 15px;">
                <a id="back" href="SelectSlot3.jsp?appointmentDate=<%= appointmentDate %>" class="btn btn-secondary">Quay lại</a>
                <input id="btnConfirm" type="submit" value="Xác nhận đặt lịch hẹn" class="btn btn-success" />
            </div>
        </form>
    </div>
</body>
</html>
