<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Help - Billing System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #121212;
            color: #eee;
            margin: 0;
            padding: 40px;
        }

        .help-container {
            max-width: 800px;
            margin: auto;
            background: #1e1e1e;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.7);
        }

        h2 {
            text-align: center;
            color: #64b5f6;
            margin-bottom: 20px;
        }

        section {
            margin-bottom: 25px;
        }

        h3 {
            color: #90caf9;
            margin-bottom: 10px;
        }

        p, li {
            font-size: 14px;
            color: #ddd;
            line-height: 1.6;
        }

        ul {
            list-style: none;
            padding-left: 0;
        }

        ul li::before {
            content: "✔ ";
            color: #64b5f6;
        }

        .navigation-links {
            text-align: center;
            margin-top: 20px;
        }

        .navigation-links a {
            color: #64b5f6;
            text-decoration: none;
            font-weight: bold;
        }

        .navigation-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="help-container">
    <h2>Help & User Guide</h2>

    <section>
        <h3>🔑 Login</h3>
        <p>Use your username and password to log into the system. If login fails, check your credentials or contact the administrator.</p>
    </section>

    <section>
        <h3>👥 Customers</h3>
        <ul>
            <li><b>Add Customer:</b> Enter name, email, phone, and address in the <i>Add Customer</i> page.</li>
            <li><b>View Customers:</b> See all registered customers, edit their details, or delete them.</li>
        </ul>
    </section>

    <section>
        <h3>📦 Items</h3>
        <ul>
            <li><b>Add Item:</b> Enter item name, description, and price.</li>
            <li><b>Manage Items:</b> Edit item details or remove items no longer in use.</li>
        </ul>
    </section>

    <section>
        <h3>🧾 Bills</h3>
        <ul>
            <li><b>Create Bill:</b> Select a customer, choose an item, enter quantity, and submit.</li>
            <li><b>View Bills:</b> View all bills, check totals, and delete bills if needed.</li>
        </ul>
    </section>

    <section>
        <h3>🚪 Logout</h3>
        <p>Click on <b>Logout</b> to securely exit the system. This ensures no one else can access your account.</p>
    </section>

    <div class="navigation-links">
        <a href="welcome.jsp">⬅ Back to Dashboard</a>
    </div>
</div>
</body>
</html>
