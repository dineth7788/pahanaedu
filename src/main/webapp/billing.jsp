<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create New Bill</title>
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

        .billing-container {
            background-color: #1e1e1e;
            padding: 30px 40px;
            border-radius: 12px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 500;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 6px;
            font-size: 14px;
            color: #cccccc;
        }

        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #333;
            background-color: #2a2a2a;
            color: #ffffff;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input:focus,
        select:focus {
            outline: none;
            border-color: #00d8ff;
        }

        input[type="submit"] {
            margin-top: 20px;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background-color: #00d8ff;
            color: #000000;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #00aacc;
        }

        .actions {
            text-align: center;
            margin-top: 20px;
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
<div class="billing-container">
    <h2>Create New Bill</h2>

    <form action="BillingServlet" method="post">
        <!-- Customer dropdown -->
        <label for="customer">Select Customer:</label>
        <select name="customer_id" id="customer" required>
            <option value="">-- Select Customer --</option>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    java.sql.Connection con = java.sql.DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/your_database", "root", "your_password");

                    java.sql.Statement st = con.createStatement();
                    java.sql.ResultSet rs = st.executeQuery("SELECT id, name FROM customers");
                    while (rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
            <%
                    }
                    rs.close();
                    st.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <!-- Item dropdown -->
        <label for="item">Select Item:</label>
        <select name="item_id" id="item" required>
            <option value="">-- Select Item --</option>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    java.sql.Connection con = java.sql.DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/your_database", "root", "your_password");

                    java.sql.Statement st = con.createStatement();
                    java.sql.ResultSet rs = st.executeQuery("SELECT id, item_name, price FROM items");
                    while (rs.next()) {
            %>
            <option value="<%= rs.getInt("id") %>">
                <%= rs.getString("item_name") %> - $<%= rs.getDouble("price") %>
            </option>
            <%
                    }
                    rs.close();
                    st.close();
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <!-- Quantity input -->
        <label for="quantity">Quantity:</label>
        <input type="number" name="quantity" id="quantity" min="1" required>

        <!-- Submit button -->
        <input type="submit" value="Create Bill">
    </form>

    <div class="actions">
        <a href="viewBills.jsp">View Bills</a> |
        <a href="welcome.jsp">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
