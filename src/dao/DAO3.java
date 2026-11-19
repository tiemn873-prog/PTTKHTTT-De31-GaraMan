package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO3 {
    public static Connection con;

    public DAO3() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/db_garaman3?autoReconnect=true&useSSL=false&characterEncoding=UTF-8&serverTimezone=UTC";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "Tiem08052005*");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public Connection getConnection() {
        return con;
    }
}
