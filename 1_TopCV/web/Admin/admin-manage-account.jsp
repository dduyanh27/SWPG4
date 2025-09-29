<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, dal.RecruiterDAO, dal.JobSeekerDAO, java.util.List, model.Admin, model.Recruiter, model.JobSeeker" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (request.getAttribute("adminList") == null) {
        AdminDAO adminDAO = new AdminDAO();
        List<Admin> adminList = adminDAO.getAllAdmin();
        request.setAttribute("adminList", adminList);
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Quản lý tài khoản</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/mana-acc.css">
    </head>
    <body>
        <!-- mobile menu toggle -->
        <button class="mobile-menu-toggle">☰</button>

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
                            <c:when test="${not empty sessionScope.admin.avatarURL}">
                                <img src="${sessionScope.admin.avatarURL}" alt="Avatar">
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
                    <a href="admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="admin-jobposting-management.jsp" class="nav-item">💼 Tin tuyển dụng</a>
                    <a href="manage-accounts?role=admin" class="nav-item active">👥 Quản lý tài khoản</a>
                    <a href="#" class="nav-item">📁 Quản lý danh mục</a>
                    <a href="#" class="nav-item">📝 Đơn xin việc</a>
                    <a href="admin-profile.jsp" class="nav-item">👤 Hồ sơ cá nhân</a>
                </nav>

                <!-- Quick actions -->
                <div class="sidebar-actions">
                    <a href="admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <main class="main">
                <header class="topbar">
                    <div class="title">Danh sách tài khoản</div>
                    <div class="user-info">
                        <div class="avatar">A</div>
                        <div>Admin</div>
                    </div>
                </header>

                <section class="container">
                    <!-- Role tabs -->
                    <div class="role-tabs">
                        <a href="${pageContext.request.contextPath}/manage-accounts?role=admin" class="tab-btn ${selectedRole eq 'admin' ? 'active' : ''}">Admin</a>
                        <a href="${pageContext.request.contextPath}/manage-accounts?role=jobseeker" class="tab-btn ${selectedRole eq 'jobseeker' ? 'active' : ''}">JobSeeker</a>
                        <a href="${pageContext.request.contextPath}/manage-accounts?role=recruiter" class="tab-btn ${selectedRole eq 'recruiter' ? 'active' : ''}">Recruiter</a>
                    </div>

                    <div class="card">
                        <div class="toolbar">
                            <div class="left-tools">
                                <a href="${pageContext.request.contextPath}/Admin/admin-add-account.jsp" class="btn-add">Thêm Tài Khoản</a>
                            </div>

                            <div class="right-tools">
                                <form method="get" action="manage-accounts" class="search-form">
                                    <input type="hidden" name="role" value="${selectedRole}" />
                                    <input type="text" name="search" placeholder="🔍 Tìm kiếm theo tên, email..." 
                                           value="${param.search}" />
                                    <button type="submit" class="btn primary">Tìm Kiếm</button>
                                </form>
                            </div>
                        </div>

                        <div class="table-wrap">
                            <table aria-label="Danh sách tài khoản">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên/Công ty</th>
                                        <th>Giới tính</th>
                                        <th>Email</th>
                                        <th>Số điện thoại</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${not empty param.msg}">
                                    <div id="flashMsg" class="alert alert-success" style="transition: opacity 400ms ease;">
                                        ${param.msg}
                                    </div>
                                </c:if>
                                <c:choose>
                                    <c:when test="${selectedRole eq 'admin'}">
                                        <c:choose>
                                            <c:when test="${not empty adminList}">
                                                <c:forEach var="admin" items="${adminList}">
                                                    <c:if test="${empty param.search or 
                                                                  fn:containsIgnoreCase(admin.fullName, param.search) or 
                                                                  fn:containsIgnoreCase(admin.email, param.search) or 
                                                                  fn:contains(admin.phone, param.search)}">
                                                          <tr>
                                                              <td>${admin.adminId}</td>
                                                              <td>${admin.fullName}</td>
                                                              <td>${admin.gender}</td>
                                                              <td>${admin.email}</td>
                                                              <td>${admin.phone}</td>
                                                              <td><span class="status ${admin.status}">${admin.status}</span></td>
                                                              <td>
                                                                  <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp?id=${admin.adminId}&type=admin" 
                                                                     class="btn outline">Chi tiết</a>
                                                                  <a href="${pageContext.request.contextPath}/admindeleteaccount?id=${admin.adminId}&type=admin" 
                                                                     class="btn danger" 
                                                                     onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">Xóa</a>
                                                              </td>

                                                          </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="no-data">Không có dữ liệu Admin</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>

                                    <c:when test="${selectedRole eq 'jobseeker'}">
                                        <c:choose>
                                            <c:when test="${not empty jobSeekerList}">
                                                <c:forEach var="js" items="${jobSeekerList}">
                                                    <c:if test="${empty param.search or 
                                                                  fn:containsIgnoreCase(js.fullName, param.search) or 
                                                                  fn:containsIgnoreCase(js.email, param.search) or 
                                                                  fn:contains(js.phone, param.search)}">
                                                          <tr>
                                                              <td>${js.jobSeekerId}</td>
                                                              <td>${js.fullName}</td>
                                                              <td>${js.gender}</td>
                                                              <td>${js.email}</td>
                                                              <td>${js.phone}</td>
                                                              <td><span class="status ${js.status}">${js.status}</span></td>
                                                              <td>
                                                                  <a href="admin-profile.jsp?id=${js.jobSeekerId}&type=jobseeker" class="btn outline">Chi tiết</a>
                                                                  <a href="${pageContext.request.contextPath}/admindeleteaccount?id=${js.jobSeekerId}&type=jobseeker" class="btn danger" 
                                                                     onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">Xóa</a>
                                                              </td>
                                                          </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="no-data">Không có dữ liệu JobSeeker</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>

                                    <c:when test="${selectedRole eq 'recruiter'}">
                                        <c:choose>
                                            <c:when test="${not empty recruiterList}">
                                                <c:forEach var="re" items="${recruiterList}">
                                                    <c:if test="${empty param.search or 
                                                                  fn:containsIgnoreCase(re.companyName, param.search) or 
                                                                  fn:containsIgnoreCase(re.email, param.search) or 
                                                                  fn:contains(re.phone, param.search)}">
                                                          <tr>
                                                              <td>${re.recruiterID}</td>
                                                              <td>${re.companyName}</td>
                                                              <td>${re.gender}</td>
                                                              <td>${re.email}</td>
                                                              <td>${re.phone}</td>
                                                              <td><span class="status ${re.status}">${re.status}</span></td>
                                                              <td>
                                                                  <a href="admin-profile.jsp?id=${re.recruiterID}&type=recruiter" class="btn outline">Chi tiết</a>
                                                                  <a href="${pageContext.request.contextPath}/admindeleteaccount?id=${re.recruiterID}&type=recruiter" class="btn danger" 
                                                                     onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">Xóa</a>
                                                              </td>
                                                          </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="no-data">Không có dữ liệu Recruiter</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <div class="table-footer">
                            <div class="info-text">
                                <c:choose>
                                    <c:when test="${selectedRole eq 'admin'}">
                                        Hiển thị ${fn:length(adminList)} tài khoản Admin
                                    </c:when>
                                    <c:when test="${selectedRole eq 'jobseeker'}">
                                        Hiển thị ${fn:length(jobSeekerList)} tài khoản JobSeeker
                                    </c:when>
                                    <c:when test="${selectedRole eq 'recruiter'}">
                                        Hiển thị ${fn:length(recruiterList)} tài khoản Recruiter
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </section>
            </main>
        </div>
        <script>
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
                }, 2500);
            })();
        </script>
    </body>
</html>