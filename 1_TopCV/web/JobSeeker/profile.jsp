<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VietnamWorks - Hồ Sơ Của Tôi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/JobSeeker/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<style>
    /* Profile Modal Styles - Responsive Fixed Version */
.main-content {
    position: relative;
}
.profile-modal {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 2000;
    display: none;
    opacity: 0;
    transition: all 0.3s ease-in-out;
    backdrop-filter: blur(0px);
}

.profile-modal.show {
    display: flex !important;
    align-items: flex-start;     /* canh modal từ trên xuống */
    justify-content: center;     /* vẫn căn giữa ngang */
    padding-top: 60px;           /* đẩy modal xuống thấp hơn (tăng từ 40px lên 80px) */
    padding-left: 20px;
    padding-right: 20px;
    padding-bottom: 20px;
}

.profile-modal .modal-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: -1;
}

.profile-modal .modal-content {
    position: relative;
    width: 100%;
    max-width: 1000px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    /* Sử dụng calc để tính toán chiều cao dựa trên viewport */
    height: calc(50vh); /* 40px = padding top + bottom */
    max-height: 700px; /* Giới hạn chiều cao tối đa */
    min-height: 500px; /* Chiều cao tối thiểu */
    overflow: hidden;
    transform: scale(0.9);
    transition: transform 0.3s ease-in-out;
}

.profile-modal.show .modal-content {
    transform: scale(1);
}

.profile-modal .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #e9ecef;
    background: white;
    border-radius: 12px 12px 0 0;
    flex-shrink: 0; /* Không cho phép co lại */
}

.profile-modal .modal-header h2 {
    color: #333;
    font-size: 1.2rem;
    margin: 0;
    font-weight: 600;
}

.profile-modal .modal-close {
    background: none;
    border: none;
    font-size: 1.2rem;
    color: #666;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 50%;
    transition: background-color 0.2s;
    width: 36px;
    height: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.profile-modal .modal-close:hover {
    background: #f8f9fa;
}

.profile-modal .modal-body {
    flex: 1; /* Chiếm hết không gian còn lại */
    overflow-y: auto; /* Cho phép cuộn */
    padding: 1.5rem;
    /* Đảm bảo có thể cuộn được */
    min-height: 0;
}

.profile-modal .modal-footer {
    padding: 1rem 1.5rem;
    border-top: 1px solid #e9ecef;
    background: white;
    border-radius: 0 0 12px 12px;
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    flex-shrink: 0; /* Không cho phép co lại */
}

/* Form styles inside modal */
.profile-modal .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 1rem;
}

.profile-modal .form-group {
    display: flex;
    flex-direction: column;
}

.profile-modal .form-group.full-width {
    grid-column: 1 / -1;
}

.profile-modal .form-group label {
    color: #333;
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 0.5rem;
}

.profile-modal .form-group input,
.profile-modal .form-group select,
.profile-modal .form-group textarea {
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 0.9rem;
    transition: border-color 0.2s;
    font-family: inherit;
}

.profile-modal .form-group input:focus,
.profile-modal .form-group select:focus,
.profile-modal .form-group textarea:focus {
    outline: none;
    border-color: #0066cc;
    box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
}

.profile-modal .form-group textarea {
    min-height: 80px;
    resize: vertical;
}

.required-note {
    color: #666;
    font-size: 0.8rem;
    margin-top: 1rem;
    font-style: italic;
}

.required {
    color: #dc3545;
}

/* Button styles */
.save-btn {
    background: #ff6b35;
    color: white;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s;
    min-width: 80px;
}

.save-btn:hover {
    background: #e55a2b;
}

.cancel-btn {
    background: #f8f9fa;
    color: #333;
    border: 1px solid #ddd;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    min-width: 80px;
}

.cancel-btn:hover {
    background: #e9ecef;
    border-color: #ccc;
}

/* Custom scrollbar cho modal body */
.profile-modal .modal-body::-webkit-scrollbar {
    width: 6px;
}

.profile-modal .modal-body::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
}

.profile-modal .modal-body::-webkit-scrollbar-thumb {
    background: #c1c1c1;
    border-radius: 3px;
}

.profile-modal .modal-body::-webkit-scrollbar-thumb:hover {
    background: #a8a8a8;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .profile-modal.show {
        padding: 10px; /* Giảm padding trên mobile */
    }
    
    .profile-modal .modal-content {
        height: calc(100vh - 20px); /* Điều chỉnh cho mobile */
        max-height: none; /* Bỏ giới hạn max-height trên mobile */
        min-height: 300px;
    }
    
    .profile-modal .modal-header {
        padding: 0.75rem 1rem;
    }
    
    .profile-modal .modal-body {
        padding: 1rem;
    }
    
    .profile-modal .modal-footer {
        padding: 0.75rem 1rem;
        flex-direction: column;
        gap: 0.5rem;
    }
    
    .profile-modal .form-row {
        grid-template-columns: 1fr;
        gap: 0.75rem;
        margin-bottom: 0.75rem;
    }
    
    .cancel-btn,
    .save-btn {
        width: 100%;
        justify-content: center;
    }
}

@media (max-height: 600px) {
    /* Đặc biệt xử lý cho màn hình thấp */
    .profile-modal .modal-content {
        max-height: calc(100vh - 20px);
        min-height: calc(100vh - 20px);
    }
    
    .profile-modal .modal-header {
        padding: 0.5rem 1rem;
    }
    
    .profile-modal .modal-header h2 {
        font-size: 1.1rem;
    }
    
    .profile-modal .modal-body {
        padding: 1rem;
    }
    
    .profile-modal .modal-footer {
        padding: 0.5rem 1rem;
    }
}

/* Animation cho smooth opening */
@keyframes modalFadeIn {
    from {
        opacity: 0;
        transform: scale(0.9) translateY(-20px);
    }
    to {
        opacity: 1;
        transform: scale(1) translateY(0);
    }
}

/* Khung tổng */
.desired-job-section {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    margin-bottom: 20px;
}

/* Tiêu đề */
.desired-job-section h3 {
    font-size: 18px;
    margin-bottom: 15px;
    color: #333;
    font-weight: 600;
}

/* Thông tin nơi làm việc */
.job-preference {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
    font-size: 15px;
    color: #555;
}

.job-preference i {
    color: #007bff;
    margin-right: 8px;
}

/* Header của mục kỹ năng */
.section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
}

/* Nút thêm kỹ năng */
.add-skill-btn {
    background: #007bff;
    color: #fff;
    border: none;
    border-radius: 50%;
    width: 28px;
    height: 28px;
    font-size: 16px;
    cursor: pointer;
    transition: 0.2s;
}
.add-skill-btn:hover {
    background: #0056b3;
}

/* Danh sách kỹ năng */
.skills-content {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

/* Kỹ năng dạng tag */
.skill-item {
    display: inline-flex;
    align-items: center;
    background: #f1f1f1;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 14px;
    color: #333;
}

.skill-item button {
    background: transparent;
    border: none;
    font-size: 14px;
    margin-left: 8px;
    cursor: pointer;
    color: #ff4d4f;
    font-weight: bold;
}

.skill-item button:hover {
    color: #d9363e;
}

/* Khi chưa có kỹ năng */
.skills-content .no-data {
    font-size: 14px;
    color: #999;
}

</style>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <h1>TopFinder</h1>
                </div>
            </div>
            
            <div class="search-section">
                <div class="search-bar">
                    <input type="text" placeholder="Tìm kiếm việc làm, công ty, kỹ năng">
                    <div class="location-selector">
                        <i class="fas fa-map-marker-alt"></i>
                        <span>Tất cả địa điểm</span>
                    </div>
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
            
            <div class="header-right">
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                    <span>Tất cả danh mục</span>
                </div>
                <button class="recruiter-btn">Nhà tuyển dụng</button>
                <div class="user-actions">
                    <div class="profile-icon">
                        <i class="fas fa-user"></i>
                        <span>Vi</span>
                    </div>
                    <div class="notification-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="main-container">
        <!-- Left Sidebar -->
        <aside class="sidebar">
            <!-- User Profile Card -->
            <div class="profile-card">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="profile-info">
                    <h3>${jobSeeker.fullName}</h3>
                    <p>${jobSeeker.headline != null ? jobSeeker.headline : 'Chưa cập nhật'}</p>
                </div>
                <div class="profile-edit">
                    <i class="fas fa-plus"></i>
                </div>
            </div>
            
            <div class="resume-status">
                <h4>Cho phép tìm kiếm hồ sơ</h4>
                <div class="resume-toggle">
                    <label class="toggle-switch">
                        <input type="checkbox" 
                               data-field="search-enabled" 
                               ${jobSeeker.status == 'Active' ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                    <span class="resume-file" data-field="active-cv">Chưa có CV</span>
                </div>
            </div>

            <!-- Navigation Menu -->
            <nav class="nav-menu">
                <ul>
                    <li>
                        <a href="index.html" class="nav-item">
                            <i class="fas fa-chart-pie"></i>
                            <span>Tổng Quan</span>
                        </a>
                    </li>
                    <li>
                        <a href="profile.html" class="nav-item active">
                            <i class="fas fa-file-alt"></i>
                            <span>Hồ Sơ Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-building"></i>
                            <span>Công Ty Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="index.html" class="nav-item">
                            <i class="fas fa-briefcase"></i>
                            <span>Việc Làm Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-bell"></i>
                            <span>Thông Báo Việc Làm</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Quản Lý Đơn Hàng</span>
                        </a>
                    </li>
                    <li>
                        <a href="account-management.html" class="nav-item">
                            <i class="fas fa-cog"></i>
                            <span>Quản Lý Tài Khoản</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Call to Action Button -->
            <button class="cta-button">
                <i class="fas fa-bell"></i>
                <span>Tạo Thông Báo Việc Làm</span>
            </button>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="content-header">
                <h1>Hồ Sơ Của Tôi</h1>
            </div>
            
            <!-- Personal Information Card -->
            <div class="profile-info-card">
                <div class="profile-header">
                    <div class="profile-avatar-large">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-details">
                        <h2 data-field="fullName">${jobSeeker.fullName}</h2>
                        <p class="job-title" data-field="headline-experience">${jobSeeker.headline != null ? jobSeeker.headline : 'Chưa cập nhật Headline'} - 
                            ${jobSeeker.currentLevelId != null ? jobSeeker.currentLevelId : 'Chưa cập nhật level'}</p>
                        <div class="profile-meta">
                            <div class="meta-item">
                                <i class="fas fa-user-tag"></i>
                                <span data-field="currentLevel">${jobSeeker.currentLevelId != null ? jobSeeker.currentLevelId : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-envelope"></i>
                                <span data-field="email">${jobSeeker.email}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span data-field="location">${jobSeeker.address != null ? jobSeeker.address : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-phone"></i>
                                <span data-field="phone">${jobSeeker.phone != null ? jobSeeker.phone : 'Chưa cập nhật'}</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-venus-mars"></i>
                                <span data-field="gender">${jobSeeker.gender != null ? jobSeeker.gender : 'Chưa cập nhật'}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="edit-profile-btn" onclick="openProfileModal()">
                    <i class="fas fa-pencil-alt"></i>
                </button>
            </div>
    <!-- Profile Edit Modal -->
    <div class="profile-modal" id="profileModal">
        <div class="modal-overlay"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h2>Thông Tin Cơ Bản</h2>
                <button class="modal-close" onclick="closeProfileModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <form id="profileForm" action="${pageContext.request.contextPath}/jobseekerprofile" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Họ và tên <span class="required">*</span></label>
                            <input type="text" name="fullName" value="${jobSeeker.fullName}" required>
                        </div>
                        <div class="form-group">
                            <label>Email <span class="required">*</span></label>
                            <input type="email" name="email" value="${jobSeeker.email}" required readonly>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Headline/Chức danh <span class="required">*</span></label>
                            <input type="text" name="headline" value="${jobSeeker.headline}" placeholder="VD: Software Engineer">
                        </div>
                            <div class="form-group">
                                <label>Cấp bậc hiện tại <span class="required">*</span></label>
                                <select name="currentLevelID">
                                    <option value="">Chọn cấp bậc</option>
                                    <c:forEach var="level" items="${types}">
                                        <option value="${level.typeID}" ${jobSeeker.currentLevelId == level.typeID ? "selected" : ""}>
                                            ${level.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="tel" name="phone" value="${jobSeeker.phone}">
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gender">
                                <option value="">Chọn giới tính</option>
                                <option value="Nam" ${jobSeeker.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${jobSeeker.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                <option value="Khác" ${jobSeeker.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Địa điểm <span class="required">*</span></label>
                            <select name="locationID">
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc.locationID}" ${jobSeeker.locationId == loc.locationID ? "selected" : ""}>${loc.locationName}</option>
                                </c:forEach>
                            </select>
                        </div>


                        <div class="form-group">
                            <label>Trạng thái</label>
                            <select name="status">
                                <option value="Active" ${jobSeeker.status == 'Active' ? 'selected' : ''}>Đang tìm việc</option>
                                <option value="Inactive" ${jobSeeker.status == 'Inactive' ? 'selected' : ''}>Không tìm việc</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label>Địa chỉ chi tiết</label>
                        <textarea name="address" rows="3">${jobSeeker.address}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label>Thông tin liên hệ</label>
                        <textarea name="contactInfo" rows="2">${jobSeeker.contactInfo}</textarea>
                    </div>
                    <p class="required-note">* Thông tin bắt buộc</p>
                </form>                    
            </div>

                <div class="modal-footer">
                    <button class="cancel-btn" onclick="closeProfileModal()">Hủy</button>
                    <button class="save-btn" type="submit" form="profileForm">Lưu</button>
                </div>
        </div>
    </div>
    </main>

    <script src="${pageContext.request.contextPath}/JobSeeker/script.js"></script>
</body>
</html>

