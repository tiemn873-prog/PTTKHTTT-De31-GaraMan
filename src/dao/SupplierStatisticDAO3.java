package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.SupplierStatistic3;

public class SupplierStatisticDAO3 extends DAO3 {
    public SupplierStatisticDAO3() {
        super();
    }

    public ArrayList<SupplierStatistic3> getSupplierStatistic(Date fromDate, Date toDate) {
        ArrayList<SupplierStatistic3> list = new ArrayList<>();
        String sql = "{call sp_tkNCCtheoLuongNhap3(?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setDate(1, fromDate);
            cs.setDate(2, toDate);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                SupplierStatistic3 s = new SupplierStatistic3();
                s.setId(rs.getInt("id"));
                s.setCode(rs.getString("code"));
                s.setName(rs.getString("name"));
                s.setAddress(rs.getString("address"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                s.setTaxCode(rs.getString("taxCode"));
                s.setTotalReceipts(rs.getInt("totalReceipts"));
                s.setTotalQuantity(rs.getInt("totalQuantity"));
                s.setTotalAmount(rs.getDouble("totalAmount"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
