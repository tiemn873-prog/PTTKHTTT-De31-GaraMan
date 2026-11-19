package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.ImportReceipt3;
import model.ImportDetail3;
import model.SparePart3;
import model.Supplier3;

public class ImportReceipt3DAO extends DAO {
    public ImportReceipt3DAO() {
        super();
    }

    public ArrayList<ImportReceipt3> getReceiptOfSupplier(int supplierId, Date fromDate, Date toDate) {
        ArrayList<ImportReceipt3> list = new ArrayList<>();
        String sql = "{call sp_chiTietNhapNCC3(?, ?, ?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, supplierId);
            cs.setDate(2, fromDate);
            cs.setDate(3, toDate);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                ImportReceipt3 r = new ImportReceipt3();
                r.setId(rs.getInt("id"));
                r.setReceiptCode(rs.getString("receiptCode"));
                r.setImportDate(rs.getDate("importDate"));
                r.setTotalAmount(rs.getDouble("totalAmount"));
                r.setNote(rs.getString("note"));
                r.setStaffName(rs.getString("staffName"));
                r.setTotalPartCount(rs.getInt("totalPartCount"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ImportReceipt3 getReceiptDetail(int receiptId) {
        ImportReceipt3 receipt = null;
        String sql = "{call sp_hoaDonNhapChiTiet3(?)}";
        try {
            CallableStatement cs = con.prepareCall(sql);
            cs.setInt(1, receiptId);
            ResultSet rs = cs.executeQuery();
            ArrayList<ImportDetail3> details = new ArrayList<>();
            while (rs.next()) {
                if (receipt == null) {
                    receipt = new ImportReceipt3();
                    receipt.setId(receiptId);
                    receipt.setReceiptCode(rs.getString("receiptCode"));
                    receipt.setImportDate(rs.getDate("importDate"));
                    receipt.setTotalAmount(rs.getDouble("receiptTotalAmount"));

                    Supplier3 s = new Supplier3();
                    s.setName(rs.getString("supplierName"));
                    s.setAddress(rs.getString("supplierAddress"));
                    receipt.setSupplier(s);
                }
                ImportDetail3 d = new ImportDetail3();
                d.setId(rs.getInt("detailId"));
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getDouble("unitPrice"));
                d.setAmount(rs.getDouble("amount"));

                SparePart3 part = new SparePart3();
                part.setId(rs.getInt("partId"));
                part.setCode(rs.getString("partCode"));
                part.setName(rs.getString("partName"));
                part.setUnit(rs.getString("unit"));
                d.setSparePart(part);

                details.add(d);
            }
            if (receipt != null) {
                receipt.setDetails(details);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return receipt;
    }
}
