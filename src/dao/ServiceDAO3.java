package dao;

import java.util.ArrayList;
import model.Service3;

public class ServiceDAO3 extends Service3DAO {
    public ServiceDAO3() {
        super();
    }

    public ArrayList<Service3> getAllServices() {
        return getServiceList();
    }
}
