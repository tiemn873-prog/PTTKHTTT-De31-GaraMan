package model;

import java.io.Serializable;

public class Supplier3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    // Các trường khớp chính xác 100% với Sơ đồ thiết kế lớp Supplier3
    private int id;
    private String supplierCode;    // Mã NCC (-supplierCode : String)
    private String name;            // Tên NCC (-name : String)
    private String address;         // Địa chỉ (-address : String)
    private String phone;           // Số điện thoại (-phone : String)
    private String email;           // Email (-email : String)
    private String representative;  // Người đại diện (-representative : String)
    
    // Thuộc tính bổ trợ CSDL
    private String taxCode;

    public Supplier3() {
    }

    public Supplier3(int id, String supplierCode, String name, String address, String phone, String email, String representative) {
        this.id = id;
        this.supplierCode = supplierCode;
        this.name = name;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.representative = representative;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Tên chuẩn theo sơ đồ: supplierCode
    public String getSupplierCode() {
        return supplierCode;
    }

    public void setSupplierCode(String supplierCode) {
        this.supplierCode = supplierCode;
    }

    // Alias tương thích code cũ: code
    public String getCode() {
        return supplierCode;
    }

    public void setCode(String code) {
        this.supplierCode = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRepresentative() {
        return representative;
    }

    public void setRepresentative(String representative) {
        this.representative = representative;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }
}
