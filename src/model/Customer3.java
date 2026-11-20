package model;

import java.util.ArrayList;

public class Customer3 extends Member3 {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp 100% với Sơ đồ thiết kế lớp Customer3
    private String customerCode;            // Mã khách hàng (-customerCode : String)
    private int loyaltyPoint;               // Điểm tích lũy (-loyaltyPoint : int)
    private ArrayList<Car3> cars;           // Danh sách xe (-cars : Car3[])
    
    // Hỗ trợ tương thích ngược
    private int memberId;
    private String licenseNo;
    private String customerType;

    public Customer3() {
        super();
        this.cars = new ArrayList<>();
    }

    public Customer3(String customerCode, int loyaltyPoint) {
        super();
        this.customerCode = customerCode;
        this.loyaltyPoint = loyaltyPoint;
        this.cars = new ArrayList<>();
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public int getLoyaltyPoint() {
        return loyaltyPoint;
    }

    public void setLoyaltyPoint(int loyaltyPoint) {
        this.loyaltyPoint = loyaltyPoint;
    }

    public ArrayList<Car3> getCars() {
        return cars;
    }

    public void setCars(ArrayList<Car3> cars) {
        this.cars = cars;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public String getLicenseNo() {
        return licenseNo;
    }

    public void setLicenseNo(String licenseNo) {
        this.licenseNo = licenseNo;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }
}
