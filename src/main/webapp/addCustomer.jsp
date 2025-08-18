<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add Customer</title>
    <style>
        /* Body styling */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #121212;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 40px 20px;
            margin: 0;
        }

        h2 {
            margin-bottom: 30px;
            font-weight: 500;
        }

        /* Form styling */
        form {
            background-color: #1f1f1f;
            padding: 30px 25px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
            width: 350px;
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 15px;
            margin-bottom: 5px;
            font-size: 14px;
        }

        input[type="text"],
        input[type="email"] {
            padding: 10px 12px;
            border-radius: 5px;
            border: 1px solid #444;
            background-color: #2a2a2a;
            color: #fff;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
        }

        input[type="text"]::placeholder,
        input[type="email"]::placeholder {
            color: #bbb;
        }

        button {
            margin-top: 25px;
            padding: 12px;
            background-color: #000000;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #333;
        }

        /* Messages */
        .message {
            margin-top: 15px;
            font-size: 14px;
        }

        .message.success {
            color: #4caf50;
        }

        .message.error {
            color: #ff4c4c;
        }

        /* Navigation links */
        p a {
            display: inline-block;
            margin: 15px 10px 0 0;
            padding: 8px 12px;
            text-decoration: none;
            color: #fff;
            background-color: #1f1f1f;
            border-radius: 5px;
            transition: background-color 0.3s, color 0.3s;
            font-size: 14px;
        }

        p a:hover {
            background-color: #333;
            color: #00d8ff;
        }

    </style>
</head>
<body>

<h2>Add Customer</h2>

<form action="add-customer" method="post">
    <label>Name:</label>
    <input type="text" name="name" required>

    <label>Email:</label>
    <input type="email" name="email">

    <label>Phone:</label>
    <input type="text" name="phone">

    <label>Address:</label>
    <input type="text" name="address">

    <button type="submit">Save</button>
</form>

<%-- show success / error coming from servlet --%>
<%
    String msg = (String) request.getAttribute("message");
    String err = (String) request.getAttribute("error");
    if (msg != null) {
%>
<p class="message success"><%= msg %></p>
<%
    }
    if (err != null) {
%>
<p class="message error"><%= err %></p>
<%
    }
%>

<p>
    <a href="viewCustomers.jsp">View Customers</a> |
    <a href="welcome.jsp">Back to Dashboard</a>
</p>

</body>
</html>
