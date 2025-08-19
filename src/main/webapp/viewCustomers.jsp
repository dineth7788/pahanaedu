<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<html>
<head>
    <title>View Customers</title>
    <style>
        /* Body styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #121212;
            color: #ffffff;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h2 {
            margin-bottom: 30px;
            font-weight: 500;
        }

        /* Table styling */
        table {
            border-collapse: collapse;
            width: 90%;
            max-width: 900px;
            background-color: #1f1f1f;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            font-size: 14px;
        }

        th {
            background-color: #2a2a2a;
            color: #ffffff;
            font-weight: 500;
        }

        tr:nth-child(even) {
            background-color: #242424;
        }

        tr:hover {
            background-color: #333333;
        }

        a {
            color: #00d8ff;
            text-decoration: none;
            margin-right: 8px;
            font-size: 14px;
        }

        a:hover {
            color: #ff4c4c;
        }

        /* Navigation links */
        p a {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 12px;
            text-decoration: none;
            background-color: #1f1f1f;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
            color: #ffffff;
        }

        p a:hover {
            background-color: #333;
            color: #00d8ff;
        }

        /* Error message styling */
        .error {
            color: #ff4c4c;
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<h2>Customer List</h2>

<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        ps = conn.prepareStatement("SELECT * FROM customers ORDER BY id DESC");
        rs = ps.executeQuery();
%>

<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Actions</th>
    </tr>
    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("phone") %></td>
        <td>
            <a href="editCustomer.jsp?id=<%= rs.getInt("id") %>">Edit</a>
            <a href="deleteCustomer?id=<%= rs.getInt("id") %>" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
    <%
        }
    %>
</table>

<%
} catch (Exception e) {
%>
<p class="error">Error: <%= e.getMessage() %></p>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (ps != null) ps.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>

<p><a href="addCustomer.jsp">Add Customer</a> | <a href="welcome.jsp">Back to Dashboard</a></p>

</body>
</html>
