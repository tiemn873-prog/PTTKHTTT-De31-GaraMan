package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

public class Appointment3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String appointmentCode;
    private Customer3 customer;
    private Car3 car;
    private TimeSlot3 timeSlot;
    private Date appointmentDate;
    private double totalAmount;
    private String status;
    private String note;
    private Date createdDate;
    private ArrayList<AppointmentDetail3> appointmentDetails;

    public Appointment3() {
        this.appointmentDetails = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAppointmentCode() {
        return appointmentCode;
    }

    public void setAppointmentCode(String appointmentCode) {
        this.appointmentCode = appointmentCode;
    }

    public Customer3 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer3 customer) {
        this.customer = customer;
    }

    public Car3 getCar() {
        return car;
    }

    public void setCar(Car3 car) {
        this.car = car;
    }

    public TimeSlot3 getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(TimeSlot3 timeSlot) {
        this.timeSlot = timeSlot;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public ArrayList<AppointmentDetail3> getAppointmentDetails() {
        return appointmentDetails;
    }

    public void setAppointmentDetails(ArrayList<AppointmentDetail3> appointmentDetails) {
        this.appointmentDetails = appointmentDetails;
    }
}
