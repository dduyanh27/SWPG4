<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Tuyển Dụng - Recruit Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/css/job-posting-final.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="job-posting-final-page">
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
                            <a href="${pageContext.request.contextPath}/Recruiter/job-posting.jsp">Tạo tin tuyển dụng mới</a>
                            <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
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
                                <a href="${pageContext.request.contextPath}/Recruiter/company-info.html" class="menu-item highlighted">
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
                                <a href="#" class="logout-item">
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
        <div class="job-posting-final-main">
            <!-- Progress Bar -->
            <div class="progress-container">
                <div class="progress-bar">
                    <div class="progress-step completed">
                        <div class="step-number">1</div>
                        <div class="step-title">Chỉnh sửa việc làm</div>
                    </div>
                    <div class="progress-line completed"></div>
                    <div class="progress-step completed">
                        <div class="step-number">2</div>
                        <div class="step-title">Thiết lập quy trình tuyển dụng</div>
                    </div>
                    <div class="progress-line active"></div>
                    <div class="progress-step active">
                        <div class="step-number">3</div>
                        <div class="step-title">Đăng tuyển dụng</div>
                    </div>
                </div>
            </div>

            <!-- Service Summary Section -->
            <div class="form-section">
                <div class="form-content">
                    <div class="section-header">
                        <i class="fas fa-file-alt"></i>
                        <h3>Tóm Tắt Dịch Vụ</h3>
                        <div class="info-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                    </div>
                    <div class="service-summary">
                        <div class="summary-item">
                            <span class="label">Chức Danh:</span>
                            <span class="value">Chuyên Viên Kiểm Thử Và Vận Hành Phần Mềm (Ba/tester)</span>
                        </div>
                        <div class="summary-item">
                            <span class="label">Mã Công Việc:</span>
                            <span class="value">1700080</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Service Package Selection -->
            <div class="form-section">
                <div class="form-content">
                    <div class="section-header">
                        <i class="fas fa-box"></i>
                        <h3>Chọn Gói Dịch Vụ Phù Hợp Để Đăng Tuyển Dụng</h3>
                    </div>
                    <div class="service-packages">
                        <div class="package-item">
                            <div class="package-radio">
                                <input type="radio" id="package1" name="package" value="basic" checked>
                                <label for="package1">Đăng Tuyển 30-Ngày - Cơ Bản</label>
                            </div>
                            <div class="package-details">
                                <div class="order-info">
                                    <select class="order-select">
                                        <option>ORD-2742737-X0H3F2 - 14-10-2023</option>
                                    </select>
                                </div>
                                <div class="quantity">
                                    <span>Số lượng: 1</span>
                                </div>
                            </div>
                        </div>
                        <div class="package-item">
                            <div class="package-radio">
                                <input type="radio" id="package2" name="package" value="premium">
                                <label for="package2">Đăng Tuyển 30-Ngày - M</label>
                            </div>
                            <div class="package-details">
                                <div class="order-info">
                                    <select class="order-select">
                                        <option>ORD-2745446-H4L2J2 - 17-10-2023</option>
                                    </select>
                                </div>
                                <div class="quantity">
                                    <span>Số lượng: 1</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Additional Services -->
            <div class="form-section">
                <div class="form-content">
                    <div class="section-header">
                        <i class="fas fa-star"></i>
                        <h3>Các Dịch Vụ Thêm</h3>
                    </div>
                    <div class="additional-services">
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service1" name="additional_services">
                                <label for="service1">Việc Làm Tuyển Gấp - M</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2965687-R1P3Q7 - 23-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <span>Ngay</span>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service2" name="additional_services">
                                <label for="service2">Việc Cần Tuyển Gấp</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2807790-X0Q3P2 - 01-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <span>Ngay</span>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service3" name="additional_services">
                                <label for="service3">Thêm - Ưu Tiên Hàng Đầu 30 Ngày - M</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2771105-R8Q9N3 - 02-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <span>Ngay</span>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service4" name="additional_services">
                                <label for="service4">Thêm - Ưu Tiên Hàng Đầu 30 Ngày</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2771105-R8Q9N3 - 02-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <span>Ngay</span>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service5" name="additional_services">
                                <label for="service5">Thêm - Ưu Tiên Hàng Đầu 15 Ngày - M</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2766646-R7T4S6 - 31-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <select class="date-select">
                                        <option>Tuần 1</option>
                                    </select>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                        <div class="service-item">
                            <div class="service-checkbox">
                                <input type="checkbox" id="service6" name="additional_services">
                                <label for="service6">B - Thêm - Ưu Tiên Hàng Đầu 15 Ngày - M</label>
                            </div>
                            <div class="service-details">
                                <div class="order-info">
                                    <span>ORD-2933817-F5B6X0 - 05-...</span>
                                </div>
                                <div class="quantity">
                                    <span>1</span>
                                </div>
                                <div class="apply-date">
                                    <select class="date-select">
                                        <option>Tuần 1</option>
                                    </select>
                                </div>
                                <div class="start-time">
                                    <span>-</span>
                                </div>
                                <div class="industry">
                                    <span>Công Nghệ Thông Tin/Viễn Thông: QA/QC/Software Testing</span>
                                </div>
                                <div class="field">
                                    <span>Cung cấp nhân lực</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="form-actions">
                <button class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/recruitment-process.jsp'">Quay lại</button>
                <button class="btn btn-primary">Đăng tuyển dụng</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
</body>
</html>
