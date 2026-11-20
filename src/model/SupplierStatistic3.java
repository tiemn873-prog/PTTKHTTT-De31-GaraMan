package model;

import java.math.BigDecimal;

public class SupplierStatistic3 extends Supplier3 {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp SupplierStatistic3
    private int importCount;            // Số lần nhập (-importCount : int)
    private int totalQuantity;          // Tổng số lượng nhập (-totalQuantity : int)
    private BigDecimal totalAmount;     // Tổng giá trị nhập (-totalAmount : BigDecimal)

    public SupplierStatistic3() {
        super();
    }

    public SupplierStatistic3(int importCount, int totalQuantity, BigDecimal totalAmount) {
        super();
        this.importCount = importCount;
        this.totalQuantity = totalQuantity;
        this.totalAmount = totalAmount;
    }

    // Tên chuẩn theo sơ đồ: importCount
    public int getImportCount() {
        return importCount;
    }

    public void setImportCount(int importCount) {
        this.importCount = importCount;
    }

    // Alias tương thích code cũ: totalReceipts
    public int getTotalReceipts() {
        return importCount;
    }

    public void setTotalReceipts(int totalReceipts) {
        this.importCount = totalReceipts;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    // Tên chuẩn theo sơ đồ: BigDecimal totalAmount
    public BigDecimal getTotalAmountBigDecimal() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    // Alias tương thích code cũ: double totalAmount
    public double getTotalAmount() {
        return totalAmount != null ? totalAmount.doubleValue() : 0.0;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = BigDecimal.valueOf(totalAmount);
    }
}
