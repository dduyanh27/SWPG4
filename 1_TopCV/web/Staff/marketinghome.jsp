<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,model.Role" %>
<%@ page import="dal.CampaignDAO, dal.ContentDAO, model.Campaign, model.MarketingContent" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Authentication check - chỉ Marketing Staff mới được truy cập
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
    
    if (adminRole == null || !"Marketing Staff".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");
    
    CampaignDAO camDAO = new CampaignDAO();
    List<Campaign> camList = camDAO.getAllActiveCampaigns();
    
    ContentDAO conDAO = new ContentDAO();
    List<MarketingContent> conList = conDAO.getAllContent();
    
    int totalCampaigns = camList.size();
    int totalContents = conList.size();
    
    request.setAttribute("totalCampaigns", totalCampaigns);
    request.setAttribute("totalContents", totalContents);
    
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Marketing Dashboard - JOBs</title>
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
                <p class="brand-subtitle">Marketing Dashboard</p>
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
                <div class="sidebar-admin-role">📢 Marketing Staff</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <!-- Navigation -->
            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="${pageContext.request.contextPath}/Staff/marketinghome.jsp" class="nav-item active">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item">📝 Quản lý nội dung</a>
                <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="nav-item">📈 Phân tích & Báo cáo</a>
                <a href="#" class="nav-item">📱 Social Media</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <!-- Actions -->
            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=marketing" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="main">
                <!-- Header -->
                <div class="marketing-header fade-in">
                    <h1>📢 Marketing Dashboard</h1>
                    <p>Quản lý chiến dịch marketing và nội dung hiệu quả</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid fade-in">
                    <div class="stat-card">
                        <div class="stat-number" id="activeCampaigns">${totalCampaigns}</div>
                        <div class="stat-label">Chiến dịch đang chạy</div>
                    </div>
<!--                    <div class="stat-card">
                        <div class="stat-number" id="totalEngagement">2.4K</div>
                        <div class="stat-label">Lượt tương tác</div>
                    </div>-->
                    <div class="stat-card">
                        <div class="stat-number" id="newPosts">${totalContents}</div>
                        <div class="stat-label">Bài viết mới</div>
                    </div>
<!--                    <div class="stat-card">
                        <div class="stat-number" id="engagementRate">89%</div>
                        <div class="stat-label">Tỷ lệ engagement</div>
                    </div>-->
                </div>

                <!-- Main Grid -->
                <div class="marketing-grid fade-in">
                    <!-- Campaigns Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon campaigns-icon">🎯</div>
                            <h3 class="card-title">Chiến dịch Marketing</h3>
                        </div>
                        <p class="card-description">
                            Tạo và quản lý các chiến dịch marketing. Theo dõi hiệu suất và tối ưu hóa kết quả theo thời gian thực.
                        </p>
                        <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="btn btn-primary">Quản lý chiến dịch</a>
                    </div>

                    <!-- Content Management Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon content-icon">📝</div>
                            <h3 class="card-title">Quản lý nội dung</h3>
                        </div>
                        <p class="card-description">
                            Tạo và chỉnh sửa nội dung marketing. Quản lý lịch đăng bài và lên kế hoạch nội dung chi tiết.
                        </p>
                        <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="btn btn-success">Tạo nội dung</a>
                    </div>

                    <!-- Analytics Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon analytics-icon">📈</div>
                            <h3 class="card-title">Phân tích & Báo cáo</h3>
                        </div>
                        <p class="card-description">
                            Xem báo cáo chi tiết về hiệu suất chiến dịch. Phân tích dữ liệu và đưa ra quyết định thông minh.
                        </p>
                        <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="btn btn-info">Xem báo cáo</a>
                    </div>

                    <!-- Social Media Card -->
<!--                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon social-icon">📱</div>
                            <h3 class="card-title">Social Media</h3>
                        </div>
                        <p class="card-description">
                            Quản lý các kênh social media, đăng bài và tương tác với cộng đồng một cách hiệu quả.
                        </p>
                        <a href="#" class="btn btn-success">Quản lý Social</a>
                    </div>-->
                </div>

                <!-- Recent Activity -->
                <div class="recent-activity fade-in">
                    <h3>Hoạt động gần đây</h3>
                    
                    <div class="activity-item">
                        <div class="activity-icon">🎯</div>
                        <div class="activity-content">
                            <div class="activity-title">Khởi động chiến dịch "Tuyển dụng mùa hè 2025"</div>
                            <div class="activity-time">30 phút trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📝</div>
                        <div class="activity-content">
                            <div class="activity-title">Đăng bài viết mới về xu hướng tuyển dụng IT</div>
                            <div class="activity-time">1 giờ trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📈</div>
                        <div class="activity-content">
                            <div class="activity-title">Cập nhật báo cáo hiệu suất tháng 10</div>
                            <div class="activity-time">2 giờ trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📱</div>
                        <div class="activity-content">
                            <div class="activity-title">Tương tác với 15 bình luận trên Facebook</div>
                            <div class="activity-time">3 giờ trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">🎨</div>
                        <div class="activity-content">
                            <div class="activity-title">Thiết kế banner cho chiến dịch LinkedIn</div>
                            <div class="activity-time">5 giờ trước</div>
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
                    if (isPercentage) displayValue = Math.floor(current) + '%';
                    
                    element.textContent = displayValue;
                }, 16);
            }

            // Run animations on page load
            window.addEventListener('load', function() {
                animateNumber('activeCampaigns', '${totalCampaigns}'); 
                animateNumber('totalEngagement', '2.4K');
                animateNumber('newPosts', '${totalContents}');
                animateNumber('engagementRate', '89%');
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
        
        <!-- Chatbot Integration -->
        <jsp:include page="../components/chatbot.jsp" />
    </body>
</html>
