package model;

public class SupplierStatistic3 extends Supplier3 {
    private static final long serialVersionUID = 1L;
    
    private int totalReceipts;
    private int totalQuantity;
    private double totalAmount;

    public SupplierStatistic3() {
        super();
    }

    public int getTotalReceipts() {
        return totalReceipts;
    }

    public void setTotalReceipts(int totalReceipts) {
        this.totalReceipts = totalReceipts;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
}
