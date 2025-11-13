<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Recruiter" %>
<%@ page import="model.Job" %>
<%@ page import="dal.RecruiterPackagesDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Recruiter recruiter = (Recruiter) session.getAttribute("recruiter");
    String userName = (recruiter != null) ? recruiter.getContactPerson() : "User";
    
    Job job = (Job) request.getAttribute("job");
    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> postingPackages = 
        (List<RecruiterPackagesDAO.RecruiterPackagesWithDetails>) request.getAttribute("postingPackages");
    
    if (postingPackages == null) postingPackages = new java.util.ArrayList<>();
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
%>
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
                            <a href="${pageContext.request.contextPath}/Recruiter/candidate-management.jsp">Quản lý theo việc đăng tuyển</a>
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
                    <li><a href="${pageContext.request.contextPath}/recruiter/purchase-history">Đơn hàng</a></li>
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
        <div class="job-posting-final-main">
            <!-- Progress Bar -->
            <div class="progress-container">
                <div class="progress-bar">
                    <div class="progress-step completed">
                        <div class="step-number">1</div>
                        <div class="step-title">Chỉnh sửa việc làm</div>
                    </div>
                    <div class="progress-line active"></div>
                    <div class="progress-step active">
                        <div class="step-number">2</div>
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
                            <span class="value"><%= job != null && job.getJobTitle() != null ? job.getJobTitle() : "N/A" %></span>
                        </div>
                        <div class="summary-item">
                            <span class="label">Mã Công Việc:</span>
                            <span class="value"><%= job != null && job.getJobCode() != null ? job.getJobCode() : "N/A" %></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Service Package Selection -->
            <form action="${pageContext.request.contextPath}/jobfinal" method="POST" id="job-final-form">
                <input type="hidden" name="jobID" value="<%= job != null ? job.getJobID() : "" %>">
                <div class="form-section">
                    <div class="form-content">
                        <div class="section-header">
                            <i class="fas fa-box"></i>
                            <h3>Chọn Gói Dịch Vụ Phù Hợp Để Đăng Tuyển Dụng</h3>
                        </div>
                        <div class="service-packages">
                        <% if (postingPackages != null && !postingPackages.isEmpty()) { 
                            int packageIndex = 0;
                            for (RecruiterPackagesDAO.RecruiterPackagesWithDetails pkg : postingPackages) {
                                packageIndex++;
                                int remainingQty = pkg.getRemainingQuantity();
                                String dateStr = pkg.purchaseDate.format(DateTimeFormatter.ofPattern("ddMMyyyy"));
                                String orderCode = "ORD-" + pkg.recruiterPackageID + "-" + 
                                    (dateStr.length() >= 6 ? dateStr.substring(0, 6) : dateStr);
                        %>
                        <div class="package-item">
                            <div class="package-radio">
                                <input type="radio" id="package<%= packageIndex %>" name="package" 
                                       value="<%= pkg.recruiterPackageID %>" <%= packageIndex == 1 ? "checked" : "" %>>
                                <label for="package<%= packageIndex %>"><%= pkg.packageName != null ? pkg.packageName : "Gói dịch vụ" %></label>
                            </div>
                            <div class="package-details">
                                <div class="order-info">
                                    <select class="order-select" name="package-<%= pkg.recruiterPackageID %>">
                                        <option value="<%= pkg.recruiterPackageID %>">
                                            <%= orderCode %> - <%= pkg.purchaseDate.format(dateFormatter) %>
                                        </option>
                                    </select>
                                </div>
                                <div class="quantity">
                                    <span>Số lượng: <%= remainingQty %></span>
                                </div>
                            </div>
                        </div>
                        <% } 
                        } else { %>
                        <div class="no-packages">
                            <p>Bạn chưa có gói đăng tuyển dụng nào. Vui lòng <a href="#">mua gói</a> để tiếp tục.</p>
                        </div>
                        <% } %>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/jobposting'">Quay lại</button>
                    <button type="submit" class="btn btn-primary">Đăng tuyển dụng</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
</body>
</html>

