<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, java.util.List, model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Authentication check - chỉ Admin mới được truy cập
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
    
    if (adminRole == null || !"Admin".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    AdminDAO adminDAO = new AdminDAO();
    List<Role> roleList = adminDAO.getAllRoles();
    request.setAttribute("roleList", roleList);
    
    // Get role parameter if exists
    String selectedRole = request.getParameter("role");
    request.setAttribute("selectedRole", selectedRole);
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Thêm Staff</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/mana-acc.css">
        <style>
            .form-container {
                max-width: 800px;
                margin: 0 auto;
            }

            .form-card {
                background: linear-gradient(180deg, var(--card), rgba(6, 24, 44, 0.6));
                border-radius: 16px;
                padding: 32px;
                border: 1px solid rgba(255, 255, 255, 0.04);
                box-shadow: 0 10px 30px rgba(2, 10, 30, 0.6);
            }

            .form-title {
                font-size: 24px;
                font-weight: 700;
                color: #eaf4ff;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .form-title::before {
                content: "➕";
                font-size: 24px;
            }

            .form-subtitle {
                color: var(--muted-2);
                margin-bottom: 32px;
                font-size: 14px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-row.full {
                grid-template-columns: 1fr;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .form-label {
                color: var(--muted);
                font-weight: 600;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .form-label .required {
                color: var(--danger);
            }

            .form-input,
            .form-select {
                padding: 12px 16px;
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 8px;
                color: #fff;
                font-size: 14px;
                transition: all 0.2s ease;
                font-family: inherit;
            }

            .form-input:focus,
            .form-select:focus {
                outline: none;
                border-color: var(--primary);
                background: rgba(255, 255, 255, 0.08);
                box-shadow: 0 0 0 3px rgba(47, 128, 237, 0.1);
            }

            .form-input::placeholder {
                color: var(--muted-2);
            }

            .form-select option {
                background: #062446;
                color: #fff;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid rgba(255, 255, 255, 0.06);
            }

            .btn-submit {
                background: linear-gradient(45deg, var(--success), #00a085);
                color: #fff;
                padding: 12px 32px;
                border-radius: 8px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
                font-size: 14px;
            }

            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(0, 214, 143, 0.3);
            }

            .btn-cancel {
                background: transparent;
                color: var(--muted);
                padding: 12px 32px;
                border-radius: 8px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
            }

            .btn-cancel:hover {
                background: rgba(255, 255, 255, 0.05);
                border-color: rgba(255, 255, 255, 0.4);
            }

            .alert {
                padding: 12px 20px;
                border-radius: 8px;
                margin-bottom: 24px;
                border: 1px solid;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-error {
                background: rgba(255, 90, 107, 0.1);
                color: var(--danger);
                border-color: rgba(255, 90, 107, 0.3);
            }

            .alert-error::before {
                content: "⚠️";
                font-size: 18px;
            }

            .password-hint {
                font-size: 12px;
                color: var(--muted-2);
                margin-top: 4px;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }

                .form-card {
                    padding: 24px;
                }

                .form-actions {
                    flex-direction: column-reverse;
                }

                .btn-submit,
                .btn-cancel {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <!-- mobile menu toggle -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()">☰</button>

        <div class="wrap">
            <!-- Sidebar -->
            <div class="unified-sidebar" id="unifiedSidebar">
                <div class="sidebar-brand">
                    <h1 class="brand-title">JOBs</h1>
                    <p class="brand-subtitle">Admin Dashboard</p>
                </div>

                <!-- Admin profile -->
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
                    <div class="sidebar-admin-name">
                        <c:choose>
                            <c:when test="${not empty sessionScope.admin}">
                                ${sessionScope.admin.fullName}
                            </c:when>
                            <c:otherwise>Quản trị viên</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <!-- Navigation -->
                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📄 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item active">🏢 Quản lý nhân sự</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-payment.jsp" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <!-- Quick actions -->
                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="${pageContext.request.contextPath}/logout" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <main class="main">
                <header class="topbar">
                    <div class="title">Thêm Admin/Staff Mới</div>
                    <div class="user-info">
                        <div class="avatar">A</div>
                        <div>Admin</div>
                    </div>
                </header>

                <section class="container">
                    <div class="form-container">
                        <div class="form-card">
                            <h2 class="form-title">Thêm Admin/Staff</h2>
                            <p class="form-subtitle">Điền thông tin để tạo tài khoản admin hoặc staff mới</p>

                            <!-- Error message -->
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-error">
                                    ${param.error}
                                </div>
                            </c:if>

                            <form method="post" action="${pageContext.request.contextPath}/addstaff" onsubmit="return validateForm()">
                                <input type="hidden" name="returnRole" value="${selectedRole}" />

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Họ và tên <span class="required">*</span>
                                        </label>
                                        <input type="text" 
                                               name="fullName" 
                                               class="form-input" 
                                               placeholder="Nhập họ và tên"
                                               required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">
                                            Giới tính <span class="required">*</span>
                                        </label>
                                        <select name="gender" class="form-select" required>
                                            <option value="">-- Chọn giới tính --</option>
                                            <option value="Nam">Nam</option>
                                            <option value="Nữ">Nữ</option>
                                            <option value="Khác">Khác</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Email <span class="required">*</span>
                                        </label>
                                        <input type="email" 
                                               name="email" 
                                               class="form-input" 
                                               placeholder="example@domain.com"
                                               required />
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">
                                            Số điện thoại <span class="required">*</span>
                                        </label>
                                        <input type="tel" 
                                               name="phone" 
                                               class="form-input" 
                                               placeholder="0xxxxxxxxx"
                                               pattern="[0-9]{10,11}"
                                               required />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Mật khẩu <span class="required">*</span>
                                        </label>
                                        <input type="password" 
                                               name="password" 
                                               id="password"
                                               class="form-input" 
                                               placeholder="Nhập mật khẩu"
                                               minlength="6"
                                               required />
                                        <div class="password-hint">Mật khẩu phải có ít nhất 6 ký tự</div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">
                                            Xác nhận mật khẩu <span class="required">*</span>
                                        </label>
                                        <input type="password" 
                                               name="confirmPassword" 
                                               id="confirmPassword"
                                               class="form-input" 
                                               placeholder="Nhập lại mật khẩu"
                                               minlength="6"
                                               required />
                                    </div>
                                </div>

                                <div class="form-row full">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Phân quyền <span class="required">*</span>
                                        </label>
                                        <select name="roleId" class="form-select" required>
                                            <option value="">-- Chọn quyền --</option>
                                            <c:forEach var="role" items="${roleList}">
                                                <option value="${role.roleId}">${role.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row full">
                                    <div class="form-group">
                                        <label class="form-label">
                                            Trạng thái <span class="required">*</span>
                                        </label>
                                        <select name="status" class="form-select" required>
                                            <option value="">-- Chọn trạng thái --</option>
                                            <option value="active" selected>Hoạt động</option>
                                            <option value="inactive">Không hoạt động</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp?role=${selectedRole}" 
                                       class="btn-cancel">Hủy</a>
                                    <button type="submit" class="btn-submit">Thêm Admin/Staff</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>
            </main>
        </div>

        <script>
            // Toggle sidebar for mobile
            function toggleSidebar() {
                var sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('show');
            }

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (event) {
                var sidebar = document.getElementById('unifiedSidebar');
                var toggle = document.querySelector('.mobile-menu-toggle');

                if (window.innerWidth <= 1024) {
                    if (!sidebar.contains(event.target) && !toggle.contains(event.target)) {
                        sidebar.classList.remove('show');
                    }
                }
            });

            // Form validation
            function validateForm() {
                var password = document.getElementById('password').value;
                var confirmPassword = document.getElementById('confirmPassword').value;

                if (password !== confirmPassword) {
                    alert('Mật khẩu và xác nhận mật khẩu không khớp!');
                    return false;
                }

                if (password.length < 6) {
                    alert('Mật khẩu phải có ít nhất 6 ký tự!');
                    return false;
                }

                return true;
            }

            // Auto-dismiss error message
            (function () {
                var errorAlert = document.querySelector('.alert-error');
                if (errorAlert) {
                    setTimeout(function () {
                        errorAlert.style.opacity = '0';
                        setTimeout(function () {
                            if (errorAlert && errorAlert.parentNode) {
                                errorAlert.parentNode.removeChild(errorAlert);
                            }
                        }, 500);
                    }, 5000);
                }
            })();
        </script>
    </body>
</html>