package model;

import java.io.Serializable;

public class ImportDetail3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private int receiptId;
    private SparePart3 sparePart;
    private int quantity;
    private double unitPrice;
    private double amount;

    public ImportDetail3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public SparePart3 getSparePart() {
        return sparePart;
    }

    public void setSparePart(SparePart3 sparePart) {
        this.sparePart = sparePart;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
}
