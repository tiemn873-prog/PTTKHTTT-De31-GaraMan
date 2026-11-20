package model;

import java.io.Serializable;
import java.sql.Time;

public class TimeSlot3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp 100% với Sơ đồ thiết kế lớp TimeSlot3
    private int id;
    private String name;        // Tên khung giờ (-name : String)
    private Time startTime;     // Giờ bắt đầu (-startTime : Time)
    private Time endTime;       // Giờ kết thúc (-endTime : Time)
    private int maxSlot;        // Số lượng xe tối đa trong khung giờ (-maxSlot : int)
    
    // Thuộc tính bổ trợ
    private String status;

    public TimeSlot3() {
    }

    public TimeSlot3(int id, String name, Time startTime, Time endTime, int maxSlot) {
        this.id = id;
        this.name = name;
        this.startTime = startTime;
        this.endTime = endTime;
        this.maxSlot = maxSlot;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    // Tên chuẩn theo sơ đồ: maxSlot
    public int getMaxSlot() {
        return maxSlot;
    }

    public void setMaxSlot(int maxSlot) {
        this.maxSlot = maxSlot;
    }

    // Alias tương thích code cũ: maxCapacity
    public int getMaxCapacity() {
        return maxSlot;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxSlot = maxCapacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
