package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.Types;
import model.Appointment3;
import model.AppointmentDetail3;

public class Appointment3DAO extends DAO {
    public Appointment3DAO() {
        super();
    }

    public boolean checkDuplicate(int customerId, Date date, int timeSlotId) {
        boolean isDuplicate = false;
        String sql = "{call sp_checkDuplicateSlot3(?, ?, ?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, customerId);
            cs.setDate(2, date);
            cs.setInt(3, timeSlotId);
            cs.registerOutParameter(4, Types.INTEGER);
            cs.execute();
            int count = cs.getInt(4);
            if (count > 0) {
                isDuplicate = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isDuplicate;
    }

    public boolean saveAppointment(Appointment3 app) {
        boolean result = false;
        if (app == null || app.getAppointmentDetails() == null || app.getAppointmentDetails().isEmpty()) {
            return false;
        }
        String sqlApp = "{call sp_saveAppointment3(?, ?, ?, ?, ?, ?, ?, ?)}";
        String sqlDetail = "{call sp_saveAppointmentDetail3(?, ?, ?)}";
        try {
            con.setAutoCommit(false);

            CallableStatement cs = con.prepareCall(sqlApp);
            cs.setInt(1, app.getCustomer().getId());
            cs.setInt(2, app.getCar().getId());
            cs.setInt(3, app.getTimeSlot().getId());
            cs.setDate(4, new java.sql.Date(app.getAppointmentDate().getTime()));
            cs.setDouble(5, app.getTotalAmount());
            cs.setString(6, app.getNote());
            cs.registerOutParameter(7, Types.INTEGER);
            cs.registerOutParameter(8, Types.VARCHAR);
            cs.executeUpdate();

            int appId = cs.getInt(7);
            String appCode = cs.getString(8);
            app.setId(appId);
            app.setAppointmentCode(appCode);

            for (AppointmentDetail3 detail : app.getAppointmentDetails()) {
                CallableStatement csDetail = con.prepareCall(sqlDetail);
                csDetail.setInt(1, appId);
                csDetail.setInt(2, detail.getService().getId());
                csDetail.setDouble(3, detail.getPrice());
                csDetail.executeUpdate();
            }

            con.commit();
            result = true;
        } catch (Exception e) {
            try {
                con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            result = false;
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}
