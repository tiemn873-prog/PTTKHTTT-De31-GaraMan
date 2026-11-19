package model;

public class Technician3 extends Employee3 {
    private static final long serialVersionUID = 1L;
    
    private String skillLevel;

    public Technician3() {
        super();
    }

    public String getSkillLevel() {
        return skillLevel;
    }

    public void setSkillLevel(String skillLevel) {
        this.skillLevel = skillLevel;
    }
}
