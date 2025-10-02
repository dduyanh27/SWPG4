<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                            <a href="${pageContext.request.contextPath}/listpostingjobs" class="active">Quản lý tin đã đăng</a>
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
                                    <div class="user-name">${userName}</div>
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

    <div class="main-content">
        <div class="job-management-main">
            <div class="filter-tabs">
                <div class="tab active">
                    <span>Đang Hiển Thị (<c:out value="${jobList.size()}" default="0"/>)</span>
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

            <div class="job-list">
                <c:choose>
                    <c:when test="${not empty jobList}">
                        <c:forEach var="job" items="${jobList}">
                            <div class="job-item">
                                <div class="job-title-section">
                                    <div class="column-header">Chức danh</div>
                                    <%-- Sử dụng job.getTitle() --%>
                                    <h3 class="job-title">${job.title}</h3>
                                    <div class="job-meta">
                                        <span class="views">
                                            <i class="fas fa-eye"></i>
                                            <%-- Giả định có job.getViews() --%>
                                            <c:out value="${job.views}" default="0"/>
                                        </span>
                                        <span class="category">
                                            <%-- Giả định có job.getLocation() --%>
                                            <c:out value="${job.location}" default="N/A"/>
                                        </span>
                                        <span class="posted-by">
                                            <%-- Sử dụng userName đã set trong servlet --%>
                                            Đăng bởi: ${userName}
                                        </span>
                                    </div>
                                    <div class="job-actions">
                                        <%-- Thêm id công việc vào URL chỉnh sửa, xem chi tiết --%>
                                        <button class="action-btn" title="Chỉnh sửa" onclick="window.location.href='${pageContext.request.contextPath}/jobedit?id=${job.jobID}'">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="action-btn" title="Sao chép">
                                            <i class="fas fa-copy"></i>
                                        </button>
                                        <button class="action-btn" title="Xem" onclick="window.open('${pageContext.request.contextPath}/jobdetails?id=${job.jobID}', '_blank')">
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
                                        <%-- Cần lặp qua list service của job nếu có --%>
                                        <div class="service-item">
                                            <span class="service-name">Đăng Tuyển Dụng</span>
                                        </div>
                                        <%-- Có thể thêm logic if để hiển thị các dịch vụ khác --%>
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
                                    <c:set var="daysLeft" value="${(job.expirationDate.time - job.postDate.time) / (1000 * 60 * 60 * 24)}"/>
                                    <div class="expiration-status <c:if test="${daysLeft < 7}">expired</c:if>">
                                        <%-- Giả định job.getExpirationDate() có tồn tại --%>
                                        <c:choose>
                                            <c:when test="${job.expirationDate.time > job.postDate.time}">
                                                <span>Hết hạn trong <fmt:formatNumber value="${daysLeft}" maxFractionDigits="0"/> ngày</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>Đã hết hạn</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="expiration-dates">
                                        <%-- Format ngày tháng --%>
                                        <fmt:formatDate value="${job.postDate}" pattern="dd/MM/yy"/> - 
                                        <fmt:formatDate value="${job.expirationDate}" pattern="dd/MM/yy"/>
                                    </div>
                                </div>

                                <div class="applications-section">
                                    <div class="column-header">Hồ sơ ứng tuyển</div>
                                    <div class="application-count">
                                        <%-- Giả định có job.getApplicantCount() và job.getRequiredApplicants() --%>
                                        <span><c:out value="${job.applicantCount}" default="0"/>/<c:out value="${job.requiredApplicants}" default="N/A"/></span>
                                    </div>
                                </div>

                                <div class="refresh-section">
                                    <div class="column-header">Làm mới lại</div>
                                    <div class="last-refresh">
                                        <%-- Giả định có job.getLastRefreshDate() --%>
                                        <span class="refresh-date">
                                            <c:choose>
                                                <c:when test="${not empty job.lastRefreshDate}">
                                                    <fmt:formatDate value="${job.lastRefreshDate}" pattern="dd/MM/yy"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-jobs">
                            <p>Bạn chưa đăng tin tuyển dụng nào.</p>
                            <a href="${pageContext.request.contextPath}/jobposting" class="btn btn-orange">Đăng tin tuyển dụng ngay!</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

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