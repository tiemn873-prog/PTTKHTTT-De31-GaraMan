package model;

import java.io.Serializable;

public class Address3 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String houseNumber;
    private String street;
    private String ward;
    private String district;
    private String city;

    public Address3() {
    }

    public Address3(String addressStr) {
        if (addressStr != null) {
            String[] parts = addressStr.split(",");
            if (parts.length >= 1) this.houseNumber = parts[0].trim();
            if (parts.length >= 2) this.street = parts[1].trim();
            if (parts.length >= 3) this.ward = parts[2].trim();
            if (parts.length >= 4) this.district = parts[3].trim();
            if (parts.length >= 5) this.city = parts[4].trim();
        }
    }

    public Address3(String houseNumber, String street, String ward, String district, String city) {
        this.houseNumber = houseNumber;
        this.street = street;
        this.ward = ward;
        this.district = district;
        this.city = city;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (houseNumber != null && !houseNumber.isEmpty()) sb.append(houseNumber);
        if (street != null && !street.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(street);
        }
        if (ward != null && !ward.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(ward);
        }
        if (district != null && !district.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(district);
        }
        if (city != null && !city.isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(city);
        }
        return sb.toString();
    }
}
