<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.Date, dao.SupplierStatistic3DAO, model.SupplierStatistic3, model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
    
    String fromDateStr = request.getParameter("fromDate");
    String toDateStr = request.getParameter("toDate");
    Date fromDate = null;
    Date toDate = null;
    if(fromDateStr != null && toDateStr != null && !fromDateStr.isEmpty() && !toDateStr.isEmpty()) {
        fromDate = Date.valueOf(fromDateStr);
        toDate = Date.valueOf(toDateStr);
    } else {
        fromDate = Date.valueOf("2026-10-01");
        toDate = Date.valueOf("2026-11-30");
        fromDateStr = fromDate.toString();
        toDateStr = toDate.toString();
    }
    
    SupplierStatistic3DAO dao = new SupplierStatistic3DAO();
    ArrayList<SupplierStatistic3> list = dao.getSupplierStatistic(fromDate, toDate);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thống kê nhà cung cấp theo lượng nhập</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>BÁO CÁO THỐNG KÊ NHÀ CUNG CẤP THEO LƯỢNG HÀNG NHẬP</h2>
    <div style="background: #f0f7ff; padding: 10px 15px; border-radius: 4px; margin-bottom: 15px;">
        📅 Khoảng thời gian: từ <b><%= fromDateStr %></b> đến <b><%= toDateStr %></b>
        <a href="gdChonTK.jsp" style="margin-left: 20px; font-size: 13px;">Đổi khoảng ngày</a>
    </div>
    <hr/>
    <p><i>Kết quả sắp xếp giảm dần theo tổng lượng phụ tùng nhập:</i></p>
    <table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse; width:100%;">
        <tr style="background-color:#003366; color:white;">
            <th>STT</th>
            <th>Mã NCC</th>
            <th>Tên Nhà cung cấp</th>
            <th>Địa chỉ</th>
            <th>Số ĐT</th>
            <th>Số lần nhập</th>
            <th>Tổng lượng phụ tùng nhập</th>
            <th>Tổng tiền nhập (VNĐ)</th>
            <th>Thao tác</th>
        </tr>
        <%
            if(list != null && !list.isEmpty()) {
                int stt = 1;
                for(SupplierStatistic3 s : list) {
        %>
        <tr>
            <td align="center"><%= stt++ %></td>
            <td align="center"><b><%= s.getCode() %></b></td>
            <td><%= s.getName() %></td>
            <td><%= s.getAddress() %></td>
            <td><%= s.getPhone() %></td>
            <td align="center"><%= s.getTotalReceipts() %></td>
            <td align="center"><b style="color:blue;"><%= s.getTotalQuantity() %></b></td>
            <td align="right"><b style="color:red;"><%= String.format("%,.0f", s.getTotalAmount()) %></b></td>
            <td align="center"><a href="gdChiTietLanNhap.jsp?supplierId=<%= s.getId() %>&fromDate=<%= fromDateStr %>&toDate=<%= toDateStr %>">Xem các lần nhập</a></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="9" align="center">Không có dữ liệu nhập hàng trong khoảng thời gian này!</td></tr>
        <%
            }
        %>
    </table>
    <br/>
    <a href="gdChinhQL.jsp">Quay về Trang chủ Quản lý</a>
</body>
</html>
