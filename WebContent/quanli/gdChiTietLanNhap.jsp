<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.ImportReceipt3DAO, model.ImportReceipt3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    int supplierId = Integer.parseInt(request.getParameter("supplierId"));
    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    Date fromDate = Date.valueOf(fromDateStr);
    Date toDate = Date.valueOf(toDateStr);
    
    ImportReceipt3DAO dao = new ImportReceipt3DAO();
    ArrayList<ImportReceipt3> list = dao.getReceiptOfSupplier(supplierId, fromDate, toDate);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách các lần nhập phụ tùng</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>CHI TIẾT CÁC LẦN NHẬP PHỤ TÙNG CỦA NHÀ CUNG CẤP</h2>
    <p>Thời gian: Từ <b><%= fromDateStr %></b> đến <b><%= toDateStr %></b></p>
    <hr/>
    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; width:100%;">
        <tr style="background-color:#003366; color:white;">
            <th>STT</th>
            <th>Mã phiếu nhập</th>
            <th>Ngày nhập</th>
            <th>Nhân viên kho tiếp nhận</th>
            <th>Tổng số phụ tùng</th>
            <th>Tổng giá trị (VNĐ)</th>
            <th>Ghi chú</th>
            <th>Thao tác</th>
        </tr>
        <%
            if(list != null && !list.isEmpty()) {
                int stt = 1;
                for(ImportReceipt3 r : list) {
        %>
        <tr>
            <td align="center"><%= stt++ %></td>
            <td align="center"><b><%= r.getReceiptCode() %></b></td>
            <td align="center"><%= r.getImportDate() %></td>
            <td><%= r.getStaffName() %></td>
            <td align="center"><b style="color:blue;"><%= r.getTotalPartCount() %></b></td>
            <td align="right"><b style="color:red;"><%= String.format("%,.0f", r.getTotalAmount()) %></b></td>
            <td><%= r.getNote() != null ? r.getNote() : "" %></td>
            <td align="center"><a href="gdHoaDonNhap.jsp?receiptId=<%= r.getId() %>&supplierId=<%= supplierId %>&fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>">Xem hóa đơn chi tiết</a></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="8" align="center">Không có lần nhập nào!</td></tr>
        <%
            }
        %>
    </table>
    <br/>
    <a href="gdThongKeNCC.jsp?fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>">Quay lại Thống kê nhà cung cấp</a>
</body>
</html>
