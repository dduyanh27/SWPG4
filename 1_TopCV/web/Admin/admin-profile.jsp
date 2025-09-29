<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,dal.JobSeekerDAO,dal.RecruiterDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy danh sách admin
    if (request.getAttribute("adminList") == null) {
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);
    }

    // Tính ngày hoạt động
    AdminDAO adminDAO = new AdminDAO();
    int days = adminDAO.getActiveDays(admin.getAdminId());
    request.setAttribute("activeDays", days);

    // Lấy thống kê jobseeker & recruiter
    JobSeekerDAO dao = new JobSeekerDAO();
    int totalJobSeekers = dao.countJobSeeker();
    request.setAttribute("totalJobSeekers", totalJobSeekers);

    RecruiterDAO rcdao = new RecruiterDAO();
    int totalRecruiters = rcdao.countRecruiter();
    request.setAttribute("totalRecruiters", totalRecruiters);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ Admin - JOBs</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/admin-profile.css">
</head>
<body>
    <!-- Sidebar -->
    <div class="unified-sidebar" id="unifiedSidebar">
        <div class="sidebar-brand">
            <h1 class="brand-title">JOBs</h1>
            <p class="brand-subtitle">Admin Dashboard</p>
        </div>

        <div class="sidebar-profile">
            <div class="sidebar-avatar" onclick="document.getElementById('avatarFile').click()">
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
            <a href="admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
            <a href="admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
            <a href="admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
            <a href="#" class="nav-item">📁 Quản lý danh mục</a>
            <a href="#" class="nav-item">📝 Đơn xin việc</a>
            <a href="#" class="nav-item active">👤 Hồ sơ cá nhân</a>
        </nav>

        <div class="sidebar-actions">
            <a href="admin-dashboard.jsp" class="action-btn">📈 Dashboard</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="main">
            <div class="page-header">
                <h1 class="page-title">Hồ sơ Admin</h1>
                <div class="breadcrumb">
                    <a href="admin-dashboard.jsp">Dashboard</a> / Hồ sơ cá nhân
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty successMessage}">
                <div class="message message-success">✅ ${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="message message-error">❌ ${errorMessage}</div>
            </c:if>

            <div class="profile-content">
                <!-- Profile Card -->
                <div class="profile-card">
                    <div class="avatar-section">
                        <div class="avatar" onclick="document.getElementById('avatarFile').click()">
                            <c:choose>
                                <c:when test="${not empty sessionScope.admin.avatarURL}">
                                    <img src="assets/img/admin/${sessionScope.admin.avatarURL}" alt="Avatar" id="avatarImage">
                                </c:when>
                                <c:otherwise>
                                    <img src="assets/img/admin/admin.png" alt="Default Avatar" id="avatarImage">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <input type="file" id="avatarFile" accept="image/*" onchange="previewAvatar(this)">
                        <button class="avatar-upload" onclick="document.getElementById('avatarFile').click()">
                            📷 Thay đổi avatar
                        </button>
                    </div>

                    <div class="profile-info">
                        <div class="profile-name">${sessionScope.admin.fullName}</div>
                        <div class="profile-role">🛡️ Quản trị viên</div>
                        <span class="status-badge status-active">Hoạt động</span>
                        <div class="profile-stats">
                            <div class="stat-item">
                                <div class="stat-number"><%= request.getAttribute("activeDays") %></div>
                                <div class="stat-label">Ngày hoạt động</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">${totalJobSeekers + totalRecruiters}</div>
                                <div class="stat-label">Người dùng quản lý</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">3,450</div>
                                <div class="stat-label">Tin đã duyệt</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Update Profile -->
                <form class="form-section" method="post" action="${pageContext.request.contextPath}/updateadminprofile">
                    <h2 class="section-title">Thông tin cá nhân</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" class="form-input" 
                                   value="${sessionScope.admin.phone}">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Giới tính</label>
                            <label><input type="radio" name="gender" value="Nam" ${sessionScope.admin.gender eq 'Nam' ? 'checked' : ''}> Nam</label>
                            <label><input type="radio" name="gender" value="Nữ" ${sessionScope.admin.gender eq 'Nữ' ? 'checked' : ''}> Nữ</label>
                            <label><input type="radio" name="gender" value="Khác" ${sessionScope.admin.gender eq 'Khác' ? 'checked' : ''}> Khác</label>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="address">Địa chỉ</label>
                            <textarea id="address" name="address" class="form-textarea">${sessionScope.admin.address}</textarea>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="bio">Giới thiệu bản thân</label>
                            <textarea id="bio" name="bio" class="form-textarea" maxlength="500">${sessionScope.admin.bio}</textarea>
                        </div>
                    </div>

                    <input type="hidden" name="adminId" value="${sessionScope.admin.adminId}">
                    <input type="hidden" name="avatarURL" id="avatarURL" value="${sessionScope.admin.avatarURL}">

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">💾 Cập nhật thông tin</button>
                        <button type="reset" class="btn btn-secondary">🔄 Khôi phục</button>
                    </div>
                </form>

                <!-- Change Password -->
                <form class="form-section" method="post" action="${pageContext.request.contextPath}/adminchangepassword">
                    <h2 class="section-title">🔐 Bảo mật tài khoản</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="currentPassword">Mật khẩu hiện tại *</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="newPassword">Mật khẩu mới *</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-input" required minlength="8">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">Xác nhận mật khẩu *</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="lastPasswordChange">Thay đổi lần cuối</label>
                            <input type="text" class="form-input" value="${sessionScope.admin.updatedAt}" readonly>
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="submit" class="btn btn-danger">🔑 Đổi mật khẩu</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
