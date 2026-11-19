package model;

import java.io.Serializable;

public class SparePart3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String code;
    private String name;
    private String unit;
    private double price;
    private String description;
    private PartCategory3 category;

    public SparePart3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PartCategory3 getCategory() {
        return category;
    }

    public void setCategory(PartCategory3 category) {
        this.category = category;
    }
}
