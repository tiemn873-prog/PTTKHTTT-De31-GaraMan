package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Service3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp Service3
    private int id;
    private String serviceCode;     // Mã dịch vụ (-serviceCode : String)
    private String name;            // Tên dịch vụ (-name : String)
    private String description;     // Mô tả dịch vụ (-description : String)
    private BigDecimal price;       // Đơn giá (-price : BigDecimal)
    private int duration;           // Thời gian thực hiện phút (-duration : int)
    
    private ServiceCategory3 category; // Danh mục dịch vụ hỗ trợ

    public Service3() {
    }

    public Service3(int id, String serviceCode, String name, String description, BigDecimal price, int duration) {
        this.id = id;
        this.serviceCode = serviceCode;
        this.name = name;
        this.description = description;
        this.price = price;
        this.duration = duration;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Tên chuẩn theo sơ đồ: BigDecimal price
    public BigDecimal getPriceBigDecimal() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    // Alias tương thích code cũ: double price
    public double getPrice() {
        return price != null ? price.doubleValue() : 0.0;
    }

    public void setPrice(double price) {
        this.price = BigDecimal.valueOf(price);
    }

    // Tên chuẩn theo sơ đồ: duration
    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    // Alias tương thích code cũ: estimatedDuration
    public int getEstimatedDuration() {
        return duration;
    }

    public void setEstimatedDuration(int estimatedDuration) {
        this.duration = estimatedDuration;
    }

    public ServiceCategory3 getCategory() {
        return category;
    }

    public void setCategory(ServiceCategory3 category) {
        this.category = category;
    }
}
