<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Payment Load</title>
</head>
<body>
    <h1>Test Payment Data Loading</h1>
    
    <p>Testing if servlet can be called...</p>
    
    <form action="${pageContext.request.contextPath}/admin-payment" method="GET">
        <button type="submit">Test Load Payment Data</button>
    </form>
    
    <p>If you see this page, the servlet mapping is working.</p>
</body>
</html>
