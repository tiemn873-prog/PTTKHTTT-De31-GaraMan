package model;

import java.util.Date;

public class Employee3 extends Member3 {
    private static final long serialVersionUID = 1L;
    
    private String position;
    private double salary;
    private Date startDate;

    public Employee3() {
        super();
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
}
