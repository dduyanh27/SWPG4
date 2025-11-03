<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="model.Role"%>
<%
    // Xác định dashboard URL dựa trên role
    String dashboardUrl = "";
    String roleName = "";
    
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj != null) {
        Role adminRole = (Role) sessionObj.getAttribute("adminRole");
        if (adminRole != null) {
            roleName = adminRole.getName();
            if ("Admin".equals(roleName)) {
                dashboardUrl = request.getContextPath() + "/Admin/admin-dashboard.jsp";
            } else if ("Marketing Staff".equals(roleName)) {
                dashboardUrl = request.getContextPath() + "/Staff/marketinghome.jsp";
            } else if ("Sales".equals(roleName)) {
                dashboardUrl = request.getContextPath() + "/Staff/salehome.jsp";
            }
        }
    }
    
    request.setAttribute("dashboardUrl", dashboardUrl);
    request.setAttribute("roleName", roleName);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối - JOBs</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }
        
        .access-denied-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 60px 40px;
            text-align: center;
            max-width: 500px;
            width: 90%;
            animation: slideUp 0.6s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        .error-title {
            font-size: 2.5rem;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #7f8c8d;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .role-info {
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
            font-size: 0.95rem;
            color: #2c3e50;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            display: inline-block;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #ecf0f1;
            color: #2c3e50;
            border: 2px solid #bdc3c7;
        }
        
        .btn-secondary:hover {
            background: #d5dbdb;
            transform: translateY(-2px);
        }
        
        .footer-info {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
            font-size: 0.9rem;
            color: #95a5a6;
        }
        
        @media (max-width: 600px) {
            .access-denied-container {
                padding: 40px 20px;
            }
            
            .error-title {
                font-size: 2rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</head>
<body>
    <div class="access-denied-container">
        <div class="error-icon">🚫</div>
        <h1 class="error-title">Truy cập bị từ chối</h1>
        
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty sessionScope.accessDeniedMessage}">
                    ${sessionScope.accessDeniedMessage}
                </c:when>
                <c:otherwise>
                    Bạn không có quyền truy cập vào khu vực này. Chỉ có Admin mới có thể truy cập khu vực Admin.
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${not empty sessionScope.admin}">
            <div class="role-info">
                <strong>Thông tin tài khoản:</strong><br>
                Tên: ${sessionScope.admin.fullName}<br>
                Vai trò: 
                <c:choose>
                    <c:when test="${not empty sessionScope.adminRole}">
                        ${sessionScope.adminRole.name}
                    </c:when>
                    <c:otherwise>
                        Không xác định
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <div class="action-buttons">
            <c:choose>
                <c:when test="${not empty dashboardUrl}">
                    <!-- Có role và có dashboard URL -->
                    <a href="${dashboardUrl}" class="btn btn-primary">
                        <c:choose>
                            <c:when test="${roleName == 'Admin'}">
                                🏠 Về Dashboard Admin
                            </c:when>
                            <c:when test="${roleName == 'Marketing Staff'}">
                                📊 Về Dashboard Marketing
                            </c:when>
                            <c:when test="${roleName == 'Sales'}">
                                💼 Về Dashboard Sales
                            </c:when>
                            <c:otherwise>
                                📊 Về Dashboard
                            </c:otherwise>
                        </c:choose>
                    </a>
                </c:when>
                <c:otherwise>
                    <!-- Không có role hoặc không có session -->
                    <a href="${pageContext.request.contextPath}/Admin/admin-login.jsp" class="btn btn-primary">
                        🔐 Đăng nhập
                    </a>
                </c:otherwise>
            </c:choose>
            
            <c:if test="${not empty dashboardUrl}">
                <a href="${pageContext.request.contextPath}/ClearSessionServlet" class="btn btn-secondary">
                    🔄 Đăng nhập lại
                </a>
            </c:if>
            
            <a href="${pageContext.request.contextPath}/index.html" class="btn btn-secondary">
                🏠 Về trang chủ
            </a>
        </div>
        
        <div class="footer-info">
            <p>Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ quản trị viên hệ thống.</p>
        </div>
    </div>
    
    <script>
        // Auto-clear session message after 10 seconds
        setTimeout(function() {
            <c:if test="${not empty sessionScope.accessDeniedMessage}">
                // Clear the message from session (would need server-side action)
                console.log('Access denied message displayed');
            </c:if>
        }, 10000);
        
        // Prevent back button and force session clear
        window.addEventListener('pageshow', function(event) {
            if (event.persisted) {
                // Page was loaded from cache (back button)
                console.log('Page loaded from cache - redirecting to clear session');
                window.location.href = '${pageContext.request.contextPath}/ClearSessionServlet';
            }
        });
        
        // Clear session on page refresh
        window.addEventListener('beforeunload', function() {
            // This will trigger when user refreshes or navigates away
            console.log('Page unloading - session should be cleared on next access');
        });
        
        // Disable back button
        history.pushState(null, null, location.href);
        window.onpopstate = function(event) {
            history.go(1);
        };
    </script>
</body>
</html>
