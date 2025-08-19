<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create New Bill</title>
</head>
<body>
<h2>Create New Bill</h2>

<form action="createBill" method="post">
    <label for="customer">Select Customer:</label>
    <select name="customer_id" id="customer" required>
        <option value="">-- Select Customer --</option>
        <c:forEach var="c" items="${customers}">
            <option value="${c.id}">${c.name}</option>
        </c:forEach>
    </select>

    <br><br>

    <label for="item">Select Item:</label>
    <select name="item_id" id="item" required>
        <option value="">-- Select Item --</option>
        <c:forEach var="i" items="${items}">
            <option value="${i.id}">${i.name}</option>
        </c:forEach>
    </select>

    <br><br>

    <label for="quantity">Quantity:</label>
    <input type="number" name="quantity" id="quantity" min="1" required>

    <br><br>

    <button type="submit">Create Bill</button>
</form>

<p>
    <a href="viewBills">View Bills</a> |
    <a href="dashboard.jsp">Back to Dashboard</a>
</p>

</body>
</html>
