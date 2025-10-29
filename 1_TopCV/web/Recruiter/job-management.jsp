<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Recruiter" %>
<%
    Recruiter recruiter = (Recruiter) session.getAttribute("recruiter");
    String userName = (recruiter != null) ? recruiter.getContactPerson() : "User";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin đã đăng - Recruit Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/css/job-management.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="job-management-page">
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-left">
                <div class="logo">
                    <i class="fas fa-briefcase"></i>
                    <span>RecruitPro</span>
                </div>
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                    <li><a href="#">Việc Làm</a></li>
                    <li class="dropdown">
                        <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quản lý theo việc đăng tuyển</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quy trình onboarding</a>
                            <a href="#">Tài liệu hướng dẫn</a>
                        </div>
                    </li>
                    <li><a href="#">Đơn hàng</a></li>
                    <li><a href="#">Báo cáo</a></li>
                    <li><a href="#" class="company-link">Công ty</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <div class="nav-buttons">
                    <div class="dropdown">
                        <button class="btn btn-orange active">
                            ĐĂNG TUYỂN DỤNG <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="${pageContext.request.contextPath}/jobposting">Tạo tin tuyển dụng mới</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp" class="active">Quản lý tin đã đăng</a>
                        </div>
                    </div>
                    <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/candidate-profile.html'">TÌM ỨNG VIÊN</button>
                    <button class="btn btn-white">Mua</button>
                </div>
                <div class="nav-icons">
                    <i class="fas fa-shopping-cart"></i>
                    <div class="dropdown user-dropdown">
                        <div class="user-avatar">
                            <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                        </div>
                        <div class="dropdown-content user-menu">
                            <div class="user-header">
                                <i class="fas fa-user-circle"></i>
                                <div class="user-info">
                                    <div class="user-name">Nguyen Phuoc</div>
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
                                <a href="${pageContext.request.contextPath}/Recruiter/account-management.html" class="menu-item">
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
    <div class="main-content">
        <div class="job-management-main">
            <!-- Filter Tabs -->
            <div class="filter-tabs">
                <div class="tab active">
                    <span>Đang Hiển Thị (1)</span>
                </div>
                <div class="tab">
                    <span>Đang Ẩn (3)</span>
                </div>
                <div class="tab">
                    <span>Sắp Hết Hạn Trong 7 Ngày (1)</span>
                </div>
                <div class="tab">
                    <span>Đã Hết Hạn</span>
                </div>
                <div class="tab">
                    <span>Nháp (26)</span>
                </div>
                <div class="tab">
                    <span>Việc Làm Ảo (19)</span>
                </div>
            </div>

            <!-- Action Bar -->
            <div class="action-bar">
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm...">
                    </div>
                </div>
                <div class="action-buttons">
                    <button class="btn btn-excel">
                        <i class="fas fa-file-excel"></i>
                        Xuất ra Excel
                    </button>
                    <button class="btn btn-filter">
                        <i class="fas fa-filter"></i>
                    </button>
                </div>
            </div>

            <!-- Job List -->
            <div class="job-list">
                <div class="job-item">
                    <div class="job-title-section">
                        <div class="column-header">Chức danh</div>
                        <h3 class="job-title">Embedded Linux Engineer (Junior/ Senior)</h3>
                        <div class="job-meta">
                            <span class="views">
                                <i class="fas fa-eye"></i>
                                3857
                            </span>
                            <span class="category">Hồ Chí Minh</span>
                            <span class="posted-by">Đăng bởi: [Tên người đăng]</span>
                        </div>
                        <div class="job-actions">
                            <button class="action-btn" title="Chỉnh sửa">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="action-btn" title="Sao chép">
                                <i class="fas fa-copy"></i>
                            </button>
                            <button class="action-btn" title="Xem">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="action-btn" title="Thêm">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                            <button class="action-btn repost-btn" title="Đăng lại">
                                Đăng lại
                            </button>
                        </div>
                    </div>

                    <div class="service-section">
                        <div class="column-header">Dịch vụ</div>
                        <div class="service-items-container">
                            <div class="service-item">
                                <span class="service-name">Đăng Tuyển Dụng</span>
                            </div>
                            <div class="service-item">
                                <span class="service-name">Làm Mới Tin Tuyển Dụng</span>
                            </div>
                            <div class="service-item">
                                <span class="service-name">Việc Cần Tuyển Gấp</span>
                            </div>
                        </div>
                        <div class="service-buttons">
                            <button class="btn-upgrade">Nâng cấp dịch vụ</button>
                            <button class="btn-view-cv">Xem những CV phù hợp</button>
                        </div>
                    </div>

                    <div class="expiration-section">
                        <div class="column-header">Hết hạn</div>
                        <div class="expiration-status expired">
                            <span>Hết hạn trong 5 ngày</span>
                        </div>
                        <div class="expiration-dates">
                            <span>19/09/24 - 19/10/24</span>
                        </div>
                    </div>

                    <div class="applications-section">
                        <div class="column-header">Hồ sơ ứng tuyển</div>
                        <div class="application-count">
                            <span>0/8</span>
                        </div>
                    </div>

                    <div class="refresh-section">
                        <div class="column-header">Làm mới lại</div>
                        <div class="last-refresh">
                            <span class="refresh-date">-</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bottom Right Buttons -->
    <div class="bottom-buttons">
        <button class="three-dots-btn">
            <i class="fas fa-ellipsis-h"></i>
        </button>
        <button class="help-btn">
            <i class="fas fa-question"></i>
            Trợ giúp
        </button>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
</body>
</html>
