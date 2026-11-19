package model;

import java.io.Serializable;

public class Service3 implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private double price;
    private int estimatedDuration;
    private String description;
    private ServiceCategory3 category;

    public Service3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getEstimatedDuration() {
        return estimatedDuration;
    }

    public void setEstimatedDuration(int estimatedDuration) {
        this.estimatedDuration = estimatedDuration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ServiceCategory3 getCategory() {
        return category;
    }

    public void setCategory(ServiceCategory3 category) {
        this.category = category;
    }
}
