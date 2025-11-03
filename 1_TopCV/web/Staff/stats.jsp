<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.Admin, model.Role" %>

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
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>📈 Phân tích & Báo cáo - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/marketing-dashboard.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">☰</button>

        <div class="unified-sidebar" id="unifiedSidebar">
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Marketing Dashboard</p>
            </div>

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

            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="${pageContext.request.contextPath}/Staff/marketinghome.jsp" class="nav-item">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item">📝 Quản lý nội dung</a>
                <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="nav-item active">📈 Phân tích & Báo cáo</a>
                <a href="#" class="nav-item">📱 Social Media</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=marketing" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <div class="main">
                <div class="marketing-header fade-in">
                    <h1>📈 Phân tích & Báo cáo Marketing</h1>
                    <p>Theo dõi hiệu suất và đưa ra quyết định dựa trên dữ liệu</p>
                </div>

                <div class="stats-grid fade-in">
                    <div class="stat-card">
                        <div class="stat-number">15.2K</div>
                        <div class="stat-label">Tổng lượt truy cập</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">3.8K</div>
                        <div class="stat-label">Chuyển đổi</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">25%</div>
                        <div class="stat-label">Tỷ lệ chuyển đổi</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">$12.5K</div>
                        <div class="stat-label">ROI</div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="chart-container fade-in">
                    <div class="chart-header">
                        <h3 class="chart-title">📊 Hiệu suất chiến dịch theo thời gian</h3>
                        <div class="chart-filters">
                            <button class="filter-btn active" onclick="updateChart('week')">Tuần</button>
                            <button class="filter-btn" onclick="updateChart('month')">Tháng</button>
                            <button class="filter-btn" onclick="updateChart('year')">Năm</button>
                        </div>
                    </div>
                    <canvas id="performanceChart" style="max-height: 400px;"></canvas>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(500px, 1fr)); gap: 25px; margin-bottom: 30px;">
                    <div class="chart-container fade-in">
                        <div class="chart-header">
                            <h3 class="chart-title">🎯 Phân bố theo nền tảng</h3>
                        </div>
                        <canvas id="platformChart" style="max-height: 300px;"></canvas>
                    </div>

                    <div class="chart-container fade-in">
                        <div class="chart-header">
                            <h3 class="chart-title">💰 Ngân sách vs Doanh thu</h3>
                        </div>
                        <canvas id="budgetChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>

                <!-- Top Campaigns -->
                <div class="table-container fade-in">
                    <div class="top-bar">
                        <h1>🏆 Top chiến dịch hiệu quả nhất</h1>
                        <button onclick="exportReport()" class="btn btn-success">📥 Xuất báo cáo</button>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Xếp hạng</th>
                                <th>Tên chiến dịch</th>
                                <th>Lượt xem</th>
                                <th>Click</th>
                                <th>Chuyển đổi</th>
                                <th>ROI</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong style="color: #f6ad55; font-size: 1.2rem;">🥇 1</strong></td>
                                <td><strong>Tuyển dụng mùa hè 2025</strong></td>
                                <td>5,234</td>
                                <td>1,456</td>
                                <td style="color: #48bb78; font-weight: 600;">892</td>
                                <td style="color: #48bb78; font-weight: 600;">+245%</td>
                            </tr>
                            <tr>
                                <td><strong style="color: #cbd5e0; font-size: 1.2rem;">🥈 2</strong></td>
                                <td><strong>LinkedIn Ads - IT Jobs</strong></td>
                                <td>4,123</td>
                                <td>1,234</td>
                                <td style="color: #48bb78; font-weight: 600;">678</td>
                                <td style="color: #48bb78; font-weight: 600;">+198%</td>
                            </tr>
                            <tr>
                                <td><strong style="color: #d69e2e; font-size: 1.2rem;">🥉 3</strong></td>
                                <td><strong>Facebook Campaign Q4</strong></td>
                                <td>3,567</td>
                                <td>987</td>
                                <td style="color: #48bb78; font-weight: 600;">456</td>
                                <td style="color: #48bb78; font-weight: 600;">+167%</td>
                            </tr>
                            <tr>
                                <td><strong>4</strong></td>
                                <td><strong>Google Ads - Remote Jobs</strong></td>
                                <td>2,890</td>
                                <td>756</td>
                                <td style="color: #48bb78; font-weight: 600;">345</td>
                                <td style="color: #48bb78; font-weight: 600;">+134%</td>
                            </tr>
                            <tr>
                                <td><strong>5</strong></td>
                                <td><strong>Email Marketing Campaign</strong></td>
                                <td>2,345</td>
                                <td>654</td>
                                <td style="color: #48bb78; font-weight: 600;">289</td>
                                <td style="color: #48bb78; font-weight: 600;">+112%</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                document.getElementById('unifiedSidebar').classList.toggle('sidebar-open');
            }

            // Performance Chart
            const performanceCtx = document.getElementById('performanceChart').getContext('2d');
            const performanceChart = new Chart(performanceCtx, {
                type: 'line',
                data: {
                    labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                    datasets: [{
                        label: 'Lượt xem',
                        data: [1200, 1900, 1500, 2100, 2400, 2200, 1800],
                        borderColor: '#667eea',
                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                        tension: 0.4,
                        fill: true
                    }, {
                        label: 'Chuyển đổi',
                        data: [300, 450, 380, 520, 600, 550, 450],
                        borderColor: '#48bb78',
                        backgroundColor: 'rgba(72, 187, 120, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Platform Chart
            const platformCtx = document.getElementById('platformChart').getContext('2d');
            new Chart(platformCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Facebook', 'LinkedIn', 'Google Ads', 'Email', 'Instagram'],
                    datasets: [{
                        data: [35, 25, 20, 12, 8],
                        backgroundColor: [
                            '#667eea',
                            '#4facfe',
                            '#f093fb',
                            '#43e97b',
                            '#fa709a'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });

            // Budget Chart
            const budgetCtx = document.getElementById('budgetChart').getContext('2d');
            new Chart(budgetCtx, {
                type: 'bar',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
                    datasets: [{
                        label: 'Ngân sách',
                        data: [5000, 6000, 5500, 7000, 6500, 8000],
                        backgroundColor: 'rgba(102, 126, 234, 0.7)'
                    }, {
                        label: 'Doanh thu',
                        data: [8000, 9500, 8800, 11000, 10500, 13000],
                        backgroundColor: 'rgba(72, 187, 120, 0.7)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'top'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            function updateChart(period) {
                document.querySelectorAll('.chart-filters .filter-btn').forEach(btn => {
                    btn.classList.remove('active');
                });
                event.target.classList.add('active');
                
                // TODO: Update chart data based on period
                console.log('Updating chart for period:', period);
            }

            function exportReport() {
                alert('Chức năng xuất báo cáo đang được phát triển!\n\nSẽ bao gồm:\n- Xuất PDF\n- Xuất Excel\n- Gửi email báo cáo');
            }

            // Fade-in animation
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
