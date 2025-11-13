<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.Recruiter" %>
<%
    String success = request.getParameter("success");
    Recruiter recruiter = (Recruiter) session.getAttribute("recruiter");
    String userName = (recruiter != null) ? recruiter.getContactPerson() : "User";
    
    // Lấy success message từ session
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage"); // Xóa sau khi lấy
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recruiter Dashboard - <%= userName %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="index-page">
    <% if (successMessage != null && !successMessage.isEmpty()) { %>
    <div class="success-alert" style="position: fixed; top: 80px; left: 50%; transform: translateX(-50%); background: #4caf50; color: white; padding: 15px 25px; border-radius: 5px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); z-index: 10000; display: flex; align-items: center; gap: 10px;">
        <i class="fas fa-check-circle"></i>
        <span><%= successMessage %></span>
        <button onclick="this.parentElement.remove()" style="background: none; border: none; color: white; font-size: 18px; cursor: pointer; margin-left: 10px;">&times;</button>
    </div>
    <script>
        setTimeout(function() {
            var alert = document.querySelector('.success-alert');
            if (alert) alert.remove();
        }, 5000); // Tự động ẩn sau 5 giây
    </script>
    <% } %>
    
    <!-- Top Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-left">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <span>RecruitPro</span>
                </div>
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp" class="active">Dashboard</a></li>
                    <li><a href="#">Việc Làm</a></li>
                    <li class="dropdown">
                        <a href="#" class="active">Ứng viên <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html" class="highlighted">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quy trình onboarding</a>
                            <a href="#">Tài liệu hướng dẫn</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
                        </div>
                    </li>
                    <li><a href="#">Báo cáo</a></li>
                    <li><a href="#">Công ty</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <div class="nav-buttons">
                    <div class="dropdown">
                        <button class="btn btn-orange">
                            Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/Recruiter/job-posting.jsp">Tạo tin tuyển dụng mới</a> 
                            <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                             
                        </div>
                    </div>
                    <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">Tìm Ứng Viên</button>
                    <button class="btn btn-white" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/job-package.jsp'">Mua</button>
                </div>
                <div class="nav-icons">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-bell"></i>
                    <div class="dropdown user-dropdown">
                        <div class="user-avatar">
                            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                        </div>
                        <div class="dropdown-content user-menu">
                            <div class="user-header">
                                <i class="fas fa-user-circle"></i>
                                <div class="user-info">
                                    <div class="user-name"><%= userName %></div>
                                    <div class="user-role">Recruiter</div>
                                    <div class="user-id">ID: <%= recruiter != null ? recruiter.getRecruiterID() : "N/A" %></div>
                                </div>
                                <i class="fas fa-times close-menu"></i>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Thành viên</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-users"></i>
                                    <span>Thành viên</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Thiết lập tài khoản</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-cog"></i>
                                    <span>Quản lý tài khoản</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item highlighted">
                                    <i class="fas fa-building"></i>
                                    <span>Thông tin công ty</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-shield-alt"></i>
                                    <span>Quản lý quyền truy cập</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-tasks"></i>
                                    <span>Quản lý yêu cầu</span>
                                </a>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-history"></i>
                                    <span>Lịch sử hoạt động</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Liên hệ mua</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-phone"></i>
                                    <span>Liên hệ mua</span>
                                </a>
                            </div>
                            
                            <div class="menu-section">
                                <div class="section-title">Hỏi đáp</div>
                                <a href="#" class="menu-item">
                                    <i class="fas fa-question-circle"></i>
                                    <span>Hỏi đáp</span>
                                </a>
                            </div>
                            
                            <div class="menu-footer">
                                <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-item">
                                    <i class="fas fa-sign-out-alt"></i>
                                    <span>Thoát</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="content-container">
            <!-- Left Panel -->
            <div class="left-panel">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <div class="welcome-content">
                        <h1>Xin chào, <%= userName %>!</h1>
                        <p>Chào mừng bạn đến với Recruiter Dashboard! Đây là một số thông tin để bạn có thể bắt đầu sử dụng:</p>
                        <div class="welcome-links">
                            <a href="#" class="link">FAQ/Hướng dẫn sử dụng</a>
                            <a href="#" class="link">Khám phá sản phẩm</a>
                        </div>
                    </div>
                    <div class="welcome-illustration">
                        <div class="illustration-person">
                            <div class="person-figure">
                                <div class="head"></div>
                                <div class="body"></div>
                                <div class="laptop"></div>
                                <div class="coffee"></div>
                                <div class="plant"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Points Section -->
                <div class="points-section">
                    <h2>Điểm khả dụng</h2>
                    <div class="points-grid">
                        <div class="point-item">
                            <div class="point-value">125</div>
                            <div class="point-text">Điểm đăng tuyển</div>
                        </div>
                        <div class="point-item">
                            <div class="point-value">588</div>
                            <div class="point-text">Điểm xem hồ sơ</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Panel -->
            <div class="right-panel">
                <!-- Current Status Section -->
                <div class="status-section">
                    <div class="status-header">
                        <h2>Tình trạng hiện tại</h2>
                        <div class="status-controls">
                            <select class="status-dropdown">
                                <option>Tất cả việc làm</option>
                                <option>Việc làm đang mở</option>
                                <option>Việc làm đã đóng</option>
                            </select>
                            <button class="export-btn">
                                <i class="fas fa-download"></i>
                            </button>
                        </div>
                    </div>
                    <div class="chart-container">
                        <canvas id="statusChart"></canvas>
                    </div>
                    <div class="chart-footer">
                        <a href="#" class="view-reports">
                            Xem tất cả báo cáo <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Quick Job Management -->
    <div class="job-management">
        <h2>Quản lý nhanh tin đăng</h2>
        <div class="table-container">
            <table class="job-table">
                <thead>
                    <tr>
                        <th>Tin đăng</th>
                        <th>Hết hạn trong</th>
                        <th>Hồ sơ</th>
                        <th>Làm mới vào</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <div class="job-title">
                                <span>Chuyên Viên Kiểm Thử Và Vận Hành Phần ...</span>
                                <div class="job-views">
                                    <i class="fas fa-eye"></i>
                                    <span>12</span>
                                </div>
                            </div>
                        </td>
                        <td>29 ngày</td>
                        <td>0</td>
                        <td>--</td>
                        <td>
                            <select class="status-select">
                                <option selected>Ẩn</option>
                                <option>Hiện</option>
                                <option>Đã đóng</option>
                            </select>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <button class="edit-btn"><i class="fas fa-edit"></i></button>
                                <button class="more-btn"><i class="fas fa-ellipsis-v"></i></button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Feedback Button -->
    <div class="feedback-button">
        <div class="feedback-content">
            <span>Feedback</span>
        </div>
    </div>

    <!-- Chat Button -->
    <div class="chat-button">
        <i class="fas fa-comments"></i>
        <span>Trò chuyện</span>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
    <script>
        // Dashboard Chart
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('statusChart').getContext('2d');
            const chart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Nhận hồ sơ','Duyệt hồ sơ','Kiểm Tra Năng Lực','Đề nghị nhận việc','Đã tuyển','Không đạt','Ứng viên từ chối'],
                    datasets: [{
                        data: [34.3, 37.9, 9.5, 0.6, 3.0, 14.2, 0.6],
                        backgroundColor: ['#dbeafe','#fce7f3','#1e40af','#dcfce7','#a855f7','#dc2626','#f59e0b'],
                        borderWidth: 0,
                        cutout: '60%'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { usePointStyle: true, padding: 20, font: { size: 12 } }
                        },
                        tooltip: {
                            callbacks: { label: function(context) { return context.label + ': ' + context.parsed + '%'; } }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>


