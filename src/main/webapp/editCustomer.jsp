<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/darktheme.css">

    <title>Edit Customer</title>
</head>
<body>
<h2>Edit Customer</h2>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null) {
        out.println("<p style='color:red'>No customer selected</p>");
        return;
    }
    int id = Integer.parseInt(idStr);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("SELECT * FROM customers WHERE id=?");
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
%>

<form action="updateCustomer" method="post">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    <label>Name:</label>
    <input type="text" name="name" value="<%= rs.getString("name") %>" required><br><br>
    <label>Email:</label>
    <input type="email" name="email" value="<%= rs.getString("email") %>" required><br><br>
    <label>Phone:</label>
    <input type="text" name="phone" value="<%= rs.getString("phone") %>" required><br><br>
    <button type="submit">Update</button>
</form>

<%
        } else {
            out.println("<p style='color:red'>Customer not found</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

<p><a href="viewCustomers.jsp">Back to Customers</a></p>
</body>
</html>
