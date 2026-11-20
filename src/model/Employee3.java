package model;

import java.util.Date;

public class Employee3 extends Member3 {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp Employee3
    private String employeeCode;    // Mã nhân viên (-employeeCode : String)
    private String position;        // Chức vụ (-position : String)
    private Date hireDate;          // Ngày tuyển dụng (-hireDate : Date)
    
    // Thuộc tính bổ trợ
    private double salary;

    public Employee3() {
        super();
    }

    public Employee3(String employeeCode, String position, Date hireDate) {
        super();
        this.employeeCode = employeeCode;
        this.position = position;
        this.hireDate = hireDate;
    }

    public String getEmployeeCode() {
        return employeeCode;
    }

    public void setEmployeeCode(String employeeCode) {
        this.employeeCode = employeeCode;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    // Tên chuẩn theo sơ đồ: hireDate
    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    // Alias tương thích code cũ: startDate
    public Date getStartDate() {
        return hireDate;
    }

    public void setStartDate(Date startDate) {
        this.hireDate = startDate;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }
}
