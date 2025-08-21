<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="dao.BillDAO,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Bills</title>
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
            width: 95%;
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
            background: #1e1e1e;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.6);
        }

        h1, h3 {
            color: #fff;
            text-align: center;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 20px;
        }

        table.table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background: #1a1a1a;
            border-radius: 6px;
            overflow: hidden;
        }

        table.table th, table.table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #333;
        }

        table.table th {
            background: #222;
            color: #ddd;
            font-weight: 500;
        }

        table.table tr:hover td {
            background: #2a2a2a;
            transition: background 0.3s;
        }

        a {
            color: #64b5f6;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        a:hover { color: #42a5f5; }

        .muted { color: #888; }
        .right { text-align:right; }
        .center { text-align:center; }

        p a {
            display: inline-block;
            background: #2a2a2a;
            padding: 8px 15px;
            border-radius: 6px;
            margin-top: 10px;
            font-size: 14px;
        }

        p a:hover {
            background: #333;
            color: #00d8ff;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Bills</h1>

    <%
        // Load bills + optional selected bill with items
        BillDAO dao = new BillDAO();
        List<Map<String,Object>> bills = dao.listBills();
        request.setAttribute("bills", bills);

        String sid = request.getParameter("id");
        Map<String,Object> header = null;
        List<Map<String,Object>> items = null;
        if (sid != null && sid.matches("\\d+")) {
            int billId = Integer.parseInt(sid);
            header = dao.getBillHeader(billId);
            items = dao.listBillItems(billId);
        }
        request.setAttribute("header", header);
        request.setAttribute("items", items);
    %>

    <div class="grid">
        <!-- Left: bill list -->
        <div>
            <table class="table">
                <thead>
                <tr><th>ID</th><th>Date</th><th>Customer</th><th class="right">Total</th></tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${bills}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/viewBills.jsp?id=${b.id}">${b.id}</a></td>
                        <td>${b.bill_date}</td>
                        <td>${b.customer}</td>
                        <td class="right">${b.total}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty bills}">
                    <tr><td colspan="4" class="center muted">No bills yet</td></tr>
                </c:if>
                </tbody>
            </table>
            <p><a href="${pageContext.request.contextPath}/billing">⬅ Back to Billing</a></p>
        </div>

        <!-- Right: selected bill details -->
        <div>
            <c:choose>
                <c:when test="${not empty header}">
                    <h3>${header.id}</h3>
                    <p>
                        <b>Date:</b> ${header.bill_date}<br/>
                        <b>Customer:</b> ${header.customer}<br/>
                        <b>Status:</b> ${header.status}
                    </p>
                    <table class="table">
                        <thead>
                        <tr><th>Item</th><th class="right">Price</th><th class="right">Qty</th><th class="right">Subtotal</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach var="it" items="${items}">
                            <tr>
                                <td>${it.item}</td>
                                <td class="right">${it.price}</td>
                                <td class="right">${it.quantity}</td>
                                <td class="right">${it.subtotal}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty items}">
                            <tr><td colspan="4" class="center muted">No items</td></tr>
                        </c:if>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td colspan="3" class="right"><b>Total</b></td>
                            <td class="right"><b>${header.total}</b></td>
                        </tr>
                        </tfoot>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="muted">Select a bill from the table to view details.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
