package dao;

import java.sql.Date;
import java.util.ArrayList;
import model.ImportReceipt3;
import model.Supplier3;

public class ImportReceiptDAO3 extends ImportReceipt3DAO {
    public ImportReceiptDAO3() {
        super();
    }

    public ArrayList<ImportReceipt3> getReceiptOfSupplier(Supplier3 supplier, Date fromDate, Date toDate) {
        if (supplier == null) return new ArrayList<>();
        return getReceiptOfSupplier(supplier.getId(), fromDate, toDate);
    }

    public ImportReceipt3 getReceiptDetail(ImportReceipt3 receipt) {
        if (receipt == null) return null;
        return getReceiptDetail(receipt.getId());
    }
}
