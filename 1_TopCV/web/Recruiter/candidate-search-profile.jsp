<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
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
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 20px;
        }

        /* Main Profile Section */
        .profile-main {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .detail-label {
            color: #666;
            font-weight: 500;
            min-width: 150px;
        }

        .detail-value {
            color: #333;
            font-weight: 400;
            text-align: right;
            flex: 1;
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
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .matching-candidates {
                order: -1;
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
                    <li><a href="#">Việc Làm</a></li>
                    <li class="dropdown">
                        <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="candidate-management.jsp">Quản lý theo việc đăng tuyển</a>
                            <a href="candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </li>
                    <li class="dropdown">
                        <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="#">Quy trình onboarding</a>
                            <a href="#">Tài liệu hướng dẫn</a>
                        </div>
                    </li>
                    <li><a href="#">Đơn hàng</a></li>
                    <li><a href="#">Báo cáo</a></li>
                    <li><a href="#">Công ty</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <div class="nav-buttons">
                    <div class="dropdown">
                        <button class="btn btn-orange">
                            Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-content">
                            <a href="candidate-management.jsp">Quản lý theo việc đăng tuyển</a>
                            <a href="candidate-folder.html" class="highlighted">Quản lý theo thư mục và thẻ</a>
                        </div>
                    </div>
                    <button class="btn btn-blue">Tìm Ứng Viên</button>
                    <button class="btn btn-white">Mua</button>
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
                                <a href="#" class="menu-item highlighted">
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
                                <a href="#" class="logout-item">
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
                            ${candidate.fullName.substring(0, 1)}
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
                            <c:when test="${not empty candidate.address}">${candidate.address}</c:when>
                            <c:otherwise>Đà Nẵng</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-update">
                        Cập nhật gần nhất: 09/09/2019
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="profile-actions">
                <button class="btn-view-contact">
                    <i class="fas fa-eye"></i>
                    Xem thông tin liên hệ (-2 Điểm)
                </button>
                <button class="btn-send-invitation">
                    <i class="fas fa-paper-plane"></i>
                    Gửi lời mời ứng tuyển
                </button>
                <div class="action-icon">
                    <i class="fas fa-share-alt"></i>
                </div>
                <div class="action-icon">
                    <i class="fas fa-bookmark"></i>
                </div>
            </div>

            <!-- Points Info -->
            <div class="points-info">
                <p>Bạn có 2303 điểm chưa sử dụng</p>
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
                        <span class="detail-label">Cấp bậc hiện tại</span>
                        <span class="detail-value">Senior</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Ngành nghề</span>
                        <span class="detail-value">Công nghệ thông tin</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Lĩnh vực</span>
                        <span class="detail-value">Phát triển phần mềm</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Cấp bậc mong muốn</span>
                        <span class="detail-value">Lead Developer</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Mức lương mong muốn</span>
                        <span class="detail-value">25-35 triệu VNĐ</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Ngày sinh</span>
                        <span class="detail-value">15/03/1990</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Giới tính</span>
                        <span class="detail-value">Nam</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Tình trạng hôn nhân</span>
                        <span class="detail-value">Đã kết hôn</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Địa chỉ</span>
                        <span class="detail-value">
                            <c:choose>
                                <c:when test="${not empty candidate.address}">${candidate.address}</c:when>
                                <c:otherwise>Quận Hải Châu, Đà Nẵng</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Nơi làm việc mong muốn</span>
                        <span class="detail-value">Đà Nẵng, Hồ Chí Minh</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Bằng cấp</span>
                        <span class="detail-value">Đại học</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Ngôn ngữ</span>
                        <span class="detail-value">Tiếng Việt, Tiếng Anh</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Matching Candidates Sidebar -->
        <div class="matching-candidates">
            <h3>ỨNG VIÊN PHÙ HỢP</h3>
            
            <div class="candidate-card">
                <div class="candidate-avatar">QA</div>
                <div class="candidate-info">
                    <h4>Nguyễn Văn A</h4>
                    <p>Junior Quality Assurance</p>
                </div>
            </div>
            
            <div class="candidate-card">
                <div class="candidate-avatar">TL</div>
                <div class="candidate-info">
                    <h4>Trần Thị B</h4>
                    <p>Technical Lead</p>
                </div>
            </div>
            
            <div class="candidate-card">
                <div class="candidate-avatar">GD</div>
                <div class="candidate-info">
                    <h4>Lê Văn C</h4>
                    <p>Game Developer</p>
                </div>
            </div>
            
            <div class="candidate-card">
                <div class="candidate-avatar">RD</div>
                <div class="candidate-info">
                    <h4>Phạm Thị D</h4>
                    <p>Ruby Developer</p>
                </div>
            </div>
            
            <div class="candidate-card">
                <div class="candidate-avatar">FS</div>
                <div class="candidate-info">
                    <h4>Hoàng Văn E</h4>
                    <p>Full Stack Developer</p>
                </div>
            </div>
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
            document.getElementById('sendInvitationModal').scrollIntoView({ behavior: 'smooth' });
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
        window.onclick = function(event) {
            const modal = document.getElementById('sendInvitationModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        // Add click event to send invitation button
        document.addEventListener('DOMContentLoaded', function() {
            const sendInvitationBtn = document.querySelector('.btn-send-invitation');
            if (sendInvitationBtn) {
                sendInvitationBtn.addEventListener('click', openModal);
            }

            // Rich text editor functionality
            const textarea = document.getElementById('emailContent');
            const toolbarBtns = document.querySelectorAll('.toolbar-btn');

            toolbarBtns.forEach(btn => {
                btn.addEventListener('click', function(e) {
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

            switch(command) {
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