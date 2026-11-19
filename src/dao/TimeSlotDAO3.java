package dao;

import java.sql.Date;
import java.util.ArrayList;
import model.TimeSlot3;

public class TimeSlotDAO3 extends TimeSlot3DAO {
    public TimeSlotDAO3() {
        super();
    }

    public ArrayList<TimeSlot3> getAvailableSlots(Date appointmentDate) {
        return getAvailableSlot(appointmentDate);
    }
}
