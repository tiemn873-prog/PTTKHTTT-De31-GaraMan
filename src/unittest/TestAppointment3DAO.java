package unittest;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;

import dao.Appointment3DAO;
import dao.DAO;
import model.Appointment3;
import model.AppointmentDetail3;
import model.Car3;
import model.Customer3;
import model.Service3;
import model.TimeSlot3;

/**
 * Lớp kiểm thử đơn vị TestAppointment3DAO cho phương thức checkDuplicate() và saveAppointment()
 * Sinh viên: Nguyễn Dụng Tiềm - B23DCCN813 (Hậu tố 3)
 */
public class TestAppointment3DAO {
    private Appointment3DAO appDAO;

    public void setUp() throws Exception {
        appDAO = new Appointment3DAO();
    }

    public void tearDown() throws Exception {
        if (DAO.con != null && !DAO.con.getAutoCommit()) {
            DAO.con.rollback();
            DAO.con.setAutoCommit(true);
        }
    }

    public void testCheckDuplicate_Chuan1_ChuaCoLich() {
        int customerId = 1;
        Date date = Date.valueOf("2026-11-20");
        int timeSlotId = 1;

        boolean isDuplicate = appDAO.checkDuplicate(customerId, date, timeSlotId);
        assertFalse("Khách hàng chưa có lịch hẹn thì phải trả về false", isDuplicate);
    }

    public void testCheckDuplicate_Chuan2_DaCoLich() {
        int customerId = 1;
        Date date = Date.valueOf("2026-11-15");
        int timeSlotId = 2;

        boolean isDuplicate = appDAO.checkDuplicate(customerId, date, timeSlotId);
        assertTrue("Khách hàng đã có lịch hẹn thì phải trả về true", isDuplicate);
    }

    public void testCheckDuplicate_NgoaiLe1_NgayNull() {
        int customerId = 1;
        Date date = null;
        int timeSlotId = 1;

        boolean isDuplicate = appDAO.checkDuplicate(customerId, date, timeSlotId);
        assertFalse("Khi tham số ngày null, phương thức phải xử lý an toàn và trả về false", isDuplicate);
    }

    public void testCheckDuplicate_NgoaiLe2_KhachHangKhongTonTai() {
        int customerId = 99999;
        Date date = Date.valueOf("2026-11-20");
        int timeSlotId = 1;

        boolean isDuplicate = appDAO.checkDuplicate(customerId, date, timeSlotId);
        assertFalse("Mã khách hàng không tồn tại thì không thể có lịch trùng", isDuplicate);
    }

    public void testSaveAppointment_Chuan1_MotDichVu() {
        Customer3 cust = new Customer3();
        cust.setId(1);

        Car3 car = new Car3();
        car.setId(1);

        TimeSlot3 slot = new TimeSlot3();
        slot.setId(3);

        Appointment3 app = new Appointment3();
        app.setCustomer(cust);
        app.setCar(car);
        app.setTimeSlot(slot);
        app.setAppointmentDate(Date.valueOf("2026-11-25"));
        app.setTotalAmount(250000.0);
        app.setNote("Test đặt lịch hẹn 1 dịch vụ");

        ArrayList<AppointmentDetail3> details = new ArrayList<>();
        AppointmentDetail3 d1 = new AppointmentDetail3();
        Service3 s1 = new Service3();
        s1.setId(1);
        d1.setService(s1);
        d1.setPrice(250000.0);
        details.add(d1);
        app.setAppointmentDetails(details);

        try {
            DAO.con.setAutoCommit(false);

            boolean result = appDAO.saveAppointment(app);
            assertTrue("Lưu lịch hẹn hợp lệ phải trả về true", result);
            assertTrue("Lịch hẹn phải được sinh ID tự động > 0", app.getId() > 0);
            assertNotNull("Mã lịch hẹn phải được sinh tự động", app.getAppointmentCode());
            assertTrue("Mã lịch hẹn phải bắt đầu bằng AP3-", app.getAppointmentCode().startsWith("AP3-"));

            String checkSql = "SELECT COUNT(*) AS total FROM tblAppointmentDetail3 WHERE appointmentId = ?";
            CallableStatement cs = DAO.con.prepareCall(checkSql);
            cs.setInt(1, app.getId());
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                assertEquals("Bảng chi tiết phải có đúng 1 bản ghi", 1, rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            fail("Xảy ra ngoại lệ: " + e.getMessage());
        } finally {
            try {
                DAO.con.rollback();
                DAO.con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public void testSaveAppointment_Chuan2_NhieuDichVu() {
        Customer3 cust = new Customer3();
        cust.setId(1);

        Car3 car = new Car3();
        car.setId(1);

        TimeSlot3 slot = new TimeSlot3();
        slot.setId(4);

        Appointment3 app = new Appointment3();
        app.setCustomer(cust);
        app.setCar(car);
        app.setTimeSlot(slot);
        app.setAppointmentDate(Date.valueOf("2026-11-26"));
        app.setTotalAmount(850000.0);
        app.setNote("Test đặt lịch hẹn 3 dịch vụ tổng hợp");

        ArrayList<AppointmentDetail3> details = new ArrayList<>();
        int[] sids = {1, 2, 3};
        double[] prices = {250000.0, 300000.0, 300000.0};
        for (int i = 0; i < sids.length; i++) {
            AppointmentDetail3 d = new AppointmentDetail3();
            Service3 s = new Service3();
            s.setId(sids[i]);
            d.setService(s);
            d.setPrice(prices[i]);
            details.add(d);
        }
        app.setAppointmentDetails(details);

        try {
            DAO.con.setAutoCommit(false);

            boolean result = appDAO.saveAppointment(app);
            assertTrue("Lưu lịch hẹn nhiều dịch vụ phải thành công", result);
            assertTrue(app.getId() > 0);

            String checkSql = "SELECT COUNT(*) AS total FROM tblAppointmentDetail3 WHERE appointmentId = ?";
            CallableStatement cs = DAO.con.prepareCall(checkSql);
            cs.setInt(1, app.getId());
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                assertEquals("Bảng chi tiết phải có đúng 3 bản ghi", 3, rs.getInt("total"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            fail("Lỗi: " + e.getMessage());
        } finally {
            try {
                DAO.con.rollback();
                DAO.con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public void testSaveAppointment_NgoaiLe1_DanhSachDichVuRong() {
        Customer3 cust = new Customer3();
        cust.setId(1);
        Car3 car = new Car3();
        car.setId(1);
        TimeSlot3 slot = new TimeSlot3();
        slot.setId(1);

        Appointment3 app = new Appointment3();
        app.setCustomer(cust);
        app.setCar(car);
        app.setTimeSlot(slot);
        app.setAppointmentDate(Date.valueOf("2026-11-27"));
        app.setAppointmentDetails(new ArrayList<AppointmentDetail3>());

        boolean result = appDAO.saveAppointment(app);
        assertFalse("Lịch hẹn không có dịch vụ không được phép lưu vào hệ thống", result);
    }

    public void testSaveAppointment_NgoaiLe2_DoiTuongNull() {
        boolean result = appDAO.saveAppointment(null);
        assertFalse("Đối tượng null phải trả về false", result);
    }

    public void testSaveAppointment_NgoaiLe3_KhachHangKhongTonTai() {
        Customer3 cust = new Customer3();
        cust.setId(99999);

        Car3 car = new Car3();
        car.setId(1);

        TimeSlot3 slot = new TimeSlot3();
        slot.setId(1);

        Appointment3 app = new Appointment3();
        app.setCustomer(cust);
        app.setCar(car);
        app.setTimeSlot(slot);
        app.setAppointmentDate(Date.valueOf("2026-11-28"));
        app.setTotalAmount(200000.0);

        ArrayList<AppointmentDetail3> details = new ArrayList<>();
        AppointmentDetail3 d = new AppointmentDetail3();
        Service3 s = new Service3();
        s.setId(1);
        d.setService(s);
        d.setPrice(200000.0);
        details.add(d);
        app.setAppointmentDetails(details);

        try {
            DAO.con.setAutoCommit(false);
            boolean result = appDAO.saveAppointment(app);
            assertFalse("Vi phạm khóa ngoại phải trả về false", result);
        } catch (Exception e) {
        } finally {
            try {
                DAO.con.rollback();
                DAO.con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    // Helper assertions
    private void assertTrue(boolean condition) {
        if (!condition) throw new AssertionError("Assert True Failed");
    }

    private void assertTrue(String msg, boolean condition) {
        if (!condition) throw new AssertionError(msg);
    }

    private void assertFalse(boolean condition) {
        if (condition) throw new AssertionError("Assert False Failed");
    }

    private void assertFalse(String msg, boolean condition) {
        if (condition) throw new AssertionError(msg);
    }

    private void assertNotNull(String msg, Object obj) {
        if (obj == null) throw new AssertionError(msg);
    }

    private void assertEquals(String msg, int expected, int actual) {
        if (expected != actual) throw new AssertionError(msg + " [Expected: " + expected + ", Actual: " + actual + "]");
    }

    private void fail(String msg) {
        throw new AssertionError(msg);
    }

    public static void main(String[] args) {
        System.out.println("Chay kiem thu don vi TestAppointment3DAO...");
        TestAppointment3DAO tester = new TestAppointment3DAO();
        int pass = 0, total = 7;
        try {
            tester.setUp();
            tester.testCheckDuplicate_Chuan1_ChuaCoLich(); pass++;
            tester.testCheckDuplicate_Chuan2_DaCoLich(); pass++;
            tester.testCheckDuplicate_NgoaiLe1_NgayNull(); pass++;
            tester.testCheckDuplicate_NgoaiLe2_KhachHangKhongTonTai(); pass++;
            tester.testSaveAppointment_Chuan1_MotDichVu(); pass++;
            tester.testSaveAppointment_Chuan2_NhieuDichVu(); pass++;
            tester.testSaveAppointment_NgoaiLe1_DanhSachDichVuRong(); pass++;
            tester.tearDown();
            System.out.println("Ket qua: " + pass + "/" + total + " ca kiem thu DA QUA (PASS).");
        } catch (Exception e) {
            System.out.println("Ket qua: Failed voi loi - " + e.getMessage());
        }
    }
}
