<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("adminList") == null) {
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê & Báo cáo - JOBs</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                margin: 0;
                font-family: 'Segoe UI', sans-serif;
                color: #e0e0e0;
                background: linear-gradient(110deg,#031428 0%,#062446 40%,#083d9a 70%,#0a67ff 100%);
                min-height: 100vh;
            }

            .container {
                display: flex;
            }

            /* Unified left sidebar combining navigation and admin profile */
            .unified-sidebar {
                position: fixed;
                left: 0;
                top: 0;
                width: 280px;
                height: 100vh;
                background: linear-gradient(180deg, rgba(3,18,40,0.95), rgba(6,24,44,0.95));
                backdrop-filter: blur(15px);
                border-right: 1px solid rgba(255,255,255,0.1);
                box-shadow: 4px 0 20px rgba(0,0,0,0.3);
                z-index: 1000;
                overflow-y: auto;
                padding: 20px;
                box-sizing: border-box;
            }

            .sidebar-brand {
                text-align: center;
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .brand-title {
                font-size: 24px;
                font-weight: 700;
                color: #00e5ff;
                margin: 0;
            }

            .brand-subtitle {
                font-size: 12px;
                color: rgba(255,255,255,0.6);
                margin-top: 5px;
            }

            /* Admin profile section in sidebar */
            .sidebar-profile {
                background: rgba(255,255,255,0.08);
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 25px;
                text-align: center;
                border: 1px solid rgba(255,255,255,0.05);
            }

            .sidebar-avatar {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                border: 2px solid #00e5ff;
                margin: 0 auto 12px;
                overflow: hidden;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .sidebar-avatar:hover {
                transform: scale(1.05);
                border-color: #40c4ff;
            }

            .sidebar-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .sidebar-avatar-placeholder {
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #00e5ff, #0288d1);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: white;
                font-weight: bold;
            }

            .sidebar-admin-name {
                font-size: 16px;
                font-weight: 600;
                color: #ffffff;
                margin-bottom: 5px;
            }

            .sidebar-admin-role {
                font-size: 12px;
                color: #00e5ff;
                margin-bottom: 12px;
            }

            .sidebar-status {
                display: inline-block;
                padding: 3px 8px;
                border-radius: 10px;
                font-size: 10px;
                font-weight: 600;
                text-transform: uppercase;
                background: rgba(76,175,80,0.2);
                color: #4caf50;
                border: 1px solid rgba(76,175,80,0.3);
            }

            /* Navigation in sidebar */
            .sidebar-nav {
                margin-bottom: 25px;
            }

            .nav-title {
                font-size: 12px;
                font-weight: 600;
                color: rgba(255,255,255,0.6);
                text-transform: uppercase;
                margin-bottom: 15px;
                padding-left: 12px;
            }

            .nav-item {
                display: block;
                padding: 12px 16px;
                border-radius: 8px;
                color: rgba(255,255,255,0.8);
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                margin-bottom: 5px;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-item:hover,
            .nav-item.active {
                background: rgba(0,229,255,0.15);
                color: #ffffff;
                transform: translateX(5px);
            }

            .nav-item.active::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 3px;
                height: 20px;
                background: #00e5ff;
                border-radius: 0 2px 2px 0;
            }

            /* Quick actions in sidebar */
            .sidebar-actions {
                margin-top: auto;
                padding-top: 20px;
                border-top: 1px solid rgba(255,255,255,0.1);
            }

            .action-btn {
                display: block;
                width: 100%;
                padding: 10px 16px;
                background: rgba(0,229,255,0.1);
                border: 1px solid rgba(0,229,255,0.2);
                border-radius: 8px;
                color: #ffffff;
                text-decoration: none;
                font-size: 13px;
                font-weight: 500;
                text-align: center;
                margin-bottom: 8px;
                transition: all 0.3s ease;
            }

            .action-btn:hover {
                background: rgba(0,229,255,0.2);
                border-color: rgba(0,229,255,0.4);
            }

            .action-btn.logout {
                background: rgba(255,107,107,0.1);
                border-color: rgba(255,107,107,0.2);
                color: #ff6b6b;
            }

            .action-btn.logout:hover {
                background: rgba(255,107,107,0.2);
                border-color: rgba(255,107,107,0.4);
            }

            /* Main content adjusted for sidebar */
            .main {
                margin-left: 280px;
                padding: 20px;
                width: calc(100% - 280px);
                box-sizing: border-box;
            }

            /* Hide original elements */
            .sidebar {
                display: none;
            }

            .admin-profile {
                display: none;
            }

            /* Page header styling */
            .page-header {
                margin-bottom: 30px;
            }

            .page-title {
                color: #ffffff;
                font-size: 28px;
                margin: 0 0 10px 0;
            }

            .breadcrumb {
                color: rgba(255,255,255,0.7);
                font-size: 14px;
            }

            .breadcrumb a {
                color: #00e5ff;
                text-decoration: none;
            }

            .breadcrumb a:hover {
                text-decoration: underline;
            }

            /* Cards thống kê */
            .stats {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 15px;
                margin-bottom: 20px;
            }
            .card {
                background: rgba(255,255,255,0.1);
                padding: 20px;
                border-radius: 12px;
                text-align: center;
                box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            }
            .card h2 {
                margin: 0;
                font-size: 28px;
                color: #00e5ff;
            }
            .card p {
                margin: 5px 0 0;
                font-size: 15px;
                color: #f5f5f5;
            }

            /* Biểu đồ */
            .charts {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }
            .chart-box {
                background: rgba(255,255,255,0.08);
                padding: 15px;
                border-radius: 12px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.3);
            }

            /* Responsive */
            @media (max-width: 1024px) {
                .unified-sidebar {
                    transform: translateX(-100%);
                    transition: transform 0.3s ease;
                }

                .unified-sidebar.show {
                    transform: translateX(0);
                }

                .main {
                    margin-left: 0;
                    width: 100%;
                }

                /* Mobile menu toggle */
                .mobile-menu-toggle {
                    position: fixed;
                    top: 20px;
                    left: 20px;
                    z-index: 1001;
                    background: rgba(0,229,255,0.9);
                    border: none;
                    border-radius: 8px;
                    width: 45px;
                    height: 45px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 18px;
                    color: white;
                    box-shadow: 0 4px 15px rgba(0,229,255,0.3);
                }
            }

            @media (max-width: 768px) {
                .stats {
                    grid-template-columns: repeat(2, 1fr);
                }

                .charts {
                    grid-template-columns: 1fr;
                }

                .main {
                    padding: 15px;
                }

                .unified-sidebar {
                    width: 260px;
                }

                .mobile-menu-toggle {
                    display: flex;
                }
            }

            @media (min-width: 1025px) {
                .mobile-menu-toggle {
                    display: none;
                }
            }
        </style>
    </head>
    <body>
        <!-- Mobile menu toggle button for responsive design -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <!-- Unified sidebar combining navigation and admin profile -->
        <div class="unified-sidebar" id="unifiedSidebar">
            <!-- Brand section -->
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Admin Dashboard</p>
            </div>

            <!-- Admin profile section -->
            <div class="sidebar-profile">
                <div class="sidebar-avatar">
                    <c:choose>
                        <c:when test="${not empty adminProfile.avatarURL}">
                            <img src="${adminProfile.avatarURL}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="sidebar-avatar-placeholder">
                                ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-admin-name">
                    <c:choose>
                        <c:when test="${not empty sessionScope.admin}">
                            ${sessionScope.admin.fullName}
                        </c:when>
                        <c:otherwise>
                            Quản trị viên
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <!-- Navigation section -->
            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="admin-dashboard.jsp" class="nav-item active">📊 Bảng thống kê</a>
                <a href="admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                <a href="admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                <a href="#" class="nav-item">📁 Quản lý danh mục</a>
                <a href="#" class="nav-item">📝 Đơn xin việc</a>
                <a href="admin-profile.jsp" class="nav-item">👤 Hồ sơ cá nhân</a>
            </nav>

            <!-- Quick actions -->
            <div class="sidebar-actions">
                <a href="admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <!-- Main content -->
            <div class="main">
                <!-- Page header with breadcrumb -->
                <div class="page-header">
                    <h1 class="page-title">Thống kê & Báo cáo</h1>
                    <div class="breadcrumb">
                        <a href="admin-dashboard.jsp">Dashboard</a> / Thống kê
                    </div>
                </div>

                <!-- Cards thống kê -->
                <div class="stats">
                    <div class="card"><h2>1,250</h2><p>Người dùng</p></div>
                    <div class="card"><h2>3,450</h2><p>Tin tuyển dụng</p></div>
                    <div class="card"><h2>7,200</h2><p>Ứng tuyển</p></div>
                    <div class="card"><h2>$12,500</h2><p>Doanh thu</p></div>
                </div>

                <div class="charts">
                    <div class="chart-box"><canvas id="usersChart"></canvas></div>
                    <div class="chart-box"><canvas id="jobsChart"></canvas></div>
                    <div class="chart-box"><canvas id="statusChart"></canvas></div>
                    <div class="chart-box"><canvas id="revenueChart"></canvas></div>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('show');
            }

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (e) {
                const sidebar = document.getElementById('unifiedSidebar');
                const toggle = document.querySelector('.mobile-menu-toggle');

                if (window.innerWidth <= 1024 &&
                        !sidebar.contains(e.target) &&
                        !toggle.contains(e.target) &&
                        sidebar.classList.contains('show')) {
                    sidebar.classList.remove('show');
                }
            });

            // Line chart - Người dùng
            new Chart(document.getElementById('usersChart'), {
                type: 'line',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
                    datasets: [{
                            label: 'Người dùng',
                            data: [200, 350, 600, 800, 1000, 1250],
                            borderColor: '#4bc0c0',
                            fill: false,
                            tension: 0.3
                        }]
                }
            });

            // Bar chart - Tin tuyển dụng
            new Chart(document.getElementById('jobsChart'), {
                type: 'bar',
                data: {
                    labels: ['CNTT', 'Kinh tế', 'Giáo dục', 'Y tế', 'Khác'],
                    datasets: [{
                            label: 'Tin tuyển dụng',
                            data: [1100, 900, 600, 400, 300],
                            backgroundColor: '#36a2eb'
                        }]
                }
            });

            // Doughnut chart - Trạng thái
            new Chart(document.getElementById('statusChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Chấp nhận', 'Từ chối', 'Đang xử lý'],
                    datasets: [{
                            data: [55, 25, 20],
                            backgroundColor: ['#4caf50', '#f44336', '#ff9800']
                        }]
                }
            });

            // Bar chart - Doanh thu
            new Chart(document.getElementById('revenueChart'), {
                type: 'bar',
                data: {
                    labels: ['Q1', 'Q2', 'Q3', 'Q4'],
                    datasets: [{
                            label: 'Doanh thu ($)',
                            data: [2500, 3000, 3300, 3200],
                            backgroundColor: '#ba68c8'
                        }]
                }
            });
        </script>
    </body>
</html>
