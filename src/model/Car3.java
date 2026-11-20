package model;

import java.io.Serializable;

public class Car3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp 100% với Sơ đồ thiết kế lớp Car3
    private int id;
    private String plateNumber;         // Biển số xe (-plateNumber : String)
    private String brand;               // Hãng xe (-brand : String)
    private String model;               // Dòng xe (-model : String)
    private int manufactureYear;        // Năm sản xuất (-manufactureYear : int)
    private String color;               // Màu sơn (-color : String)
    private String chassisNumber;       // Số khung (-chassisNumber : String)
    
    // Khóa ngoại hỗ trợ CSDL
    private int customerId;

    public Car3() {
    }

    public Car3(int id, String plateNumber, String brand, String model, int manufactureYear, String color, String chassisNumber) {
        this.id = id;
        this.plateNumber = plateNumber;
        this.brand = brand;
        this.model = model;
        this.manufactureYear = manufactureYear;
        this.color = color;
        this.chassisNumber = chassisNumber;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    // Tên chuẩn theo sơ đồ: plateNumber
    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    // Alias tương thích code cũ: licensePlate
    public String getLicensePlate() {
        return plateNumber;
    }

    public void setLicensePlate(String licensePlate) {
        this.plateNumber = licensePlate;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    // Tên chuẩn theo sơ đồ: manufactureYear
    public int getManufactureYear() {
        return manufactureYear;
    }

    public void setManufactureYear(int manufactureYear) {
        this.manufactureYear = manufactureYear;
    }

    // Alias tương thích code cũ: year
    public int getYear() {
        return manufactureYear;
    }

    public void setYear(int year) {
        this.manufactureYear = year;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getChassisNumber() {
        return chassisNumber;
    }

    public void setChassisNumber(String chassisNumber) {
        this.chassisNumber = chassisNumber;
    }
}
