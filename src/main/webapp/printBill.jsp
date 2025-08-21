<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    model.Cart cart = (model.Cart) request.getAttribute("cart");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice #${orderId}</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/billing.css">
    <style>
        body {
            margin: 0;
            font-family: system-ui, Arial, sans-serif;
            background: #121212;
            color: #e0e0e0;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            background: #1e1e1e;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.7);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #ffffff;
        }
        p {
            margin: 10px 0 20px;
            font-size: 16px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .table th, .table td {
            padding: 10px;
            border: 1px solid #333;
            text-align: center;
        }
        .table th {
            background: #2a2a2a;
            color: #f0f0f0;
        }
        .table tr:nth-child(even) {
            background: #222;
        }
        .table tr:hover {
            background: #2f2f2f;
        }
        .right {
            text-align: right;
        }
        .no-print a {
            color: #4cafef;
            text-decoration: none;
            font-weight: bold;
        }
        .no-print button {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            background: #4cafef;
            color: #000;
            font-weight: bold;
            cursor: pointer;
        }
        .no-print button:hover {
            background: #2196f3;
        }
        @media print {
            .no-print { display: none; }
            body { background: #fff; color: #000; }
            .container { box-shadow: none; border: none; }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="no-print"><a href="<%=request.getContextPath()%>/billing">⬅ New Sale</a></div>
    <h2>Invoice #${orderId}</h2>
    <p>Customer: <b>${cart.customerName}</b></p>
    <table class="table">
        <thead><tr><th>ID</th><th>Product</th><th>Price</th><th>Qty</th><th>Amount</th></tr></thead>
        <tbody>
        <c:forEach var="ci" items="${cart.items.values()}">
            <tr>
                <td>${ci.itemId}</td><td>${ci.name}</td><td>${ci.price}</td>
                <td>${ci.qty}</td><td>${ci.amount}</td>
            </tr>
        </c:forEach>
        </tbody>
        <tfoot>
        <tr><td colspan="4" class="right"><b>Total</b></td><td><b>${cart.total}</b></td></tr>
        </tfoot>
    </table>
    <div class="no-print">
        <button onclick="window.print()">Print</button>
    </div>
</div>
</body>
</html>
