package dao;

import java.util.ArrayList;
import model.Car3;
import model.Customer3;

public class CarDAO3 extends Car3DAO {
    public CarDAO3() {
        super();
    }

    public ArrayList<Car3> getCarOfCustomer(Customer3 customer) {
        if (customer == null) return new ArrayList<>();
        return getCarOfCustomer(customer.getId());
    }
}
