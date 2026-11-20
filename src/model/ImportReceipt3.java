package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

public class ImportReceipt3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp ImportReceipt3
    private int id;
    private String receiptNumber;           // Số phiếu nhập (-receiptNumber : String)
    private Date importDate;                // Ngày nhập (-importDate : Date)
    private String note;                    // Ghi chú (-note : String)
    private Supplier3 supplier;             // Nhà cung cấp (-supplier : Supplier3)
    private WarehouseStaff3 createdBy;      // Nhân viên kho lập phiếu (-createdBy : WarehouseStaff3)
    private ArrayList<ImportDetail3> details; // Chi tiết phiếu nhập (-details : ImportDetail3[])
    
    // Các trường bổ trợ giao diện & DTO
    private int warehouseStaffId;
    private String staffName;
    private double totalAmount;
    private int totalPartCount;

    public ImportReceipt3() {
        this.details = new ArrayList<>();
    }

    public ImportReceipt3(int id, String receiptNumber, Date importDate, String note, Supplier3 supplier, WarehouseStaff3 createdBy) {
        this.id = id;
        this.receiptNumber = receiptNumber;
        this.importDate = importDate;
        this.note = note;
        this.supplier = supplier;
        this.createdBy = createdBy;
        this.details = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Tên chuẩn theo sơ đồ: receiptNumber
    public String getReceiptNumber() {
        return receiptNumber;
    }

    public void setReceiptNumber(String receiptNumber) {
        this.receiptNumber = receiptNumber;
    }

    // Alias tương thích code cũ: receiptCode
    public String getReceiptCode() {
        return receiptNumber;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptNumber = receiptCode;
    }

    public Date getImportDate() {
        return importDate;
    }

    public void setImportDate(Date importDate) {
        this.importDate = importDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Supplier3 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier3 supplier) {
        this.supplier = supplier;
    }

    public WarehouseStaff3 getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(WarehouseStaff3 createdBy) {
        this.createdBy = createdBy;
    }

    public ArrayList<ImportDetail3> getDetails() {
        return details;
    }

    public void setDetails(ArrayList<ImportDetail3> details) {
        this.details = details;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getTotalPartCount() {
        return totalPartCount;
    }

    public void setTotalPartCount(int totalPartCount) {
        this.totalPartCount = totalPartCount;
    }
}
