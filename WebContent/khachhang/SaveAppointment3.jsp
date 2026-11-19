<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date, java.util.ArrayList, dao.AppointmentDAO3, dao.CarDAO3, model.Appointment3, model.AppointmentDetail3, model.Customer3, model.Car3, model.TimeSlot3, model.Service3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    Customer3 cust = (Customer3) session.getAttribute("currentCustomer");
    @SuppressWarnings("unchecked")
    ArrayList<Service3> selectedServices = (ArrayList<Service3>) session.getAttribute("selectedServices");
    
    String appointmentDateStr = request.getParameter("appointmentDate");
    String timeSlotIdStr = request.getParameter("timeSlotId");
    String carIdStr = request.getParameter("carId");
    String newLicensePlate = request.getParameter("newLicensePlate");
    String newBrand = request.getParameter("newBrand");
    String newModel = request.getParameter("newModel");
    String note = request.getParameter("note");
    
    boolean success = false;
    String message = "";
    int appointmentId = 0;
    
    try {
        Date appointmentDate = Date.valueOf(appointmentDateStr);
        int timeSlotId = Integer.parseInt(timeSlotIdStr);
        int carId = (carIdStr != null && !carIdStr.isEmpty()) ? Integer.parseInt(carIdStr) : 0;
        
        CarDAO3 carDAO = new CarDAO3();
        if (carId <= 0 && newLicensePlate != null && !newLicensePlate.trim().isEmpty()) {
            Car3 newCar = new Car3();
            newCar.setCustomerId(cust.getId());
            newCar.setLicensePlate(newLicensePlate.trim().toUpperCase());
            newCar.setBrand(newBrand != null ? newBrand.trim() : "Khác");
            newCar.setModel(newModel != null ? newModel.trim() : "Khác");
            newCar.setColor("Mặc định");
            newCar.setYear(2022);
            carId = carDAO.saveCar(newCar);
        }
        
        AppointmentDAO3 appDAO = new AppointmentDAO3();
        boolean isDuplicate = appDAO.checkDuplicate(cust.getId(), appointmentDate, timeSlotId);
        if (isDuplicate) {
            message = "Quý khách đã có một lịch hẹn trong khung giờ này. Vui lòng chọn khung giờ khác!";
            success = false;
        } else {
            Appointment3 app = new Appointment3();
            app.setCustomer(cust);
            
            Car3 chosenCar = new Car3();
            chosenCar.setId(carId);
            chosenCar.setLicensePlate(newLicensePlate != null && !newLicensePlate.isEmpty() ? newLicensePlate : "Xe đã đăng ký");
            app.setCar(chosenCar);
            
            TimeSlot3 slot = new TimeSlot3();
            slot.setId(timeSlotId);
            app.setTimeSlot(slot);
            
            app.setAppointmentDate(appointmentDate);
            app.setStatus(0); // 0 = Chờ xác nhận
            app.setNote(note);
            
            double total = 0.0;
            ArrayList<AppointmentDetail3> details = new ArrayList<>();
            if (selectedServices != null) {
                for (Service3 s : selectedServices) {
                    AppointmentDetail3 d = new AppointmentDetail3();
                    d.setService(s);
                    d.setPrice(s.getPrice());
                    details.add(d);
                    total += s.getPrice();
                }
            }
            app.setTotalAmount(total);
            app.setAppointmentDetails(details);
            
            success = appDAO.saveAppointment(app);
            if (success) {
                appointmentId = app.getId();
                message = "Đặt lịch hẹn thành công! Gara sẽ liên hệ xác nhận trong thời gian sớm nhất.";
            } else {
                message = "Đã xảy ra lỗi trong quá trình lưu lịch hẹn. Vui lòng thử lại!";
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "Lỗi xử lý hệ thống: " + e.getMessage();
        success = false;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SaveAppointment3 - Kết quả đặt lịch hẹn</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
        .card { max-width: 650px; margin: 0 auto; background: white; padding: 35px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }
        .badge { display: inline-block; padding: 6px 14px; border-radius: 20px; font-weight: bold; font-size: 14px; }
        .badge-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .btn { padding: 9px 18px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin: 5px; }
        .btn-primary { background: #003366; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <% if (success) { %>
            <div style="font-size: 50px; color: #28a745; margin-bottom: 10px;">✔</div>
            <h2 style="color: #003366; margin-top: 0;">ĐẶT LỊCH HẸN THÀNH CÔNG</h2>
            <p style="font-size: 16px; color: #333;"><%= message %></p>
            <div style="background: #f9fafb; padding: 20px; border-radius: 6px; text-align: left; margin: 20px 0; border: 1px solid #e5e7eb;">
                <p><strong>Khách hàng:</strong> <%= cust != null ? cust.getName() : "" %> (<%= cust != null ? cust.getPhone() : "" %>)</p>
                <p><strong>Ngày hẹn:</strong> <%= appointmentDateStr %></p>
                <p><strong>Trạng thái nghiệp vụ:</strong> <span class="badge badge-warning">Chờ xác nhận</span></p>
            </div>
        <% } else { %>
            <div style="font-size: 50px; color: #dc3545; margin-bottom: 10px;">✖</div>
            <h2 style="color: #dc3545; margin-top: 0;">ĐẶT LỊCH HẸN KHÔNG THÀNH CÔNG</h2>
            <p class="badge badge-danger" style="font-size: 15px;"><%= message %></p>
        <% } %>
        
        <div style="margin-top: 25px;">
            <a id="btnHome" href="CustomerMain3.jsp" class="btn btn-primary">Trang chủ</a>
            <a id="btnViewMyAppointments" href="#" class="btn btn-secondary">Xem lịch hẹn của tôi</a>
        </div>
    </div>
</body>
</html>
