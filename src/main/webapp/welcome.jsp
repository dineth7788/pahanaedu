<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
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
        h2 {
            margin-top: 60px;
            font-weight: 500;
        }
        p a {
            display: inline-block;
            margin: 10px 15px;
            padding: 10px 15px;
            text-decoration: none;
            color: #fff;
            background: #1f1f1f;
            border-radius: 5px;
            transition: background-color .3s, color .3s;
            font-size: 14px;
        }
        p a:hover {
            background: #333;
            color: #00d8ff;
        }
        p:last-of-type a {
            background: #000;
        }
        p:last-of-type a:hover {
            background: #333;
            color: #ff4c4c;
        }
    </style>
</head>
<body>

<%-- Build URLs that respect the app's context path --%>
<c:url var="loginUrl" value="/login"/>
<c:url var="addCustomerUrl" value="/addCustomer.jsp"/>
<c:url var="viewCustomersUrl" value="/viewCustomers.jsp"/>
<c:url var="addItemUrl" value="/addItem.jsp"/>
<c:url var="viewItemsUrl" value="/viewItems.jsp"/>
<c:url var="billingUrl" value="/billing"/>          <%-- servlet --%>
<c:url var="viewBillsUrl" value="/viewBills.jsp"/>
<c:url var="helpUrl" value="/help.jsp"/>
<c:url var="logoutUrl" value="/logout"/>            <%-- servlet --%>

<%-- 🔒 Redirect to login if not authenticated --%>
<c:if test="${empty sessionScope.username}">
    <c:redirect url="${loginUrl}"/>
</c:if>

<h2>Welcome, ${sessionScope.username}!</h2>

<p>
    <a href="${addCustomerUrl}">Add Customer</a> |
    <a href="${viewCustomersUrl}">View Customers</a> |
    <a href="${addItemUrl}">Add Item</a> |
    <a href="${viewItemsUrl}">View Items</a> |
    <a href="${billingUrl}">Create Bill</a> |
    <a href="${viewBillsUrl}">View Bills</a> |
    <a href="${helpUrl}">Help</a>
</p>

<p><a href="${logoutUrl}">Logout</a></p>

</body>
</html>
