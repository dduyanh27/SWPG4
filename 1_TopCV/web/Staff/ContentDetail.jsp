<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.MarketingContent, model.Campaign, model.Admin, model.Role" %>

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
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>📄 Chi tiết nội dung - JOBs</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Staff/marketing-dashboard.css">

        <style>
            .content-detail-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 20px;
            }

            .content-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .content-title {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 15px;
                line-height: 1.2;
            }

            .content-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 20px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 8px;
                background: rgba(255,255,255,0.1);
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.9rem;
            }

            .content-status {
                display: inline-block;
                padding: 6px 16px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-published {
                background: rgba(72, 187, 120, 0.2);
                color: #48bb78;
                border: 1px solid rgba(72, 187, 120, 0.3);
            }

            .status-draft {
                background: rgba(237, 137, 54, 0.2);
                color: #ed8936;
                border: 1px solid rgba(237, 137, 54, 0.3);
            }

            .status-archived {
                background: rgba(159, 122, 234, 0.2);
                color: #9f7aea;
                border: 1px solid rgba(159, 122, 234, 0.3);
            }

            .content-body {
                background: white;
                border-radius: 15px;
                padding: 40px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                margin-bottom: 30px;
            }

            .content-text {
                font-size: 1.1rem;
                line-height: 1.8;
                color: #2d3748;
                margin-bottom: 30px;
                white-space: pre-wrap;
            }

            .media-section {
                margin: 30px 0;
                text-align: center;
            }

            .media-image {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .campaign-info {
                background: #f7fafc;
                border-radius: 10px;
                padding: 25px;
                margin-bottom: 30px;
            }

            .campaign-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .campaign-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
            }

            .campaign-detail-item {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .campaign-detail-label {
                font-size: 0.85rem;
                color: #718096;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .campaign-detail-value {
                font-size: 1rem;
                color: #2d3748;
                font-weight: 600;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }

            .btn {
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s ease;
                border: none;
                cursor: pointer;
                font-size: 0.95rem;
            }

            .btn-primary {
                background: #3182ce;
                color: white;
            }

            .btn-primary:hover {
                background: #2c5aa0;
                transform: translateY(-2px);
            }

            .btn-secondary {
                background: #e2e8f0;
                color: #4a5568;
            }

            .btn-secondary:hover {
                background: #cbd5e0;
                transform: translateY(-2px);
            }

            .btn-danger {
                background: #e53e3e;
                color: white;
            }

            .btn-danger:hover {
                background: #c53030;
                transform: translateY(-2px);
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #3182ce;
                text-decoration: none;
                font-weight: 500;
                margin-bottom: 20px;
                transition: color 0.2s ease;
            }

            .back-link:hover {
                color: #2c5aa0;
            }

            /* Edit Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            }

            .modal-content {
                background-color: white;
                margin: 5% auto;
                padding: 0;
                border-radius: 15px;
                width: 90%;
                max-width: 800px;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                animation: modalSlideIn 0.3s ease-out;
            }

            @keyframes modalSlideIn {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px 30px;
                border-radius: 15px 15px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .modal-title {
                font-size: 1.5rem;
                font-weight: 600;
                margin: 0;
            }

            .close {
                color: white;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                transition: opacity 0.2s ease;
            }

            .close:hover {
                opacity: 0.7;
            }

            .modal-body {
                padding: 30px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2d3748;
                font-size: 0.9rem;
            }

            .form-label.required::after {
                content: " *";
                color: #e53e3e;
            }

            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 1rem;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
                box-sizing: border-box;
            }

            .form-control:focus {
                outline: none;
                border-color: #3182ce;
                box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
            }

            .form-control.textarea {
                min-height: 120px;
                resize: vertical;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .modal-footer {
                padding: 20px 30px;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                background: #f7fafc;
                border-radius: 0 0 15px 15px;
            }

            .btn-success {
                background: #48bb78;
                color: white;
            }

            .btn-success:hover {
                background: #38a169;
                transform: translateY(-2px);
            }

            @media (max-width: 768px) {
                .content-detail-container {
                    padding: 15px;
                }

                .content-title {
                    font-size: 2rem;
                }

                .content-meta {
                    flex-direction: column;
                    gap: 10px;
                }

                .content-body {
                    padding: 25px;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .modal-content {
                    width: 95%;
                    margin: 2% auto;
                }

                .modal-body {
                    padding: 20px;
                }

                .form-row {
                    grid-template-columns: 1fr;
                }

                .modal-footer {
                    padding: 15px 20px;
                    flex-direction: column;
                }
            }
        </style>
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
                <a href="${pageContext.request.contextPath}/Staff/campaign.jsp" class="nav-item">🎯 Chiến dịch Marketing</a>
                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="nav-item active">📝 Quản lý nội dung</a>
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
                <div class="content-detail-container">
                    <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="back-link">
                        ← Quay lại danh sách nội dung
                    </a>

                    <!-- Display error/success messages only when content is not available -->
                    <c:if test="${empty content and not empty error}">
                        <div style="background: #fed7d7; color: #c53030; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #e53e3e;">
                            <strong>⚠️ Lỗi:</strong> ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div style="background: #c6f6d5; color: #2f855a; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #48bb78;">
                            <strong>✅ Thành công:</strong> ${success}
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty content}">
                            <!-- Content Header -->
                            <div class="content-header">
                                <h1 class="content-title">${content.title}</h1>

                                <div class="content-meta">
                                    <div class="meta-item">
                                        <span>📅</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${not empty content.postDate}">
                                                    <fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>Chưa đặt ngày</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="meta-item">
                                        <span>🌐</span>
                                        <span>${content.platform}</span>
                                    </div>
                                    <div class="meta-item">
                                        <span>👤</span>
                                        <span>${content.creatorName}</span>
                                    </div>
                                    <div class="meta-item">
                                        <span>🎯</span>
                                        <span>${content.campaignName}</span>
                                    </div>
                                </div>

                                <div>
                                    <c:choose>
                                        <c:when test="${content.status == 'Published'}">
                                            <span class="content-status status-published">✅ Đã xuất bản</span>
                                        </c:when>
                                        <c:when test="${content.status == 'Draft'}">
                                            <span class="content-status status-draft">📝 Bản nháp</span>
                                        </c:when>
                                        <c:when test="${content.status == 'Archived'}">
                                            <span class="content-status status-archived">📦 Lưu trữ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="content-status status-draft">⏰ Chờ duyệt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Content Body -->
                            <div class="content-body">
                                <c:if test="${not empty content.contentText}">
                                    <div class="content-text">${content.contentText}</div>
                                </c:if>

                                <c:if test="${not empty content.mediaURL}">
                                    <div class="media-section">
                                        <img src="${content.mediaURL}" alt="Media content" class="media-image" 
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" 
                                             onclick="window.open(this.src, '_blank');" style="cursor: pointer;">
                                        <div style="display: none; padding: 20px; background: #f7fafc; border-radius: 8px; color: #718096;">
                                            <p>🔗 <a href="${content.mediaURL}" target="_blank">Xem media tại đây</a></p>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Campaign Information -->
                            <c:if test="${not empty campaign}">
                                <div class="campaign-info">
                                    <h3 class="campaign-title">
                                        🎯 Thông tin chiến dịch
                                    </h3>
                                    <div class="campaign-details">
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Tên chiến dịch</span>
                                            <span class="campaign-detail-value">${campaign.campaignName}</span>
                                        </div>
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Nền tảng</span>
                                            <span class="campaign-detail-value">${campaign.platform}</span>
                                        </div>
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Loại đối tượng</span>
                                            <span class="campaign-detail-value">${campaign.targetType}</span>
                                        </div>
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Ngân sách</span>
                                            <span class="campaign-detail-value">
                                                <fmt:formatNumber value="${campaign.budget}" type="currency" currencyCode="VND"/>
                                            </span>
                                        </div>
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Ngày bắt đầu</span>
                                            <span class="campaign-detail-value">
                                                <fmt:formatDate value="${campaign.startDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                        <div class="campaign-detail-item">
                                            <span class="campaign-detail-label">Ngày kết thúc</span>
                                            <span class="campaign-detail-value">
                                                <fmt:formatDate value="${campaign.endDate}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                    </div>
                                    <c:if test="${not empty campaign.description}">
                                        <div style="margin-top: 15px;">
                                            <span class="campaign-detail-label">Mô tả</span>
                                            <p style="margin-top: 5px; color: #4a5568; line-height: 1.6;">${campaign.description}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="btn btn-secondary">
                                    ← Quay lại
                                </a>
                                <button onclick="openEditModal()" class="btn btn-primary">
                                    ✏️ Chỉnh sửa
                                </button>
                                <c:if test="${content.status != 'Published'}">
                                    <a href="${pageContext.request.contextPath}/Staff/PublishContent?id=${content.contentID}" 
                                       class="btn btn-success"
                                       onclick="return confirm('Bạn có chắc muốn xuất bản nội dung này không?');">
                                        📢 Xuất bản
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/Staff/DeleteContent?id=${content.contentID}" 
                                   class="btn btn-danger"
                                   onclick="return confirmDelete()">
                                    🗑️ Xóa
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 60px 20px;">
                                <div style="font-size: 4rem; margin-bottom: 20px;">📄</div>
                                <h2 style="color: #4a5568; margin-bottom: 10px;">Không tìm thấy nội dung</h2>
                                <p style="color: #718096; margin-bottom: 30px;">Nội dung bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="btn btn-primary">
                                    ← Quay lại danh sách
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Edit Content Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">✏️ Chỉnh sửa nội dung</h2>
                    <span class="close" onclick="closeEditModal()">&times;</span>
                </div>
                <form id="editForm" method="POST" action="${pageContext.request.contextPath}/Staff/UpdateContent" onsubmit="return validateEditForm()">
                    <div class="modal-body">
                        <input type="hidden" name="contentID" id="editContentID" value="${content.contentID}">
                        <input type="hidden" name="campaignID" value="${content.campaignID}">
                        
                        <div class="form-group">
                            <label for="editTitle" class="form-label required">Tiêu đề</label>
                            <input type="text" id="editTitle" name="title" class="form-control" 
                                   value="${content.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="editContentText" class="form-label">Nội dung</label>
                            <textarea id="editContentText" name="contentText" class="form-control textarea">${content.contentText}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="editMediaURL" class="form-label">URL Media</label>
                            <input type="url" id="editMediaURL" name="mediaURL" class="form-control" 
                                   value="${content.mediaURL}" placeholder="https://example.com/image.jpg">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="editPlatform" class="form-label required">Nền tảng</label>
                                <select id="editPlatform" name="platform" class="form-control" required>
                                    <option value="">Chọn nền tảng</option>
                                    <option value="Facebook" ${content.platform == 'Facebook' ? 'selected' : ''}>Facebook</option>
                                    <option value="Instagram" ${content.platform == 'Instagram' ? 'selected' : ''}>Instagram</option>
                                    <option value="Twitter" ${content.platform == 'Twitter' ? 'selected' : ''}>Twitter</option>
                                    <option value="LinkedIn" ${content.platform == 'LinkedIn' ? 'selected' : ''}>LinkedIn</option>
                                    <option value="TikTok" ${content.platform == 'TikTok' ? 'selected' : ''}>TikTok</option>
                                    <option value="YouTube" ${content.platform == 'YouTube' ? 'selected' : ''}>YouTube</option>
                                    <option value="Website" ${content.platform == 'Website' ? 'selected' : ''}>Website</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="editStatus" class="form-label">Trạng thái</label>
                                <select id="editStatus" name="status" class="form-control">
                                    <option value="Draft" ${content.status == 'Draft' ? 'selected' : ''}>📝 Bản nháp</option>
                                    <option value="Published" ${content.status == 'Published' ? 'selected' : ''}>✅ Đã xuất bản</option>
                                    <option value="Archived" ${content.status == 'Archived' ? 'selected' : ''}>📦 Lưu trữ</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="editPostDate" class="form-label">Ngày đăng</label>
                            <input type="datetime-local" id="editPostDate" name="postDate" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="closeEditModal()">Hủy</button>
                        <button type="submit" class="btn btn-success">💾 Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                document.getElementById('unifiedSidebar').classList.toggle('sidebar-open');
            }

            // Mobile responsive
            window.addEventListener('resize', function () {
                if (window.innerWidth > 768) {
                    document.getElementById('unifiedSidebar').classList.remove('sidebar-open');
                }
            });

            // Function to handle delete confirmation
            function confirmDelete() {
                var result = confirm('Bạn có chắc chắn muốn xóa nội dung này không?');
                if (result) {
                    // User clicked OK - proceed with deletion
                    return true;
                } else {
                    // User clicked Cancel - prevent deletion
                    return false;
                }
            }

            // Modal functions
            function openEditModal() {
                document.getElementById('editModal').style.display = 'block';
                document.body.style.overflow = 'hidden'; // Prevent background scrolling
                
                // Set the post date value if it exists
                <c:if test="${not empty content.postDate}">
                    var postDate = '<fmt:formatDate value="${content.postDate}" pattern="yyyy-MM-dd\'T\'HH:mm"/>';
                    document.getElementById('editPostDate').value = postDate;
                </c:if>
            }

            function closeEditModal() {
                document.getElementById('editModal').style.display = 'none';
                document.body.style.overflow = 'auto'; // Restore scrolling
            }

            // Close modal when clicking outside of it
            window.onclick = function(event) {
                var modal = document.getElementById('editModal');
                if (event.target == modal) {
                    closeEditModal();
                }
            }

            // Close modal with Escape key
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    closeEditModal();
                }
            });

            // Form validation function
            function validateEditForm() {
                var title = document.getElementById('editTitle').value.trim();
                var platform = document.getElementById('editPlatform').value;
                
                if (!title) {
                    alert('Vui lòng nhập tiêu đề!');
                    return false;
                }
                
                if (!platform) {
                    alert('Vui lòng chọn nền tảng!');
                    return false;
                }
                
                console.log('Form validation passed, submitting...');
                return true;
            }

            // Auto-hide messages after 5 seconds
            document.addEventListener('DOMContentLoaded', function () {
                try {
                    // Use more specific selectors to avoid errors
                    var errorMessages = document.querySelectorAll('div[style*="background: #fed7d7"]');
                    var successMessages = document.querySelectorAll('div[style*="background: #c6f6d5"]');

                    // Convert NodeList to Array safely
                    var messages = [];
                    for (var i = 0; i < errorMessages.length; i++) {
                        messages.push(errorMessages[i]);
                    }
                    for (var i = 0; i < successMessages.length; i++) {
                        messages.push(successMessages[i]);
                    }

                    messages.forEach(function (message) {
                        if (message && message.style) {
                            setTimeout(function () {
                                message.style.transition = 'opacity 0.5s ease';
                                message.style.opacity = '0';
                                setTimeout(function () {
                                    message.style.display = 'none';
                                }, 500);
                            }, 5000);
                        }
                    });
                } catch (e) {
                    console.log('Auto-hide messages error:', e);
                }
            });
        </script>
    </body>
</html>
