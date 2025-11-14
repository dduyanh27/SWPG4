<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, dal.RecruiterDAO, dal.JobSeekerDAO, dal.AdminJobDAO, dal.ApplicationDAO, java.util.List, model.Admin, model.Recruiter, model.JobSeeker, model.Job, model.Application, model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Authentication check - chỉ Admin mới được truy cập
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
    
    if (adminRole == null || !"Admin".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    // Load admin data if not already loaded
    if (request.getAttribute("adminList") == null) {
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);
    }
    
    RecruiterDAO rcDAO = new RecruiterDAO();
    List<Recruiter> rcList = rcDAO.getAllRecruiters();
    
    JobSeekerDAO jsDAO = new JobSeekerDAO();
    List<JobSeeker> jsList = jsDAO.getAllJobSeekers();
    
    AdminJobDAO jobDAO = new AdminJobDAO();
    List<Job> jobList = jobDAO.getAllJobs();
    
    ApplicationDAO appDAO = new ApplicationDAO();
    List<Application> appList = appDAO.getAllApplications();
    
    
    int totalUsers = rcList.size() + jsList.size();
    
    int totalJobs = jobList.size();
    
    int totalApplications = appList.size();
    
    // For now, using placeholder values
    request.setAttribute("totalUsers", totalUsers);
    request.setAttribute("totalJobs", totalJobs);
    request.setAttribute("totalApplications", totalApplications);
    request.setAttribute("totalRevenue", 12500);
    
    // User growth trend (positive = up, negative = down)
    request.setAttribute("userTrend", 12.5);
    request.setAttribute("jobTrend", 8.3);
    request.setAttribute("applicationTrend", -3.2);
    request.setAttribute("revenueTrend", 15.7);
%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Bảng thống kê</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/dashboard.css">
    </head>
    <body>
        <!-- Mobile menu toggle button -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <div class="container">
            <div class="unified-sidebar" id="unifiedSidebar">
                <div class="sidebar-brand">
                    <h1 class="brand-title">JOBs</h1>
                    <p class="brand-subtitle">Admin Dashboard</p>
                </div>

                <div class="sidebar-profile">
                    <div class="sidebar-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.admin.avatarUrl}">
                                <img src="${pageContext.request.contextPath}/assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="sidebar-avatar-placeholder">${fn:substring(sessionScope.admin.fullName, 0, 1)}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item active">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢  Quản lý nhân sự</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-payment.jsp" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <div class="main">
                <header class="topbar">
                    <div class="title">Bảng thống kê</div>
                    <div class="topbar-actions">
                        <a href="#" class="btn btn-ghost btn-sm">🔄 Làm mới</a>
                        <button class="btn btn-primary btn-sm" onclick="exportReport()">📊 Xuất báo cáo</button>
                    </div>
                </header>

                <main class="content">
                    <!-- Thống kê tổng quan -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">👥</div>
                                <div class="stat-trend trend-up">↗️ +${userTrend}%</div>
                            </div>
                            <div class="stat-value">${totalUsers}</div>
                            <div class="stat-label">Tổng người dùng</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💼</div>
                                <div class="stat-trend trend-up">↗️ +${jobTrend}%</div>
                            </div>
                            <div class="stat-value">${totalJobs}</div>
                            <div class="stat-label">Tin tuyển dụng</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">📝</div>
                                <div class="stat-trend trend-down">↘️ ${applicationTrend}%</div>
                            </div>
                            <div class="stat-value">${totalApplications}</div>
                            <div class="stat-label">Đơn ứng tuyển</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💰</div>
                                <div class="stat-trend trend-up">↗️ +${revenueTrend}%</div>
                            </div>
                            <div class="stat-value">₫${totalRevenue}K</div>
                            <div class="stat-label">Doanh thu</div>
                        </div>
                    </div>

                    <!-- Biểu đồ và báo cáo -->
                    <div class="dashboard-grid">
                        <!-- Biểu đồ người dùng -->
                        <div class="chart-card">
                            <div class="chart-header">
                                <h3>📈 Tăng trưởng người dùng</h3>
                                <div class="chart-controls">
                                    <select class="chart-select">
                                        <option value="7">7 ngày qua</option>
                                        <option value="30" selected>30 ngày qua</option>
                                        <option value="90">90 ngày qua</option>
                                    </select>
                                </div>
                            </div>
                            <div class="chart-container">
                                <canvas id="userGrowthChart"></canvas>
                            </div>
                        </div>

                        <!-- Biểu đồ doanh thu -->
                        <div class="chart-card">
                            <div class="chart-header">
                                <h3>💰 Doanh thu theo tháng</h3>
                                <div class="chart-controls">
                                    <select class="chart-select">
                                        <option value="6">6 tháng qua</option>
                                        <option value="12" selected>12 tháng qua</option>
                                    </select>
                                </div>
                            </div>
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>

                        <!-- Top công việc -->
                        <div class="table-card">
                            <div class="table-header">
                                <h3>🔥 Công việc hot nhất</h3>
                                <a href="admin-jobposting-management.jsp" class="btn btn-ghost btn-sm">Xem tất cả</a>
                            </div>
                            <div class="table-container">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Công ty</th>
                                            <th>Vị trí</th>
                                            <th>Ứng viên</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <div class="company-info">
                                                    <div class="company-logo">🏢</div>
                                                    <div class="company-name">TechCorp</div>
                                                </div>
                                            </td>
                                            <td>Senior Developer</td>
                                            <td>156</td>
                                            <td><span class="status-badge status-published">Đã duyệt</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="company-info">
                                                    <div class="company-logo">🏢</div>
                                                    <div class="company-name">StartupXYZ</div>
                                                </div>
                                            </td>
                                            <td>Product Manager</td>
                                            <td>89</td>
                                            <td><span class="status-badge status-published">Đã duyệt</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="company-info">
                                                    <div class="company-logo">🏢</div>
                                                    <div class="company-name">GlobalCorp</div>
                                                </div>
                                            </td>
                                            <td>UX Designer</td>
                                            <td>67</td>
                                            <td><span class="status-badge status-pending">Chờ duyệt</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Hoạt động gần đây -->
                        <div class="activity-card">
                            <div class="activity-header">
                                <h3>⚡ Hoạt động gần đây</h3>
                                <a href="#" class="btn btn-ghost btn-sm">Xem tất cả</a>
                            </div>
                            <div class="activity-list">
                                <div class="activity-item">
                                    <div class="activity-icon">👤</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Người dùng mới đăng ký</div>
                                        <div class="activity-time">5 phút trước</div>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon">💼</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Tin tuyển dụng mới được duyệt</div>
                                        <div class="activity-time">15 phút trước</div>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon">📝</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Ứng viên nộp đơn mới</div>
                                        <div class="activity-time">30 phút trước</div>
                                    </div>
                                </div>
                                <div class="activity-item">
                                    <div class="activity-icon">💰</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Giao dịch thanh toán thành công</div>
                                        <div class="activity-time">1 giờ trước</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('sidebar-open');
            }

            function exportReport() {
                alert('Chức năng xuất báo cáo đang được phát triển...');
            }

            // User Growth Chart
            const userGrowthCtx = document.getElementById('userGrowthChart').getContext('2d');
            new Chart(userGrowthCtx, {
                type: 'line',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                    datasets: [{
                        label: 'Người dùng mới',
                        data: [120, 150, 180, 200, 250, 280, 320, 350, 380, 420, 450, 480],
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'bar',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                    datasets: [{
                        label: 'Doanh thu (₫K)',
                        data: [1200, 1500, 1800, 2000, 2500, 2800, 3200, 3500, 3800, 4200, 4500, 4800],
                        backgroundColor: 'rgba(67, 233, 123, 0.8)',
                        borderColor: '#43e97b',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

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