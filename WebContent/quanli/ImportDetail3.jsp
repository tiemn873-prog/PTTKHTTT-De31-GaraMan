<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.ImportReceiptDAO3, model.ImportReceipt3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    int supplierId = Integer.parseInt(request.getParameter("supplierId"));
    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    Date fromDate = Date.valueOf(fromDateStr);
    Date toDate = Date.valueOf(toDateStr);
    
    ImportReceiptDAO3 dao = new ImportReceiptDAO3();
    ArrayList<ImportReceipt3> listReceipt = dao.getReceiptOfSupplier(supplierId, fromDate, toDate);
    
    int sumPartCount = 0;
    double sumAmount = 0.0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ImportDetail3 - Chi tiết các lần nhập phụ tùng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .card { max-width: 1000px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; }
        th { background: #003366; color: white; text-align: left; }
        .total-row { background: #e9ecef; font-weight: bold; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h2 style="color: #003366; margin-top: 0;">DANH SÁCH CÁC LẦN NHẬP PHỤ TÙNG CỦA NHÀ CUNG CẤP</h2>
        <div style="background: #eef6ff; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #cce5ff;">
            📅 Khoảng thời gian: từ <strong><%= fromDateStr %></strong> đến <strong><%= toDateStr %></strong>
        </div>

        <table id="tblReceipt">
            <thead>
                <tr>
                    <th style="width: 50px; text-align: center;">STT</th>
                    <th>Mã phiếu nhập</th>
                    <th>Ngày nhập</th>
                    <th>Nhân viên lập phiếu</th>
                    <th style="text-align: center;">Số lượng PT</th>
                    <th style="text-align: right;">Tổng giá trị (VNĐ)</th>
                    <th>Ghi chú</th>
                    <th style="text-align: center;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (listReceipt != null && !listReceipt.isEmpty()) {
                    int stt = 1;
                    for (ImportReceipt3 r : listReceipt) {
                        sumPartCount += r.getTotalPartCount();
                        sumAmount += r.getTotalAmount();
            %>
                <tr>
                    <td align="center"><%= stt++ %></td>
                    <td align="center"><strong><%= r.getReceiptCode() %></strong></td>
                    <td align="center"><%= r.getImportDate() %></td>
                    <td><%= r.getStaffName() %></td>
                    <td align="center" style="font-weight: bold; color: #0055aa;"><%= r.getTotalPartCount() %></td>
                    <td align="right" style="font-weight: bold; color: #c00;"><%= String.format("%,.0f", r.getTotalAmount()) %></td>
                    <td><%= r.getNote() != null ? r.getNote() : "" %></td>
                    <td align="center">
                        <a id="chooseReceipt" href="ImportInvoice3.jsp?receiptId=<%= r.getId() %>&supplierId=<%= supplierId %>&fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>" style="color: #0055aa; font-weight: bold; text-decoration: none;">Xem hóa đơn ❯</a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="8" align="center" style="color: red; padding: 20px;">Không có lần nhập nào trong khoảng thời gian này!</td></tr>
            <%
                }
            %>
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td colspan="4" align="center">TỔNG CỘNG</td>
                    <td align="center" style="color: #0055aa;"><%= sumPartCount %></td>
                    <td align="right" style="color: #c00;"><%= String.format("%,.0f", sumAmount) %></td>
                    <td colspan="2"></td>
                </tr>
            </tfoot>
        </table>

        <div style="margin-top: 25px;">
            <a id="back" href="SupplierReport3.jsp?fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>" class="btn btn-secondary">Quay lại Báo cáo NCC</a>
        </div>
    </div>
</body>
</html>
