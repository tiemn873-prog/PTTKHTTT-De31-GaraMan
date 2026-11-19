<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ImportReceipt3DAO, model.ImportReceipt3, model.ImportDetail3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    int receiptId = Integer.parseInt(request.getParameter("receiptId"));
    ImportReceipt3DAO dao = new ImportReceipt3DAO();
    ImportReceipt3 receipt = dao.getReceiptDetail(receiptId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn nhập phụ tùng chi tiết</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>HÓA ĐƠN NHẬP PHỤ TÙNG CHI TIẾT</h2>
    <% if(receipt != null) { %>
    <table border="0" cellpadding="4">
        <tr><td><b>Mã hóa đơn:</b></td><td><b style="color:blue;"><%= receipt.getReceiptCode() %></b></td></tr>
        <tr><td><b>Ngày nhập:</b></td><td><%= receipt.getImportDate() %></td></tr>
        <tr><td><b>Nhà cung cấp:</b></td><td><%= receipt.getSupplier() != null ? receipt.getSupplier().getName() : "" %></td></tr>
        <tr><td><b>Địa chỉ NCC:</b></td><td><%= receipt.getSupplier() != null ? receipt.getSupplier().getAddress() : "" %></td></tr>
    </table>
    <hr/>
    <h3>Danh sách phụ tùng nhập:</h3>
    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; width:100%;">
        <tr style="background-color:#003366; color:white;">
            <th>STT</th>
            <th>Mã phụ tùng</th>
            <th>Tên phụ tùng</th>
            <th>Đơn vị tính</th>
            <th>Số lượng</th>
            <th>Đơn giá nhập (VNĐ)</th>
            <th>Thành tiền (VNĐ)</th>
        </tr>
        <%
            if(receipt.getDetails() != null && !receipt.getDetails().isEmpty()) {
                int stt = 1;
                for(ImportDetail3 d : receipt.getDetails()) {
        %>
        <tr>
            <td align="center"><%= stt++ %></td>
            <td align="center"><b><%= d.getSparePart().getCode() %></b></td>
            <td><%= d.getSparePart().getName() %></td>
            <td align="center"><%= d.getSparePart().getUnit() %></td>
            <td align="center"><%= d.getQuantity() %></td>
            <td align="right"><%= String.format("%,.0f", d.getUnitPrice()) %></td>
            <td align="right"><b><%= String.format("%,.0f", d.getAmount()) %></b></td>
        </tr>
        <%
                }
            }
        %>
        <tr>
            <td colspan="6" align="right"><b>TỔNG TIỀN HÓA ĐƠN:</b></td>
            <td align="right"><b style="color:red; font-size:16px;"><%= String.format("%,.0f", receipt.getTotalAmount()) %> VNĐ</b></td>
        </tr>
    </table>
    <% } else { %>
        <p style="color:red;">Không tìm thấy thông tin hóa đơn!</p>
    <% } %>
    <br/>
    <a href="javascript:history.back()">Quay lại</a>
</body>
</html>
