package dao;

import java.sql.Date;
import model.Appointment3;
import model.Customer3;
import model.TimeSlot3;

public class AppointmentDAO3 extends Appointment3DAO {
    public AppointmentDAO3() {
        super();
    }

    public boolean checkDuplicate(Customer3 customer, Date date, TimeSlot3 slot) {
        if (customer == null || slot == null) return false;
        return checkDuplicate(customer.getId(), date, slot.getId());
    }
}
