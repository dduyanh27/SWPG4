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
        <title>Quản lý CV - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/admin-cv-management.css">
    </head>
    <body>
        <!-- Sidebar -->
        <div class="unified-sidebar" id="unifiedSidebar">
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Admin Dashboard</p>
            </div>

            <div class="sidebar-profile">
                <div class="sidebar-avatar">
                    <c:choose>
                        <c:when test="${not empty sessionScope.admin.avatarURL}">
                            <img src="assets/img/admin/${sessionScope.admin.avatarURL}" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="sidebar-avatar-placeholder">
                                ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item active">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢  Quản lý nhân sự</a>
                    <a href="#" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
        </div>

        <div class="container">
            <div class="main">
                <div class="page-header">
                    <h1 class="page-title">Quản lý CV ứng viên</h1>
                    <div class="breadcrumb">
                        <a href="admin-dashboard.jsp">Dashboard</a> / Quản lý CV
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <form method="get" action="${pageContext.request.contextPath}/admin/cv-management" class="filter-form">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label class="filter-label" for="searchKeyword">Tìm kiếm</label>
                                <input type="text" id="searchKeyword" name="keyword" class="filter-input" 
                                       placeholder="Tên ứng viên, email, kỹ năng..." value="${param.keyword}">
                            </div>

                            <div class="filter-group">
                                <label class="filter-label" for="filterStatus">Trạng thái</label>
                                <select id="filterStatus" name="status" class="filter-select">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${param.status eq 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                    <option value="inactive" ${param.status eq 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                    <option value="pending" ${param.status eq 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label" for="filterExperience">Kinh nghiệm</label>
                                <select id="filterExperience" name="experience" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="0-1" ${param.experience eq '0-1' ? 'selected' : ''}>Dưới 1 năm</option>
                                    <option value="1-3" ${param.experience eq '1-3' ? 'selected' : ''}>1-3 năm</option>
                                    <option value="3-5" ${param.experience eq '3-5' ? 'selected' : ''}>3-5 năm</option>
                                    <option value="5+" ${param.experience eq '5+' ? 'selected' : ''}>Trên 5 năm</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label" for="sortBy">Sắp xếp theo</label>
                                <select id="sortBy" name="sort" class="filter-select">
                                    <option value="newest" ${param.sort eq 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="oldest" ${param.sort eq 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                                    <option value="name" ${param.sort eq 'name' ? 'selected' : ''}>Tên A-Z</option>
                                </select>
                            </div>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                            <a href="admin-cv-management.jsp" class="btn btn-secondary">🔄 Đặt lại</a>
                        </div>
                    </form>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">📄</div>
                        <div class="stat-content">
                            <div class="stat-value">${totalCVs != null ? totalCVs : 0}</div>
                            <div class="stat-label">Tổng CV</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">✅</div>
                        <div class="stat-content">
                            <div class="stat-value">${activeCVs != null ? activeCVs : 0}</div>
                            <div class="stat-label">CV đang hoạt động</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">⏳</div>
                        <div class="stat-content">
                            <div class="stat-value">${pendingCVs != null ? pendingCVs : 0}</div>
                            <div class="stat-label">CV chờ duyệt</div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">📊</div>
                        <div class="stat-content">
                            <div class="stat-value">${viewsToday != null ? viewsToday : 0}</div>
                            <div class="stat-label">Lượt xem hôm nay</div>
                        </div>
                    </div>
                </div>

                <!-- CV List -->
                <div class="cv-list-section">
                    <div class="section-header">
                        <h2 class="section-title">Danh sách CV</h2>
                        <div class="section-actions">
                            <span class="result-count">Hiển thị ${cvList != null ? cvList.size() : 0} kết quả</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty cvList}">
                            <div class="empty-state">
                                <div class="empty-icon">📭</div>
                                <h3 class="empty-title">Không tìm thấy CV nào</h3>
                                <p class="empty-text">Hiện tại chưa có CV nào trong hệ thống hoặc không khớp với bộ lọc của bạn.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="cv-grid">
                                <c:forEach var="cv" items="${cvList}">
                                    <div class="cv-card">
                                        <div class="cv-header">
                                            <div class="cv-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty cv.avatarURL}">
                                                        <img src="${cv.avatarURL}" alt="${cv.fullName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="cv-avatar-placeholder">
                                                            ${fn:substring(cv.fullName, 0, 1)}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="cv-basic-info">
                                                <h3 class="cv-name">${cv.fullName}</h3>
                                                <p class="cv-position">${cv.desiredPosition}</p>
                                            </div>
                                            <c:choose>
                                                <c:when test="${cv.status eq 'active'}">
                                                    <span class="cv-status status-active">Hoạt động</span>
                                                </c:when>
                                                <c:when test="${cv.status eq 'pending'}">
                                                    <span class="cv-status status-pending">Chờ duyệt</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="cv-status status-inactive">Không hoạt động</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="cv-details">
                                            <div class="cv-detail-item">
                                                <span class="detail-icon">📧</span>
                                                <span class="detail-text">${cv.email}</span>
                                            </div>
                                            <div class="cv-detail-item">
                                                <span class="detail-icon">📱</span>
                                                <span class="detail-text">${cv.phone}</span>
                                            </div>
                                            <div class="cv-detail-item">
                                                <span class="detail-icon">💼</span>
                                                <span class="detail-text">${cv.experience} năm kinh nghiệm</span>
                                            </div>
                                            <div class="cv-detail-item">
                                                <span class="detail-icon">📍</span>
                                                <span class="detail-text">${cv.location}</span>
                                            </div>
                                        </div>

                                        <c:if test="${not empty cv.skills}">
                                            <div class="cv-skills">
                                                <c:forEach var="skill" items="${fn:split(cv.skills, ',')}">
                                                    <span class="skill-tag">${skill}</span>
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <div class="cv-meta">
                                            <span class="meta-item">
                                                <span class="meta-icon">👁️</span>
                                                ${cv.views} lượt xem
                                            </span>
                                            <span class="meta-item">
                                                <span class="meta-icon">🕐</span>
                                                ${cv.createdAt}
                                            </span>
                                        </div>

                                        <div class="cv-actions">
                                            <a href="${pageContext.request.contextPath}/admin/cv-detail?id=${cv.cvId}" 
                                               class="action-link view">
                                                👁️ Xem chi tiết
                                            </a>
                                            <a href="${cv.cvFileURL}" target="_blank" class="action-link download">
                                                📥 Tải CV
                                            </a>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/cv-action" class="inline-form">
                                                <input type="hidden" name="cvId" value="${cv.cvId}">
                                                <input type="hidden" name="action" value="delete">
                                                <button type="submit" class="action-link delete" 
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa CV này?')">
                                                    🗑️ Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&experience=${param.experience}&sort=${param.sort}" 
                                           class="pagination-link">« Trước</a>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="pagination-link active">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${i}&keyword=${param.keyword}&status=${param.status}&experience=${param.experience}&sort=${param.sort}" 
                                                   class="pagination-link">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&experience=${param.experience}&sort=${param.sort}" 
                                           class="pagination-link">Sau »</a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body>
</html>