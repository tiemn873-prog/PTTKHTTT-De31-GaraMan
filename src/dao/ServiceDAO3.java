package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Service3;
import model.ServiceCategory3;

public class ServiceDAO3 extends DAO3 {
    public ServiceDAO3() {
        super();
    }

    public ArrayList<Service3> getAllServices() {
        return getServiceList();
    }

    public ArrayList<Service3> getServiceList() {
        ArrayList<Service3> list = new ArrayList<>();
        String sql = "{call sp_getServiceList3()}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                Service3 s = new Service3();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setPrice(rs.getDouble("price"));
                s.setEstimatedDuration(rs.getInt("estimatedDuration"));
                s.setDescription(rs.getString("description"));

                ServiceCategory3 cat = new ServiceCategory3();
                cat.setId(rs.getInt("categoryId"));
                cat.setName(rs.getString("categoryName"));
                s.setCategory(cat);

                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
