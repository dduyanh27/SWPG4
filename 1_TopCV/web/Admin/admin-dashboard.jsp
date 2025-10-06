<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Load admin data if not already loaded
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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/dashboard.css">
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
            <p class="brand-subtitle">Admin Dashboard</p>
        </div>

        <!-- Admin Profile Section -->
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

        <!-- Navigation Section -->
        <nav class="sidebar-nav">
            <div class="nav-title">Menu chính</div>
            <a href="admin-dashboard.jsp" class="nav-item active">📊 Bảng thống kê</a>
            <a href="admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
            <a href="admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
            <a href="admin-cv-management.jsp" class="nav-item">📄 Quản lý CV</a>
            <a href="#" class="nav-item">📝 Quản lý nhân sự</a>
            <a href="#" class="nav-item">💳 Quản lý thanh toán</a>
        </nav>

        <!-- Quick Actions -->
        <div class="sidebar-actions">
            <a href="admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
            <a href="logout" class="action-btn logout">🚪 Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <!-- Main Content -->
        <div class="main">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">Thống kê & Báo cáo</h1>
                <div class="breadcrumb">
                    <a href="admin-dashboard.jsp">Dashboard</a> / Thống kê
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats">
                <!-- Users Card -->
                <div class="stat-card users">
                    <div class="stat-icon">👥</div>
                    <div class="stat-value" id="userCount">${totalUsers}</div>
                    <div class="stat-label">Người dùng</div>
                    <c:choose>
                        <c:when test="${userTrend >= 0}">
                            <span class="stat-trend up">↑ +${userTrend}%</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-trend down">↓ ${userTrend}%</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Jobs Card -->
                <div class="stat-card jobs">
                    <div class="stat-icon">💼</div>
                    <div class="stat-value" id="jobCount">${totalJobs}</div>
                    <div class="stat-label">Tin tuyển dụng</div>
                    <c:choose>
                        <c:when test="${jobTrend >= 0}">
                            <span class="stat-trend up">↑ +${jobTrend}%</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-trend down">↓ ${jobTrend}%</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Applications Card -->
                <div class="stat-card applications">
                    <div class="stat-icon">📋</div>
                    <div class="stat-value" id="applicationCount">${totalApplications}</div>
                    <div class="stat-label">Ứng tuyển</div>
                    <c:choose>
                        <c:when test="${applicationTrend >= 0}">
                            <span class="stat-trend up">↑ +${applicationTrend}%</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-trend down">↓ ${applicationTrend}%</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Revenue Card -->
                <div class="stat-card revenue">
                    <div class="stat-icon">💰</div>
                    <div class="stat-value" id="revenueCount">$${totalRevenue}</div>
                    <div class="stat-label">Doanh thu</div>
                    <c:choose>
                        <c:when test="${revenueTrend >= 0}">
                            <span class="stat-trend up">↑ +${revenueTrend}%</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stat-trend down">↓ ${revenueTrend}%</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts">
                <!-- Users Chart -->
                <div class="chart-box">
                    <div class="chart-title">📈 Tăng trưởng người dùng</div>
                    <div class="chart-container">
                        <canvas id="usersChart"></canvas>
                    </div>
                </div>

                <!-- Jobs Chart -->
                <div class="chart-box">
                    <div class="chart-title">💼 Tin tuyển dụng theo ngành</div>
                    <div class="chart-container">
                        <canvas id="jobsChart"></canvas>
                    </div>
                </div>

                <!-- Status Chart -->
                <div class="chart-box">
                    <div class="chart-title">📊 Trạng thái ứng tuyển</div>
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                </div>

                <!-- Revenue Chart -->
                <div class="chart-box">
                    <div class="chart-title">💰 Doanh thu theo quý</div>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle sidebar for mobile
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

        // Chart configuration for modern look
        Chart.defaults.color = 'rgba(255, 255, 255, 0.8)';
        Chart.defaults.borderColor = 'rgba(255, 255, 255, 0.1)';
        Chart.defaults.plugins.legend.labels.padding = 15;
        Chart.defaults.plugins.legend.labels.font.size = 13;
        Chart.defaults.plugins.legend.labels.font.weight = '500';

        // ===== USERS CHART - Line Chart =====
        // TODO: Replace with real data from backend
        // Example: Pass data as JSON from JSP
        // var userGrowthData = ${userGrowthDataJSON};
        var usersChartData = {
            labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'],
            datasets: [{
                label: 'Người dùng',
                data: [200, 350, 600, 800, 1000, 1250],
                borderColor: '#4bc0c0',
                backgroundColor: 'rgba(75, 192, 192, 0.1)',
                fill: true,
                tension: 0.4,
                borderWidth: 3,
                pointRadius: 5,
                pointBackgroundColor: '#4bc0c0',
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2,
                pointHoverRadius: 7
            }]
        };

        new Chart(document.getElementById('usersChart'), {
            type: 'line',
            data: usersChartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    tooltip: {
                        backgroundColor: 'rgba(3, 20, 40, 0.95)',
                        padding: 12,
                        titleColor: '#00e5ff',
                        bodyColor: '#ffffff',
                        borderColor: 'rgba(0, 229, 255, 0.3)',
                        borderWidth: 1
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(255, 255, 255, 0.05)'
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)'
                        }
                    }
                }
            }
        });

        // ===== JOBS CHART - Bar Chart =====
        // TODO: Replace with real data
        // Example: var jobsByCategory = ${jobsByCategoryJSON};
        var jobsChartData = {
            labels: ['CNTT', 'Kinh tế', 'Giáo dục', 'Y tế', 'Khác'],
            datasets: [{
                label: 'Tin tuyển dụng',
                data: [1100, 900, 600, 400, 300],
                backgroundColor: [
                    'rgba(54, 162, 235, 0.8)',
                    'rgba(0, 102, 255, 0.8)',
                    'rgba(64, 196, 255, 0.8)',
                    'rgba(0, 229, 255, 0.8)',
                    'rgba(138, 198, 209, 0.8)'
                ],
                borderColor: [
                    '#36a2eb',
                    '#0066ff',
                    '#40c4ff',
                    '#00e5ff',
                    '#8ac6d1'
                ],
                borderWidth: 2,
                borderRadius: 8,
                borderSkipped: false
            }]
        };

        new Chart(document.getElementById('jobsChart'), {
            type: 'bar',
            data: jobsChartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(3, 20, 40, 0.95)',
                        padding: 12,
                        titleColor: '#00e5ff',
                        bodyColor: '#ffffff',
                        borderColor: 'rgba(0, 229, 255, 0.3)',
                        borderWidth: 1
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(255, 255, 255, 0.05)'
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)'
                        }
                    }
                }
            }
        });

        // ===== STATUS CHART - Doughnut Chart =====
        // TODO: Replace with real data
        // Example: var applicationStatus = ${applicationStatusJSON};
        var statusChartData = {
            labels: ['Chấp nhận', 'Từ chối', 'Đang xử lý'],
            datasets: [{
                data: [55, 25, 20],
                backgroundColor: [
                    'rgba(76, 175, 80, 0.8)',
                    'rgba(255, 107, 107, 0.8)',
                    'rgba(255, 152, 0, 0.8)'
                ],
                borderColor: [
                    '#4caf50',
                    '#ff6b6b',
                    '#ff9800'
                ],
                borderWidth: 3,
                hoverOffset: 10
            }]
        };

        new Chart(document.getElementById('statusChart'), {
            type: 'doughnut',
            data: statusChartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(3, 20, 40, 0.95)',
                        padding: 12,
                        titleColor: '#00e5ff',
                        bodyColor: '#ffffff',
                        borderColor: 'rgba(0, 229, 255, 0.3)',
                        borderWidth: 1,
                        callbacks: {
                            label: function(context) {
                                var label = context.label || '';
                                var value = context.parsed || 0;
                                var total = context.dataset.data.reduce((a, b) => a + b, 0);
                                var percentage = ((value / total) * 100).toFixed(1);
                                return label + ': ' + percentage + '%';
                            }
                        }
                    }
                },
                cutout: '60%'
            }
        });

        // ===== REVENUE CHART - Bar Chart =====
        // TODO: Replace with real data
        // Example: var revenueByQuarter = ${revenueByQuarterJSON};
        var revenueChartData = {
            labels: ['Q1', 'Q2', 'Q3', 'Q4'],
            datasets: [{
                label: 'Doanh thu ($)',
                data: [2500, 3000, 3300, 3200],
                backgroundColor: [
                    'rgba(186, 104, 200, 0.8)',
                    'rgba(156, 39, 176, 0.8)',
                    'rgba(171, 71, 188, 0.8)',
                    'rgba(142, 36, 170, 0.8)'
                ],
                borderColor: [
                    '#ba68c8',
                    '#9c27b0',
                    '#ab47bc',
                    '#8e24aa'
                ],
                borderWidth: 2,
                borderRadius: 8,
                borderSkipped: false
            }]
        };

        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: revenueChartData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(3, 20, 40, 0.95)',
                        padding: 12,
                        titleColor: '#00e5ff',
                        bodyColor: '#ffffff',
                        borderColor: 'rgba(0, 229, 255, 0.3)',
                        borderWidth: 1,
                        callbacks: {
                            label: function(context) {
                                return 'Doanh thu:  + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(255, 255, 255, 0.05)'
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)',
                            callback: function(value) {
                                return ' + value.toLocaleString();
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: 'rgba(255, 255, 255, 0.7)'
                        }
                    }
                }
            }
        });

        // ===== ANIMATION ON LOAD =====
        // Animate stat numbers on page load
        function animateValue(id, start, end, duration) {
            const obj = document.getElementById(id);
            if (!obj) return;
            
            const range = end - start;
            const increment = end > start ? 1 : -1;
            const stepTime = Math.abs(Math.floor(duration / range));
            let current = start;
            
            const timer = setInterval(function() {
                current += increment;
                obj.textContent = current.toLocaleString();
                if (current == end) {
                    clearInterval(timer);
                }
            }, stepTime);
        }

        // Animate on page load
        window.addEventListener('load', function() {
            animateValue('userCount', 0, ${totalUsers}, 1500);
            animateValue('jobCount', 0, ${totalJobs}, 1500);
            animateValue('applicationCount', 0, ${totalApplications}, 1500);
            // For revenue, handle the $ sign separately
            const revenueElement = document.getElementById('revenueCount');
            let currentRevenue = 0;
            const targetRevenue = ${totalRevenue};
            const duration = 1500;
            const increment = targetRevenue / (duration / 10);
            
            const revenueTimer = setInterval(function() {
                currentRevenue += increment;
                if (currentRevenue >= targetRevenue) {
                    currentRevenue = targetRevenue;
                    clearInterval(revenueTimer);
                }
                revenueElement.textContent = ' + Math.floor(currentRevenue).toLocaleString();
            }, 10);
        });
    </script>
</body>
</html>