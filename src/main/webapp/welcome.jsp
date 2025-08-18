<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <style>
        /* Body styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #121212;
            color: #ffffff;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        /* Container for content */
        h2 {
            margin-top: 60px;
            font-weight: 500;
        }

        /* Navigation links */
        p a {
            display: inline-block;
            margin: 10px 15px;
            padding: 10px 15px;
            text-decoration: none;
            color: #ffffff;
            background-color: #1f1f1f;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
            font-size: 14px;
        }

        p a:hover {
            background-color: #333;
            color: #00d8ff;
        }

        /* Logout link */
        p:last-of-type a {
            background-color: #000000;
        }

        p:last-of-type a:hover {
            background-color: #333;
            color: #ff4c4c;
        }
    </style>
</head>
<body>

<%
    // 🔒 Session check (redirect if not logged in)
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<h2>Welcome, <%= session.getAttribute("username") %>!</h2>

<p>
    <a href="addCustomer.jsp">Add Customer</a> |
    <a href="viewCustomers.jsp">View Customers</a> |
    <a href="addItem.jsp">Add Item</a> |
    <a href="viewItems.jsp">View Items</a> |
    <a href="billing.jsp">Create Bill</a> |
    <a href="viewBills.jsp">View Bills</a>
</p>

<!-- 🔑 Logout link -->
<p><a href="logout">Logout</a></p>

</body>
</html>
