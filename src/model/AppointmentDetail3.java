package model;

import java.io.Serializable;

public class AppointmentDetail3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp AppointmentDetail3
    private int id;
    private String note;            // Ghi chú chi tiết (-note : String)
    private Service3 service;       // Dịch vụ (-service : Service3)
    
    // Bổ trợ CSDL và hiển thị
    private int appointmentId;
    private double price;

    public AppointmentDetail3() {
    }

    public AppointmentDetail3(int id, String note, Service3 service) {
        this.id = id;
        this.note = note;
        this.service = service;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Service3 getService() {
        return service;
    }

    public void setService(Service3 service) {
        this.service = service;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
