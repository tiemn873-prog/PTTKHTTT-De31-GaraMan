package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import model.Car3;

public class Car3DAO extends DAO {
    public Car3DAO() {
        super();
    }

    public ArrayList<Car3> getCarOfCustomer(int customerId) {
        ArrayList<Car3> list = new ArrayList<>();
        String sql = "{call sp_getCarOfCustomer3(?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, customerId);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                Car3 car = new Car3();
                car.setId(rs.getInt("id"));
                car.setCustomerId(rs.getInt("customerId"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setBrand(rs.getString("brand"));
                car.setModel(rs.getString("model"));
                car.setColor(rs.getString("color"));
                car.setYear(rs.getInt("year"));
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int saveCar(Car3 car) {
        int newCarId = 0;
        String sql = "{call sp_saveCar3(?, ?, ?, ?, ?, ?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, car.getCustomerId());
            cs.setString(2, car.getLicensePlate());
            cs.setString(3, car.getBrand());
            cs.setString(4, car.getModel());
            cs.setString(5, car.getColor());
            cs.setInt(6, car.getYear());
            cs.registerOutParameter(7, Types.INTEGER);
            cs.executeUpdate();
            newCarId = cs.getInt(7);
            car.setId(newCarId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newCarId;
    }
}
