package model;

import java.io.Serializable;

public class FullName3 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String lastName;
    private String middleName;
    private String firstName;

    public FullName3() {
    }

    public FullName3(String firstName, String middleName, String lastName) {
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
    }

    public FullName3(String fullNameStr) {
        if (fullNameStr != null && !fullNameStr.trim().isEmpty()) {
            String[] parts = fullNameStr.trim().split("\\s+");
            if (parts.length == 1) {
                this.firstName = parts[0];
            } else if (parts.length == 2) {
                this.lastName = parts[0];
                this.firstName = parts[1];
            } else {
                this.lastName = parts[0];
                this.firstName = parts[parts.length - 1];
                StringBuilder mid = new StringBuilder();
                for (int i = 1; i < parts.length - 1; i++) {
                    if (mid.length() > 0) mid.append(" ");
                    mid.append(parts[i]);
                }
                this.middleName = mid.toString();
            }
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (lastName != null && !lastName.isEmpty()) sb.append(lastName).append(" ");
        if (middleName != null && !middleName.isEmpty()) sb.append(middleName).append(" ");
        if (firstName != null && !firstName.isEmpty()) sb.append(firstName);
        return sb.toString().trim();
    }
}
