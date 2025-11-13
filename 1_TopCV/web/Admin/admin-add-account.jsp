<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Role" %>
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
    
    // Get account type parameter (admin or recruiter)
    String accountType = request.getParameter("type");
    if (accountType == null) {
        accountType = "admin";
    }
    request.setAttribute("accountType", accountType);
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Thêm Tài Khoản</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/mana-acc.css">
        <style>
            .form-container {
                max-width: 900px;
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

            .account-type-selector {
                display: flex;
                gap: 12px;
                margin-bottom: 32px;
                background: rgba(255, 255, 255, 0.02);
                border-radius: 12px;
                padding: 4px;
                border: 1px solid rgba(255, 255, 255, 0.04);
            }

            .type-btn {
                flex: 1;
                padding: 12px 24px;
                border: none;
                background: transparent;
                color: rgba(255, 255, 255, 0.7);
                font-weight: 600;
                font-size: 14px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                text-decoration: none;
                text-align: center;
            }

            .type-btn:hover {
                background: rgba(255, 255, 255, 0.05);
                color: rgba(255, 255, 255, 0.9);
            }

            .type-btn.active {
                background: linear-gradient(45deg, #2196f3, #1976d2);
                color: #ffffff;
                box-shadow: 0 2px 8px rgba(33, 150, 243, 0.3);
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
            .form-select,
            .form-textarea {
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
            .form-select:focus,
            .form-textarea:focus {
                outline: none;
                border-color: var(--primary);
                background: rgba(255, 255, 255, 0.08);
                box-shadow: 0 0 0 3px rgba(47, 128, 237, 0.1);
            }

            .form-input::placeholder,
            .form-textarea::placeholder {
                color: var(--muted-2);
            }

            .form-select option {
                background: #062446;
                color: #fff;
            }

            .form-textarea {
                min-height: 100px;
                resize: vertical;
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

            .info-box {
                background: rgba(47, 128, 237, 0.1);
                border: 1px solid rgba(47, 128, 237, 0.3);
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 24px;
                color: #2f80ed;
                font-size: 13px;
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }

            .info-box::before {
                content: "ℹ️";
                font-size: 16px;
                flex-shrink: 0;
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

                .account-type-selector {
                    flex-direction: column;
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
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item active">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📄 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢 Quản lý nhân sự</a>
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
                    <div class="title">Thêm Tài Khoản Mới</div>
                    <div class="user-info">
                        <div class="avatar">A</div>
                        <div>Admin</div>
                    </div>
                </header>

                <section class="container">
                    <div class="form-container">
                        <div class="form-card">
                            <h2 class="form-title">Tạo Tài Khoản</h2>
                            <p class="form-subtitle">Điền thông tin để tạo tài khoản Admin hoặc Recruiter mới</p>

                            <!-- Account Type Selector -->
                            <div class="account-type-selector">
                                <a href="${pageContext.request.contextPath}/Admin/admin-add-account.jsp?type=admin" 
                                   class="type-btn ${accountType eq 'admin' ? 'active' : ''}">
                                    Admin
                                </a>
                                <a href="${pageContext.request.contextPath}/Admin/admin-add-account.jsp?type=recruiter" 
                                   class="type-btn ${accountType eq 'recruiter' ? 'active' : ''}">
                                    Recruiter
                                </a>
                            </div>

                            <!-- Info box -->
                            <div class="info-box">
                                <c:choose>
                                    <c:when test="${accountType eq 'admin'}">
                                        Bạn đang tạo tài khoản Admin. Admin có quyền quản lý toàn bộ hệ thống.
                                    </c:when>
                                    <c:otherwise>
                                        Bạn đang tạo tài khoản Recruiter. Recruiter có thể đăng tin tuyển dụng và quản lý ứng viên.
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Error message -->
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-error">
                                    ${param.error}
                                </div>
                            </c:if>

                            <form method="post" 
                                  action="${pageContext.request.contextPath}/${accountType eq 'admin' ? 'adminaddaccount' : 'adminaddrecruiter'}" 
                                  onsubmit="return validateForm()">

                                <input type="hidden" name="accountType" value="${accountType}" />

                                <c:choose>
                                    <c:when test="${accountType eq 'admin'}">
                                        <!-- Admin Form -->
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
                                                    Trạng thái <span class="required">*</span>
                                                </label>
                                                <select name="status" class="form-select" required>
                                                    <option value="">-- Chọn trạng thái --</option>
                                                    <option value="active" selected>Hoạt động</option>
                                                    <option value="inactive">Không hoạt động</option>
                                                </select>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Recruiter Form -->
                                        <div class="form-row">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    Tên công ty <span class="required">*</span>
                                                </label>
                                                <input type="text" 
                                                       name="companyName" 
                                                       class="form-input" 
                                                       placeholder="Nhập tên công ty"
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
                                                       placeholder="company@domain.com"
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

                                        <div class="form-row full">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    Địa chỉ công ty <span class="required">*</span>
                                                </label>
                                                <input type="text" 
                                                       name="address" 
                                                       class="form-input" 
                                                       placeholder="Nhập địa chỉ công ty"
                                                       required />
                                            </div>
                                        </div>

                                        <div class="form-row full">
                                            <div class="form-group">
                                                <label class="form-label">
                                                    Mô tả công ty
                                                </label>
                                                <textarea name="description" 
                                                          class="form-textarea" 
                                                          placeholder="Nhập mô tả về công ty (không bắt buộc)"></textarea>
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
                                                    Trạng thái <span class="required">*</span>
                                                </label>
                                                <select name="status" class="form-select" required>
                                                    <option value="">-- Chọn trạng thái --</option>
                                                    <option value="active" selected>Hoạt động</option>
                                                    <option value="inactive">Không hoạt động</option>
                                                </select>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" 
                                       class="btn-cancel">Hủy</a>
                                    <button type="submit" class="btn-submit">
                                        Tạo Tài Khoản ${accountType eq 'admin' ? 'Admin' : 'Recruiter'}
                                    </button>
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