package model;

import java.io.Serializable;
import java.util.Date;

public class Member3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String username;
    private String password;
    private FullName3 fullName;
    private Date birthday;
    private Address3 address;
    private String email;
    private String phone;
    private String role;
    private String note;

    public Member3() {
        this.fullName = new FullName3();
        this.address = new Address3();
    }

    public Member3(int id, String username, String password, String name, String phone, String email, String address, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = new FullName3(name);
        this.phone = phone;
        this.email = email;
        this.address = new Address3(address);
        this.role = role;
    }

    public Member3(int id, String username, String password, FullName3 fullName, Date birthday, Address3 address, String email, String phone, String role, String note) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.birthday = birthday;
        this.address = address;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public FullName3 getFullName() {
        return fullName;
    }

    public void setFullName(FullName3 fullName) {
        this.fullName = fullName;
    }

    public String getName() {
        return fullName != null ? fullName.toString() : "";
    }

    public void setName(String name) {
        this.fullName = new FullName3(name);
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Address3 getAddressObj() {
        return address;
    }

    public void setAddressObj(Address3 address) {
        this.address = address;
    }

    public String getAddress() {
        return address != null ? address.toString() : "";
    }

    public void setAddress(String address) {
        this.address = new Address3(address);
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
