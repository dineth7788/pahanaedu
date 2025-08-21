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
        @media print {
            .no-print { display: none; }
            body { background: #fff; }
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
