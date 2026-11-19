package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import model.Member3;

public class Member3DAO extends DAO {
    public Member3DAO() {
        super();
    }

    public Member3 checkLogin(Member3 member) {
        Member3 res = null;
        String sql = "{call sp_checkLogin3(?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setString(1, member.getUsername());
            cs.setString(2, member.getPassword());
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                res = new Member3();
                res.setId(rs.getInt("id"));
                res.setUsername(rs.getString("username"));
                res.setName(rs.getString("name"));
                res.setPhone(rs.getString("phone"));
                res.setEmail(rs.getString("email"));
                res.setAddress(rs.getString("address"));
                res.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }
}
