<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Billing System - Home</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        /* Reset & base styles */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        html, body { height: 100%; }
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #0b0b0c;
            color: #e8e8e8;
            display: flex;
            flex-direction: column;
            line-height: 1.6;
        }

        /* Header */
        header {
            background: #121315;
            padding: 18px 24px;
            border-bottom: 1px solid #26282b;
        }
        header h1 {
            font-size: 1.5rem; /* 24px */
            font-weight: 600;
            letter-spacing: 0.3px;
            color: #fff;
        }

        /* Main container */
        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Card */
        .card {
            background: #131416;
            border: 1px solid #26282b;
            border-radius: 12px;
            padding: 32px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.4);
            text-align: center;
        }
        .title {
            font-size: 1.4rem; /* 22px */
            margin-bottom: 8px;
            font-weight: 600;
            color: #f5f5f5;
        }
        .subtitle {
            font-size: 1rem; /* 16px */
            color: #a8acb3;
            margin-bottom: 24px;
        }
        .welcome {
            font-size: 1.05rem; /* ~17px */
            margin-bottom: 20px;
        }
        .username {
            color: #ffd966;
            font-weight: 600;
        }

        /* Buttons */
        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            justify-content: center;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 44px;
            padding: 0 20px;
            border-radius: 8px;
            border: 1px solid transparent;
            text-decoration: none;
            font-size: 0.95rem; /* 15px */
            font-weight: 600;
            letter-spacing: 0.3px;
            cursor: pointer;
            transition: background-color 0.25s, border-color 0.25s, transform 0.05s;
        }
        .btn:active { transform: translateY(1px); }
        .btn-primary {
            background: #3b82f6;
            color: #fff;
            border-color: #3b82f6;
        }
        .btn-primary:hover {
            background: #2563eb;
            border-color: #2563eb;
        }
        .btn-secondary {
            background: #1c1e22;
            color: #e8e8e8;
            border-color: #2b2f36;
        }
        .btn-secondary:hover {
            background: #23262b;
            border-color: #343a42;
        }
        .btn-block { width: 100%; }

        /* Footer */
        footer {
            padding: 14px 20px;
            border-top: 1px solid #26282b;
            font-size: 0.85rem; /* 14px */
            color: #8b8f96;
            text-align: center;
        }

        /* Mobile adjustments */
        @media (max-width: 480px) {
            .card {
                padding: 24px;
            }
            .title { font-size: 1.25rem; }
            .subtitle { font-size: 0.95rem; }
            .btn { font-size: 0.9rem; }
        }
    </style>
</head>
<body>

<header>
    <h1>Billing System</h1>
</header>

<main>
    <div class="card">
        <%
            boolean loggedIn = (session != null && session.getAttribute("username") != null);
            String username = loggedIn ? String.valueOf(session.getAttribute("username")) : null;
        %>

        <h2 class="title"><%= loggedIn ? "Home" : "Welcome" %></h2>
        <p class="subtitle">
            <%= loggedIn
                    ? "Quick access to your dashboard and account controls."
                    : "Please sign in to access your dashboard and billing tools." %>
        </p>

        <%
            if (loggedIn) {
        %>
        <p class="welcome">Welcome back, <span class="username"><%= username %></span>.</p>
        <div class="actions">
            <a href="welcome.jsp" class="btn btn-primary">Go to Dashboard</a>
            <a href="logout" class="btn btn-secondary">Logout</a>
        </div>
        <%
        } else {
        %>
        <div class="actions">
            <a href="login.jsp" class="btn btn-primary btn-block">Login</a>
        </div>
        <%
            }
        %>
    </div>
</main>

<footer>
    &copy; <%= java.time.Year.now() %> Pahana Edu Billing System
</footer>

</body>
</html>
