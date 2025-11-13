<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Authentication check - chỉ Sales mới được truy cập
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    String userType = (String) sessionObj.getAttribute("userType");
    Role adminRole = (Role) sessionObj.getAttribute("adminRole");
    
    if (userType == null || !"admin".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
    
    if (adminRole == null || !"Sales".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sales Dashboard - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/marketing-dashboard.css">
    </head>
    <body>
        <!-- Mobile menu toggle button -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <!-- Unified Sidebar -->
        <div class="unified-sidebar" id="unifiedSidebar">
            <!-- Brand Section -->
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Sales Dashboard</p>
            </div>

            <!-- Profile Section -->
            <div class="sidebar-profile">
                <div class="sidebar-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.admin.avatarUrl}">
                            <img src="${pageContext.request.contextPath}/assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="sidebar-avatar-placeholder">
                                ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                <div class="sidebar-admin-role">💼 Sales Staff</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <!-- Navigation -->
            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="${pageContext.request.contextPath}/Staff/salehome.jsp" class="nav-item active">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/cus-service.jsp" class="nav-item">💬 Customer Service</a>
                <a href="${pageContext.request.contextPath}/Staff/order-service.jsp" class="nav-item">🛒 Quản lý đơn hàng</a>
                <a href="${pageContext.request.contextPath}/Staff/dt.jsp" class="nav-item">👥 Quản lý doanh thu</a>
                <a href="#" class="nav-item">📈 Báo cáo doanh thu</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <!-- Actions -->
            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=sales" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="main">
                <!-- Header -->
                <div class="marketing-header fade-in">
                    <h1>💼 Sales Dashboard</h1>
                    <p>Quản lý tin nhắn khách hàng và bán khóa up job</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid fade-in">
                    <div class="stat-card">
                        <div class="stat-number" id="newMessages">24</div>
                        <div class="stat-label">Tin nhắn mới</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="todayCustomers">156</div>
                        <div class="stat-label">Khách hàng hôm nay</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="soldPackages">8</div>
                        <div class="stat-label">Khóa đã bán</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number" id="todayRevenue">₫2.4M</div>
                        <div class="stat-label">Doanh thu hôm nay</div>
                    </div>
                </div>

                <!-- Main Grid -->
                <div class="marketing-grid fade-in">
                    <!-- Customer Messages Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon campaigns-icon">💬</div>
                            <h3 class="card-title">Tin nhắn khách hàng</h3>
                        </div>
                        <p class="card-description">
                            Quản lý và trả lời tin nhắn từ khách hàng. Theo dõi các cuộc trò chuyện và đảm bảo phản hồi nhanh chóng.
                        </p>
                        <a href="#" class="btn btn-primary">Xem tin nhắn (24)</a>
                    </div>

                    <!-- Job Upgrade Sales Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon content-icon">🛒</div>
                            <h3 class="card-title">Bán khóa up job</h3>
                        </div>
                        <p class="card-description">
                            Bán các gói nâng cấp job posting cho recruiter. Quản lý gói dịch vụ và theo dõi doanh số bán hàng.
                        </p>
                        <a href="#" class="btn btn-success">Bán khóa mới</a>
                    </div>

                    <!-- Customer Management Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon analytics-icon">👥</div>
                            <h3 class="card-title">Quản lý khách hàng</h3>
                        </div>
                        <p class="card-description">
                            Theo dõi thông tin khách hàng, lịch sử mua hàng và tương tác. Xây dựng mối quan hệ khách hàng.
                        </p>
                        <a href="#" class="btn btn-info">Danh sách khách mua hàng</a>
                    </div>

                    <!-- Reports Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon social-icon">📈</div>
                            <h3 class="card-title">Báo cáo doanh thu</h3>
                        </div>
                        <p class="card-description">
                            Xem báo cáo doanh số, thống kê bán hàng và hiệu suất làm việc. Phân tích xu hướng và cơ hội.
                        </p>
                        <a href="#" class="btn btn-success">Xem báo cáo</a>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="recent-activity fade-in">
                    <h3>Hoạt động gần đây</h3>
                    
                    <div class="activity-item">
                        <div class="activity-icon">💬</div>
                        <div class="activity-content">
                            <div class="activity-title">Trả lời tin nhắn từ Công ty ABC</div>
                            <div class="activity-time">5 phút trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">🛒</div>
                        <div class="activity-content">
                            <div class="activity-title">Bán thành công gói Premium cho XYZ Corp</div>
                            <div class="activity-time">15 phút trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">👥</div>
                        <div class="activity-content">
                            <div class="activity-title">Thêm khách hàng mới: Tech Solutions Ltd</div>
                            <div class="activity-time">1 giờ trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📞</div>
                        <div class="activity-content">
                            <div class="activity-title">Cuộc gọi tư vấn với Global Corp</div>
                            <div class="activity-time">2 giờ trước</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Toggle sidebar for mobile
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('sidebar-open');
            }

            // Mobile responsive
            window.addEventListener('resize', function() {
                const sidebar = document.getElementById('unifiedSidebar');
                if (window.innerWidth > 768) {
                    sidebar.classList.remove('sidebar-open');
                }
            });

            // Animate numbers on page load
            function animateNumber(elementId, target, duration = 2000) {
                const element = document.getElementById(elementId);
                const isPercentage = target.includes('%');
                const isK = target.includes('K');
                const isM = target.includes('M');
                
                let numericTarget = parseFloat(target.replace(/[^\d.]/g, ''));
                let current = 0;
                const increment = numericTarget / (duration / 16);
                
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= numericTarget) {
                        current = numericTarget;
                        clearInterval(timer);
                    }
                    
                    let displayValue = Math.floor(current);
                    if (isK) displayValue = (current).toFixed(1) + 'K';
                    if (isM) displayValue = '₫' + (current).toFixed(1) + 'M';
                    if (isPercentage) displayValue = Math.floor(current) + '%';
                    
                    element.textContent = displayValue;
                }, 16);
            }

            // Run animations on page load
            window.addEventListener('load', function() {
                animateNumber('newMessages', '24'); 
                animateNumber('todayCustomers', '156');
                animateNumber('soldPackages', '8');
                animateNumber('todayRevenue', '2.4M');
            });

            // Add fade-in animation to elements
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });

            document.querySelectorAll('.fade-in').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
        </script>
    </body>
</html>