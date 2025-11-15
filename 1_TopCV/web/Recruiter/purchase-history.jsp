<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.RecruiterPackagesDAO" %>
<%@ page import="dal.JobPackagesDAO" %>
<%@ page import="model.JobPackages" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<RecruiterPackagesDAO.RecruiterPackagesWithDetails> history =
        (List<RecruiterPackagesDAO.RecruiterPackagesWithDetails>) request.getAttribute("purchaseHistory");
    if (history == null) history = new java.util.ArrayList<>();
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
    String v = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử mua hàng</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Recruiter/styles.css?v=<%= v %>">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/Recruiter/css/purchase-history.css?v=<%= v %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body class="ph-page">
        <!-- Header đồng nhất (navbar) -->
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html" class="highlighted">Quản lý theo thư mục và thẻ</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quy trình onboarding</a>
                                <a href="#">Tài liệu hướng dẫn</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="active">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/recruiter/purchase-history" class="active">Lịch sử mua</a>
                            </div>
                        </li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange">
                                Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/Recruiter/job-posting.jsp">Tạo tin tuyển dụng mới</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/job-management.jsp">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue" onclick="window.location.href='${pageContext.request.contextPath}/candidate-search'">Tìm Ứng Viên</button>
                        <button class="btn btn-white" onclick="window.location.href='${pageContext.request.contextPath}/Recruiter/job-package.jsp'">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-bell"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item highlighted">
                                        <i class="fas fa-building"></i>
                                        <span>Thông tin công ty</span>
                                    </a>
                                </div>
                                <div class="menu-footer">
                                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-item">
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

        <main class="ph-main">
            <div class="ph-card">
                <div class="ph-card-header">
                    <div class="ph-title"><i class="fas fa-receipt"></i> Lịch sử mua hàng</div>
                    <div class="ph-actions">
                        <button class="ph-btn" onclick="location.href = '<%= request.getContextPath() %>/Recruiter/job-package.jsp'">
                            <i class="fas fa-plus"></i> Mua gói
                        </button>
                    </div>
                </div>

                <!-- Tabs removed per request -->

                <!-- Thanh tìm kiếm -->
                <form method="get" action="${pageContext.request.contextPath}/recruiter/purchase-history" style="margin-bottom: 12px; display:flex; gap:8px; align-items:center; justify-content:flex-end;">
                    <input type="text" name="q" class="search-input" placeholder="Tìm theo tên gói..." value="${q}" style="min-width:280px;">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                    <button type="submit" class="ph-btn"><i class="fas fa-search"></i></button>
                </form>
                <div class="ph-table-wrap">
                    <table class="ph-table">
                        <thead>
                            <tr>
                                <th>Gói Dịch Vụ</th>
                                <th>Tổng</th>
                                <th>Đã sử dụng</th>
                                <th>Đã chia sẻ</th>
                                <th>Còn lại</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (history.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="6" style="text-align:center; color:#6b7280; padding:20px;">Chưa có giao dịch nào</td>
                            </tr>
                            <%
                                } else {
                                    for (RecruiterPackagesDAO.RecruiterPackagesWithDetails it : history) {
                                        boolean expired = it.expiryDate != null && it.expiryDate.isBefore(java.time.LocalDateTime.now());
                                        // Tính tổng lượt theo features.posts
                                        int postsPerPackage = 1;
                                        try {
                                            JobPackagesDAO jpDAO = new JobPackagesDAO();
                                            JobPackages pkg = jpDAO.getPackageById(it.packageID);
                                            if (pkg != null && pkg.getFeatures() != null) {
                                                try {
                                                    JsonObject obj = new Gson().fromJson(pkg.getFeatures(), JsonObject.class);
                                                    if (obj != null && obj.has("posts")) {
                                                        postsPerPackage = obj.get("posts").getAsInt();
                                                    }
                                                } catch (Exception ignore) {}
                                            }
                                        } catch (Exception ignore) {}
                                        int capacity = it.quantity * postsPerPackage; // Tổng lượt đăng tối đa
                                        int remaining = capacity - it.usedQuantity;   // Còn lại
                                        int shared = 0; // Không có dữ liệu chia sẻ, mặc định 0
                            %>
                            <tr>
                                <td>
                                    <div style="display:flex; flex-direction:column;">
                                        <strong><%= it.packageName %></strong>
                                        <span style="color:#6b7280; font-size:12px;">
                                            <%= it.packageType %> • HSD: <%= it.expiryDate != null ? df.format(it.expiryDate) : "-" %>
                                        </span>
                                    </div>
                                </td>
                                <td><%= capacity %></td>
                                <td><%= it.usedQuantity %></td>
                                <td><%= shared %></td>
                                <td><%= remaining %></td>
                                <td>
                                    <button class="ph-btn" onclick="location.href='<%= request.getContextPath() %>/Recruiter/job-package.jsp'">Mua thêm</button>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <div class="pagination-info">
                                <span>Trang ${page} / ${totalPages} (${total} kết quả)</span>
                            </div>

                            <div class="pagination">
                                <!-- Previous Button -->
                                <c:if test="${page > 1}">
                                    <a href="${pageContext.request.contextPath}/recruiter/purchase-history?page=${page-1}&pageSize=${pageSize}&q=${q}" 
                                       class="pagination-btn prev-btn">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </a>
                                </c:if>

                                <!-- Page Numbers -->
                                <c:set var="startPage" value="${page - 2 > 1 ? page - 2 : 1}" />
                                <c:set var="endPage" value="${page + 2 < totalPages ? page + 2 : totalPages}" />

                                <c:if test="${startPage > 1}">
                                    <a href="${pageContext.request.contextPath}/recruiter/purchase-history?page=1&pageSize=${pageSize}&q=${q}" 
                                       class="pagination-btn">1</a>
                                    <c:if test="${startPage > 2}">
                                        <span class="pagination-dots">...</span>
                                    </c:if>
                                </c:if>

                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                    <a href="${pageContext.request.contextPath}/recruiter/purchase-history?page=${i}&pageSize=${pageSize}&q=${q}" 
                                       class="pagination-btn ${i == page ? 'active' : ''}">${i}</a>
                                </c:forEach>

                                <c:if test="${endPage < totalPages}">
                                    <c:if test="${endPage < totalPages - 1}">
                                        <span class="pagination-dots">...</span>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/recruiter/purchase-history?page=${totalPages}&pageSize=${pageSize}&q=${q}" 
                                       class="pagination-btn">${totalPages}</a>
                                </c:if>

                                <!-- Next Button -->
                                <c:if test="${page < totalPages}">
                                    <a href="${pageContext.request.contextPath}/recruiter/purchase-history?page=${page+1}&pageSize=${pageSize}&q=${q}" 
                                       class="pagination-btn next-btn">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <script src="<%= request.getContextPath() %>/Recruiter/js/purchase-history.js"></script>
    </body>
</html>


