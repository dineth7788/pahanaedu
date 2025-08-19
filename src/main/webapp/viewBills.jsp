<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>View Bills</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #121212;
            color: #ffffff;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        .bills-container {
            background-color: #1e1e1e;
            padding: 30px 40px;
            border-radius: 12px;
            max-width: 900px;
            width: 100%;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 500;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        thead {
            background-color: #2a2a2a;
        }

        th, td {
            padding: 12px 10px;
            text-align: left;
            font-size: 14px;
            border-bottom: 1px solid #333;
        }

        th {
            color: #00d8ff;
            font-weight: 600;
        }

        tr:hover {
            background-color: #2c2c2c;
        }

        td {
            color: #dddddd;
        }

        .actions {
            text-align: center;
            margin-top: 10px;
        }

        .actions a {
            text-decoration: none;
            color: #00d8ff;
            font-size: 14px;
            margin: 0 8px;
            transition: color 0.3s;
        }

        .actions a:hover {
            color: #ff4c4c;
        }
    </style>
</head>
<body>
<div class="bills-container">
    <h2>All Bills</h2>

    <table>
        <thead>
        <tr>
            <th>Bill ID</th>
            <th>Customer</th>
            <th>Item</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Status</th>
            <th>Created At</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/your_database", "root", "your_password");

                String query = "SELECT b.bill_id, c.name AS customer_name, i.item_name, b.quantity, b.total, b.status, b.created_at " +
                        "FROM bills b " +
                        "JOIN customers c ON b.customer_id = c.id " +
                        "JOIN items i ON b.item_id = i.id " +
                        "ORDER BY b.created_at DESC";
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("bill_id") %></td>
            <td><%= rs.getString("customer_name") %></td>
            <td><%= rs.getString("item_name") %></td>
            <td><%= rs.getInt("quantity") %></td>
            <td>$<%= rs.getDouble("total") %></td>
            <td><%= rs.getString("status") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception ignored) {}
                try { if (ps != null) ps.close(); } catch (Exception ignored) {}
                try { if (con != null) con.close(); } catch (Exception ignored) {}
            }
        %>
        </tbody>
    </table>

    <div class="actions">
        <a href="billing.jsp">+ Create New Bill</a> |
        <a href="welcome.jsp">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
