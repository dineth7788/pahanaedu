<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/darktheme.css">

    <title>Edit Item</title>
</head>
<body>
<h2>Edit Item</h2>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null) {
        out.println("<p style='color:red'>No item selected</p>");
        return;
    }
    int id = Integer.parseInt(idStr);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("SELECT * FROM items WHERE id=?");
        ps.setInt(1, id);
        rs = ps.executeQuery();

        if (rs.next()) {
%>

<form action="updateItem" method="post">
    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
    <label>Name:</label>
    <input type="text" name="name" value="<%= rs.getString("name") %>" required><br><br>
    <label>Price:</label>
    <input type="number" step="0.01" name="price" value="<%= rs.getDouble("price") %>" required><br><br>
    <button type="submit">Update</button>
</form>

<%
        } else {
            out.println("<p style='color:red'>Item not found</p>");
        }
    } catch (Exception e) {
        out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

<p><a href="viewItems.jsp">Back to Items</a></p>
</body>
</html>
