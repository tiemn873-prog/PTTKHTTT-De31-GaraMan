package model;

public class Customer3 extends Member3 {
    private static final long serialVersionUID = 1L;
    
    private int memberId;
    private String licenseNo;
    private String customerType;

    public Customer3() {
        super();
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
