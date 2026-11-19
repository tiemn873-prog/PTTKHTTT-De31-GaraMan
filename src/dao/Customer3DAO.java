package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import model.Customer3;

public class Customer3DAO extends DAO {
    public Customer3DAO() {
        super();
    }

    public Customer3 getCustomerInfo(int memberId) {
        Customer3 c = null;
        String sql = "{call sp_getCustomerInfo3(?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, memberId);
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                c = new Customer3();
                c.setId(rs.getInt("customerId"));
                c.setMemberId(rs.getInt("memberId"));
                c.setName(rs.getString("name"));
                c.setPhone(rs.getString("phone"));
                c.setEmail(rs.getString("email"));
                c.setAddress(rs.getString("address"));
                c.setLicenseNo(rs.getString("licenseNo"));
                c.setCustomerType(rs.getString("customerType"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }
}
