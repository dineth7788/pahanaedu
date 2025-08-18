<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    session.invalidate(); // clear session
    response.sendRedirect("login.jsp");
%>
