<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.RecruiterDAO, java.util.List, model.Recruiter, model.Role" %>
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
    
    // Load danh sách Recruiter nếu chưa có
    if (request.getAttribute("recruiterList") == null) {
        try {
            RecruiterDAO recruiterDAO = new RecruiterDAO();
            List<Recruiter> recruiterList = recruiterDAO.getAllRecruiters();
            request.setAttribute("recruiterList", recruiterList);
            // Debug: log số lượng recruiter
            System.out.println("Loaded " + (recruiterList != null ? recruiterList.size() : 0) + " recruiters");
        } catch (Exception e) {
            System.out.println("Error loading recruiters: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("recruiterList", new java.util.ArrayList<Recruiter>());
        }
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
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢  Quản lý nhân sự</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-payment.jsp" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
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
                    <!-- Title for Recruiter Management -->
                    <div class="page-title">
                        <h2>Quản lý tài khoản Recruiter</h2>
                    </div>

                    <div class="card">
                        <div class="toolbar">
                            <div class="left-tools">
                                <a href="${pageContext.request.contextPath}/Admin/admin-add-account.jsp" class="btn-add">Thêm Tài Khoản</a>
                            </div>

                            <div class="right-tools">
                                <form method="get" action="Admin/admin-manage-account.jsp" class="search-form">
                                    <input type="text" name="search" placeholder="🔍 Tìm kiếm theo tên công ty, người liên hệ, email..." 
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
                                        <th>Tên công ty</th>
                                        <th>Người liên hệ</th>
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
                                    <c:when test="${not empty recruiterList}">
                                        <c:forEach var="recruiter" items="${recruiterList}">
                                            <c:if test="${empty param.search or 
                                                          fn:containsIgnoreCase(recruiter.companyName, param.search) or 
                                                          fn:containsIgnoreCase(recruiter.contactPerson, param.search) or
                                                          fn:containsIgnoreCase(recruiter.email, param.search) or 
                                                          fn:contains(recruiter.phone, param.search)}">
                                                  <tr>
                                                      <td>${recruiter.recruiterID}</td>
                                                      <td>${recruiter.companyName}</td>
                                                      <td>${recruiter.contactPerson}</td>
                                                      <td>${recruiter.email}</td>
                                                      <td>${recruiter.phone}</td>
                                                      <td><span class="status ${recruiter.status}">${recruiter.status}</span></td>
                                                      <td>
                                                          <a href="${pageContext.request.contextPath}/admin-view-recruiter-company?id=${recruiter.recruiterID}" class="btn outline">Chi tiết</a>
                                                          <a href="${pageContext.request.contextPath}/admindeleteaccount?id=${recruiter.recruiterID}&type=recruiter" class="btn danger" 
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
                                </tbody>
                            </table>
                        </div>

                        <div class="table-footer">
                            <div class="info-text">
                                Hiển thị ${fn:length(recruiterList)} tài khoản Recruiter
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