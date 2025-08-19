<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bill Details</title>
    <link rel="stylesheet" href="css/billing.css">
</head>
<body>
<h2>Bill Details</h2>

<%
    String billId = request.getParameter("bill_id");

    if (billId != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/your_database", "root", "your_password");

            String sql = "SELECT b.bill_id, c.name AS customer_name, i.name AS item_name, " +
                    "b.quantity, b.total, b.status, b.created_at " +
                    "FROM bills b " +
                    "JOIN customers c ON b.customer_id = c.id " +
                    "JOIN items i ON b.item_id = i.id " +
                    "WHERE b.bill_id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(billId));
            rs = ps.executeQuery();

            if (rs.next()) {
%>
<p><strong>Bill ID:</strong> <%= rs.getInt("bill_id") %></p>
<p><strong>Customer:</strong> <%= rs.getString("customer_name") %></p>
<p><strong>Item:</strong> <%= rs.getString("item_name") %></p>
<p><strong>Quantity:</strong> <%= rs.getInt("quantity") %></p>
<p><strong>Total:</strong> $<%= rs.getBigDecimal("total") %></p>
<p><strong>Status:</strong> <%= rs.getString("status") %></p>
<p><strong>Created At:</strong> <%= rs.getTimestamp("created_at") %></p>

<!-- Update Status Form -->
<h3>Update Status</h3>
<form action="UpdateBillStatusServlet" method="post">
    <input type="hidden" name="bill_id" value="<%= rs.getInt("bill_id") %>">
    <select name="status">
        <option value="PENDING"
                <%= rs.getString("status").equals("PENDING") ? "selected" : "" %>>PENDING</option>
        <option value="PAID"
                <%= rs.getString("status").equals("PAID") ? "selected" : "" %>>PAID</option>
    </select>
    <input type="submit" value="Update">
</form>

<!-- Delete Bill Form -->
<h3>Delete Bill</h3>
<form action="DeleteBillServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this bill?');">
    <input type="hidden" name="bill_id" value="<%= rs.getInt("bill_id") %>">
    <input type="submit" value="Delete Bill" style="background:red; color:white; border:none; padding:8px 12px; cursor:pointer; border-radius:4px;">
</form>
<%
            } else {
                out.println("<p>No bill found with ID " + billId + "</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    } else {
        out.println("<p>No bill ID provided</p>");
    }
%>

<br>
<a href="viewBills.jsp">⬅ Back to All Bills</a>
</body>
</html>
