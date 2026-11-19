package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

public class ImportReceipt3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String receiptCode;
    private Supplier3 supplier;
    private int warehouseStaffId;
    private String staffName;
    private Date importDate;
    private double totalAmount;
    private String note;
    private int totalPartCount;
    private ArrayList<ImportDetail3> details;

    public ImportReceipt3() {
        this.details = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public Supplier3 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier3 supplier) {
        this.supplier = supplier;
    }

    public int getWarehouseStaffId() {
        return warehouseStaffId;
    }

    public void setWarehouseStaffId(int warehouseStaffId) {
        this.warehouseStaffId = warehouseStaffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getTotalPartCount() {
        return totalPartCount;
    }

    public void setTotalPartCount(int totalPartCount) {
        this.totalPartCount = totalPartCount;
    }

    public ArrayList<ImportDetail3> getDetails() {
        return details;
    }

    public void setDetails(ArrayList<ImportDetail3> details) {
        this.details = details;
    }
}
