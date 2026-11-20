package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

public class Appointment3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp Appointment3
    private int id;
    private String appointmentCode;                             // Mã lịch hẹn (-appointmentCode : String)
    private Date appointmentDate;                               // Ngày hẹn (-appointmentDate : Date)
    private Date bookingDate;                                   // Ngày đặt lịch (-bookingDate : Date)
    private String status;                                      // Trạng thái (-status : String)
    private String note;                                        // Ghi chú (-note : String)
    private Customer3 customer;                                 // Khách hàng (-customer : Customer3)
    private Car3 car;                                           // Xe (-car : Car3)
    private TimeSlot3 timeSlot;                                 // Khung giờ (-timeSlot : TimeSlot3)
    private ArrayList<AppointmentDetail3> details;              // Danh sách chi tiết (-details : AppointmentDetail3[])
    
    // Thuộc tính bổ trợ tính tổng tiền
    private double totalAmount;

    public Appointment3() {
        this.details = new ArrayList<>();
    }

    public Appointment3(int id, String appointmentCode, Date appointmentDate, Date bookingDate, String status, String note, Customer3 customer, Car3 car, TimeSlot3 timeSlot) {
        this.id = id;
        this.appointmentCode = appointmentCode;
        this.appointmentDate = appointmentDate;
        this.bookingDate = bookingDate;
        this.status = status;
        this.note = note;
        this.customer = customer;
        this.car = car;
        this.timeSlot = timeSlot;
        this.details = new ArrayList<>();
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

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    // Tên chuẩn theo sơ đồ: bookingDate
    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    // Alias tương thích code cũ: createdDate
    public Date getCreatedDate() {
        return bookingDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.bookingDate = createdDate;
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

    // Tên chuẩn theo sơ đồ: details
    public ArrayList<AppointmentDetail3> getDetails() {
        return details;
    }

    public void setDetails(ArrayList<AppointmentDetail3> details) {
        this.details = details;
    }

    // Alias tương thích code cũ: appointmentDetails
    public ArrayList<AppointmentDetail3> getAppointmentDetails() {
        return details;
    }

    public void setAppointmentDetails(ArrayList<AppointmentDetail3> appointmentDetails) {
        this.details = appointmentDetails;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
}
