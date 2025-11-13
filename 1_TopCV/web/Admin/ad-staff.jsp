<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, java.util.List, model.Admin, model.AdminWithRole, model.Role, java.util.stream.Collectors" %>
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
    List<AdminWithRole> adminWithRoleList;
    List<Role> roleList = adminDAO.getAllRoles();

    // Xác định role đang chọn (mặc định là "admin")
    String selectedRole = request.getParameter("role");
    if (selectedRole == null) {
        selectedRole = "admin";
    }

    // Kiểm tra có từ khóa tìm kiếm không
    String searchKeyword = request.getParameter("search");
    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        // Nếu có từ khóa thì tìm kiếm với filter theo role
        adminWithRoleList = adminDAO.searchAdminWithRole(searchKeyword, selectedRole);
    } else {
        // Nếu không có thì lấy toàn bộ danh sách với filter theo role
        if ("admin".equals(selectedRole)) {
            adminWithRoleList = adminDAO.getAdminByRole("Admin");
        } else if ("other".equals(selectedRole)) {
            adminWithRoleList = adminDAO.getAllAdminWithRole();
            adminWithRoleList = adminWithRoleList.stream()
                .filter(adminWithRole -> adminWithRole.getRole() == null || 
                        !"Admin".equals(adminWithRole.getRole().getName()))
                .collect(Collectors.toList());
        } else {
            adminWithRoleList = adminDAO.getAllAdminWithRole();
        }
    }
    request.setAttribute("adminWithRoleList", adminWithRoleList);
    request.setAttribute("roleList", roleList);
    request.setAttribute("selectedRole", selectedRole);
%>


<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Quản lý Staff</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/mana-acc.css">
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
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item active">🏢  Quản lý nhân sự</a>
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
                    <div class="title">Quản lý Admin & Staff</div>
                    <div class="user-info">
                        <div class="avatar">A</div>
                        <div>Admin</div>
                    </div>
                </header>

                <section class="container">
                    <!-- Role tabs -->
                    <div class="role-tabs">
                        <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp?role=admin${not empty param.search ? '&search=' : ''}${not empty param.search ? param.search : ''}" 
                           class="tab-btn ${selectedRole eq 'admin' ? 'active' : ''}">
                            Admin (Role: Admin)
                        </a>
                        <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp?role=other${not empty param.search ? '&search=' : ''}${not empty param.search ? param.search : ''}" 
                           class="tab-btn ${selectedRole eq 'other' ? 'active' : ''}">
                            Admin (Role: Khác)
                        </a>
                    </div>

                    <div class="card">
                        <div class="toolbar">
                            <div class="left-tools">
                                <a href="${pageContext.request.contextPath}/Admin/admin-add-staff.jsp?role=${selectedRole}" 
                                   class="btn-add">
                                    Thêm Admin
                                </a>
                            </div>

                            <div class="right-tools">
                                <form method="get" action="ad-staff.jsp" class="search-form">
                                    <input type="hidden" name="role" value="${selectedRole}" />
                                    <input type="text" 
                                           name="search" 
                                           id="searchInput"
                                           placeholder="🔍 Tìm kiếm theo tên, số điện thoại..." 
                                           value="${param.search}" />
                                    <button type="submit" class="btn primary">Tìm Kiếm</button>
                                    <c:if test="${not empty param.search}">
                                        <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp?role=${selectedRole}" 
                                           class="btn outline">Xóa tìm kiếm</a>
                                    </c:if>
                                </form>
                            </div>
                        </div>

                        <!-- Flash message -->
                        <c:if test="${not empty param.msg}">
                            <div id="flashMsg" class="alert alert-success" 
                                 style="background: rgba(76, 175, 80, 0.2);
                                 color: #4caf50;
                                 padding: 12px 20px;
                                 border-radius: 8px;
                                 margin-bottom: 20px;
                                 border: 1px solid rgba(76, 175, 80, 0.3);
                                 transition: opacity 400ms ease;">
                                ${param.msg}
                            </div>
                        </c:if>

                        <div class="table-wrap">
                            <table aria-label="Danh sách Admin & Staff">
                                <thead>
                                    <tr>
                                        <th class="col-id">ID</th>
                                        <th class="col-name">Họ và tên</th>
                                        <th class="col-role">Role</th>
                                        <th class="col-gender">Giới tính</th>
                                        <th class="col-email">Email</th>
                                        <th class="col-phone">Số điện thoại</th>
                                        <th class="col-status">Trạng thái</th>
                                        <th class="col-act">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty adminWithRoleList}">
                                            <c:set var="hasResults" value="false" />
                                            <c:forEach var="adminWithRole" items="${adminWithRoleList}">
                                                <c:set var="admin" value="${adminWithRole.admin}" />
                                                <c:set var="role" value="${adminWithRole.role}" />

                                                <%-- Kiểm tra role filter --%>
                                                <c:choose>
                                                    <c:when test="${selectedRole eq 'admin'}">
                                                        <%-- Tab Admin: chỉ hiển thị Admin có role = "Admin" --%>
                                                        <c:choose>
                                                            <c:when test="${not empty role and role.name eq 'Admin'}">
                                                                <c:set var="showAdmin" value="true" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="showAdmin" value="false" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:when test="${selectedRole eq 'other'}">
                                                        <%-- Tab Khác: hiển thị Admin có role khác "Admin" --%>
                                                        <c:choose>
                                                            <c:when test="${not empty role and role.name ne 'Admin'}">
                                                                <c:set var="showAdmin" value="true" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="showAdmin" value="false" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="showAdmin" value="false" />
                                                    </c:otherwise>
                                                </c:choose>

                                                <%-- Kiểm tra search filter --%>
                                                <c:if test="${showAdmin and (empty param.search or 
                                                              fn:containsIgnoreCase(admin.fullName, param.search) or 
                                                              fn:containsIgnoreCase(admin.email, param.search) or 
                                                              fn:contains(admin.phone, param.search))}">
                                                    <c:set var="hasResults" value="true" />
                                                    <tr>
                                                        <td class="col-id">${admin.adminId}</td>
                                                        <td class="col-name">${admin.fullName}</td>
                                                        <td class="col-role">
                                                            <c:choose>
                                                                <c:when test="${not empty role}">
                                                                    <span class="role-badge">${role.name}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="role-badge no-role">Chưa phân quyền</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="col-gender">${admin.gender}</td>
                                                        <td class="col-email">${admin.email}</td>
                                                        <td class="col-phone">${admin.phone}</td>
                                                        <td class="col-status">
                                                            <span class="status ${admin.status}">${admin.status}</span>
                                                        </td>
                                                        <td class="col-act">
                                                            <button onclick="openAssignRoleModal(this)" 
                                                                    data-admin-id="${admin.adminId}" 
                                                                    data-admin-name="${admin.fullName}" 
                                                                    data-current-role="${not empty role ? role.name : 'Chưa phân quyền'}"
                                                                    class="btn primary">Phân quyền</button>
<!--                                                            <a href="${pageContext.request.contextPath}/delete-staff?id=${admin.adminId}&type=admin" 
                                                               class="btn danger" 
                                                               onclick="return confirm('Bạn có chắc chắn muốn xóa Admin này?')">Xóa</a>-->
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${not hasResults}">
                                                <tr>
                                                    <td colspan="8" class="no-data">Không tìm thấy kết quả phù hợp</td>
                                                </tr>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="no-data">Không có dữ liệu Admin</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-footer">
                            <div class="info-text">
                                <c:choose>
                                    <c:when test="${not empty param.search}">
                                        <c:choose>
                                            <c:when test="${selectedRole eq 'admin'}">
                                                Kết quả tìm kiếm "${param.search}" trong Admin có role "Admin"
                                            </c:when>
                                            <c:when test="${selectedRole eq 'other'}">
                                                Kết quả tìm kiếm "${param.search}" trong Admin có role khác "Admin"
                                            </c:when>
                                            <c:otherwise>
                                                Kết quả tìm kiếm "${param.search}" trong Admin
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${selectedRole eq 'admin'}">
                                                Hiển thị Actor Admin có role "Admin"
                                            </c:when>
                                            <c:when test="${selectedRole eq 'other'}">
                                                Hiển thị Actor Admin có role khác "Admin"
                                            </c:when>
                                            <c:otherwise>
                                                Hiển thị Actor Admin
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </section>
            </main>
        </div>

        <!-- Modal Assign Role -->
        <div id="assignRoleModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Phân quyền cho Admin</h3>
                    <button class="close" onclick="closeAssignRoleModal()" onKeyPress="closeAssignRoleModal()" tabindex="0">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="assignRoleForm" method="post" action="${pageContext.request.contextPath}/adminassignrole">
                        <input type="hidden" name="adminId" id="modalAdminId">
                        <input type="hidden" name="selectedRole" value="${selectedRole}">

                        <div class="form-group">
                            <label for="modalAdminName">Tên Admin:</label>
                            <input type="text" id="modalAdminName" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="modalCurrentRole">Role hiện tại:</label>
                            <input type="text" id="modalCurrentRole" readonly class="form-control">
                        </div>

                        <div class="form-group">
                            <label for="modalRoleSelect">Chọn Role mới:</label>
                            <select name="roleId" id="modalRoleSelect" class="form-control" required>
                                <option value="">-- Chọn Role --</option>
                                <c:forEach var="role" items="${roleList}">
                                    <option value="${role.roleId}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="modal-footer">
                            <button type="button" onclick="closeAssignRoleModal()" class="btn outline">Hủy</button>
                            <button type="submit" class="btn primary">Phân quyền</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Flash message auto hide
            (function () {
                var el = document.getElementById('flashMsg');
                if (!el)
                    return;
                setTimeout(function () {
                    el.style.opacity = '0';
                    setTimeout(function () {
                        if (el && el.parentNode) {
                            el.parentNode.removeChild(el);
                        }
                    }, 500);
                }, 3000);
            })();

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

            // Assign Role Modal functions
            function openAssignRoleModal(button) {
                var adminId = button.getAttribute('data-admin-id');
                var adminName = button.getAttribute('data-admin-name');
                var currentRole = button.getAttribute('data-current-role');

                document.getElementById('modalAdminId').value = adminId;
                document.getElementById('modalAdminName').value = adminName;
                document.getElementById('modalCurrentRole').value = currentRole;
                document.getElementById('modalRoleSelect').value = '';
                document.getElementById('assignRoleModal').style.display = 'block';
            }

            function closeAssignRoleModal() {
                document.getElementById('assignRoleModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                var modal = document.getElementById('assignRoleModal');
                if (event.target == modal) {
                    closeAssignRoleModal();
                }
            }

            // Trim trailing spaces before form submission only
            document.querySelector('.search-form').addEventListener('submit', function(e) {
                var searchInput = document.getElementById('searchInput');
                // Only trim trailing spaces, keep leading and middle spaces
                searchInput.value = searchInput.value.replace(/\s+$/, '');
            });
        </script>
    </body>
</html>