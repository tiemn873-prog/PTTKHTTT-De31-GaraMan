package model;

import java.io.Serializable;

public class AppointmentDetail3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private int appointmentId;
    private Service3 service;
    private double price;

    public AppointmentDetail3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Service3 getService() {
        return service;
    }

    public void setService(Service3 service) {
        this.service = service;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
