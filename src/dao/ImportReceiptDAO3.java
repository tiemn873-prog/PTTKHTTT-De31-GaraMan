package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.ImportReceipt3;
import model.ImportDetail3;
import model.SparePart3;
import model.Supplier3;

public class ImportReceiptDAO3 extends DAO3 {
    public ImportReceiptDAO3() {
        super();
    }

    public ArrayList<ImportReceipt3> getReceiptOfSupplier(Supplier3 supplier, Date fromDate, Date toDate) {
        if (supplier == null) return new ArrayList<>();
        return getReceiptOfSupplier(supplier.getId(), fromDate, toDate);
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

    public ImportReceipt3 getReceiptDetail(ImportReceipt3 receipt) {
        if (receipt == null) return null;
        return getReceiptDetail(receipt.getId());
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
                    receipt.setId(rs.getInt("receiptId"));
                    receipt.setReceiptCode(rs.getString("receiptCode"));
                    receipt.setImportDate(rs.getDate("importDate"));
                    receipt.setTotalAmount(rs.getDouble("receiptTotalAmount"));
                    receipt.setStaffName(rs.getString("staffName"));

                    Supplier3 sup = new Supplier3();
                    sup.setName(rs.getString("supplierName"));
                    sup.setAddress(rs.getString("supplierAddress"));
                    sup.setPhone(rs.getString("supplierPhone"));
                    sup.setEmail(rs.getString("supplierEmail"));
                    receipt.setSupplier(sup);
                }

                ImportDetail3 d = new ImportDetail3();
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getDouble("importPrice"));
                d.setAmount(rs.getDouble("detailAmount"));

                SparePart3 p = new SparePart3();
                p.setCode(rs.getString("partCode"));
                p.setName(rs.getString("partName"));
                p.setUnit(rs.getString("partUnit"));
                d.setSparePart(p);

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
