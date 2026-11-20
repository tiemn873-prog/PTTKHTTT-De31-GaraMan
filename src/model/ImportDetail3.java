package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class ImportDetail3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp ImportDetail3
    private int id;
    private int quantity;               // Số lượng (-quantity : int)
    private BigDecimal importPrice;     // Đơn giá nhập (-importPrice : BigDecimal)
    private SparePart3 sparePart;       // Phụ tùng (-sparePart : SparePart3)
    
    // Các trường bổ trợ CSDL & hiển thị
    private int receiptId;
    private double amount;

    public ImportDetail3() {
    }

    public ImportDetail3(int id, int quantity, BigDecimal importPrice, SparePart3 sparePart) {
        this.id = id;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.sparePart = sparePart;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Tên chuẩn theo sơ đồ: BigDecimal importPrice
    public BigDecimal getImportPriceBigDecimal() {
        return importPrice;
    }

    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
    }

    // Alias tương thích code cũ: double unitPrice
    public double getUnitPrice() {
        return importPrice != null ? importPrice.doubleValue() : 0.0;
    }

    public void setUnitPrice(double unitPrice) {
        this.importPrice = BigDecimal.valueOf(unitPrice);
    }

    public double getImportPrice() {
        return getUnitPrice();
    }

    public void setImportPrice(double importPrice) {
        setUnitPrice(importPrice);
    }

    public SparePart3 getSparePart() {
        return sparePart;
    }

    public void setSparePart(SparePart3 sparePart) {
        this.sparePart = sparePart;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}
