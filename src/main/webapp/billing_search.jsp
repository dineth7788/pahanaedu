<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Items</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/billing.css">
</head>
<body>
<div class="container">
    <h2>Search Results</h2>
    <c:if test="${not empty err}"><div class="error">${err}</div></c:if>

    <table class="table">
        <thead>
        <tr><th>ID</th><th>Name</th><th>Add</th></tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty results}">
                <c:forEach var="it" items="${results}">
                    <tr>
                        <td>${it.id}</td>
                        <td>${it.name}</td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/billing" class="inline">
                                <input type="hidden" name="action" value="addItem"/>
                                <input type="hidden" name="itemId" value="${it.id}"/>
                                <input type="number" name="qty" min="1" value="1" style="width:70px"/>
                                <button type="submit">Add</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr><td colspan="3" class="muted center">No results</td></tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <p><a href="${pageContext.request.contextPath}/billing">⬅ Back to Billing</a></p>
</div>
</body>
</html>
