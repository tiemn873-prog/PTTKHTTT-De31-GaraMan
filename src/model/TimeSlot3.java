package model;

import java.io.Serializable;
import java.sql.Time;

public class TimeSlot3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private Time startTime;
    private Time endTime;
    private int maxCapacity;
    private String status;

    public TimeSlot3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
