<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GaraMan - Chọn loại thống kê và khoảng ngày</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
    <h2>CHỌN LOẠI BÁO CÁO VÀ KHOẢNG NGÀY THỐNG KÊ</h2>
    <hr/>
    <form action="gdThongKeNCC.jsp" method="get" style="max-width: 500px;">
        <div style="margin-bottom: 15px;">
            <label><b>Loại thống kê:</b></label><br/>
            <select name="reportType" style="padding: 6px; width: 100%; margin-top: 5px;">
                <option value="supplier_qty" selected>Nhà cung cấp theo lượng hàng nhập</option>
            </select>
        </div>
        <div style="margin-bottom: 15px;">
            <label><b>Từ ngày bắt đầu:</b></label><br/>
            <input type="date" name="fromDate" value="2026-10-01" required style="padding: 6px; width: 100%; margin-top: 5px;" />
        </div>
        <div style="margin-bottom: 20px;">
            <label><b>Đến ngày kết thúc:</b></label><br/>
            <input type="date" name="toDate" value="2026-11-30" required style="padding: 6px; width: 100%; margin-top: 5px;" />
        </div>
        <input type="submit" value="Xem thống kê" style="padding: 8px 20px; background-color: #0d6efd; color: white; border: none; cursor: pointer; font-weight: bold;" />
        <a href="gdChinhQL.jsp" style="margin-left: 15px; color: #666;">Quay lại</a>
    </form>
</body>
</html>
