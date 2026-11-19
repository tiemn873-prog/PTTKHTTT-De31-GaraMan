<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ImportReceiptDAO3, model.ImportReceipt3, model.ImportDetail3, model.Member3, model.Supplier3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    int receiptId = Integer.parseInt(request.getParameter("receiptId"));
    String supplierId = request.getParameter("supplierId");
    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    
    ImportReceiptDAO3 dao = new ImportReceiptDAO3();
    ImportReceipt3 receipt = dao.getReceiptDetail(receiptId);
    
    int totalQuantity = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ImportInvoice3 - Hóa đơn chi tiết lần nhập</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .card { max-width: 950px; margin: 0 auto; background: white; padding: 35px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 9px; }
        th { background: #003366; color: white; text-align: left; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px; background: #f9fafb; padding: 15px; border-radius: 6px; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h2 style="color: #003366; margin-top: 0;">HÓA ĐƠN CHI TIẾT LẦN NHẬP PHỤ TÙNG</h2>
        
        <% if (receipt != null) { 
            Supplier3 sup = receipt.getSupplier();
        %>
            <div class="info-grid">
                <div>
                    <p><strong>Mã hóa đơn:</strong> <span style="color: #0055aa; font-weight: bold;"><%= receipt.getReceiptCode() %></span></p>
                    <p><strong>Ngày nhập:</strong> <%= receipt.getImportDate() %></p>
                    <p><strong>Nhân viên kho tiếp nhận:</strong> <%= receipt.getStaffName() %></p>
                </div>
                <div>
                    <p><strong>Nhà cung cấp:</strong> <%= sup != null ? sup.getName() : "" %></p>
                    <p><strong>Địa chỉ:</strong> <%= sup != null ? sup.getAddress() : "" %></p>
                    <p><strong>Số điện thoại:</strong> <%= sup != null ? sup.getPhone() : "" %></p>
                    <p><strong>Email:</strong> <%= sup != null ? sup.getEmail() : "" %></p>
                </div>
            </div>

            <h3>DANH SÁCH PHỤ TÙNG NHẬP</h3>
            <table id="tblDetail">
                <thead>
                    <tr>
                        <th style="width: 50px; text-align: center;">STT</th>
                        <th>Mã phụ tùng</th>
                        <th>Tên phụ tùng</th>
                        <th style="text-align: center;">ĐVT</th>
                        <th style="text-align: center;">Số lượng</th>
                        <th style="text-align: right;">Đơn giá nhập (VNĐ)</th>
                        <th style="text-align: right;">Thành tiền (VNĐ)</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (receipt.getDetails() != null && !receipt.getDetails().isEmpty()) {
                        int stt = 1;
                        for (ImportDetail3 d : receipt.getDetails()) {
                            totalQuantity += d.getQuantity();
                %>
                    <tr>
                        <td align="center"><%= stt++ %></td>
                        <td align="center"><strong><%= d.getSparePart() != null ? d.getSparePart().getCode() : "" %></strong></td>
                        <td><%= d.getSparePart() != null ? d.getSparePart().getName() : "" %></td>
                        <td align="center"><%= d.getSparePart() != null ? d.getSparePart().getUnit() : "" %></td>
                        <td align="center" style="font-weight: bold; color: #0055aa;"><%= d.getQuantity() %></td>
                        <td align="right"><%= String.format("%,.0f", d.getUnitPrice()) %></td>
                        <td align="right" style="font-weight: bold; color: #333;"><%= String.format("%,.0f", d.getAmount()) %></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
                <tfoot>
                    <tr style="background: #eef2f7; font-weight: bold;">
                        <td colspan="4" align="center">TỔNG CỘNG</td>
                        <td align="center" style="color: #0055aa;"><%= totalQuantity %></td>
                        <td align="right">TỔNG TIỀN:</td>
                        <td align="right" style="color: #c00; font-size: 16px;"><%= String.format("%,.0f", receipt.getTotalAmount()) %> VNĐ</td>
                    </tr>
                </tfoot>
            </table>
        <% } else { %>
            <p style="color: red;">Không tìm thấy thông tin hóa đơn nhập này!</p>
        <% } %>

        <div style="margin-top: 25px;">
            <a id="back" href="ImportDetail3.jsp?supplierId=<%= supplierId %>&fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>" class="btn btn-secondary">Quay lại Danh sách lần nhập</a>
        </div>
    </div>
</body>
</html>
