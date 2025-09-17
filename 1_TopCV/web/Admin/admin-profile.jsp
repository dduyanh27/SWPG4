<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,dal.JobSeekerDAO,dal.RecruiterDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("adminList") == null) {
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);
    }
%>

<%
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

            /* Hide original sidebar */
            .sidebar {
                display: none;
            }

            /* Admin Profile Box - Top Right */
            .admin-profile-mini {
                display: none;
            }


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

            /* Profile Content */
            .profile-content {
                display: grid;
                grid-template-columns: 1fr 2fr;
                gap: 30px;
                max-width: 1200px;
            }

            /* Profile Card */
            .profile-card {
                background: rgba(255,255,255,0.1);
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.3);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255,255,255,0.1);
                height: fit-content;
            }

            .avatar-section {
                text-align: center;
                margin-bottom: 25px;
            }

            .avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                border: 4px solid #00e5ff;
                margin: 0 auto 15px;
                overflow: hidden;
                position: relative;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .avatar:hover {
                transform: scale(1.05);
                border-color: #40c4ff;
            }

            .avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .avatar-placeholder {
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #00e5ff, #0288d1);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 48px;
                color: white;
                font-weight: bold;
            }

            .avatar-upload {
                background: rgba(0,229,255,0.15);
                border: 1px solid rgba(0,229,255,0.3);
                color: #ffffff;
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 12px;
                cursor: pointer;
                margin-top: 10px;
                transition: all 0.3s ease;
            }

            .avatar-upload:hover {
                background: rgba(0,229,255,0.25);
            }

            .profile-info {
                text-align: center;
            }

            .profile-name {
                font-size: 24px;
                font-weight: 700;
                color: #ffffff;
                margin-bottom: 5px;
            }

            .profile-role {
                color: #00e5ff;
                font-size: 16px;
                font-weight: 500;
                margin-bottom: 15px;
            }

            .profile-stats {
                display: flex;
                justify-content: space-around;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid rgba(255,255,255,0.1);
            }

            .stat-item {
                text-align: center;
            }

            .stat-number {
                font-size: 20px;
                font-weight: 700;
                color: #00e5ff;
            }

            .stat-label {
                font-size: 12px;
                color: rgba(255,255,255,0.7);
                margin-top: 5px;
            }

            /* Form Section */
            .form-section {
                background: rgba(255,255,255,0.08);
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.2);
                border: 1px solid rgba(255,255,255,0.05);
            }

            .section-title {
                color: #ffffff;
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #00e5ff;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-label {
                display: block;
                color: #ffffff;
                font-weight: 500;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .form-input,
            .form-select,
            .form-textarea {
                width: 100%;
                padding: 12px 16px;
                background: rgba(255,255,255,0.1);
                border: 1px solid rgba(255,255,255,0.2);
                border-radius: 8px;
                color: #ffffff;
                font-size: 14px;
                transition: all 0.3s ease;
                box-sizing: border-box;
            }

            .form-input:focus,
            .form-select:focus,
            .form-textarea:focus {
                outline: none;
                border-color: #00e5ff;
                background: rgba(255,255,255,0.15);
                box-shadow: 0 0 0 2px rgba(0,229,255,0.2);
            }

            .form-textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-input::placeholder {
                color: rgba(255,255,255,0.5);
            }

            /* Security Section */
            .security-section {
                margin-top: 30px;
                background: rgba(255,107,107,0.1);
                border: 1px solid rgba(255,107,107,0.2);
            }

            .security-section .section-title {
                border-bottom-color: #ff6b6b;
            }

            /* Buttons */
            .btn-group {
                display: flex;
                gap: 15px;
                margin-top: 30px;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #00e5ff, #0288d1);
                color: #ffffff;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #40c4ff, #0277bd);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,229,255,0.3);
            }

            .btn-secondary {
                background: rgba(255,255,255,0.1);
                color: #ffffff;
                border: 1px solid rgba(255,255,255,0.2);
            }

            .btn-secondary:hover {
                background: rgba(255,255,255,0.2);
            }

            .btn-danger {
                background: linear-gradient(135deg, #ff6b6b, #f44336);
                color: #ffffff;
            }

            .btn-danger:hover {
                background: linear-gradient(135deg, #ff8a80, #e53935);
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(255,107,107,0.3);
            }

            /* Status indicators */
            .status-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status-active {
                background: rgba(76,175,80,0.2);
                color: #4caf50;
                border: 1px solid rgba(76,175,80,0.3);
            }

            .status-inactive {
                background: rgba(255,107,107,0.2);
                color: #ff6b6b;
                border: 1px solid rgba(255,107,107,0.3);
            }

            /* Success/Error Messages */
            .message {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
            }

            .message-success {
                background: rgba(76,175,80,0.2);
                border: 1px solid rgba(76,175,80,0.3);
                color: #4caf50;
            }

            .message-error {
                background: rgba(255,107,107,0.2);
                border: 1px solid rgba(255,107,107,0.3);
                color: #ff6b6b;
            }

            /* Hidden file input */
            #avatarFile {
                display: none;
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

                .profile-content {
                    grid-template-columns: 1fr;
                    gap: 20px;
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
                .form-grid {
                    grid-template-columns: 1fr;
                }

                .btn-group {
                    flex-direction: column;
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
                <div class="sidebar-avatar" onclick="document.getElementById('avatarFile').click()">
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
                <a href="admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                <a href="admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                <a href="Admin-user.html" class="nav-item">👥 Quản lý tài khoản</a>
                <a href="#" class="nav-item">📁 Quản lý danh mục</a>
                <a href="#" class="nav-item">📝 Đơn xin việc</a>
                <a href="#" class="nav-item active">👤 Hồ sơ cá nhân</a>
            </nav>

            <!-- Quick actions -->
            <div class="sidebar-actions">
                <a href="admin-dashboard.jsp" class="action-btn">📈 Dashboard</a>
                <a href="logout" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <!-- Main content -->
            <div class="main">
                <div class="page-header">
                    <h1 class="page-title">Hồ sơ Admin</h1>
                    <div class="breadcrumb">
                        <a href="admin-dashboard.jsp">Dashboard</a> / Hồ sơ cá nhân
                    </div>
                </div>

                <!-- Display Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="message message-success">
                        ✅ ${successMessage}
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="message message-error">
                        ❌ ${errorMessage}
                    </div>
                </c:if>

                <div class="profile-content">
                    <!-- Profile Card -->
                    <div class="profile-card">
                        <div class="avatar-section">
                            <div class="avatar" onclick="document.getElementById('avatarFile').click()">
                                <c:choose>
                                    <c:when test="${not empty adminProfile.avatarURL}">
                                        <img src="${adminProfile.avatarURL}" alt="Avatar" id="avatarImage">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar-placeholder" id="avatarPlaceholder">
                                            ${fn:substring(sessionScope.admin.fullName, 0, 1)}
                                        </div>
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
                                    <div class="stat-number">156</div>
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

                    <!-- Form Section -->
                    <div>
                        <!-- Personal Information -->
                        <form class="form-section" method="post" action="updateAdminProfile" enctype="multipart/form-data">
                            <h2 class="section-title">Thông tin cá nhân</h2>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label" for="phone">Số điện thoại</label>
                                    <input type="tel" id="phone" name="phone" class="form-input" 
                                           value="${not empty adminProfile.phone ? adminProfile.phone : ''}" 
                                           placeholder="0123456789">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="dateOfBirth">Ngày sinh</label>
                                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input" 
                                           value="${not empty adminProfile.dateOfBirth ? adminProfile.dateOfBirth : ''}">
                                </div>

                                <div class="form-group full-width">
                                    <label class="form-label" for="address">Địa chỉ</label>
                                    <textarea id="address" name="address" class="form-textarea" 
                                              placeholder="Nhập địa chỉ đầy đủ...">${not empty adminProfile.address ? adminProfile.address : ''}</textarea>
                                </div>

                                <div class="form-group full-width">
                                    <label class="form-label" for="bio">Giới thiệu bản thân</label>
                                    <textarea id="bio" name="bio" class="form-textarea" 
                                              placeholder="Mô tả ngắn về bản thân..." maxlength="500">${not empty adminProfile.bio ? adminProfile.bio : ''}</textarea>
                                </div>
                            </div>

                            <input type="hidden" name="profileId" value="${not empty adminProfile.profileID ? adminProfile.profileID : ''}">
                            <input type="hidden" name="adminId" value="${sessionScope.admin.adminID}">
                            <input type="hidden" name="avatarURL" id="avatarURL" value="${not empty adminProfile.avatarURL ? adminProfile.avatarURL : ''}">

                            <div class="btn-group">
                                <button type="submit" class="btn btn-primary">
                                    💾 Cập nhật thông tin
                                </button>
                                <button type="reset" class="btn btn-secondary">
                                    🔄 Khôi phục
                                </button>
                            </div>
                        </form>

                        <!-- Security Section -->
                        <form class="form-section security-section" method="post" action="changeAdminPassword">
                            <h2 class="section-title">🔐 Bảo mật tài khoản</h2>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label" for="currentPassword">Mật khẩu hiện tại *</label>
                                    <input type="password" id="currentPassword" name="currentPassword" 
                                           class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="newPassword">Mật khẩu mới *</label>
                                    <input type="password" id="newPassword" name="newPassword" 
                                           class="form-input" required minlength="8">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="confirmPassword">Xác nhận mật khẩu *</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" 
                                           class="form-input" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="lastPasswordChange">Thay đổi lần cuối</label>
                                    <input type="text" class="form-input" 
                                           value="15/12/2024" readonly 
                                           style="background: rgba(255,255,255,0.05);">
                                </div>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn btn-danger">
                                    🔑 Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Updated JavaScript for unified sidebar -->
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

            // Preview avatar before upload
            function previewAvatar(input) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        const avatarImage = document.getElementById('avatarImage');
                        const avatarPlaceholder = document.getElementById('avatarPlaceholder');

                        // Update main avatar
                        if (avatarImage) {
                            avatarImage.src = e.target.result;
                        } else if (avatarPlaceholder) {
                            avatarPlaceholder.parentElement.innerHTML =
                                    '<img src="' + e.target.result + '" alt="Avatar" id="avatarImage">';
                        }

                        // Update sidebar avatar
                        const sidebarAvatar = document.querySelector('.sidebar-avatar');
                        if (sidebarAvatar) {
                            sidebarAvatar.innerHTML = '<img src="' + e.target.result + '" alt="Avatar">';
                        }

                        document.getElementById('avatarURL').value = 'pending_upload';
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            }

            // Password confirmation validation
            document.getElementById('confirmPassword').addEventListener('input', function () {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = this.value;

                if (newPassword !== confirmPassword) {
                    this.setCustomValidity('Mật khẩu xác nhận không khớp');
                } else {
                    this.setCustomValidity('');
                }
            });

            // Form validation before submit
            document.querySelector('form[action="updateAdminProfile"]').addEventListener('submit', function (e) {
                const bio = document.getElementById('bio').value.trim();

                if (bio.length > 500) {
                    e.preventDefault();
                    alert('Giới thiệu bản thân không được vượt quá 500 ký tự');
                    return false;
                }
            });

            document.querySelector('form[action="changeAdminPassword"]').addEventListener('submit', function (e) {
                const currentPassword = document.getElementById('currentPassword').value;
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;

                if (!currentPassword || !newPassword || !confirmPassword) {
                    e.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin mật khẩu');
                    return false;
                }

                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('Mật khẩu xác nhận không khớp');
                    return false;
                }

                if (newPassword.length < 8) {
                    e.preventDefault();
                    alert('Mật khẩu mới phải có ít nhất 8 ký tự');
                    return false;
                }
            });
        </script>
    </body>
</html>
