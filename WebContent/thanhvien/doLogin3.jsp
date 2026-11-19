<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.MemberDAO3, model.Member3" %>
<%
    String u = request.getParameter("username");
    String p = request.getParameter("password");
    
    Member3 m = new Member3();
    m.setUsername(u);
    m.setPassword(p);
    
    MemberDAO3 dao = new MemberDAO3();
    Member3 user = dao.checkLogin(m);
    
    if (user != null) {
        session.setAttribute("user", user);
        if ("Customer".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("../khachhang/CustomerMain3.jsp");
        } else if ("Manager".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("../quanli/ManagerMain3.jsp");
        } else {
            response.sendRedirect("../khachhang/CustomerMain3.jsp");
        }
    } else {
        response.sendRedirect("Login3.jsp?err=1");
    }
%>
