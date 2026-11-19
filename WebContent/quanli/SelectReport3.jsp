<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member3" %>
<%
    Member3 user = (Member3) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../gddangnhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SelectReport3 - Chọn loại báo cáo thống kê</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
        .card { max-width: 550px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 6px; color: #333; }
        .form-control { width: 100%; padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        .btn { padding: 9px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #003366; color: white; font-weight: bold; }
        .btn-secondary { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <div class="card">
        <h2 style="color: #003366; margin-top: 0;">CHỌN BÁO CÁO VÀ THỜI GIAN THỐNG KÊ</h2>
        <hr style="border: 0; border-top: 1px solid #ddd; margin: 20px 0;"/>
        
        <form action="SupplierReport3.jsp" method="get">
            <div class="form-group">
                <label>Loại thống kê:</label>
                <select id="reportType" name="reportType" class="form-control">
                    <option value="supplier_quantity" selected>Thống kê nhà cung cấp theo lượng hàng nhập</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Từ ngày:</label>
                <input type="date" id="fromDate" name="fromDate" value="2026-10-01" class="form-control" required />
            </div>
            
            <div class="form-group">
                <label>Đến ngày:</label>
                <input type="date" id="toDate" name="toDate" value="2026-11-30" class="form-control" required />
            </div>
            
            <div style="margin-top: 25px; display: flex; gap: 15px;">
                <a id="back" href="ManagerMain3.jsp" class="btn btn-secondary">Quay lại trang chủ</a>
                <input id="btnView" type="submit" value="Xem báo cáo" class="btn btn-primary" />
            </div>
        </form>
    </div>
</body>
</html>
