package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.TimeSlot3;

public class TimeSlot3DAO extends DAO {
    public TimeSlot3DAO() {
        super();
    }

    public ArrayList<TimeSlot3> getAvailableSlot(Date appointmentDate) {
        ArrayList<TimeSlot3> list = new ArrayList<>();
        String sql = "{call sp_getAvailableSlot3(?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setDate(1, appointmentDate);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                TimeSlot3 slot = new TimeSlot3();
                slot.setId(rs.getInt("id"));
                slot.setStartTime(rs.getTime("startTime"));
                slot.setEndTime(rs.getTime("endTime"));
                slot.setMaxCapacity(rs.getInt("maxCapacity"));
                list.add(slot);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
