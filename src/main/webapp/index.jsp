<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Billing System - Home</title>
</head>
<body>
<h2>Billing System - Home</h2>

<%
    if (session != null && session.getAttribute("username") != null) {
%>
<p>Welcome back, <b><%= session.getAttribute("username") %></b>!</p>
<a href="welcome.jsp">Go to Dashboard</a> |
<a href="logout">Logout</a>
<%
} else {
%>
<p>You are not logged in. <a href="login.jsp">Login here</a></p>
<%
    }
%>

</body>
</html>
