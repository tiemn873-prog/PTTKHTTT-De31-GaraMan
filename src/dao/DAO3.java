package dao;

import java.sql.Connection;

public class DAO3 extends DAO {
    public DAO3() {
        super();
    }

    public Connection getConnection() {
        return con;
    }
}
