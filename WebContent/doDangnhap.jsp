<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.Member3DAO, model.Member3" %>
<%
    request.setCharacterEncoding("UTF-8");
    String u = request.getParameter("username");
    String p = request.getParameter("password");
    
    Member3 m = new Member3();
    m.setUsername(u);
    m.setPassword(p);
    
    Member3DAO dao = new Member3DAO();
    Member3 user = dao.checkLogin(m);
    
    if(user == null) {
        response.sendRedirect("gddangnhap.jsp?err=1");
    } else {
        session.setAttribute("user", user);
        if("Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("khachhang/CustomerMain3.jsp");
        } else if("Manager".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("quanli/ManagerMain3.jsp");
        } else {
            response.sendRedirect("gddangnhap.jsp?err=unauthorized");
        }
    }
%>
