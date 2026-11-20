package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class SparePart3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp SparePart3
    private int id;
    private String partCode;        // Mã phụ tùng (-partCode : String)
    private String name;            // Tên phụ tùng (-name : String)
    private String unit;            // Đơn vị tính (-unit : String)
    private BigDecimal salePrice;   // Giá bán (-salePrice : BigDecimal)
    private int stockQuantity;      // Số lượng tồn kho (-stockQuantity : int)
    private String description;     // Mô tả chi tiết (-description : String)
    private PartCategory3 category; // Danh mục phụ tùng

    public SparePart3() {
    }

    public SparePart3(int id, String partCode, String name, String unit, BigDecimal salePrice, int stockQuantity, String description) {
        this.id = id;
        this.partCode = partCode;
        this.name = name;
        this.unit = unit;
        this.salePrice = salePrice;
        this.stockQuantity = stockQuantity;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPartCode() {
        return partCode;
    }

    public void setPartCode(String partCode) {
        this.partCode = partCode;
    }

    // Alias tương thích code cũ
    public String getCode() {
        return partCode;
    }

    public void setCode(String code) {
        this.partCode = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    // Alias tương thích kiểu double
    public double getPrice() {
        return salePrice != null ? salePrice.doubleValue() : 0.0;
    }

    public void setPrice(double price) {
        this.salePrice = BigDecimal.valueOf(price);
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PartCategory3 getCategory() {
        return category;
    }

    public void setCategory(PartCategory3 category) {
        this.category = category;
    }
}
