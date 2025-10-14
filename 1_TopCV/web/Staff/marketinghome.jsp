<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Marketing Dashboard - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/dashboard.css">
        <style>
            .marketing-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .marketing-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .marketing-header h1 {
                margin: 0;
                font-size: 2.5rem;
                font-weight: 700;
            }
            
            .marketing-header p {
                margin: 10px 0 0 0;
                font-size: 1.1rem;
                opacity: 0.9;
            }
            
            .marketing-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 30px;
                margin-bottom: 30px;
            }
            
            .marketing-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border: 1px solid #e0e6ed;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            
            .marketing-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }
            
            .card-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .card-icon {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin-right: 15px;
            }
            
            .campaigns-icon {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .content-icon {
                background: linear-gradient(135deg, #f093fb, #f5576c);
                color: white;
            }
            
            .analytics-icon {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
                color: white;
            }
            
            .social-icon {
                background: linear-gradient(135deg, #43e97b, #38f9d7);
                color: white;
            }
            
            .card-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: #2d3748;
                margin: 0;
            }
            
            .card-description {
                color: #718096;
                margin: 10px 0 20px 0;
                line-height: 1.5;
            }
            
            .btn {
                display: inline-block;
                padding: 12px 24px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 14px;
            }
            
            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }
            
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }
            
            .btn-success {
                background: linear-gradient(135deg, #43e97b, #38f9d7);
                color: white;
            }
            
            .btn-success:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(67, 233, 123, 0.4);
            }
            
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: 1px solid #e0e6ed;
            }
            
            .stat-number {
                font-size: 2rem;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 5px;
            }
            
            .stat-label {
                color: #718096;
                font-size: 0.9rem;
                font-weight: 500;
            }
            
            .recent-activity {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border: 1px solid #e0e6ed;
            }
            
            .activity-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f1f5f9;
            }
            
            .activity-item:last-child {
                border-bottom: none;
            }
            
            .activity-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: #f7fafc;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                color: #667eea;
            }
            
            .activity-content {
                flex: 1;
            }
            
            .activity-title {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 5px;
            }
            
            .activity-time {
                color: #718096;
                font-size: 0.9rem;
            }
        </style>
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
                            <img src="assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
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
                <a href="#" class="nav-item active">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item">📝 Quản lý nội dung</a>
                <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="nav-item">📈 Phân tích & Báo cáo</a>
                <a href="#" class="nav-item">📱 Social Media</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <!-- Actions -->
            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="container">
            <div class="main">
                <!-- Header -->
                <div class="marketing-header">
                    <h1>📢 Marketing Dashboard</h1>
                    <p>Quản lý chiến dịch marketing và nội dung</p>
                </div>

                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">12</div>
                        <div class="stat-label">Chiến dịch đang chạy</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">2.4K</div>
                        <div class="stat-label">Lượt tương tác</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">156</div>
                        <div class="stat-label">Bài viết mới</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">89%</div>
                        <div class="stat-label">Tỷ lệ engagement</div>
                    </div>
                </div>

                <!-- Main Grid -->
                <div class="marketing-grid">
                    <!-- Campaigns Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon campaigns-icon">🎯</div>
                            <h3 class="card-title">Chiến dịch Marketing</h3>
                        </div>
                        <p class="card-description">
                            Tạo và quản lý các chiến dịch marketing. Theo dõi hiệu suất và tối ưu hóa kết quả.
                        </p>
                        <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="btn btn-primary">Tạo chiến dịch mới</a>
                    </div>

                    <!-- Content Management Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon content-icon">📝</div>
                            <h3 class="card-title">Quản lý nội dung</h3>
                        </div>
                        <p class="card-description">
                            Tạo và chỉnh sửa nội dung marketing. Quản lý lịch đăng bài và lên kế hoạch nội dung.
                        </p>
                        <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="btn btn-success">Tạo nội dung mới</a>
                    </div>

                    <!-- Social Media Card -->
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon social-icon">📱</div>
                            <h3 class="card-title">Social Media</h3>
                        </div>
                        <p class="card-description">
                            Quản lý các kênh social media, đăng bài và tương tác với cộng đồng.
                        </p>
                        <a href="#" class="btn btn-success">Quản lý Social</a>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="recent-activity">
                    <h3 style="margin-bottom: 20px; color: #2d3748;">Hoạt động gần đây</h3>
                    
                    <div class="activity-item">
                        <div class="activity-icon">🎯</div>
                        <div class="activity-content">
                            <div class="activity-title">Khởi động chiến dịch "Tuyển dụng mùa hè"</div>
                            <div class="activity-time">30 phút trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📝</div>
                        <div class="activity-content">
                            <div class="activity-title">Đăng bài viết mới về xu hướng tuyển dụng</div>
                            <div class="activity-time">1 giờ trước</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📈</div>
                        <div class="activity-content">
                            <div class="activity-title">Cập nhật báo cáo hiệu suất tháng</div>
                            <div class="activity-time">2 giờ trước</div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon">📱</div>
                        <div class="activity-content">
                            <div class="activity-title">Tương tác với 15 bình luận trên Facebook</div>
                            <div class="activity-time">3 giờ trước</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
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
        </script>
    </body>
</html>