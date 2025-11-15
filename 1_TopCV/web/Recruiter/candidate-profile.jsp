<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="model.JobSeeker" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm kiếm ứng viên - RecruitPro</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Candidate Search Profile Specific Styles */
            .candidate-search-page {
                background-color: #f5f7fa;
                min-height: 100vh;
            }

            .candidate-search-container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
                display: block;
            }

            /* Main Profile Section */
            .profile-main {
                background: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 100%;
                margin: 0 auto;
            }

            .profile-header {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 30px;
            }

            .profile-avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 32px;
                font-weight: bold;
            }

            .profile-info h1 {
                font-size: 28px;
                color: #333;
                margin-bottom: 8px;
                font-weight: 600;
            }

            .profile-title {
                color: #666;
                font-size: 16px;
                margin-bottom: 4px;
            }

            .profile-location {
                color: #888;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 5px;
                margin-bottom: 4px;
            }

            .profile-update {
                color: #999;
                font-size: 12px;
            }

            .profile-actions {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                flex-wrap: nowrap;
                align-items: center;
                flex-direction: row;
            }

            .btn-view-contact {
                background: #ff6b35;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
                flex-shrink: 0;
            }

            .btn-view-contact:hover {
                background: #e55a2b;
                transform: translateY(-2px);
            }

            .btn-send-invitation {
                background: white;
                color: #ff6b35;
                border: 2px solid #ff6b35;
                padding: 10px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
                position: relative;
                flex-shrink: 0;
            }

            .btn-send-invitation:hover {
                background: #ff6b35;
                color: white;
                transform: translateY(-2px);
            }

            .btn-send-invitation::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 0;
                height: 0;
                border-left: 8px solid transparent;
                border-right: 8px solid transparent;
                border-top: 8px solid #ff6b35;
            }

            .btn-send-invitation::before {
                content: '';
                position: absolute;
                bottom: -12px;
                left: 50%;
                transform: translateX(-50%);
                width: 0;
                height: 0;
                border-left: 10px solid transparent;
                border-right: 10px solid transparent;
                border-top: 10px solid #ff6b35;
            }

            /* Accept and Reject Button Styles */
            .btn-accept-action {
                background: #4caf50 !important;
                color: white !important;
                border: none !important;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-accept-action:hover {
                background: #45a049 !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
            }

            .btn-reject-action {
                background: #f44336 !important;
                color: white !important;
                border: none !important;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-reject-action:hover {
                background: #da190b !important;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(244, 67, 54, 0.3);
            }


            .action-icon {
                width: 40px;
                height: 40px;
                border: 1px solid #ddd;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                color: #666;
                flex-shrink: 0;
            }

            .action-icon:hover {
                background: #f8f9fa;
                color: #ff6b35;
            }

            .action-icon.active {
                background: #ff6b35;
                color: white;
            }

            .points-info {
                background: #fff3e0;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 30px;
                border-left: 4px solid #ff6b35;
            }

            .points-info p {
                color: #ff6b35;
                font-weight: 600;
                margin: 0;
            }

            /* Profile Details Section */
            .profile-details h2 {
                font-size: 20px;
                color: #333;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .details-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }

            .detail-item {
                display: flex;
                flex-direction: column;
                padding: 15px;
                border: 1px solid #f0f0f0;
                border-radius: 8px;
                background: #fafafa;
                gap: 8px;
                transition: all 0.2s ease;
            }

            .detail-item:hover {
                background: #f5f5f5;
                border-color: #e0e0e0;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }

            .detail-label {
                color: #666;
                font-weight: 500;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .detail-value {
                color: #333;
                font-weight: 400;
                font-size: 15px;
                word-wrap: break-word;
                word-break: break-word;
                overflow-wrap: break-word;
                line-height: 1.5;
            }

            /* Matching Candidates Sidebar */
            .matching-candidates {
                background: white;
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: fit-content;
            }

            .matching-candidates h3 {
                font-size: 18px;
                color: #333;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .candidate-card {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 15px;
                border: 1px solid #f0f0f0;
                border-radius: 8px;
                margin-bottom: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .candidate-card:hover {
                border-color: #ff6b35;
                box-shadow: 0 2px 8px rgba(255, 107, 53, 0.1);
            }

            .candidate-avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 18px;
                font-weight: bold;
            }

            .candidate-info h4 {
                font-size: 14px;
                color: #333;
                margin-bottom: 4px;
                font-weight: 600;
            }

            .candidate-info p {
                font-size: 12px;
                color: #666;
                margin: 0;
            }

            /* Chat Button */
            .chat-button {
                position: fixed;
                bottom: 30px;
                right: 30px;
                background: #031428;
                color: white;
                padding: 15px 20px;
                border-radius: 25px;
                display: flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                transition: all 0.3s ease;
                z-index: 1000;
            }

            .chat-button:hover {
                background: #062446;
                transform: translateY(-2px);
            }

            .chat-button i {
                font-size: 18px;
            }

            .chat-button span {
                font-weight: 600;
            }

            /* Three dots button */
            .three-dots-button {
                position: fixed;
                bottom: 100px;
                right: 30px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: white;
                border: 1px solid #ddd;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                z-index: 1000;
            }

            .three-dots-button:hover {
                background: #f8f9fa;
                transform: translateY(-2px);
            }

            .three-dots-button i {
                color: #666;
                font-size: 18px;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 2000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
            }

            .modal-content {
                background-color: white;
                margin: 5% auto;
                padding: 0;
                border-radius: 12px;
                width: 90%;
                max-width: 800px;
                max-height: 90vh;
                overflow-y: auto;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px 30px;
                border-bottom: 1px solid #e5e7eb;
            }

            .modal-title {
                font-size: 20px;
                font-weight: 600;
                color: #333;
                margin: 0;
            }

            .modal-close {
                background: none;
                border: none;
                font-size: 24px;
                color: #666;
                cursor: pointer;
                padding: 0;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-close:hover {
                color: #333;
            }

            .modal-body {
                padding: 30px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .form-label.required::after {
                content: " *";
                color: #ef4444;
            }

            .form-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }

            .form-input:focus {
                outline: none;
                border-color: #ff6b35;
            }

            .form-select {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #d1d5db;
                border-radius: 8px;
                font-size: 14px;
                background-color: white;
                cursor: pointer;
            }

            .form-select:focus {
                outline: none;
                border-color: #ff6b35;
            }

            .form-textarea {
                width: 100%;
                min-height: 300px;
                padding: 16px;
                border: 1px solid #d1d5db;
                border-top: none;
                border-radius: 0 0 8px 8px;
                font-size: 14px;
                font-family: inherit;
                resize: vertical;
            }

            .form-textarea:focus {
                outline: none;
                border-color: #ff6b35;
            }

            .rich-text-toolbar {
                display: flex;
                gap: 8px;
                padding: 8px;
                background: #f8f9fa;
                border: 1px solid #d1d5db;
                border-bottom: none;
                border-radius: 8px 8px 0 0;
            }

            .toolbar-btn {
                background: none;
                border: none;
                padding: 6px 8px;
                border-radius: 4px;
                cursor: pointer;
                color: #666;
                font-size: 14px;
                font-weight: bold;
            }

            .toolbar-btn:hover {
                background: #e9ecef;
                color: #333;
            }

            .toolbar-btn.active {
                background: #ff6b35;
                color: white;
            }

            .character-count {
                text-align: right;
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                padding: 20px 30px;
                border-top: 1px solid #e5e7eb;
                background: #f8f9fa;
                border-radius: 0 0 12px 12px;
            }

            .btn-cancel {
                background: white;
                color: #666;
                border: 1px solid #d1d5db;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
            }

            .btn-cancel:hover {
                background: #f8f9fa;
            }

            .btn-send {
                background: #ff6b35;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
            }

            .btn-send:hover {
                background: #e55a2b;
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .candidate-search-container {
                    max-width: 100%;
                    padding: 15px;
                }
            }

            @media (max-width: 768px) {
                .profile-header {
                    flex-direction: column;
                    text-align: center;
                }

                .profile-actions {
                    justify-content: center;
                    flex-wrap: wrap;
                }

                .details-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body class="candidate-search-page">
        <!-- Top Navigation Bar -->
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
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
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
                            <a href="#">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
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
                        <i class="fas fa-bell" style="position: relative;">
                            <span style="position: absolute; top: -5px; right: -5px; background: #ff4757; color: white; border-radius: 50%; width: 8px; height: 8px; font-size: 8px;"></span>
                        </i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="user-header">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-info">
                                        <div class="user-name">Nguyen Phuoc</div>
                                    </div>
                                    <i class="fas fa-times close-menu"></i>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Thành viên</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-users"></i>
                                        <span>Thành viên</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Quản lý tài khoản</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Recruiter/company-info.jsp" class="menu-item highlighted">
                                        <i class="fas fa-building"></i>
                                        <span>Thông tin công ty</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Quản lý quyền truy cập</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-tasks"></i>
                                        <span>Quản lý yêu cầu</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-history"></i>
                                        <span>Lịch sử hoạt động</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Liên hệ mua</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-phone"></i>
                                        <span>Liên hệ mua</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Hỏi đáp</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>Hỏi đáp</span>
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

        <!-- Main Content -->
        <div class="candidate-search-container">
            <!-- Main Profile Section -->
            <div class="profile-main">
                <!-- Profile Header -->
                <div class="profile-header">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty candidate.fullName}">
                                <c:set var="firstName" value="${candidate.fullName}" />
                                ${fn:substring(firstName, 0, 1)}
                            </c:when>
                            <c:otherwise>HT</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-info">
                        <h1><c:choose>
                                <c:when test="${not empty candidate.fullName}">${candidate.fullName}</c:when>
                                <c:otherwise>Hoàng Minh Tran</c:otherwise>
                            </c:choose></h1>
                        <div class="profile-title">
                            <c:choose>
                                <c:when test="${not empty candidate.headline}">${candidate.headline}</c:when>
                                <c:otherwise>Ruby Developer</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="profile-title">Full-time</div>
                        <div class="profile-location">
                            <i class="fas fa-map-marker-alt"></i>
                            <c:choose>
                                <c:when test="${not empty candidate.address}">
                                    <%
                                        model.JobSeeker candidateObj = (model.JobSeeker) request.getAttribute("candidate");
                                        String address = candidateObj != null ? candidateObj.getAddress() : null;
                                        if (address != null) {
                                            try {
                                                // Fix encoding: if string contains ? characters, try to fix
                                                if (address.contains("?")) {
                                                    byte[] bytes = address.getBytes("ISO-8859-1");
                                                    address = new String(bytes, java.nio.charset.StandardCharsets.UTF_8);
                                                }
                                            } catch (Exception e) {}
                                        }
                                        out.print(address != null ? address : "Đà Nẵng");
                                    %>
                                </c:when>
                                <c:otherwise>Đà Nẵng</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="profile-update">
                            <c:choose>
                                <c:when test="${not empty selectedCV and not empty selectedCV.creationDate}">
                                    Cập nhật gần nhất: <fmt:formatDate value="${selectedCV.creationDate}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>
                                    Cập nhật gần nhất: N/A
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <!-- ============================================ -->
                <!-- TRANG XEM THÔNG TIN ỨNG VIÊN ĐÃ ỨNG TUYỂN -->
                <!-- ============================================ -->
                <!-- Debug: applicationID=${applicationID}, applicationStatus='${applicationStatus}' -->
                <div class="profile-actions">
                    <c:set var="status" value="${fn:trim(applicationStatus)}" />
                    <c:choose>
                        <c:when test="${not empty status and (status eq 'Accepted' or status eq 'Chấp nhận')}">
                            <!-- Đã chấp nhận - Hiển thị status badge -->
                            <div style="display: inline-block; padding: 12px 24px; border-radius: 8px; background: #4caf50; color: white; font-size: 16px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fas fa-check-circle"></i>
                                Đã chấp nhận
                            </div>
                        </c:when>
                        <c:when test="${not empty status and (status eq 'Rejected' or status eq 'Từ chối')}">
                            <!-- Đã từ chối - Hiển thị status badge -->
                            <div style="display: inline-block; padding: 12px 24px; border-radius: 8px; background: #f44336; color: white; font-size: 16px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fas fa-times-circle"></i>
                                Đã từ chối
                            </div>
                        </c:when>
                        <c:when test="${not empty status and status ne 'Pending' and status ne 'Đang chờ'}">
                            <!-- Có status khác Accepted/Rejected/Pending - Hiển thị status hiện tại -->
                            <div style="display: inline-block; padding: 12px 24px; border-radius: 8px; background: #ff9800; color: white; font-size: 16px; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                <i class="fas fa-info-circle"></i>
                                Trạng thái: ${applicationStatus}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Pending hoặc chưa có status - Hiển thị buttons -->
                            <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;" 
                                  onsubmit="return confirm('Bạn có chắc chắn muốn chấp nhận ứng viên này?');">
                                <input type="hidden" name="action" value="accept">
                                <input type="hidden" name="applicationID" value="${applicationID}">
                                <input type="hidden" name="jobID" value="${jobID}">
                                <button type="submit" class="btn-accept-action" style="background: #4caf50; color: white; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-check"></i>
                                    Chấp nhận
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/candidate-management" method="POST" style="display: inline;"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn từ chối ứng viên này?');">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="applicationID" value="${applicationID}">
                                <input type="hidden" name="jobID" value="${jobID}">
                                <button type="submit" class="btn-reject-action" style="background: #f44336; color: white; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 600; cursor: pointer; display: inline-flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-times"></i>
                                    Từ chối
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                    <div class="action-icon">
                        <i class="fas fa-share-alt"></i>
                    </div>
                    <div class="action-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                </div>


                <!-- Profile Details -->
                <div class="profile-details">
                    <h2>Thông tin chung</h2>
                    <div class="details-grid">
                        <div class="detail-item">
                            <span class="detail-label">Vị trí hiện tại</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.headline}">${candidate.headline}</c:when>
                                    <c:otherwise>Ruby Developer</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">CV Tiêu đề</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty selectedCV and not empty selectedCV.cvTitle}">${selectedCV.cvTitle}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Số điện thoại</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.phone}">${candidate.phone}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Email</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.email}">${candidate.email}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Giới tính</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.gender}">${candidate.gender}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Thông tin liên hệ</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.contactInfo}">${candidate.contactInfo}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Địa chỉ</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.address}">
                                        <%
                                            model.JobSeeker candidateObj = (model.JobSeeker) request.getAttribute("candidate");
                                            String address = candidateObj != null ? candidateObj.getAddress() : null;
                                            if (address != null) {
                                                try {
                                                    // Fix encoding: if string contains ? characters, try to fix
                                                    if (address.contains("?")) {
                                                        byte[] bytes = address.getBytes("ISO-8859-1");
                                                        address = new String(bytes, java.nio.charset.StandardCharsets.UTF_8);
                                                    }
                                                } catch (Exception e) {}
                                            }
                                            out.print(address != null ? address : "Quận Hải Châu, Đà Nẵng");
                                        %>
                                    </c:when>
                                    <c:otherwise>Quận Hải Châu, Đà Nẵng</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Trạng thái</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty candidate.status}">${candidate.status}</c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">CV URL</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty selectedCV and not empty selectedCV.cvURL}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(selectedCV.cvURL, 'http://') || fn:startsWith(selectedCV.cvURL, 'https://')}">
                                                <a href="${selectedCV.cvURL}" target="_blank" style="color: #ff6b35;">Xem CV</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}${fn:startsWith(selectedCV.cvURL, '/') ? '' : '/'}${selectedCV.cvURL}" target="_blank" style="color: #ff6b35;">Xem CV</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Ngày tạo CV</span>
                            <span class="detail-value">
                                <c:choose>
                                    <c:when test="${not empty selectedCV and not empty selectedCV.creationDate}">
                                        <fmt:formatDate value="${selectedCV.creationDate}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- ============================================ -->
                <!-- PHẦN XEM CV - ỨNG VIÊN ĐÃ ỨNG TUYỂN -->
                <!-- ============================================ -->
                <div class="profile-details" style="margin-top: 30px;">
                    <h2 style="font-size: 24px; color: #333; margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #ff6b35;">
                        <i class="fas fa-file-pdf" style="color: #ff6b35; margin-right: 10px;"></i>Xem CV
                    </h2>
                    <c:if test="${not empty selectedCV}">
                        <c:choose>
                            <c:when test="${not empty selectedCV.cvURL}">
                                <!-- Hiển thị CV file (PDF, DOC, etc.) -->
                                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                                    <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 15px;">
                                        <%
                                            // Get CV URL and construct full path
                                            model.CV cv = (model.CV) request.getAttribute("selectedCV");
                                            String cvUrl = cv != null ? cv.getCvURL() : null;
                                            String downloadUrl = null;
                                            String fullCvUrl = null;
                                            
                                            if (cvUrl != null && !cvUrl.isEmpty()) {
                                                if (cvUrl.startsWith("http://") || cvUrl.startsWith("https://")) {
                                                    // Absolute URL
                                                    downloadUrl = cvUrl;
                                                    fullCvUrl = cvUrl;
                                                } else {
                                                    // Relative URL - ensure it starts with /uploads/cvs/
                                                    String normalizedUrl = cvUrl.startsWith("/") ? cvUrl : "/" + cvUrl;
                                                    // If it doesn't start with /uploads/cvs/, add it
                                                    if (!normalizedUrl.startsWith("/uploads/cvs/")) {
                                                        // Extract filename from path
                                                        String fileName = normalizedUrl.substring(normalizedUrl.lastIndexOf("/") + 1);
                                                        normalizedUrl = "/uploads/cvs/" + fileName;
                                                    }
                                                    String contextPath = request.getContextPath();
                                                    downloadUrl = contextPath + normalizedUrl;
                                                    fullCvUrl = contextPath + normalizedUrl;
                                                }
                                            }
                                        %>
                                        <c:if test="<%= downloadUrl != null %>">
                                            <a href="<%= downloadUrl %>" target="_blank" 
                                               style="background: #ff6b35; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-download"></i>
                                                Tải xuống CV
                                            </a>
                                        </c:if>
                                        <span style="color: #666; font-size: 14px;">
                                            <c:if test="${not empty selectedCV.cvTitle}">
                                                Tiêu đề: ${selectedCV.cvTitle}
                                            </c:if>
                                        </span>
                                    </div>
                                    <!-- CV Viewer -->
                                    <div style="border: 1px solid #ddd; border-radius: 8px; overflow: hidden; background: white; position: relative;">
                                        <c:if test="<%= fullCvUrl != null %>">
                                            <%
                                                String fileExtension = "";
                                                if (cvUrl != null) {
                                                    int lastDot = cvUrl.lastIndexOf(".");
                                                    if (lastDot > 0) {
                                                        fileExtension = cvUrl.substring(lastDot).toLowerCase();
                                                    }
                                                }
                                            %>
                                            <c:choose>
                                                <c:when test="<%= \".pdf\".equals(fileExtension) %>">
                                                    <!-- PDF Viewer -->
                                                    <iframe src="<%= fullCvUrl %>#toolbar=0&navpanes=0&scrollbar=1" 
                                                            style="width: 100%; height: 800px; border: none;"
                                                            title="CV Viewer (PDF)">
                                                        <p>Trình duyệt của bạn không hỗ trợ iframe. 
                                                            <a href="<%= fullCvUrl %>" target="_blank">Nhấp vào đây để xem CV</a>
                                                        </p>
                                                    </iframe>
                                                </c:when>
                                                <c:when test="<%= \".doc\".equals(fileExtension) || \".docx\".equals(fileExtension) %>">
                                                    <!-- DOC/DOCX - Use Google Docs Viewer -->
                                                    <%
                                                        String docViewerUrl;
                                                        if (cvUrl != null && (cvUrl.startsWith("http://") || cvUrl.startsWith("https://"))) {
                                                            docViewerUrl = "https://docs.google.com/gview?url=" + java.net.URLEncoder.encode(cvUrl, "UTF-8") + "&embedded=true";
                                                        } else {
                                                            String fullUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + fullCvUrl;
                                                            docViewerUrl = "https://docs.google.com/gview?url=" + java.net.URLEncoder.encode(fullUrl, "UTF-8") + "&embedded=true";
                                                        }
                                                    %>
                                                    <iframe src="<%= docViewerUrl %>" 
                                                            style="width: 100%; height: 800px; border: none;"
                                                            title="CV Viewer (DOC/DOCX)">
                                                        <p>Trình duyệt của bạn không hỗ trợ iframe. 
                                                            <a href="<%= fullCvUrl %>" target="_blank">Nhấp vào đây để tải xuống CV</a>
                                                        </p>
                                                    </iframe>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Other file types - direct link -->
                                                    <div style="padding: 40px; text-align: center;">
                                                        <i class="fas fa-file" style="font-size: 48px; color: #999; margin-bottom: 20px;"></i>
                                                        <p style="color: #666; margin-bottom: 20px;">Không thể xem trước file này trong trình duyệt.</p>
                                                        <a href="<%= fullCvUrl %>" target="_blank" 
                                                           style="background: #ff6b35; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;">
                                                            <i class="fas fa-download"></i>
                                                            Tải xuống để xem
                                                        </a>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="background: #fff3cd; padding: 15px; border-radius: 8px; border-left: 4px solid #ffc107;">
                                    <p style="color: #856404; margin: 0;">
                                        <i class="fas fa-info-circle"></i> CV file không có sẵn.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${empty selectedCV}">
                        <div style="background: #fff3cd; padding: 20px; border-radius: 8px; border-left: 4px solid #ffc107; text-align: center;">
                            <i class="fas fa-info-circle" style="font-size: 32px; color: #ffc107; margin-bottom: 10px;"></i>
                            <p style="color: #856404; margin: 0; font-size: 16px;">Chưa có CV nào được tải lên cho ứng viên này.</p>
                        </div>
                    </c:if>
                </div>
                
                <!-- CV Content Section -->
                <c:if test="${not empty selectedCV and not empty selectedCV.cvContent}">
                    <div class="profile-details" style="margin-top: 30px;">
                        <h2>Nội dung CV</h2>
                        <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; white-space: pre-wrap; line-height: 1.6; color: #333;">
                            ${selectedCV.cvContent}
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Three Dots Button -->
        <div class="three-dots-button">
            <i class="fas fa-ellipsis-h"></i>
        </div>

        <!-- Chat Button -->
        <div class="chat-button">
            <i class="fas fa-comments"></i>
            <span>Trò chuyện</span>
        </div>

        <!-- Send Invitation Modal -->
        <div id="sendInvitationModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title">Gửi lời mời tới ứng viên</h2>
                    <button class="modal-close" onclick="closeModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label required">Chọn công việc để gửi lời mời</label>
                        <input type="text" class="form-input" value="Test N" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Tiêu đề Email</label>
                        <input type="text" class="form-input" value="VietnamWorks Service - Gửi bạn lời mời ứng tuyển vị trí Test N">
                    </div>

                    <div class="form-group">
                        <label class="form-label required">Nội dung gửi đến ứng viên</label>
                        <div class="rich-text-toolbar">
                            <button class="toolbar-btn" title="Bold" data-command="bold">B</button>
                            <button class="toolbar-btn" title="Italic" data-command="italic">I</button>
                            <button class="toolbar-btn" title="Underline" data-command="underline">U</button>
                            <div style="width: 1px; height: 20px; background: #d1d5db; margin: 0 4px;"></div>
                            <button class="toolbar-btn" title="Align Left" data-command="alignLeft">≡</button>
                            <button class="toolbar-btn" title="Align Center" data-command="alignCenter">≡</button>
                            <button class="toolbar-btn" title="Align Right" data-command="alignRight">≡</button>
                            <button class="toolbar-btn" title="Justify" data-command="justify">≡</button>
                            <div style="width: 1px; height: 20px; background: #d1d5db; margin: 0 4px;"></div>
                            <button class="toolbar-btn" title="Bullet List" data-command="bulletList">•</button>
                            <button class="toolbar-btn" title="Numbered List" data-command="numberList">1.</button>
                            <button class="toolbar-btn" title="Indent" data-command="indent">→</button>
                            <button class="toolbar-btn" title="Outdent" data-command="outdent">←</button>
                            <div style="width: 1px; height: 20px; background: #d1d5db; margin: 0 4px;"></div>
                            <button class="toolbar-btn" title="Font" data-command="font">A <i class="fas fa-chevron-down"></i></button>
                        </div>
                        <textarea class="form-textarea" id="emailContent">Dear [Tên ứng viên],

Chúng tôi rất vui mừng được mời bạn ứng tuyển vào vị trí **Test N** tại **VietnamWorks Service**.

Nền tảng và kỹ năng ấn tượng của bạn đã thu hút sự chú ý của chúng tôi và chúng tôi tin rằng bạn có thể là một nhân tố tiềm năng cho đội ngũ của chúng tôi.

Vui lòng nộp đơn ứng tuyển của bạn thông qua trang web VietnamWorks kèm theo CVs của bạn trước ngày [Ngày hết hạn].

Tại **VietnamWorks Service**, chúng tôi luôn chú trọng đến sự phát triển và phúc lợi của nhân viên. Khi gia nhập đội ngũ của chúng tôi, bạn sẽ được hưởng các lợi ích sau:

• Môi trường làm việc chuyên nghiệp và năng động
• Cơ hội phát triển nghề nghiệp rõ ràng
• Chế độ lương thưởng cạnh tranh
• Bảo hiểm sức khỏe toàn diện
• Các chương trình đào tạo và phát triển kỹ năng

Chúng tôi mong muốn được gặp bạn trong buổi phỏng vấn sắp tới.

Trân trọng,
Đội ngũ Tuyển dụng
VietnamWorks Service</textarea>
                        <div class="character-count">789/10000 ký tự</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-cancel" onclick="closeModal()">Hủy</button>
                    <button class="btn-send" onclick="sendInvitation()">Gửi lời mời ứng tuyển</button>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
        <script>
                        // Modal functions
                        function openModal() {
                            document.getElementById('sendInvitationModal').style.display = 'block';
                            // Scroll to modal
                            document.getElementById('sendInvitationModal').scrollIntoView({behavior: 'smooth'});
                        }

                        function closeModal() {
                            document.getElementById('sendInvitationModal').style.display = 'none';
                        }

                        function sendInvitation() {
                            // Handle send invitation logic here
                            alert('Lời mời đã được gửi thành công!');
                            closeModal();
                        }

                        // Close modal when clicking outside
                        window.onclick = function (event) {
                            const modal = document.getElementById('sendInvitationModal');
                            if (event.target === modal) {
                                closeModal();
                            }
                        }

                        // Add click event to send invitation button
                        document.addEventListener('DOMContentLoaded', function () {
                            const sendInvitationBtn = document.querySelector('.btn-send-invitation');
                            if (sendInvitationBtn) {
                                sendInvitationBtn.addEventListener('click', openModal);
                            }

                            // Rich text editor functionality
                            const textarea = document.getElementById('emailContent');
                            const toolbarBtns = document.querySelectorAll('.toolbar-btn');

                            toolbarBtns.forEach(btn => {
                                btn.addEventListener('click', function (e) {
                                    e.preventDefault();
                                    const command = this.getAttribute('data-command');
                                    if (command) {
                                        executeCommand(command);
                                    }
                                });
                            });

                            // Character count update
                            if (textarea) {
                                textarea.addEventListener('input', updateCharacterCount);
                                updateCharacterCount();
                            }
                        });

                        function executeCommand(command) {
                            const textarea = document.getElementById('emailContent');
                            const start = textarea.selectionStart;
                            const end = textarea.selectionEnd;
                            const selectedText = textarea.value.substring(start, end);
                            let newText = '';

                            switch (command) {
                                case 'bold':
                                    newText = `**${selectedText}**`;
                                    break;
                                case 'italic':
                                    newText = `*${selectedText}*`;
                                    break;
                                case 'underline':
                                    newText = `<u>${selectedText}</u>`;
                                    break;
                                case 'bulletList':
                                    newText = `• ${selectedText}`;
                                    break;
                                case 'numberList':
                                    newText = `1. ${selectedText}`;
                                    break;
                                default:
                                    return;
                            }

                            textarea.value = textarea.value.substring(0, start) + newText + textarea.value.substring(end);
                            textarea.focus();
                            textarea.setSelectionRange(start + newText.length, start + newText.length);
                            updateCharacterCount();
                        }

                        function updateCharacterCount() {
                            const textarea = document.getElementById('emailContent');
                            const charCount = document.querySelector('.character-count');
                            if (textarea && charCount) {
                                const currentLength = textarea.value.length;
                                charCount.textContent = `${currentLength}/10000 ký tự`;
                            }
                        }
        </script>
    </body>
</html>
</html>