<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Billing</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/billing.css">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: #121212;
            color: #eee;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
            background: #1e1e1e;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.6);
        }

        h1 {
            text-align: center;
            margin-bottom: 25px;
            font-weight: 500;
            color: #fff;
        }

        .row {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 15px 0;
            flex-wrap: wrap;
        }

        .inline {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .right { margin-left: auto; }

        label {
            font-size: 14px;
            margin-right: 8px;
            color: #bbb;
        }

        select, input[type="text"], input[type="number"] {
            padding: 8px 10px;
            border-radius: 6px;
            border: none;
            background: #2a2a2a;
            color: #fff;
        }
        select:focus, input:focus {
            outline: none;
            background: #333;
        }

        button {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #64b5f6;
            color: #121212;
            font-weight: bold;
            transition: 0.3s;
        }

        button:hover {
            background: #42a5f5;
        }

        button.danger {
            background: #e57373;
            color: #fff;
        }
        button.danger:hover {
            background: #ef5350;
        }

        button.primary {
            background: #81c784;
            color: #121212;
        }
        button.primary:hover {
            background: #66bb6a;
        }

        button[disabled] {
            background: #555 !important;
            color: #999 !important;
            cursor: not-allowed;
        }

        .error {
            color: #ff4c4c;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: #1a1a1a;
        }

        .table th, .table td {
            padding: 10px;
            border-bottom: 1px solid #333;
            text-align: center;
        }

        .table th {
            background: #222;
            color: #ddd;
        }

        .muted {
            color: #aaa;
            font-size: 13px;
        }

        .center { text-align: center; }
        .right { text-align: right; }

        .mt { margin-top: 20px; text-align: center; }

        a {
            color: #64b5f6;
            text-decoration: none;
            transition: color 0.3s;
        }
        a:hover { color: #42a5f5; }
    </style>
</head>
<body>
<div class="container">
    <h1>Billing</h1>

    <!-- expose session cart to EL -->
    <c:set var="cart" value="${sessionScope.CART}" />

    <c:if test="${not empty err}">
        <div class="error">${err}</div>
    </c:if>

    <!-- Customer selection -->
    <form method="post" action="${pageContext.request.contextPath}/billing" class="row">
        <input type="hidden" name="action" value="selectCustomer"/>
        <label>Select Customer</label>
        <select name="customerId" required>
            <option value="">-- choose --</option>
            <c:forEach var="e" items="${customers}">
                <option value="${e.key}"
                        <c:if test="${not empty cart and cart.customerId == e.key}">selected</c:if>>
                        ${e.value}
                </option>
            </c:forEach>
        </select>
        <button type="submit">Set</button>
        <span class="muted">
            <c:choose>
                <c:when test="${not empty cart and cart.customerName != null}">
                    Current: <b>${cart.customerName}</b>
                </c:when>
                <c:otherwise>Not set</c:otherwise>
            </c:choose>
        </span>
    </form>

    <!-- Add Item -->
    <div class="row">
        <form method="post" action="${pageContext.request.contextPath}/billing" class="inline">
            <input type="hidden" name="action" value="addItem"/>
            <input type="number" name="itemId" placeholder="Item ID" required/>
            <input type="number" name="qty" min="1" value="1" required/>
            <button type="submit">Add by ID</button>
        </form>

        <form method="get" action="${pageContext.request.contextPath}/billing/search" class="inline">
            <input type="text" name="q" placeholder="Search item by name..."/>
            <button type="submit">Search</button>
        </form>

        <form method="post" action="${pageContext.request.contextPath}/billing" class="inline right">
            <input type="hidden" name="action" value="clear"/>
            <button type="submit" class="danger">Clear Cart</button>
        </form>
    </div>

    <!-- Cart Table -->
    <table class="table">
        <thead>
        <tr><th>ID</th><th>Product</th><th>Price</th><th>Qty</th><th>Amount</th><th>Actions</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty cart and not empty cart.items}">
                <c:forEach var="entry" items="${cart.items}">
                    <c:set var="ci" value="${entry.value}" />
                    <tr>
                        <td>${ci.itemId}</td>
                        <td>${ci.name}</td>
                        <td>${ci.price}</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/billing" class="inline">
                                <input type="hidden" name="action" value="updateQty"/>
                                <input type="hidden" name="itemId" value="${ci.itemId}"/>
                                <input type="number" name="qty" min="1" value="${ci.qty}" style="width:70px"/>
                                <button type="submit">Update</button>
                            </form>
                        </td>
                        <td>${ci.amount}</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/billing" class="inline">
                                <input type="hidden" name="action" value="remove"/>
                                <input type="hidden" name="itemId" value="${ci.itemId}"/>
                                <button type="submit" class="danger">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="6" class="muted center">No items</td></tr>
            </c:otherwise>
        </c:choose>
        </tbody>
        <tfoot>
        <tr>
            <td colspan="4" class="right"><b>Total</b></td>
            <td colspan="2"><b>${not empty cart ? cart.total : 0}</b></td>
        </tr>
        </tfoot>
    </table>

    <!-- Checkout -->
    <form method="post" action="${pageContext.request.contextPath}/billing/print">
        <button type="submit" class="primary"
                <c:if test="${empty cart or empty cart.items or cart.customerId == null}">disabled</c:if>>
            Print Bill & Save
        </button>
        <span class="muted">Requires a selected customer and at least one item.</span>
    </form>

    <div class="mt">
        <a href="${pageContext.request.contextPath}/welcome.jsp">⬅ Back to Welcome</a>
    </div>
</div>
</body>
</html>
