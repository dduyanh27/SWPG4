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
/* Mega menu open state */
.mega-menu.open {
    transform: translateY(0);
    opacity: 1;
}

/* Logo link styles */
.logo {
    text-decoration: none;
    display: block;
}

.logo h1 {
    color: white;
    margin: 0;
}

.logo .tagline {
    color: rgba(255, 255, 255, 0.8);
}

.logo:hover h1 {
    color: #e6f3ff;
}

.logo:hover .tagline {
    color: rgba(255, 255, 255, 0.9);
}
</style>

<style>
    :root {
        --primary: #0a67ff;
        --primary-dark: #0b5bdf;
        --success: #10b981;
        --danger: #ef4444;
        --text-dark: #1f2937;
        --text-muted: #6b7280;
        --border: #e5e7eb;
        --bg-light: #f9fafb;
        --shadow-sm: 0 2px 8px rgba(0,0,0,0.06);
        --shadow-md: 0 4px 16px rgba(0,0,0,0.1);
        --shadow-lg: 0 8px 32px rgba(0,0,0,0.12);
        --radius-md: 12px;
        --radius-lg: 16px;
    }

    .profile-documents-section {
        background: white;
        border-radius: var(--radius-lg);
        padding: 32px;
        box-shadow: var(--shadow-sm);
        margin: 24px 0;
    }

    .profile-documents-section h3 {
        font-size: 24px;
        font-weight: 700;
        color: var(--text-dark);
        margin: 0 0 24px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .profile-documents-section h3::before {
        content: '\f15c';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        color: var(--primary);
        font-size: 28px;
    }

    /* ========== UPLOAD AREA ========== */
    .upload-area {
        background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
        border: 3px dashed var(--primary);
        border-radius: var(--radius-lg);
        padding: 40px;
        text-align: center;
        margin-bottom: 32px;
        transition: all 0.3s ease;
    }

    .upload-area:hover {
        background: linear-gradient(135deg, #e6f3ff 0%, #dbeafe 100%);
        border-color: var(--primary-dark);
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }

    .upload-area.drag-over {
        background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
        border-color: var(--primary-dark);
        transform: scale(1.02);
    }

    .upload-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 16px;
        cursor: pointer;
        margin-bottom: 16px;
    }

    .upload-btn i {
        font-size: 48px;
        color: var(--primary);
        transition: all 0.3s ease;
    }

    .upload-btn:hover i {
        transform: scale(1.1) rotate(90deg);
        color: var(--primary-dark);
    }

    /* File selected state for upload button */
    .upload-area.file-selected .upload-btn i {
        font-size: 32px;
        color: var(--success);
        transform: scale(1);
    }

    .upload-area.file-selected .upload-btn:hover i {
        transform: scale(1.05);
        color: var(--success);
    }

    .upload-btn span {
        font-size: 16px;
        font-weight: 600;
        color: var(--text-dark);
    }

    .upload-note {
        color: var(--text-muted);
        font-size: 14px;
        margin: 16px 0;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: all 0.3s ease;
    }

    .upload-note i {
        color: var(--primary);
    }

    /* File selected state for upload note */
    .upload-area.file-selected .upload-note {
        font-weight: 600;
    }

    .upload-area.file-selected .upload-note i {
        color: var(--success);
    }

    .btn-submit {
        background: linear-gradient(135deg, var(--primary-dark), var(--primary));
        color: white;
        border: none;
        padding: 14px 32px;
        border-radius: 30px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(10,103,255,0.3);
        display: none; /* Ban đầu ẩn nút submit */
        align-items: center;
        gap: 8px;
        margin-top: 16px;
        opacity: 0;
        transform: translateY(10px);
    }

    .btn-submit.show {
        display: inline-flex !important;
        opacity: 1;
        transform: translateY(0);
    }

    /* Clear file button */
    .btn-clear {
        background: #6b7280;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        display: none;
        align-items: center;
        gap: 6px;
        margin-left: 12px;
    }

    .btn-clear:hover {
        background: #4b5563;
    }

    .btn-clear.show {
        display: inline-flex;
    }

    /* File selected state styling */
    .upload-area.file-selected {
        background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%) !important;
        border-color: #10b981 !important;
    }

    .file-selected-info {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 16px;
    }

    .upload-actions {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin-top: 16px;
    }

    .btn-submit::before {
        content: '\f093';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
    }

    .btn-submit:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(10,103,255,0.4);
    }

    .btn-submit:active {
        transform: translateY(0);
    }

    /* ========== UPLOADED FILES ========== */
    .uploaded-files {
        display: grid;
        gap: 16px;
    }

    .file-item {
        background: white;
        border: 2px solid var(--border);
        border-radius: var(--radius-md);
        padding: 20px;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 20px;
        transition: all 0.3s ease;
        position: relative;
    }

    .file-item:hover {
        border-color: var(--primary);
        box-shadow: var(--shadow-md);
        transform: translateY(-2px);
    }

    .file-item::before {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        background: linear-gradient(180deg, var(--primary), var(--primary-dark));
        border-radius: var(--radius-md) 0 0 var(--radius-md);
        opacity: 0;
        transition: opacity 0.3s;
    }

    .file-item:hover::before {
        opacity: 1;
    }

    .file-info {
        flex: 1;
    }

    .file-info h4 {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-dark);
        margin: 0 0 12px 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .file-info h4::before {
        content: '\f1c2';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        color: var(--primary);
        font-size: 20px;
    }

    .file-meta {
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--text-muted);
        font-size: 14px;
        margin-bottom: 12px;
    }

    .file-meta i {
        color: var(--primary);
    }

    .view-as-recruiter {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        color: var(--primary);
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        padding: 6px 12px;
        border-radius: 6px;
        transition: all 0.2s;
    }

    .view-as-recruiter::before {
        content: '\f06e';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
    }

    .view-as-recruiter:hover {
        background: rgba(10,103,255,0.1);
        color: var(--primary-dark);
    }

    /* ========== FILE ACTIONS ========== */
    .file-actions {
        position: relative;
    }

    .file-menu-btn {
        background: var(--bg-light);
        border: 2px solid var(--border);
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
        color: var(--text-muted);
    }

    .file-menu-btn:hover {
        background: var(--primary);
        border-color: var(--primary);
        color: white;
        transform: rotate(90deg);
    }

    .file-dropdown {
        position: absolute;
        right: 0;
        top: calc(100% + 8px);
        background: white;
        border-radius: var(--radius-md);
        box-shadow: var(--shadow-lg);
        min-width: 240px;
        padding: 8px;
        display: none;
        z-index: 100;
        animation: slideDown 0.3s ease;
    }

    @keyframes slideDown {
        from {
            opacity: 0;
            transform: translateY(-10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .file-dropdown.active {
        display: block;
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        padding: 12px 16px;
        color: var(--text-dark);
        text-decoration: none;
        border-radius: 8px;
        transition: all 0.2s;
        cursor: pointer;
    }

    .dropdown-item:hover {
        background: var(--bg-light);
    }

    .dropdown-item i {
        color: var(--primary);
        width: 20px;
        text-align: center;
    }

    .dropdown-item span:first-child {
        flex: 1;
        font-size: 14px;
        font-weight: 500;
    }

    /* ========== TOGGLE SWITCH ========== */
    .toggle-switch {
        position: relative;
        width: 50px;
        height: 26px;
        display: inline-block;
    }

    .toggle-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: #cbd5e1;
        border-radius: 26px;
        transition: all 0.3s;
    }

    .slider::before {
        position: absolute;
        content: "";
        height: 20px;
        width: 20px;
        left: 3px;
        bottom: 3px;
        background: white;
        border-radius: 50%;
        transition: all 0.3s;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    }

    .toggle-switch input:checked + .slider {
        background: var(--success);
    }

    .toggle-switch input:checked + .slider::before {
        transform: translateX(24px);
    }

    .toggle-switch:hover .slider {
        box-shadow: 0 0 0 3px rgba(16,185,129,0.2);
    }

    /* ========== EMPTY STATE ========== */
    .uploaded-files > p {
        text-align: center;
        color: var(--text-muted);
        font-size: 16px;
        padding: 60px 20px;
        background: var(--bg-light);
        border-radius: var(--radius-md);
        border: 2px dashed var(--border);
    }

    .uploaded-files > p::before {
        content: '\f15b';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        display: block;
        font-size: 48px;
        color: var(--primary);
        margin-bottom: 16px;
        opacity: 0.5;
    }

    /* ========== RESPONSIVE ========== */
    @media (max-width: 768px) {
        .profile-documents-section {
            padding: 20px;
        }

        .upload-area {
            padding: 30px 20px;
        }

        .file-item {
            flex-direction: column;
        }

        .file-actions {
            width: 100%;
            display: flex;
            justify-content: flex-end;
        }

        .file-dropdown {
            right: 0;
        }

        .upload-actions {
            flex-direction: column;
            gap: 8px;
        }

        .btn-submit,
        .btn-clear {
            width: 100%;
            justify-content: center;
        }

        .upload-btn i {
            font-size: 36px;
        }

        .upload-area.file-selected .upload-btn i {
            font-size: 24px;
        }
    }

    /* ========== LOADING STATE ========== */
    .btn-submit:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none !important;
    }

    .btn-submit.loading::before {
        content: '\f1ce';
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
</style>

<style>
    /* Error message styles */
    #fullNameError,
    #phoneError {
        display: block;
        color: #ef4444;
        font-size: 12px;
        margin-top: 4px;
        min-height: 16px;
    }

    /* Character count styles */
    .char-count {
        color: #666;
        font-size: 12px;
        margin-top: 4px;
        display: block;
    }

    /* Input error state */
    input.error,
    textarea.error {
        border-color: #ef4444 !important;
        box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
    }
</style>

<body>
    <!-- Preloader Start -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="logo">
                    <h1>Top</h1>
                    <span class="tagline">Empower growth</span>
                </a>
            </div>
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/job-list" method="get" class="search-bar">
                    <input type="text" name="keyword" placeholder="Tìm kiếm việc làm, công ty">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            <div class="header-right">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                    <span>Tất cả danh mục</span>
                </div>
                <button class="recruiter-btn">Nhà tuyển dụng</button>
                <div class="user-actions">
                    <a class="profile-icon" href="${pageContext.request.contextPath}/jobseekerprofile" title="Tài khoản">
                        <i class="fas fa-user"></i>
                    </a>
                    <div class="notification-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="message-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>
    <!-- Mega menu panel -->
    <div class="mega-menu" id="megaMenu">
        <div class="mega-grid">
            <div class="mega-col">
                <h4>Việc làm</h4>
                <a href="#">Việc làm mới nhất</a>
                <a href="${pageContext.request.contextPath}/job-list">Tìm việc làm</a>
                <a href="#">Việc làm quản lý</a>
            </div>
            <div class="mega-col">
                <h4>Việc của tôi</h4>
                <a href="${pageContext.request.contextPath}/saved-jobs">Việc đã lưu</a>
                <a href="${pageContext.request.contextPath}/applied-jobs">Việc đã ứng tuyển</a>
                <a href="#">Thông báo việc làm</a>
                <a href="#">Việc dành cho bạn</a>
            </div>
            <div class="mega-col">
                <h4>Công ty</h4>
                <a href="#">Tất cả công ty</a>
            </div>
        </div>
    </div>
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
                        <a href="index.html" class="nav-item">
                            <i class="fas fa-briefcase"></i>
                            <span>Việc Làm Của Tôi</span>
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/applied-jobs" class="nav-item">
                            <i class="fas fa-history"></i>
                            <span>Lịch Sử Ứng Tuyển</span>
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
                        <p class="job-title" data-field="headline-experience">${jobSeeker.headline != null ? jobSeeker.headline : 'Chưa cập nhật Headline'}</p>
                        <div class="profile-meta">
                            <div class="meta-item">
                                <i class="fas fa-user-tag"></i>
                                <span data-field="currentLevel">${jobSeeker.currentLevelId != null ? typeName : 'Chưa cập nhật'}</span>
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

            <!-- Desired Job Section -->
            <!--            <div class="desired-job-section">
                            <h3>Công Việc Mong Muốn</h3>
                            <div class="desired-job-info">
                                <div class="job-preference">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>Nơi làm việc: Hà Nội</span>
                                </div>
                                <div class="job-preference">
                                    <i class="fas fa-dollar-sign"></i>
                                    <span>Mức lương mong muốn (USD / tháng): 200</span>
                                </div>
                            </div>
                        </div>-->
            <!-- Profile Documents Section -->
            <div class="profile-documents-section">
    <h3>Hồ sơ đã tải lên</h3>
    
    <!-- Upload Form -->
    <form action="${pageContext.request.contextPath}/UploadCVServlet"
          method="post"
          enctype="multipart/form-data"
          class="upload-area"
          id="uploadForm">
        
        <label class="upload-btn" id="uploadLabel" for="cvFileInput">
            <i class="fas fa-cloud-upload-alt" id="uploadIcon"></i>
            <span id="uploadText">Chọn hoặc kéo thả hồ sơ từ máy của bạn</span>
            <input type="file" 
                   name="cvFile" 
                   id="cvFileInput"
                   hidden 
                   required 
                   accept=".doc,.docx,.pdf">
        </label>
        
        <p class="upload-note" id="uploadNote">
            <i class="fas fa-info-circle"></i>
            Hỗ trợ định dạng .doc, .docx, .pdf có kích thước dưới 5MB
        </p>
        
        <div class="upload-actions">
            <button type="submit" class="btn-submit" id="submitBtn">
                Tải lên
            </button>
            <button type="button" class="btn-clear" id="clearBtn" onclick="clearSelectedFile()">
                <i class="fas fa-times"></i>
                Bỏ chọn
            </button>
        </div>
    </form>

    <!-- Danh sách CV đã upload -->
    <div class="uploaded-files">
        <c:forEach var="cv" items="${uploadedCVs}">
            <div class="file-item">
                <div class="file-info">
                    <h4>${cv.cvTitle}</h4>
                    <div class="file-meta">
                        <i class="fas fa-clock"></i>
                        <span>Ngày tải lên: ${cv.creationDate}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}${cv.cvURL}" 
                       target="_blank"
                       class="view-as-recruiter">
                        Xem hồ sơ
                    </a>
                </div>
                
                <div class="file-actions">
                    <button class="file-menu-btn" onclick="toggleDropdown(event, this)">
                        <i class="fas fa-ellipsis-v"></i>
                    </button>
                    <div class="file-dropdown">
                        <a href="${pageContext.request.contextPath}${cv.cvURL}" 
                           download="${cv.cvTitle}"
                           class="dropdown-item">
                            <i class="fas fa-download"></i>
                            <span>Tải xuống</span>
                        </a>
                        <div class="dropdown-item">
                            <span>Cho phép tìm kiếm</span>
                            <label class="toggle-switch">
                                <input type="checkbox"
                                       ${cv.active ? "checked" : ""}
                                       onchange="toggleSearchable(${cv.cvId}, this.checked)">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- Empty State -->
        <c:if test="${empty uploadedCVs}">
            <div style="text-align: center; padding: 40px; color: #666;">
                <i class="fas fa-folder-open" style="font-size: 48px; color: #ddd; margin-bottom: 16px;"></i>
                <p style="font-size: 16px;">Chưa có hồ sơ nào được tải lên</p>
                <p style="font-size: 14px; color: #999;">Hãy tải lên hồ sơ đầu tiên của bạn</p>
            </div>
        </c:if>
    </div>
</div>
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
                            <input type="text" name="fullName" id="fullName" value="${jobSeeker.fullName}" required>
                            <span id="fullNameError" style="color:red"></span>
                        </div>
                        <div class="form-group">
                            <label>Email <span class="required">*</span></label>
                            <input type="email" name="email" value="${jobSeeker.email}" required readonly>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Headline/Chức danh</label>
                            <input type="text" name="headline" id="headline" value="${jobSeeker.headline}" placeholder="VD: Software Engineer">
                        </div>
                        <div class="form-group">
                            <label>Cấp bậc hiện tại</label>
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
                            <input type="tel" pattern="[0-9]{10,11}" name="phone" id="phone" value="${jobSeeker.phone}"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                            <span id="phoneError" style="color:red"></span>
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
                            <label>Địa điểm</label>
                            <select name="locationID">
                                <option value="">Chọn địa điểm</option>
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
                    <c:if test="${not empty error}">
                        <p style="color:red">${error}</p>
                    </c:if>
                </form>                    
            </div>

                <div class="modal-footer">
                    <button class="cancel-btn" onclick="closeProfileModal()">Hủy</button>
                    <button class="save-btn" type="submit" form="profileForm">Lưu</button>
                </div>
        </div>
    </div>
    </main>

    <script>
        // Định nghĩa contextPath để sử dụng trong JavaScript
        const contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/JobSeeker/script.js"></script>
    <script>
            (function(){
                const toggle = document.getElementById('menuToggle');
                const panel = document.getElementById('megaMenu');
                if(!toggle || !panel) return;
                function closeOnOutside(e){
                    if(!panel.contains(e.target) && !toggle.contains(e.target)){
                        panel.classList.remove('open');
                        document.removeEventListener('click', closeOnOutside);
                    }
                }
                toggle.addEventListener('click', function(e){
                    e.stopPropagation();
                    panel.classList.toggle('open');
                    if(panel.classList.contains('open')){
                        document.addEventListener('click', closeOnOutside);
                    }
                });
            })();
            
            // Toggle hiển thị menu 3 chấm
            document.addEventListener("click", function (e) {
                if (e.target.closest(".file-menu-btn")) {
                    const dropdown = e.target.closest(".file-actions").querySelector(".file-dropdown");
                    dropdown.classList.toggle("active");
                } else {
                    document.querySelectorAll(".file-dropdown").forEach(d => d.classList.remove("active"));
                }
            });

    </script>
    
    <script>
// Xóa function toggleSearchable thứ hai (ở cuối file) và chỉ giữ lại function này:

function toggleSearchable(cvId, isChecked) {
    console.log('toggleSearchable called:', cvId, isChecked);
    
    fetch(contextPath + "/ToggleSearchableServlet", {
        method: "POST",
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `cvId=${cvId}&searchable=${isChecked}`
    })
    .then(response => {
        console.log('Response status:', response.status);
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        console.log('Response data:', data);
        if (data.success) {
            const message = isChecked ? 'Đã bật tìm kiếm hồ sơ' : 'Đã tắt tìm kiếm hồ sơ';
            showNotification(message, 'success');
        } else {
            showNotification(data.message || 'Không thể cập nhật trạng thái hồ sơ!', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Có lỗi xảy ra khi cập nhật trạng thái hồ sơ!', 'error');
        // Revert checkbox state nếu có lỗi
        const checkbox = document.querySelector(`input[onchange*="${cvId}"]`);
        if (checkbox) {
            checkbox.checked = !isChecked;
        }
    });
}
    </script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const uploadForm = document.getElementById('uploadForm');
            const uploadArea = document.querySelector('.upload-area');
            const fileInput = document.getElementById('cvFileInput');
            const uploadText = document.getElementById('uploadText');
            const uploadIcon = document.getElementById('uploadIcon');
            const uploadNote = document.getElementById('uploadNote');
            const submitBtn = document.getElementById('submitBtn');
            const clearBtn = document.getElementById('clearBtn');

            // ========== File Input Change ==========
            fileInput.addEventListener('change', function() {
                console.log('File input changed, files:', this.files);
                
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileNameLower = fileName.toLowerCase();
                    const fileSize = (file.size / 1024).toFixed(2);
                    
                    console.log('File details:', fileName, fileSize + 'KB');

                    // Kiểm tra loại file
                    const allowedTypes = ['.doc', '.docx', '.pdf'];
                    const isValidType = allowedTypes.some(type => fileNameLower.includes(type));
                    
                    if (!isValidType) {
                        showNotification('Chỉ hỗ trợ file .doc, .docx, .pdf', 'error');
                        this.value = ''; // Clear input
                        resetUploadArea();
                        return;
                    }
                    
                    // Kiểm tra kích thước file (5MB = 5 * 1024 * 1024 bytes)
                    if (file.size > 5 * 1024 * 1024) {
                        showNotification('File không được vượt quá 5MB', 'error');
                        this.value = ''; // Clear input
                        resetUploadArea();
                        return;
                    }

                    // Xác định icon theo loại file
                    let iconClass = 'fas fa-file';
                    if (fileNameLower.includes('.pdf')) {
                        iconClass = 'fas fa-file-pdf';
                    } else if (fileNameLower.includes('.doc')) {
                        iconClass = 'fas fa-file-word';
                    }

                    // Cập nhật giao diện
                    uploadIcon.className = iconClass;
                    uploadText.innerHTML = '<strong>' + fileName + '</strong><br><small>(' + fileSize + ' KB)</small>';
                    uploadNote.style.color = '#10b981';
                    uploadNote.innerHTML = '<i class="fas fa-check-circle"></i> File đã sẵn sàng để tải lên';
                    uploadArea.style.borderColor = '#10b981';
                    uploadArea.style.background = 'linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%)';
                    uploadArea.classList.add('file-selected');
                    
                    // Hiển thị nút submit và clear với hiệu ứng
                    submitBtn.style.display = 'inline-flex';
                    clearBtn.style.display = 'inline-flex';
                    setTimeout(() => {
                        submitBtn.style.opacity = '1';
                        submitBtn.style.transform = 'translateY(0)';
                        clearBtn.classList.add('show');
                    }, 100);

                    console.log('UI updated for file:', fileName);
                } else {
                    console.log('No file selected, resetting upload area');
                    // Reset về trạng thái ban đầu
                    resetUploadArea();
                }
            });

            // ========== Drag & Drop ==========
            ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, preventDefaults, false);
            });

            function preventDefaults(e) {
                e.preventDefault();
                e.stopPropagation();
            }

            ['dragenter', 'dragover'].forEach(eventName => {
                uploadArea.addEventListener(eventName, () => {
                    uploadArea.classList.add('drag-over');
                });
            });

            ['dragleave', 'drop'].forEach(eventName => {
                uploadArea.addEventListener(eventName, () => {
                    uploadArea.classList.remove('drag-over');
                });
            });

            uploadArea.addEventListener('drop', function(e) {
                console.log('File dropped');
                const dt = e.dataTransfer;
                const files = dt.files;

                if (files.length > 0) {
                    // Kiểm tra loại file
                    const file = files[0];
                    const fileName = file.name.toLowerCase();
                    const allowedTypes = ['.doc', '.docx', '.pdf'];
                    const isValidType = allowedTypes.some(type => fileName.includes(type));
                    
                    if (!isValidType) {
                        showNotification('Chỉ hỗ trợ file .doc, .docx, .pdf', 'error');
                        return;
                    }
                    
                    // Kiểm tra kích thước file (5MB = 5 * 1024 * 1024 bytes)
                    if (file.size > 5 * 1024 * 1024) {
                        showNotification('File không được vượt quá 5MB', 'error');
                        return;
                    }
                    
                    fileInput.files = files;

                    // Trigger change event manually
                    const event = new Event('change', { bubbles: true });
                    fileInput.dispatchEvent(event);
                    
                    console.log('File dropped and processed:', file.name);
                }
            });

            // ========== Reset Upload Area ==========
            function resetUploadArea() {
                uploadIcon.className = 'fas fa-cloud-upload-alt';
                uploadText.textContent = 'Chọn hoặc kéo thả hồ sơ từ máy của bạn';
                uploadNote.style.color = '';
                uploadNote.innerHTML = '<i class="fas fa-info-circle"></i> Hỗ trợ định dạng .doc, .docx, .pdf có kích thước dưới 5MB';
                uploadArea.style.borderColor = '';
                uploadArea.style.background = '';
                uploadArea.classList.remove('file-selected');
                
                // Ẩn nút submit và clear với hiệu ứng
                if (submitBtn) {
                    submitBtn.style.opacity = '0';
                    submitBtn.style.transform = 'translateY(10px)';
                    setTimeout(() => {
                        submitBtn.style.display = 'none';
                    }, 200);
                }
                
                if (clearBtn) {
                    clearBtn.classList.remove('show');
                    setTimeout(() => {
                        clearBtn.style.display = 'none';
                    }, 200);
                }
                
                console.log('Upload area reset to default state');
            }

            // ========== Form Submit ==========
            uploadForm.addEventListener('submit', function(e) {
                if (!fileInput.files || !fileInput.files[0]) {
                    e.preventDefault();
                    showNotification('Vui lòng chọn file trước khi tải lên', 'error');
                    return false;
                }

                submitBtn.classList.add('loading');
                submitBtn.disabled = true;

                // Tạo icon loading
                const loadingIcon = document.createElement('i');
                loadingIcon.className = 'fas fa-spinner fa-spin';
                loadingIcon.style.marginRight = '8px';

                submitBtn.textContent = 'Đang tải lên...';
                submitBtn.insertBefore(loadingIcon, submitBtn.firstChild);

                console.log('Form submitting...');
            });

            // ========== Close Dropdowns on Outside Click ==========
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.file-actions')) {
                    document.querySelectorAll('.file-dropdown').forEach(dropdown => {
                        dropdown.classList.remove('active');
                    });
                }
            });
        });

        // ========== Toggle Dropdown ==========        
        function toggleDropdown(event, button) {
            event.stopPropagation();

            // Close all other dropdowns
            document.querySelectorAll('.file-dropdown').forEach(dropdown => {
                if (dropdown !== button.nextElementSibling) {
                    dropdown.classList.remove('active');
                }
            });

            // Toggle current dropdown
            const dropdown = button.nextElementSibling;
            dropdown.classList.toggle('active');
        }

        // ========== Clear Selected File Function ==========        
        function clearSelectedFile() {
            const fileInput = document.getElementById('cvFileInput');
            const uploadArea = document.querySelector('.upload-area');
            
            if (fileInput) {
                fileInput.value = ''; // Clear file input
                
                // Trigger change event to reset UI
                const event = new Event('change', { bubbles: true });
                fileInput.dispatchEvent(event);
                
                console.log('File selection cleared');
                showNotification('Đã bỏ chọn file', 'success');
            }
        }

        // ========== Show Notification ==========        
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.textContent = message;

            const bgColor = type === 'success' ? '#10b981' : '#ef4444';

            notification.style.position = 'fixed';
            notification.style.top = '20px';
            notification.style.right = '20px';
            notification.style.background = bgColor;
            notification.style.color = 'white';
            notification.style.padding = '16px 24px';
            notification.style.borderRadius = '8px';
            notification.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
            notification.style.zIndex = '9999';
            notification.style.animation = 'slideIn 0.3s ease';

            document.body.appendChild(notification);

            setTimeout(function() {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(function() {
                    notification.remove();
                }, 300);
            }, 3000);
        }

        // Add CSS for notification animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from {
                    transform: translateX(400px);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(400px);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // ========== Profile Modal Reset Logic ==========        
        // Lưu giá trị gốc khi mở modal
        let originalProfileData = {};

        function openProfileModal() {
            // Lưu lại giá trị gốc khi mở modal
            const form = document.getElementById('profileForm');
            if (form) {
                originalProfileData = {
                    fullName: form.fullName.value,
                    email: form.email.value,
                    headline: form.headline.value,
                    currentLevelID: form.currentLevelID.value,
                    phone: form.phone.value,
                    gender: form.gender.value,
                    locationID: form.locationID.value,
                    status: form.status.value,
                    address: form.address.value,
                    contactInfo: form.contactInfo.value
                };
            }
            document.getElementById('profileModal').classList.add('show');
        }

        function closeProfileModal() {
            // Reset lại form về giá trị gốc
            const form = document.getElementById('profileForm');
            if (form && originalProfileData && Object.keys(originalProfileData).length > 0) {
                form.fullName.value = originalProfileData.fullName;
                form.email.value = originalProfileData.email;
                form.headline.value = originalProfileData.headline;
                form.currentLevelID.value = originalProfileData.currentLevelID;
                form.phone.value = originalProfileData.phone;
                form.gender.value = originalProfileData.gender;
                form.locationID.value = originalProfileData.locationID;
                form.status.value = originalProfileData.status;
                form.address.value = originalProfileData.address;
                form.contactInfo.value = originalProfileData.contactInfo;
                // Xóa thông báo lỗi nếu có
                const fullNameError = document.getElementById('fullNameError');
                if (fullNameError) fullNameError.textContent = '';
                const phoneError = document.getElementById('phoneError');
                if (phoneError) phoneError.textContent = '';
            }
            document.getElementById('profileModal').classList.remove('show');
        }
    </script>
<script>
    // ========== Validation Functions ==========
    
    // Validate Họ và tên
    function validateFullName() {
        let name = document.getElementById("fullName").value.trim();
        let error = document.getElementById("fullNameError");

        if (name.length === 0) {
            error.textContent = "Họ và tên không được để trống.";
            return false;
        }

        if (name.length > 100) {
            error.textContent = "Họ và tên không được vượt quá 100 ký tự.";
            return false;
        }

        let regex = /^[\p{L}\s]+$/u; 
        if (!regex.test(name)) {
            error.textContent = "Họ và tên chỉ được chứa chữ cái và khoảng trắng.";
            return false;
        }

        error.textContent = "";
        return true;
    }

    // Validate Số điện thoại
    function validatePhone() {
        let phone = document.getElementById("phone").value.trim();
        let error = document.getElementById("phoneError");

        // Nếu để trống thì bỏ qua (không bắt buộc)
        if (phone.length === 0) {
            error.textContent = "";
            return true;
        }

        // Kiểm tra chỉ chứa số
        if (!/^\d+$/.test(phone)) {
            error.textContent = "Số điện thoại chỉ được chứa chữ số.";
            return false;
        }

        // Kiểm tra độ dài 10-11 số
        if (phone.length < 10 || phone.length > 11) {
            error.textContent = "Số điện thoại phải có 10-11 chữ số.";
            return false;
        }

        error.textContent = "";
        return true;
    }

    // Validate Headline
    function validateHeadline(input) {
        const maxLength = 200;
        if (input.value.length > maxLength) {
            input.value = input.value.substring(0, maxLength);
            showNotification(`Headline không được vượt quá 200 ký tự`, 'error');
            return false;
        }
        return true;
    }

    // Validate Địa chỉ chi tiết
    function validateAddress(textarea) {
        const maxLength = 255;
        if (textarea.value.length > maxLength) {
            textarea.value = textarea.value.substring(0, maxLength);
            showNotification(`Địa chỉ không được vượt quá 255 ký tự`, 'error');
            return false;
        }
        return true;
    }

    // Validate Thông tin liên hệ
    function validateContactInfo(textarea) {
        const maxLength = 255;
        if (textarea.value.length > maxLength) {
            textarea.value = textarea.value.substring(0, maxLength);
            showNotification(`Thông tin liên hệ không được vượt quá 255 ký tự`, 'error');
            return false;
        }
        return true;
    }

    // ========== Real-time Validation ==========
    document.addEventListener('DOMContentLoaded', function() {
        const fullNameInput = document.getElementById('fullName');
        const phoneInput = document.getElementById('phone');
        const headlineInput = document.querySelector('input[name="headline"]');
        const addressTextarea = document.querySelector('textarea[name="address"]');
        const contactInfoTextarea = document.querySelector('textarea[name="contactInfo"]');

        // Real-time validate cho Họ và tên
        if (fullNameInput) {
            fullNameInput.addEventListener('blur', validateFullName);
            fullNameInput.addEventListener('input', function() {
                if (this.value.length > 100) {
                    this.value = this.value.substring(0, 100);
                    showNotification('Họ và tên không được vượt quá 100 ký tự', 'error');
                }
            });
        }

        // Real-time validate cho Số điện thoại
        if (phoneInput) {
            phoneInput.addEventListener('blur', validatePhone);
            phoneInput.addEventListener('input', function() {
                // Chỉ cho phép nhập số
                this.value = this.value.replace(/[^0-9]/g, '');
                
                // Giới hạn 11 ký tự
                if (this.value.length > 11) {
                    this.value = this.value.substring(0, 11);
                    showNotification('Số điện thoại không được vượt quá 11 số', 'error');
                }
            });
        }

        // Real-time validate cho Headline
        if (headlineInput) {
            headlineInput.addEventListener('input', function() {
                validateHeadline(this);
            });
        }

        // Real-time validate cho Địa chỉ
        if (addressTextarea) {
            addressTextarea.addEventListener('input', function() {
                validateAddress(this);
            });
        }

        // Real-time validate cho Thông tin liên hệ
        if (contactInfoTextarea) {
            contactInfoTextarea.addEventListener('input', function() {
                validateContactInfo(this);
            });
        }

        // ========== Form Submit Validation ==========
        const profileForm = document.getElementById('profileForm');
        if (profileForm) {
            profileForm.addEventListener('submit', function(e) {
                let isValid = true;

                // Validate Họ và tên (bắt buộc)
                if (!validateFullName()) {
                    isValid = false;
                }

                // Validate Số điện thoại (không bắt buộc nhưng phải đúng format nếu có)
                if (!validatePhone()) {
                    isValid = false;
                }

                // Validate các field khác
                if (headlineInput && !validateHeadline(headlineInput)) {
                    isValid = false;
                }

                if (addressTextarea && !validateAddress(addressTextarea)) {
                    isValid = false;
                }

                if (contactInfoTextarea && !validateContactInfo(contactInfoTextarea)) {
                    isValid = false;
                }

                // Nếu có lỗi, ngăn submit
                if (!isValid) {
                    e.preventDefault();
                    showNotification('Vui lòng kiểm tra lại thông tin nhập vào', 'error');
                    return false;
                }
            });
        }
    });

</script>
</body>
</html>

