<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.SupplierStatisticDAO3, model.SupplierStatistic3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    Date fromDate = null;
    Date toDate = null;
    if (fromDateStr != null && toDateStr != null && !fromDateStr.isEmpty() && !toDateStr.isEmpty()) {
        fromDate = Date.valueOf(fromDateStr);
        toDate = Date.valueOf(toDateStr);
    } else {
        fromDate = Date.valueOf("2026-10-01");
        toDate = Date.valueOf("2026-11-30");
        fromDateStr = fromDate.toString();
        toDateStr = toDate.toString();
    }
    
    SupplierStatisticDAO3 dao = new SupplierStatisticDAO3();
    ArrayList<SupplierStatistic3> listSupplier = dao.getSupplierStatistic(fromDate, toDate);
    
    int sumReceipts = 0;
    int sumQuantity = 0;
    double sumAmount = 0.0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SupplierReport3 - Báo cáo thống kê nhà cung cấp theo lượng hàng nhập</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background: #f8f9fa; }
        .card { max-width: 1100px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
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
        <h2 style="color: #003366; margin-top: 0;">BÁO CÁO THỐNG KÊ NHÀ CUNG CẤP THEO LƯỢNG HÀNG NHẬP</h2>
        <div style="background: #eef6ff; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; border: 1px solid #cce5ff;">
            📅 Khoảng thời gian thống kê: từ <strong><%= fromDateStr %></strong> đến <strong><%= toDateStr %></strong>
        </div>
        
        <table id="tblSupplier">
            <thead>
                <tr>
                    <th style="width: 50px; text-align: center;">STT</th>
                    <th>Mã NCC</th>
                    <th>Tên nhà cung cấp</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th style="text-align: center;">Số lần nhập</th>
                    <th style="text-align: center;">Tổng số lượng nhập</th>
                    <th style="text-align: right;">Tổng tiền (VNĐ)</th>
                    <th style="text-align: center;">Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (listSupplier != null && !listSupplier.isEmpty()) {
                    int stt = 1;
                    for (SupplierStatistic3 s : listSupplier) {
                        sumReceipts += s.getTotalReceipts();
                        sumQuantity += s.getTotalQuantity();
                        sumAmount += s.getTotalAmount();
            %>
                <tr>
                    <td align="center"><%= stt++ %></td>
                    <td align="center"><strong><%= s.getCode() %></strong></td>
                    <td><%= s.getName() %></td>
                    <td><%= s.getAddress() %></td>
                    <td><%= s.getPhone() %></td>
                    <td align="center"><%= s.getTotalReceipts() %></td>
                    <td align="center" style="font-weight: bold; color: #0055aa;"><%= s.getTotalQuantity() %></td>
                    <td align="right" style="font-weight: bold; color: #c00;"><%= String.format("%,.0f", s.getTotalAmount()) %></td>
                    <td align="center">
                        <a id="chooseSupplier" href="ImportDetail3.jsp?supplierId=<%= s.getId() %>&fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>" style="color: #0055aa; font-weight: bold; text-decoration: none;">Xem chi tiết ❯</a>
                    </td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr><td colspan="9" align="center" style="color: red; padding: 20px;">Không có dữ liệu nhập hàng trong khoảng thời gian này!</td></tr>
            <%
                }
            %>
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td colspan="5" align="center">TỔNG CỘNG</td>
                    <td align="center"><%= sumReceipts %></td>
                    <td align="center" style="color: #0055aa;"><%= sumQuantity %></td>
                    <td align="right" style="color: #c00;"><%= String.format("%,.0f", sumAmount) %></td>
                    <td></td>
                </tr>
            </tfoot>
        </table>

        <div style="margin-top: 25px;">
            <a id="back" href="SelectReport3.jsp" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>
</body>
</html>
