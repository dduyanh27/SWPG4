<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO,java.util.List,model.Admin,model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Authentication check - chỉ Marketing Staff hoặc Sales mới được truy cập
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
    
    if (adminRole == null || (!"Marketing Staff".equals(adminRole.getName()) && !"Sales".equals(adminRole.getName()))) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");

    // Tính ngày hoạt động
    AdminDAO adminDAO = new AdminDAO();
    int days = adminDAO.getActiveDays(admin.getAdminId());
    request.setAttribute("activeDays", days);
    
    // Xác định role của staff để hiển thị navigation phù hợp
    String staffRole = "sales"; // Mặc định là sales
    String dashboardUrl = "/Staff/salehome.jsp";
    String dashboardTitle = "Sales Dashboard";
    
    // Kiểm tra role từ URL parameter (ưu tiên cao nhất)
    String roleParam = request.getParameter("role");
    if ("marketing".equals(roleParam)) {
        staffRole = "marketing";
        dashboardUrl = "/Staff/marketinghome.jsp";
        dashboardTitle = "Marketing Dashboard";
        // Lưu role vào session để sử dụng cho các lần sau
        session.setAttribute("staffRole", "marketing");
    } else if ("sales".equals(roleParam)) {
        staffRole = "sales";
        dashboardUrl = "/Staff/salehome.jsp";
        dashboardTitle = "Sales Dashboard";
        // Lưu role vào session để sử dụng cho các lần sau
        session.setAttribute("staffRole", "sales");
    } else {
        // Kiểm tra role từ session trước
        String sessionRole = (String) session.getAttribute("staffRole");
        if ("marketing".equals(sessionRole)) {
            staffRole = "marketing";
            dashboardUrl = "/Staff/marketinghome.jsp";
            dashboardTitle = "Marketing Dashboard";
        } else if ("sales".equals(sessionRole)) {
            staffRole = "sales";
            dashboardUrl = "/Staff/salehome.jsp";
            dashboardTitle = "Sales Dashboard";
        } else {
            // Fallback: Kiểm tra nếu là marketing staff - có thể dựa vào:
            // 1. Email chứa "marketing"
            // 2. Tên chứa "marketing" 
            // 3. Hoặc dựa vào referrer URL
            String referrer = request.getHeader("referer");
            boolean isMarketingStaff = false;
            
            if (admin.getEmail() != null && admin.getEmail().toLowerCase().contains("marketing")) {
                isMarketingStaff = true;
            } else if (admin.getFullName() != null && admin.getFullName().toLowerCase().contains("marketing")) {
                isMarketingStaff = true;
            } else if (referrer != null && referrer.contains("marketinghome")) {
                isMarketingStaff = true;
            }
            
            if (isMarketingStaff) {
                staffRole = "marketing";
                dashboardUrl = "/Staff/marketinghome.jsp";
                dashboardTitle = "Marketing Dashboard";
                session.setAttribute("staffRole", "marketing");
            } else {
                session.setAttribute("staffRole", "sales");
            }
        }
    }
    
    // Debug: In ra console để kiểm tra
    System.out.println("Staff Role Detection:");
    System.out.println("Role Parameter: " + roleParam);
    System.out.println("Email: " + admin.getEmail());
    System.out.println("FullName: " + admin.getFullName());
    System.out.println("Detected Role: " + staffRole);
    
    request.setAttribute("staffRole", staffRole);
    request.setAttribute("dashboardUrl", dashboardUrl);
    request.setAttribute("dashboardTitle", dashboardTitle);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ Staff - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/staff-profile.css">
    </head>
    <body>
        <!-- Mobile menu toggle button -->
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <!-- Sidebar -->
        <div class="unified-sidebar" id="unifiedSidebar">
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">${dashboardTitle}</p>
            </div>

            <div class="sidebar-profile">
                <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                <div class="sidebar-admin-role">
                    <c:choose>
                        <c:when test="${staffRole eq 'marketing'}">📢 Marketing Staff</c:when>
                        <c:otherwise>💼 Sales Staff</c:otherwise>
                    </c:choose>
                </div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                
                <c:choose>
                    <c:when test="${staffRole eq 'marketing'}">
                        <!-- Marketing Staff Navigation -->
                        <a href="${pageContext.request.contextPath}/Staff/marketinghome.jsp" class="nav-item">📊 Tổng quan</a>
                        <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                        <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item">📝 Quản lý nội dung</a>
                        <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="nav-item">📈 Phân tích & Báo cáo</a>
                        <a href="#" class="nav-item">📱 Social Media</a>
                    </c:when>
                    <c:otherwise>
                        <!-- Sales Staff Navigation -->
                        <a href="${pageContext.request.contextPath}/Staff/salehome.jsp" class="nav-item">📊 Tổng quan</a>
                        <a href="${pageContext.request.contextPath}/Staff/cus-service.jsp" class="nav-item">💬 Customer Service</a>
                        <a href="${pageContext.request.contextPath}/Staff/order-service.jsp" class="nav-item">🛒 Quản lý đơn hàng</a>
                        <a href="${pageContext.request.contextPath}/Staff/dt.jsp" class="nav-item">👥 Quản lý doanh thu</a>
                        <a href="#" class="nav-item">📈 Báo cáo doanh thu</a>
                    </c:otherwise>
                </c:choose>
            </nav>

            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=${staffRole}" class="action-btn active">👤 Hồ sơ cá nhân</a>
                <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <div class="main">
                <div class="page-header">
                    <h1 class="page-title">Hồ sơ Staff</h1>
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}${dashboardUrl}">Dashboard</a> / Hồ sơ cá nhân
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
                        <form action="${pageContext.request.contextPath}/uploadavatar" method="post" enctype="multipart/form-data">
                            <div class="avatar-section">
                                <button type="button" class="avatar" onclick="document.getElementById('avatarFile').click()" style="border: none; background: none; padding: 0; cursor: pointer;">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.admin.avatarUrl}">
                                            <img src="${pageContext.request.contextPath}/assets/img/staff/${sessionScope.admin.avatarUrl}" alt="Avatar" id="avatarImage" onerror="this.src='${pageContext.request.contextPath}/assets/img/admin/admin.png'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/img/admin/admin.png" alt="Default Avatar" id="avatarImage">
                                        </c:otherwise>
                                    </c:choose> 
                                </button>

                                <input type="file" name="avatar" id="avatarFile" accept="image/*" onchange="previewAvatar(this)" style="display:none;">

                                <button type="submit" class="avatar-upload">
                                    📷 Thay đổi avatar
                                </button>
                            </div>
                        </form>

                        <div class="profile-info">
                            <div class="profile-name">${sessionScope.admin.fullName}</div>
                            <div class="profile-role">
                                <c:choose>
                                    <c:when test="${staffRole eq 'marketing'}">📢 Marketing Staff</c:when>
                                    <c:otherwise>💼 Sales Staff</c:otherwise>
                                </c:choose>
                            </div>
                            <span class="status-badge status-active">Hoạt động</span>
                            <div class="profile-stats">
                                <div class="stat-item">
                                    <div class="stat-number"><%= request.getAttribute("activeDays") %></div>
                                    <div class="stat-label">Ngày hoạt động</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">24</div>
                                    <div class="stat-label">Dự án hoàn thành</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">98%</div>
                                    <div class="stat-label">Hiệu suất</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Update Profile -->
                    <form class="form-section" method="post" action="${pageContext.request.contextPath}/updatestaffprofile">
                        <h2 class="section-title">Thông tin cá nhân</h2>
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="phone">Số điện thoại</label>
                                <input type="tel" id="phone" name="phone" class="form-input" 
                                       value="${sessionScope.admin.phone}">
                            </div>

                            <div class="form-group">
                                <div class="form-label">Giới tính</div>
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
                        <input type="hidden" name="avatarUrl" id="avatarUrl" value="${sessionScope.admin.avatarUrl}">

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
    <script>
        function previewAvatar(input) {
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    document.getElementById('avatarImage').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        }

        function toggleSidebar() {
            const sidebar = document.getElementById('unifiedSidebar');
            sidebar.classList.toggle('show');
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.message');
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);

        // Responsive menu handling
        function handleResize() {
            const sidebar = document.getElementById('unifiedSidebar');
            const toggle = document.querySelector('.mobile-menu-toggle');
            
            if (window.innerWidth <= 1024) {
                toggle.style.display = 'flex';
                sidebar.classList.remove('show');
            } else {
                toggle.style.display = 'none';
                sidebar.classList.add('show');
            }
        }

        window.addEventListener('resize', handleResize);
        document.addEventListener('DOMContentLoaded', handleResize);
    </script>

</html>