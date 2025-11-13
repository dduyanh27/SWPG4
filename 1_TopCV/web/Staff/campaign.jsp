<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="dal.CampaignDAO, java.util.List, model.Campaign, model.Admin, model.Role" %>

<%
    // Authentication check - chỉ Marketing Staff mới được truy cập
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
    
    if (adminRole == null || !"Marketing Staff".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Admin admin = (Admin) sessionObj.getAttribute("admin");

    // 2. Khởi tạo DAO và lấy tham số tìm kiếm
    CampaignDAO dao = new CampaignDAO();
    String search = request.getParameter("search");

    // 3. Logic quyết định danh sách nào sẽ được hiển thị
    List<Campaign> listToDisplay;

    if (search != null && !search.trim().isEmpty()) {
        // Nếu người dùng có tìm kiếm -> gọi hàm search
        listToDisplay = dao.searchCampaigns(search);
    } else {
        // Mặc định -> gọi hàm lấy các chiến dịch đang hoạt động
        listToDisplay = dao.getAllActiveCampaigns();
    }

    // 4. Đặt danh sách vào request để JSTL có thể sử dụng
    request.setAttribute("listToDisplay", listToDisplay);

    // 5. Lấy các số liệu thống kê cho dashboard (luôn tính toán độc lập)
    // Giả sử bạn có hàm getAllCampaigns() để đếm tổng số
    int totalCampaigns = dao.getAllCampaigns().size(); 
    int totalActiveCampaigns = dao.getAllActiveCampaigns().size();
    
    request.setAttribute("totalCampaigns", totalCampaigns);
    request.setAttribute("totalActiveCampaigns", totalActiveCampaigns);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>🎯 Quản lý Chiến dịch Marketing - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/marketing-dashboard.css">
    </head>
    <body>
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">☰</button>

        <div class="unified-sidebar" id="unifiedSidebar">
            <div class="sidebar-brand">
                <h1 class="brand-title">JOBs</h1>
                <p class="brand-subtitle">Marketing Dashboard</p>
            </div>

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
                <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                <div class="sidebar-admin-role">📢 Marketing Staff</div>
                <span class="sidebar-status">Hoạt động</span>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-title">Menu chính</div>
                <a href="${pageContext.request.contextPath}/Staff/marketinghome.jsp" class="nav-item">📊 Tổng quan</a>
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item active">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item">📝 Quản lý nội dung</a>
                <a href="${pageContext.request.contextPath}/Staff/stats.jsp" class="nav-item">📈 Phân tích & Báo cáo</a>
                <a href="#" class="nav-item">📱 Social Media</a>
                <a href="#" class="nav-item">⚙️ Cài đặt</a>
            </nav>

            <div class="sidebar-actions">
                <a href="${pageContext.request.contextPath}/Staff/staff-profile.jsp?role=marketing" class="action-btn">👤 Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="action-btn logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <div class="main">
                <div class="marketing-header fade-in">
                    <h1>🎯 Quản lý Chiến dịch Marketing</h1>
                    <p>Tạo, theo dõi và tối ưu hóa các chiến dịch marketing của bạn</p>
                </div>

                <%-- Hiển thị thông báo thành công --%>
                <c:if test="${param.success == '1'}">
                    <div style="background: rgba(72, 187, 120, 0.2); border: 1px solid rgba(72, 187, 120, 0.4); color: #48bb78; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600;">
                        ✅ Tạo chiến dịch marketing thành công!
                    </div>
                </c:if>
                
                <c:if test="${param.updated == '1'}">
                    <div style="background: rgba(72, 187, 120, 0.2); border: 1px solid rgba(72, 187, 120, 0.4); color: #48bb78; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600;">
                        ✅ Cập nhật chiến dịch marketing thành công!
                    </div>
                </c:if>
                
                <c:if test="${param.deleted == '1'}">
                    <div style="background: rgba(72, 187, 120, 0.2); border: 1px solid rgba(72, 187, 120, 0.4); color: #48bb78; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600;">
                        ✅ Xóa chiến dịch marketing thành công!
                    </div>
                </c:if>
                
                <c:if test="${param.error == '1'}">
                    <div style="background: rgba(255, 107, 107, 0.2); border: 1px solid rgba(255, 107, 107, 0.4); color: #ff6b6b; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600;">
                        ❌ Có lỗi xảy ra khi xử lý chiến dịch!
                    </div>
                </c:if>

                <div class="stats-grid fade-in">
                    <div class="stat-card">
                        <div class="stat-number">${totalCampaigns}</div>
                        <div class="stat-label">Tổng chiến dịch</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${totalActiveCampaigns}</div>
                        <div class="stat-label">Đang hoạt động</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">3</div>
                        <div class="stat-label">Sắp diễn ra</div>
                    </div>
<!--                    <div class="stat-card">
                        <div class="stat-number">92%</div>
                        <div class="stat-label">Tỷ lệ thành công</div>
                    </div>-->
                </div>

                <div class="table-container fade-in">
                    <div class="top-bar">
                        <h1>Danh sách chiến dịch</h1>
                        <form action="campaign.jsp" method="get" class="search-box">
                            <input type="text" name="search" value="${param.search}" placeholder="🔍 Tìm kiếm chiến dịch...">
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        </form>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <a href="add-campaign.jsp" class="btn btn-success">➕ Tạo chiến dịch mới</a>
                        <button onclick="exportCampaigns()" class="btn btn-info" style="margin-left: 10px;">📥 Xuất Excel</button>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên chiến dịch</th>
                                <th>Nền tảng</th>
                                <th>Ngân sách</th>
                                <th>Trạng thái</th>
                                <th>Thời gian</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty listToDisplay}">
                                    <tr>
                                        <td colspan="7" style="text-align:center; color:#a0aec0; padding: 40px;">
                                            <div style="font-size: 3rem; margin-bottom: 10px;">📭</div>
                                            <c:choose>
                                                <c:when test="${not empty param.search}">
                                                    <div style="font-size: 1.1rem; font-weight: 600;">Không tìm thấy kết quả nào</div>
                                                    <div style="margin-top: 5px;">Vui lòng thử lại với từ khóa khác.</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="font-size: 1.1rem; font-weight: 600;">Không có chiến dịch nào đang hoạt động</div>
                                                    <div style="margin-top: 5px;">Hãy tạo chiến dịch đầu tiên của bạn!</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${listToDisplay}">
                                        <tr>
                                            <td><strong>#${c.campaignID}</strong></td>
                                            <td><strong>${c.campaignName}</strong></td>
                                            <td>
                                                <span style="padding: 4px 12px; background: #edf2f7; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                                    ${c.platform}
                                                </span>
                                            </td>
                                            <td style="color: #48bb78; font-weight: 600;">${c.budget} VNĐ</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${fn:toLowerCase(c.status) == 'running'}">
                                                        <span style="padding: 4px 12px; background: rgba(72, 187, 120, 0.2); color: #48bb78; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">✓ Đang chạy</span>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(c.status) == 'paused'}">
                                                        <span style="padding: 4px 12px; background: rgba(237, 137, 54, 0.2); color: #ed8936; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">⏸ Tạm dừng</span>
                                                    </c:when>
                                                    <c:when test="${fn:toLowerCase(c.status) == 'completed'}">
                                                        <span style="padding: 4px 12px; background: rgba(160, 174, 192, 0.2); color: #718096; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">🏁 Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="padding: 4px 12px; background: rgba(160, 174, 192, 0.2); color: #718096; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">${c.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-size: 0.9rem;">${c.startDate} → ${c.endDate}</td>
                                            <td class="actions">
                                                <a href="edit-campaign.jsp?id=${c.campaignID}" style="color: #4299e1; background: rgba(66, 153, 225, 0.1);">✏️ Sửa</a>
                                                <a href="delete-campaign?id=${c.campaignID}" onclick="return confirm('Bạn có chắc muốn xóa chiến dịch này?')" style="color: #f56565; background: rgba(245, 101, 101, 0.1);">🗑️ Xóa</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('unifiedSidebar');
                sidebar.classList.toggle('sidebar-open');
            }

            window.addEventListener('resize', function () {
                const sidebar = document.getElementById('unifiedSidebar');
                if (window.innerWidth > 768) {
                    sidebar.classList.remove('sidebar-open');
                }
            });

            function exportCampaigns() {
                alert('Chức năng xuất Excel đang được phát triển!');
            }

            // Fade-in animation
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });

            document.querySelectorAll('.fade-in').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
        </script>
    </body>
</html>