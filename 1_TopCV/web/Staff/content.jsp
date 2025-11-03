<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dal.CampaignDAO, dal.ContentDAO, model.Campaign, model.MarketingContent, model.Admin, model.Role, java.util.List" %>

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

    CampaignDAO camDAO = new CampaignDAO();
    List<Campaign> camList = camDAO.getAllActiveCampaigns();
    request.setAttribute("campaigns", camList);

    ContentDAO contentDAO = new ContentDAO();
    
    List<MarketingContent> contentList = contentDAO.getAllContent();
    List<MarketingContent> draftList = contentDAO.getAllDraftContent();
    List<MarketingContent> arcList = contentDAO.getAllArchivedContent();
    
    int totalContents = contentList.size();
    int totalDrafts = draftList.size();
    int totalArc = arcList.size();
    
    request.setAttribute("totalContents", totalContents);
    request.setAttribute("totalDrafts", totalDrafts);
    request.setAttribute("totalArc", totalArc);
    
    request.setAttribute("contentList", contentList);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>📝 Quản lý Nội dung - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/marketing-dashboard.css">
        
        <%-- **BƯỚC 2: THÊM CSS MỚI** --%>
        <style>
            /* Thêm hiệu ứng con trỏ và hover cho các hàng trong bảng */
            #contentTableBody .clickable-row {
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            #contentTableBody .clickable-row:hover {
                background-color: #f7fafc; /* Màu xám rất nhạt */
            }

            #contentTableBody .clickable-row:focus {
                background-color: #e2e8f0;
                outline: 2px solid #3182ce;
                outline-offset: -2px;
            }
            
            /* CSS cho nút Xóa trong modal */
            .btn-danger {
                background-color: #e53e3e;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: background-color 0.2s ease;
            }
            .btn-danger:hover {
                background-color: #c53030;
            }
        </style>

    </head>
    <body>
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">☰</button>

        <div class="unified-sidebar" id="unifiedSidebar">
            <%-- Sidebar content - Giữ nguyên không thay đổi --%>
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
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item active">📝 Quản lý nội dung</a>
                <a href="${pageContext.request.contextPath}/Staff/content-stats" class="nav-item">👁️ Thống kê lượt xem</a>
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
                    <h1>📝 Quản lý Nội dung Marketing</h1>
                    <p>Tạo và quản lý nội dung cho các kênh marketing</p>
                    
                    <%-- Hiển thị thông báo lỗi/thành công --%>
                    <c:if test="${not empty error}">
                        <div style="background-color: #fee; color: #c53030; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #feb2b2;">
                            ❌ ${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div style="background-color: #f0fff4; color: #2f855a; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #9ae6b4;">
                            ✅ ${success}
                        </div>
                    </c:if>
                    <c:if test="${not empty fixMessage}">
                        <div style="background-color: #e6f3ff; color: #1e40af; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #93c5fd;">
                            🔧 ${fixMessage}
                        </div>
                    </c:if>
                </div>

                <%-- Các thẻ thống kê (Stats grid) - Giữ nguyên không thay đổi --%>
                <div class="stats-grid fade-in">
                    <div class="stat-card">
                        <div class="stat-number">${totalContents}</div>
                        <div class="stat-label">Bài viết đã đăng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${totalDrafts}</div>
                        <div class="stat-label">Bản nháp</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${totalArc}</div>
                        <div class="stat-label">Đã ẩn đi</div>
                    </div>
<!--                    <div class="stat-card">
                        <div class="stat-number">3.2K</div>
                        <div class="stat-label">Lượt xem</div>
                    </div>-->
                </div>

                <%-- Các card chức năng (Marketing grid) - Giữ nguyên không thay đổi --%>
                <div class="marketing-grid fade-in">
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon content-icon">✍️</div>
                            <h3 class="card-title">Tạo bài viết mới</h3>
                        </div>
                        <p class="card-description">Viết và xuất bản bài viết blog, tin tức hoặc nội dung marketing cho website và social media.</p>
                        <button onclick="showCreatePostModal()" class="btn btn-primary">Tạo bài viết</button>
                    </div>
                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon analytics-icon">📅</div>
                            <h3 class="card-title">Lịch đăng bài</h3>
                        </div>
                        <p class="card-description">Lên lịch đăng bài tự động cho các kênh marketing. Quản lý timeline nội dung hiệu quả.</p>
                        <button onclick="showCalendar()" class="btn btn-info">Xem lịch</button>
                    </div>
<!--                    <div class="marketing-card">
                        <div class="card-header">
                            <div class="card-icon social-icon">🎨</div>
                            <h3 class="card-title">Thư viện Media</h3>
                        </div>
                        <p class="card-description">Quản lý hình ảnh, video và tài liệu marketing. Upload và tổ chức media files.</p>
                        <button onclick="showMediaLibrary()" class="btn btn-success">Mở thư viện</button>
                    </div>-->
                </div>

                <%-- **BƯỚC 1: CHỈNH SỬA BẢNG** --%>
                <div class="table-container fade-in">
                    <div class="top-bar">
                        <h1>Nội dung gần đây</h1>
                        <div class="chart-filters">
                            <button class="filter-btn active" onclick="filterContent('all')">Tất cả</button>
                            <button class="filter-btn" onclick="filterContent('published')">Đã đăng</button>
                            <button class="filter-btn" onclick="filterContent('draft')">Bản nháp</button>
                            <button class="filter-btn" onclick="filterContent('pending')">Chờ duyệt</button>
                        </div>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Tiêu đề</th>
                                <th>Loại</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Lượt xem</th>
                                <%-- Đã xóa cột Thao tác --%>
                            </tr>
                        </thead>
                        <tbody id="contentTableBody">
                            <c:choose>
                                <c:when test="${not empty contentList}">
                                    <c:forEach items="${contentList}" var="content">
                                        <%-- Thêm class "clickable-row" và data-content-id vào thẻ tr --%>
                                        <tr class="clickable-row" data-content-id="${content.contentID}" onclick="handleRowClick(this)" onkeydown="handleRowKeyDown(event, this)" tabindex="0" role="button" aria-label="Chỉnh sửa nội dung: ${content.title}">
                                            <td>
                                                <a href="${pageContext.request.contextPath}/Staff/ContentDetail?id=${content.contentID}" 
                                                   style="color: #3182ce; text-decoration: none; font-weight: 600;"
                                                   onmouseover="this.style.textDecoration='underline'"
                                                   onmouseout="this.style.textDecoration='none'">
                                                    ${content.title}
                                                </a>
                                            </td>
                                            <td><span style="padding: 4px 12px; background: #edf2f7; border-radius: 20px; font-size: 0.85rem;">${content.platform}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${content.status == 'Published'}"><span style="padding: 4px 12px; background: rgba(72, 187, 120, 0.2); color: #48bb78; border-radius: 20px; font-size: 0.85rem;">✓ Đã đăng</span></c:when>
                                                    <c:when test="${content.status == 'Draft'}"><span style="padding: 4px 12px; background: rgba(237, 137, 54, 0.2); color: #ed8936; border-radius: 20px; font-size: 0.85rem;">⏳ Bản nháp</span></c:when>
                                                    <c:when test="${content.status == 'Archived'}"><span style="padding: 4px 12px; background: rgba(159, 122, 234, 0.2); color: #9f7aea; border-radius: 20px; font-size: 0.85rem;">📦 Lưu trữ</span></c:when>
                                                    <c:otherwise><span style="padding: 4px 12px; background: rgba(159, 122, 234, 0.2); color: #9f7aea; border-radius: 20px; font-size: 0.85rem;">⏰ Chờ duyệt</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty content.postDate}"><fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy HH:mm"/></c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-weight: 600;">-</td>
                                            <%-- Đã xóa <td> chứa nút Sửa/Xóa --%>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 40px; color: #666;">
                                            <div style="font-size: 48px; margin-bottom: 16px;">📝</div>
                                            <div>Chưa có nội dung nào</div>
                                            <div style="font-size: 0.9rem; margin-top: 8px;">Hãy tạo bài viết đầu tiên của bạn!</div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- Modal "Tạo bài viết mới" - Giữ nguyên không thay đổi --%>
        <div class="modal-overlay" id="createPostModal" onclick="closeModalOnOverlay(event)">
            <div class="create-content-modal">
                <div class="modal-header">
                    <h2 class="modal-title">✏️ Tạo nội dung mới</h2>
                    <button class="modal-close" onclick="closeCreatePostModal()">✕</button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/Staff/CreateContent" method="POST" onsubmit="return validateForm()">
                        <div class="form-group">
                            <label for="campaignID">Chiến dịch <span class="required">*</span></label>
                            <select id="campaignID" name="campaignID" class="form-select" required>
                                <option value="">-- Chọn chiến dịch --</option>
                                <c:choose>
                                    <c:when test="${not empty campaigns}">
                                        <c:forEach items="${campaigns}" var="campaign">
                                            <option value="${campaign.campaignID}">${campaign.campaignName} (${campaign.platform})</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="" disabled>Không có chiến dịch nào đang chạy</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                            <c:if test="${empty campaigns}">
                                <small style="color: #e53e3e; margin-top: 5px; display: block;">
                                    ⚠️ Không có chiến dịch nào đang chạy. Vui lòng tạo chiến dịch trước khi tạo nội dung.
                                </small>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <label for="postTitle">Tiêu đề <span class="required">*</span></label>
                            <input type="text" id="postTitle" name="title" class="form-input" placeholder="Nhập tiêu đề nội dung..." required maxlength="255">
                        </div>
                        <div class="form-group">
                            <label for="contentText">Nội dung</label>
                            <textarea id="contentText" name="contentText" class="form-textarea content-editor" placeholder="Viết nội dung chi tiết..." rows="6"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="mediaURL">URL Media</label>
                            <input type="url" id="mediaURL" name="mediaURL" class="form-input" placeholder="https://example.com/image.jpg">
                        </div>
                        <div class="form-group">
                            <label for="platform">Nền tảng <span class="required">*</span></label>
                            <select id="platform" name="platform" class="form-select" required>
                                <option value="">-- Chọn nền tảng --</option>
                                <option value="Facebook">📘 Facebook</option>
                                <option value="Instagram">📷 Instagram</option>
                                <option value="LinkedIn">💼 LinkedIn</option>
                                <option value="Twitter">🐦 Twitter</option>
                                <option value="TikTok">🎵 TikTok</option>
                                <option value="Website">🌐 Website</option>
                                <option value="Email">📧 Email</option>
                                <option value="Other">📱 Khác</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="postDate">Ngày đăng</label>
                                <input type="datetime-local" id="postDate" name="postDate" class="form-input">
                            </div>
                            <div class="form-group">
                                <label for="status">Trạng thái <span class="required">*</span></label>
                                <select id="status" name="status" class="form-select" required>
                                    <option value="Draft">📝 Bản nháp</option>
                                    <option value="Published">✅ Đã xuất bản</option>
                                    <option value="Archived">📦 Lưu trữ</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-secondary" onclick="closeCreatePostModal()">Hủy</button>
                            <button type="submit" class="btn-submit">Tạo nội dung</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <%-- **BƯỚC 1.2: THÊM MODAL CHỈNH SỬA** --%>
        <div class="modal-overlay" id="editContentModal">
            <div class="create-content-modal">
                <div class="modal-header">
                    <h2 class="modal-title">⚙️ Chỉnh sửa nội dung</h2>
                    <button class="modal-close" onclick="closeEditModal()">✕</button>
                </div>
                <div class="modal-body">
                    <form id="editContentForm">
                        <input type="hidden" id="editContentId" name="contentID">
                        <div class="form-group">
                            <label for="editCampaignID">Chiến dịch</label>
                            <select id="editCampaignID" name="campaignID" class="form-select" required>
                                <option value="">-- Chọn chiến dịch --</option>
                                <c:choose>
                                    <c:when test="${not empty campaigns}">
                                        <c:forEach items="${campaigns}" var="campaign">
                                            <option value="${campaign.campaignID}">${campaign.campaignName} (${campaign.platform})</option>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="" disabled>Không có chiến dịch nào đang chạy</option>
                                    </c:otherwise>
                                </c:choose>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editTitle">Tiêu đề</label>
                            <input type="text" id="editTitle" name="title" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label for="editContentText">Nội dung</label>
                            <textarea id="editContentText" name="contentText" class="form-textarea" rows="6"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="editMediaURL">URL Media</label>
                            <input type="url" id="editMediaURL" name="mediaURL" class="form-input">
                        </div>
                        <div class="form-group">
                            <label for="editPlatform">Nền tảng</label>
                            <select id="editPlatform" name="platform" class="form-select" required>
                                <option value="Facebook">📘 Facebook</option>
                                <option value="Instagram">📷 Instagram</option>
                                <option value="LinkedIn">💼 LinkedIn</option>
                                <option value="Twitter">🐦 Twitter</option>
                                <option value="TikTok">🎵 TikTok</option>
                                <option value="Website">🌐 Website</option>
                                <option value="Email">📧 Email</option>
                                <option value="Other">📱 Khác</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="editPostDate">Ngày đăng</label>
                                <input type="datetime-local" id="editPostDate" name="postDate" class="form-input">
                            </div>
                            <div class="form-group">
                                <label for="editStatus">Trạng thái</label>
                                <select id="editStatus" name="status" class="form-select" required>
                                    <option value="Draft">📝 Bản nháp</option>
                                    <option value="Published">✅ Đã xuất bản</option>
                                    <option value="Pending">⏰ Chờ duyệt</option>
                                    <option value="Archived">📦 Lưu trữ</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-actions" style="justify-content: space-between;">
                            <button type="button" class="btn-danger" id="deleteContentBtn">🗑️ Xóa</button>
                            <div>
                                <button type="button" class="btn-secondary" onclick="closeEditModal()">Hủy</button>
                                <button type="button" class="btn-submit" id="saveContentBtn">Lưu thay đổi</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <script>
            // ===== SIDEBAR FUNCTIONS =====
            function toggleSidebar() {
                document.getElementById('unifiedSidebar').classList.toggle('sidebar-open');
            }

            // ===== CREATE MODAL FUNCTIONS =====
            function showCreatePostModal() {
                document.getElementById('createPostModal').classList.add('active');
                document.body.style.overflow = 'hidden';
                document.getElementById('postTitle').focus();
            }

            function closeCreatePostModal() {
                document.getElementById('createPostModal').classList.remove('active');
                document.body.style.overflow = 'auto';
            }

            function closeModalOnOverlay(event) {
                if (event.target.id === 'createPostModal') {
                    closeCreatePostModal();
                }
            }

            // Simple form validation - only basic checks
            function validateForm() {
                const campaignSelect = document.getElementById('campaignID');
                const title = document.getElementById('postTitle').value.trim();
                const platform = document.getElementById('platform').value;
                
                if (!campaignSelect.value || campaignSelect.value.trim() === '') {
                    alert('❌ Vui lòng chọn chiến dịch!');
                    campaignSelect.focus();
                    return false;
                }
                
                if (!title || title.length === 0) {
                    alert('❌ Vui lòng nhập tiêu đề!');
                    document.getElementById('postTitle').focus();
                    return false;
                }
                
                if (!platform || platform.trim() === '') {
                    alert('❌ Vui lòng chọn nền tảng!');
                    document.getElementById('platform').focus();
                    return false;
                }
                
                return true;
            }

            // ===== EDIT MODAL FUNCTIONS =====
            function showEditModal() {
                document.getElementById('editContentModal').classList.add('active');
                document.body.style.overflow = 'hidden';
            }

            function closeEditModal() {
                document.getElementById('editContentModal').classList.remove('active');
                document.body.style.overflow = 'auto';
            }

            // ===== ROW CLICK HANDLER =====
            function handleRowClick(row) {
                handleRowAction(row);
            }

            // ===== ROW KEYBOARD HANDLER =====
            function handleRowKeyDown(event, row) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    handleRowAction(row);
                }
            }

            // ===== COMMON ROW ACTION HANDLER =====
            function handleRowAction(row) {
                const contentId = row.dataset.contentId;
                
                // Validate contentId before making request
                if (!contentId || isNaN(contentId) || contentId.trim() === '') {
                    alert('ID nội dung không hợp lệ.');
                    return;
                }
                
                // Navigate directly to ContentDetail page instead of calling API
                window.location.href = `${pageContext.request.contextPath}/Staff/ContentDetail?id=${contentId}`;
            }

            // Simple event listeners
            document.addEventListener('DOMContentLoaded', () => {
                // Basic functionality only
            });


            // ===== CÁC HÀM CŨ KHÁC - GIỮ NGUYÊN =====
            function showCalendar() {
                alert('Lịch đăng bài đang được phát triển!');
            }

            function showMediaLibrary() {
                alert('Thư viện Media đang được phát triển!');
            }

            function filterContent(type) {
                document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
                event.target.classList.add('active');
                const rows = document.querySelectorAll('#contentTableBody tr');

                if (type === 'all') {
                    rows.forEach(row => row.style.display = '');
                } else {
                    rows.forEach(row => {
                        const statusCell = row.querySelector('td:nth-child(3)');
                        if (statusCell) {
                            const statusText = statusCell.textContent.toLowerCase();
                            let shouldShow = false;
                            if (type === 'published' && statusText.includes('đã đăng')) shouldShow = true;
                            else if (type === 'draft' && statusText.includes('bản nháp')) shouldShow = true;
                            else if (type === 'pending' && statusText.includes('chờ duyệt')) shouldShow = true;
                            row.style.display = shouldShow ? '' : 'none';
                        }
                    });
                }
            }

            // ===== KEYBOARD SHORTCUTS =====
            document.addEventListener('keydown', function (event) {
                const createModal = document.getElementById('createPostModal');
                const editModal = document.getElementById('editContentModal');

                if (event.key === 'Escape') {
                    if (createModal.classList.contains('active')) closeCreatePostModal();
                    if (editModal.classList.contains('active')) closeEditModal();
                }

                if ((event.ctrlKey || event.metaKey) && event.key === 'Enter' && createModal.classList.contains('active')) {
                    const submitBtn = document.getElementById('submitBtn');
                    if (!submitBtn.disabled) submitPost(event);
                }
            });

            // ===== INTERSECTION OBSERVER FOR FADE-IN ANIMATION =====
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

            // ===== MOBILE RESPONSIVE =====
            window.addEventListener('resize', function () {
                if (window.innerWidth > 768) {
                    document.getElementById('unifiedSidebar').classList.remove('sidebar-open');
                }
            });
        </script>
    </body>
</html>