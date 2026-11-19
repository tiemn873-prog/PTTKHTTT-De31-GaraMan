<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date, java.util.ArrayList, dao.Appointment3DAO, dao.Car3DAO, model.Customer3, model.Car3, model.TimeSlot3, model.Service3, model.Appointment3, model.AppointmentDetail3" %>
<%
    request.setCharacterEncoding("UTF-8");
    Customer3 cust = (Customer3) session.getAttribute("currentCustomer");
    ArrayList<Service3> selectedServices = (ArrayList<Service3>) session.getAttribute("selectedServices");
    
    if(cust == null || selectedServices == null || selectedServices.isEmpty()) {
        response.sendRedirect("gdChonNgayGioDV.jsp");
        return;
    }
    
    String appointmentDateStr = request.getParameter("appointmentDate");
    Date appointmentDate = Date.valueOf(appointmentDateStr);
    int timeSlotId = Integer.parseInt(request.getParameter("timeSlotId"));
    double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
    String note = request.getParameter("note");
    
    Appointment3DAO appDAO = new Appointment3DAO();
    if(appDAO.checkDuplicate(cust.getId(), appointmentDate, timeSlotId)) {
        response.sendRedirect("gdKetQuaDatLich.jsp?status=duplicate");
        return;
    }
    
    String carOption = request.getParameter("carOption");
    Car3 car = new Car3();
    if("new".equalsIgnoreCase(carOption)) {
        Car3DAO carDAO = new Car3DAO();
        car.setCustomerId(cust.getId());
        car.setLicensePlate(request.getParameter("newLicensePlate"));
        car.setBrand(request.getParameter("newBrand"));
        car.setModel(request.getParameter("newModel"));
        car.setColor(request.getParameter("newColor"));
        car.setYear(Integer.parseInt(request.getParameter("newYear")));
        int newCarId = carDAO.saveCar(car);
        car.setId(newCarId);
    } else {
        car.setId(Integer.parseInt(carOption));
    }
    
    Appointment3 app = new Appointment3();
    app.setCustomer(cust);
    app.setCar(car);
    
    TimeSlot3 slot = new TimeSlot3();
    slot.setId(timeSlotId);
    app.setTimeSlot(slot);
    
    app.setAppointmentDate(appointmentDate);
    app.setTotalAmount(totalAmount);
    app.setNote(note);
    
    ArrayList<AppointmentDetail3> details = new ArrayList<>();
    for(Service3 s : selectedServices) {
        AppointmentDetail3 d = new AppointmentDetail3();
        d.setService(s);
        d.setPrice(s.getPrice());
        details.add(d);
    }
    app.setAppointmentDetails(details);
    
    boolean ok = appDAO.saveAppointment(app);
    if(ok) {
        session.setAttribute("confirmedAppointment", app);
        response.sendRedirect("gdKetQuaDatLich.jsp?status=success");
    } else {
        response.sendRedirect("gdKetQuaDatLich.jsp?status=failed");
    }
%>
