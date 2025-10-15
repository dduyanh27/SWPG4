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
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<style>
    /* ========== GLOBAL STYLES ========== */
    body {
        font-size: 16px;
        line-height: 1.6;
    }
    
    * {
        box-sizing: border-box;
    }
    
    /* ========== TWO COLUMN LAYOUT ========== */
    .main-container.full-width {
        max-width: 95%;
        margin: 0 auto;
        padding: 30px 3%;
        display: grid;
        grid-template-columns: 1fr 360px;
        gap: 35px;
        align-items: start;
    }

    .main-container.full-width .main-content {
        width: 100%;
        max-width: none;
        min-width: 0;
    }

    .content-header {
        text-align: left;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #e5e7eb;
    }

    .content-header h1 {
        font-size: 2.75rem;
        color: #1f2937;
        margin-bottom: 8px;
        font-weight: 700;
    }

    .content-header .subtitle {
        font-size: 1.25rem;
        color: #6b7280;
    }

    /* ========== DASHBOARD SECTION ========== */
    .dashboard-section {
        margin-bottom: 30px;
        background: white;
        border-radius: 16px;
        padding: 32px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .section-title {
        font-size: 2rem;
        color: #1f2937;
        margin-bottom: 26px;
        display: flex;
        align-items: center;
        gap: 12px;
        font-weight: 700;
    }

    .section-title i {
        color: #0a67ff;
        font-size: 1.85rem;
    }

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 18px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
        border-radius: 14px;
        padding: 24px;
        display: flex;
        align-items: center;
        gap: 18px;
        border: 1px solid #e5e7eb;
        transition: all 0.3s ease;
    }

    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border-color: #0a67ff;
    }

    .stat-icon {
        width: 64px;
        height: 64px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32px;
        flex-shrink: 0;
    }

    .stat-icon.cv-icon {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .stat-icon.applied-icon {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        color: white;
    }

    .stat-icon.saved-icon {
        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        color: white;
    }

    .stat-icon.view-icon {
        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        color: white;
    }

    .stat-info h3 {
        font-size: 2.5rem;
        font-weight: 700;
        color: #1f2937;
        margin: 0 0 4px 0;
    }

    .stat-info p {
        font-size: 1.15rem;
        color: #6b7280;
        margin: 0;
        font-weight: 500;
    }

    /* Recent Activities */
    .recent-activities {
        background: #f9fafb;
        border-radius: 14px;
        padding: 26px;
        border: 1px solid #e5e7eb;
    }

    .recent-activities h3 {
        font-size: 1.65rem;
        color: #1f2937;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
    }

    .recent-activities h3 i {
        color: #0a67ff;
        font-size: 1.5rem;
    }

    .activity-list {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }

    .activity-item {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 16px;
        background: white;
        border-radius: 12px;
        transition: all 0.2s;
        border: 1px solid #e5e7eb;
    }

    .activity-item:hover {
        background: #f8f9fa;
        border-color: #d1d5db;
    }

    .activity-icon {
        width: 54px;
        height: 54px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        flex-shrink: 0;
    }

    .activity-icon.apply {
        background: #fef3c7;
        color: #f59e0b;
    }

    .activity-icon.save {
        background: #dbeafe;
        color: #3b82f6;
    }

    .activity-icon.upload {
        background: #d1fae5;
        color: #10b981;
    }

    .activity-content {
        flex: 1;
        min-width: 0;
    }

    .activity-title {
        font-size: 1.15rem;
        color: #1f2937;
        margin: 0 0 6px 0;
        font-weight: 500;
    }

    .activity-title strong {
        color: #0a67ff;
        font-weight: 600;
    }

    .activity-meta {
        font-size: 1rem;
        color: #6b7280;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .activity-meta .separator {
        color: #d1d5db;
    }

    .activity-status {
        padding: 8px 14px;
        border-radius: 18px;
        font-size: 1rem;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 5px;
        white-space: nowrap;
    }

    .activity-status.pending {
        background: #fef3c7;
        color: #f59e0b;
    }

    .activity-status.accepted {
        background: #d1fae5;
        color: #10b981;
    }

    .activity-status.interview {
        background: #dbeafe;
        color: #3b82f6;
    }

    .activity-status.rejected {
        background: #fee2e2;
        color: #ef4444;
    }

    /* Profile Completion */
    .profile-completion {
        background: #f9fafb;
        border-radius: 14px;
        padding: 26px;
        border: 1px solid #e5e7eb;
        margin-top: 20px;
    }

    .profile-completion h3 {
        font-size: 1.65rem;
        color: #1f2937;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
    }

    .profile-completion h3 i {
        color: #0a67ff;
        font-size: 1.5rem;
    }

    .completion-bar {
        width: 100%;
        height: 36px;
        background: #e5e7eb;
        border-radius: 16px;
        overflow: hidden;
        margin-bottom: 22px;
    }

    .completion-progress {
        height: 100%;
        background: linear-gradient(90deg, #0a67ff 0%, #667eea 100%);
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding-right: 14px;
        transition: width 0.5s ease;
    }

    .completion-progress span {
        color: white;
        font-weight: 700;
        font-size: 1.1rem;
    }

    .completion-checklist {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }

    .checklist-item {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 1.1rem;
        color: #6b7280;
    }

    .checklist-item.completed {
        color: #10b981;
    }

    .checklist-item i {
        font-size: 1.35rem;
    }

    .checklist-item.completed i {
        color: #10b981;
    }

    .checklist-item:not(.completed) i {
        color: #d1d5db;
    }

    /* ========== RIGHT SIDEBAR ========== */
    .right-sidebar {
        position: sticky;
        top: 20px;
        max-height: calc(100vh - 40px);
        overflow-y: auto;
        background: white;
        border-radius: 18px;
        padding: 32px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .right-sidebar::-webkit-scrollbar {
        width: 8px;
    }

    .right-sidebar::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 4px;
    }

    .right-sidebar::-webkit-scrollbar-thumb {
        background: #c1c1c1;
        border-radius: 4px;
    }

    .right-sidebar h2 {
        font-size: 1.85rem;
        font-weight: 700;
        color: #1f2937;
        margin: 0 0 24px 0;
        padding-bottom: 16px;
        border-bottom: 3px solid #e5e7eb;
    }

    .job-listings,
    .company-listings {
        display: flex;
        flex-direction: column;
        gap: 18px;
        margin-bottom: 36px;
    }

    .job-card,
    .company-card {
        display: flex;
        gap: 18px;
        padding: 20px;
        background: #f9fafb;
        border-radius: 14px;
        transition: all 0.3s;
        cursor: pointer;
        border: 2px solid #e5e7eb;
    }

    .job-card:hover,
    .company-card:hover {
        background: white;
        box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        transform: translateY(-3px);
        border-color: #0a67ff;
    }

    .company-logo {
        flex-shrink: 0;
    }

    .logo-placeholder {
        width: 70px;
        height: 70px;
        border-radius: 12px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.9rem;
        font-weight: 700;
        box-shadow: 0 2px 8px rgba(102,126,234,0.3);
    }

    .job-info,
    .company-info {
        flex: 1;
        min-width: 0;
    }

    .job-info h4,
    .company-info h4 {
        font-size: 1.35rem;
        font-weight: 700;
        color: #1f2937;
        margin: 0 0 10px 0;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        white-space: normal;
        line-height: 1.4;
    }

    .job-info p,
    .company-info p {
        font-size: 1.15rem;
        color: #6b7280;
        margin: 6px 0;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        line-height: 1.5;
    }

    .job-info .company {
        color: #4b5563;
        font-weight: 600;
        font-size: 1.1rem;
    }

    .job-info .salary {
        color: #059669;
        font-weight: 700;
        font-size: 1.2rem;
    }

    .job-info .location {
        color: #6b7280;
        font-size: 1.05rem;
    }

    .company-info .followers,
    .company-info .jobs {
        color: #6b7280;
    }

    .zalo-chat {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 56px;
        height: 56px;
        background: linear-gradient(135deg, #0084ff 0%, #0063d1 100%);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 28px;
        box-shadow: 0 4px 20px rgba(0,132,255,0.4);
        cursor: pointer;
        transition: all 0.3s ease;
        z-index: 1000;
    }

    .zalo-chat:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 24px rgba(0,132,255,0.6);
    }

    /* ========== PROFILE INFO CARD OVERRIDE ========== */
    .profile-info-card {
        background: white !important;
        border-radius: 16px !important;
        padding: 2.5rem !important;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1) !important;
        margin-bottom: 2rem !important;
        position: relative !important;
    }

    .profile-header {
        display: flex !important;
        gap: 2rem !important;
        align-items: flex-start !important;
    }

    .profile-avatar-large {
        width: 110px !important;
        height: 110px !important;
        background: #0066cc !important;
        border-radius: 50% !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: white !important;
        font-size: 3rem !important;
        flex-shrink: 0 !important;
    }

    .profile-details h2 {
        color: #333 !important;
        font-size: 2.2rem !important;
        margin-bottom: 0.5rem !important;
        font-weight: 700 !important;
        line-height: 1.3 !important;
    }

    .profile-details .job-title {
        color: #666 !important;
        font-size: 1.4rem !important;
        margin-bottom: 1.2rem !important;
        line-height: 1.4 !important;
    }

    .profile-meta {
        display: flex !important;
        flex-direction: column !important;
        gap: 0.8rem !important;
    }

    .profile-meta .meta-item {
        display: flex !important;
        align-items: center !important;
        gap: 1rem !important;
        color: #555 !important;
        font-size: 1.2rem !important;
        line-height: 1.5 !important;
    }

    .profile-meta .meta-item i {
        color: #0066cc !important;
        width: 24px !important;
        text-align: center !important;
        font-size: 1.3rem !important;
        flex-shrink: 0 !important;
    }

    .edit-profile-btn {
        position: absolute !important;
        top: 1.5rem !important;
        right: 1.5rem !important;
        background: #f8f9fa !important;
        border: 1px solid #e9ecef !important;
        color: #666 !important;
        width: 52px !important;
        height: 52px !important;
        border-radius: 50% !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        cursor: pointer !important;
        transition: all 0.2s !important;
        font-size: 1.2rem !important;
    }

    .edit-profile-btn:hover {
        background: #0066cc !important;
        color: white !important;
        border-color: #0066cc !important;
        transform: scale(1.08) !important;
    }

    /* ========== RESPONSIVE ========== */
    @media (max-width: 768px) {
        .content-header h1 {
            font-size: 1.8rem;
        }

        .stats-grid {
            grid-template-columns: 1fr;
        }

        .stat-card {
            padding: 20px;
        }

        .activity-item {
            flex-direction: column;
            align-items: flex-start;
        }

        .activity-status {
            align-self: flex-start;
        }

        .completion-checklist {
            grid-template-columns: 1fr;
        }
    }

    /* Profile Modal Styles - Responsive Fixed Version */
.main-content {
    position: relative;
    overflow: visible;
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
    max-width: 1200px;
    background: white;
    border-radius: 16px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    /* Sử dụng calc để tính toán chiều cao dựa trên viewport */
    height: calc(70vh); /* 40px = padding top + bottom */
    max-height: 850px; /* Giới hạn chiều cao tối đa */
    min-height: 600px; /* Chiều cao tối thiểu */
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
    padding: 1.5rem 2rem;
    border-bottom: 1px solid #e9ecef;
    background: white;
    border-radius: 16px 16px 0 0;
    flex-shrink: 0; /* Không cho phép co lại */
}

.profile-modal .modal-header h2 {
    color: #333;
    font-size: 1.6rem;
    margin: 0;
    font-weight: 600;
}

.profile-modal .modal-close {
    background: none;
    border: none;
    font-size: 1.5rem;
    color: #666;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 50%;
    transition: background-color 0.2s;
    width: 42px;
    height: 42px;
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
    padding: 2rem;
    /* Đảm bảo có thể cuộn được */
    min-height: 0;
}

.profile-modal .modal-footer {
    padding: 1.25rem 2rem;
    border-top: 1px solid #e9ecef;
    background: white;
    border-radius: 0 0 16px 16px;
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    flex-shrink: 0; /* Không cho phép co lại */
}

/* Form styles inside modal */
.profile-modal .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
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
    font-size: 1.1rem;
    font-weight: 500;
    margin-bottom: 0.6rem;
}

.profile-modal .form-group input,
.profile-modal .form-group select,
.profile-modal .form-group textarea {
    padding: 0.9rem 1rem;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 1.05rem;
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
    min-height: 100px;
    resize: vertical;
}

.required-note {
    color: #666;
    font-size: 1rem;
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
    padding: 0.9rem 2rem;
    border-radius: 8px;
    font-weight: 500;
    font-size: 1.05rem;
    cursor: pointer;
    transition: background-color 0.2s;
    min-width: 100px;
}

.save-btn:hover {
    background: #e55a2b;
}

.cancel-btn {
    background: #f8f9fa;
    color: #333;
    border: 1px solid #ddd;
    padding: 0.9rem 2rem;
    border-radius: 8px;
    font-weight: 500;
    font-size: 1.05rem;
    cursor: pointer;
    transition: all 0.2s;
    min-width: 100px;
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
@media (max-width: 1400px) {
    .main-container.full-width {
        max-width: 100%;
        padding: 30px 30px;
    }
}

@media (max-width: 1200px) {
    .main-container.full-width {
        padding: 25px 25px;
        grid-template-columns: 1fr 320px;
        gap: 25px;
    }
    
    .stats-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 1024px) {
    .main-container.full-width {
        grid-template-columns: 1fr;
        padding: 20px;
    }
    
    .right-sidebar {
        display: none;
    }
    
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .main-container.full-width {
        padding: 20px;
    }
    
    .content-header h1 {
        font-size: 1.5rem;
    }
    
    .content-header .subtitle {
        font-size: 0.9rem;
    }
    
    .dashboard-section {
        padding: 20px;
    }
    
    .section-title {
        font-size: 1.25rem;
    }
    
    .stats-grid {
        grid-template-columns: 1fr;
        gap: 12px;
    }
    
    .stat-card {
        padding: 16px;
    }
    
    .stat-icon {
        width: 44px;
        height: 44px;
        font-size: 18px;
    }
    
    .stat-info h3 {
        font-size: 1.5rem;
    }
    
    .recent-activities,
    .profile-completion {
        padding: 20px;
    }
    
    .profile-modal.show {
        padding: 10px;
    }
    
    .profile-modal .modal-content {
        height: calc(100vh - 20px);
        max-height: none;
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
        overflow: visible;
    }

    .profile-documents-section h3 {
        font-size: 1.85rem;
        font-weight: 700;
        color: var(--text-dark);
        margin: 0 0 26px 0;
        display: flex;
        align-items: center;
        gap: 14px;
    }

    .profile-documents-section h3::before {
        content: '\f15c';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        color: var(--primary);
        font-size: 2rem;
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
        font-size: 1.15rem;
        font-weight: 600;
        color: var(--text-dark);
    }

    .upload-note {
        color: var(--text-muted);
        font-size: 1.05rem;
        margin: 16px 0;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
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
        padding: 16px 36px;
        border-radius: 30px;
        font-size: 1.15rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(10,103,255,0.3);
        display: none; /* Ban đầu ẩn nút submit */
        align-items: center;
        gap: 10px;
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
        padding: 10px 20px;
        border-radius: 22px;
        font-size: 1.05rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        display: none;
        align-items: center;
        gap: 8px;
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
        position: relative;
        z-index: 1;
        padding-bottom: 20px; /* Khoảng trống nhỏ ở dưới cùng */
    }

    .file-item {
        background: white;
        border: 2px solid var(--border);
        border-radius: var(--radius-md);
        padding: 26px;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 24px;
        transition: all 0.3s ease;
        position: relative;
        z-index: 1;
    }

    .file-item:has(.file-dropdown.active) {
        z-index: 20;
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
        font-size: 1.35rem;
        font-weight: 700;
        color: var(--text-dark);
        margin: 0 0 14px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .file-info h4::before {
        content: '\f1c2';
        font-family: 'Font Awesome 6 Free';
        font-weight: 900;
        color: var(--primary);
        font-size: 1.5rem;
    }

    .file-meta {
        display: flex;
        align-items: center;
        gap: 10px;
        color: var(--text-muted);
        font-size: 1.1rem;
        margin-bottom: 14px;
    }

    .file-meta i {
        color: var(--primary);
        font-size: 1.15rem;
    }

    .view-as-recruiter {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        color: var(--primary);
        text-decoration: none;
        font-size: 1.05rem;
        font-weight: 600;
        padding: 8px 14px;
        border-radius: 8px;
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
        z-index: 10;
    }

    .file-menu-btn {
        background: var(--bg-light);
        border: 2px solid var(--border);
        width: 48px;
        height: 48px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
        color: var(--text-muted);
        font-size: 1.15rem;
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
        min-width: 280px;
        padding: 10px;
        display: none;
        z-index: 9999;
        animation: slideDown 0.3s ease;
    }

    /* Dropdown mở lên trên cho item cuối */
    .file-item:last-child .file-dropdown {
        top: auto;
        bottom: calc(100% + 8px);
        animation: slideUp 0.3s ease;
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
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
        gap: 14px;
        padding: 14px 18px;
        color: var(--text-dark);
        text-decoration: none;
        border-radius: 10px;
        transition: all 0.2s;
        cursor: pointer;
    }

    .dropdown-item:hover {
        background: var(--bg-light);
    }

    .dropdown-item i {
        color: var(--primary);
        width: 22px;
        text-align: center;
        font-size: 1.1rem;
    }

    .dropdown-item span:first-child {
        flex: 1;
        font-size: 1.05rem;
        font-weight: 500;
    }

    .dropdown-item.toggle-item {
        padding: 14px 18px;
        cursor: default;
    }

    .dropdown-item.toggle-item:hover {
        background: transparent;
    }

    .dropdown-divider {
        height: 1px;
        background: var(--border);
        margin: 4px 0;
    }

    .dropdown-item.delete-item {
        color: var(--danger);
    }

    .dropdown-item.delete-item i {
        color: var(--danger);
    }

    .dropdown-item.delete-item:hover {
        background: rgba(239, 68, 68, 0.1);
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
    
    <!-- Main Content (Full Width - No Sidebar) -->
    <div class="main-container full-width">
        <main class="main-content">
            <div class="content-header">
                <h1>Hồ Sơ & Tổng Quan</h1>
                <p class="subtitle">Quản lý thông tin cá nhân và theo dõi hoạt động tìm việc của bạn</p>
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
                                    <div class="dropdown-item toggle-item">
                                        <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                                            <i class="fas fa-search"></i>
                                            <span style="flex: 1;">Cho phép NTD tìm kiếm</span>
                                            <label class="toggle-switch" onclick="event.stopPropagation();">
                                                <input type="checkbox" 
                                                       data-cv-id="${cv.cvId}" 
                                                       ${cv.active ? 'checked' : ''}
                                                       onchange="toggleCVSearch(this, ${cv.cvId})">
                                                <span class="slider"></span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="dropdown-divider"></div>
                                    <a href="#" 
                                       class="dropdown-item delete-item"
                                       onclick="confirmDeleteCV(event, ${cv.cvId}, '${cv.cvTitle}')">
                                        <i class="fas fa-trash-alt"></i>
                                        <span>Xóa hồ sơ</span>
                                    </a>
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

            <!-- Dashboard / Statistics Section -->
            <div class="dashboard-section">
                <h2 class="section-title">
                    <i class="fas fa-chart-line"></i>
                    Thống kê hoạt động
                </h2>
                
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon cv-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${cvCount != null ? cvCount : 0}</h3>
                            <p>CV đã tải lên</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon applied-icon">
                            <i class="fas fa-paper-plane"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${totalApplications != null ? totalApplications : 0}</h3>
                            <p>Đơn đã ứng tuyển</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon saved-icon">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${savedJobsCount != null ? savedJobsCount : 0}</h3>
                            <p>Việc đã lưu</p>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon view-icon">
                            <i class="fas fa-eye"></i>
                        </div>
                        <div class="stat-info">
                            <h3>${profileViews != null ? profileViews : 0}</h3>
                            <p>Lượt xem hồ sơ</p>
                        </div>
                    </div>
                </div>

                <!-- Application Status Chart -->
                <div class="chart-container" style="margin-bottom: 30px;">
                    <h3 style="font-size: 1.3rem; color: #1f2937; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-chart-pie"></i> Trạng thái ứng tuyển
                    </h3>
                    <div style="display: flex; justify-content: center; align-items: center; padding: 10px;">
                        <div style="width: 250px; height: 250px;">
                            <canvas id="applicationStatusChart"></canvas>
                        </div>
                    </div>
                    <div class="chart-legend" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-top: 20px;">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 16px; height: 16px; background: #FFA500; border-radius: 4px;"></span>
                            <span style="font-size: 14px; color: #6b7280;">Đang chờ: <strong>${pendingCount != null ? pendingCount : 0}</strong></span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 16px; height: 16px; background: #4CAF50; border-radius: 4px;"></span>
                            <span style="font-size: 14px; color: #6b7280;">Chấp thuận: <strong>${acceptedCount != null ? acceptedCount : 0}</strong></span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 16px; height: 16px; background: #2196F3; border-radius: 4px;"></span>
                            <span style="font-size: 14px; color: #6b7280;">Phỏng vấn: <strong>${interviewCount != null ? interviewCount : 0}</strong></span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 16px; height: 16px; background: #F44336; border-radius: 4px;"></span>
                            <span style="font-size: 14px; color: #6b7280;">Từ chối: <strong>${rejectedCount != null ? rejectedCount : 0}</strong></span>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="recent-activities">
                    <h3><i class="fas fa-clock"></i> Hoạt động gần đây</h3>
                    <div class="activity-list">
                        <!-- Recent Applications -->
                        <c:if test="${not empty recentApplications}">
                            <c:forEach var="app" items="${recentApplications}" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="activity-item">
                                        <div class="activity-icon apply">
                                            <i class="fas fa-paper-plane"></i>
                                        </div>
                                        <div class="activity-content">
                                            <p class="activity-title">Ứng tuyển <strong>${app.jobTitle}</strong></p>
                                            <p class="activity-meta">
                                                <i class="fas fa-building"></i> ${app.companyName}
                                                <span class="separator">•</span>
                                                <i class="fas fa-map-marker-alt"></i> ${app.locationName}
                                            </p>
                                        </div>
                                        <c:choose>
                                            <c:when test="${app.status eq 'Pending' or app.status eq 'pending'}">
                                                <div class="activity-status pending">
                                                    <i class="fas fa-hourglass-half"></i> Đang chờ
                                                </div>
                                            </c:when>
                                            <c:when test="${app.status eq 'Accepted' or app.status eq 'accepted'}">
                                                <div class="activity-status accepted">
                                                    <i class="fas fa-check-circle"></i> Chấp thuận
                                                </div>
                                            </c:when>
                                            <c:when test="${app.status eq 'Interview' or app.status eq 'interview'}">
                                                <div class="activity-status interview">
                                                    <i class="fas fa-calendar-check"></i> Phỏng vấn
                                                </div>
                                            </c:when>
                                            <c:when test="${app.status eq 'Rejected' or app.status eq 'rejected'}">
                                                <div class="activity-status rejected">
                                                    <i class="fas fa-times-circle"></i> Từ chối
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        
                        <!-- Recent Saved Jobs (limited to 2) -->
                        <c:if test="${not empty recentSavedJobs}">
                            <c:forEach var="saved" items="${recentSavedJobs}" varStatus="status">
                                <c:if test="${status.index < 2}">
                                    <div class="activity-item">
                                        <div class="activity-icon save">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                        <div class="activity-content">
                                            <p class="activity-title">Lưu <strong>${saved.jobTitle}</strong></p>
                                            <p class="activity-meta">
                                                <i class="fas fa-building"></i> ${saved.companyName}
                                                <span class="separator">•</span>
                                                <i class="fas fa-map-marker-alt"></i> ${saved.locationName}
                                            </p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        
                        <!-- No Activities Message -->
                        <c:if test="${empty recentApplications and empty recentSavedJobs}">
                            <div style="text-align: center; padding: 30px; color: #6b7280;">
                                <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                                <p>Chưa có hoạt động nào gần đây</p>
                                <p style="font-size: 0.9rem; margin-top: 10px;">Hãy bắt đầu ứng tuyển hoặc lưu các công việc bạn quan tâm!</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Profile Completion -->
                <div class="profile-completion">
                    <h3><i class="fas fa-tasks"></i> Hoàn thiện hồ sơ</h3>
                    <div class="completion-bar">
                        <div class="completion-progress" style="width: 75%">
                            <span>75%</span>
                        </div>
                    </div>
                    <div class="completion-checklist">
                        <div class="checklist-item completed">
                            <i class="fas fa-check-circle"></i>
                            <span>Xác thực email</span>
                        </div>
                        <div class="checklist-item completed">
                            <i class="fas fa-check-circle"></i>
                            <span>Tải lên CV</span>
                        </div>
                        <div class="checklist-item completed">
                            <i class="fas fa-check-circle"></i>
                            <span>Thêm số điện thoại</span>
                        </div>
                        <div class="checklist-item">
                            <i class="fas fa-circle"></i>
                            <span>Thêm ảnh đại diện</span>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Right Sidebar -->
        <aside class="right-sidebar">
            <h2>Việc Làm Bạn Sẽ Thích</h2>
            
            <div class="job-listings">
                <div class="job-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">N</div>
                    </div>
                    <div class="job-info">
                        <h4>Account Exec...</h4>
                        <p class="company">Tập Đoàn Novaon</p>
                        <p class="salary">15tr-40tr đ/tháng</p>
                        <p class="location">Hà Nội, Hồ Chí Minh</p>
                    </div>
                </div>

                <div class="job-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">D</div>
                    </div>
                    <div class="job-info">
                        <h4>Trade Marketing</h4>
                        <p class="company">CÔNG TY TNHH T...</p>
                        <p class="salary">Từ 10tr đ/tháng</p>
                        <p class="location">Hà Nội</p>
                    </div>
                </div>

                <div class="job-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">S</div>
                    </div>
                    <div class="job-info">
                        <h4>Phát Triển Kin...</h4>
                        <p class="company">Công Ty TNHH SPE...</p>
                        <p class="salary">$ 500-1,500 /tháng</p>
                        <p class="location">Hà Nội</p>
                    </div>
                </div>

                <div class="job-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">V</div>
                    </div>
                    <div class="job-info">
                        <h4>Trưởng Ban N...</h4>
                        <p class="company">Công Ty Cổ Phần S...</p>
                        <p class="salary">Thương lượng</p>
                        <p class="location">Hà Nội</p>
                    </div>
                </div>
            </div>

            <h2>Công Ty Bạn Sẽ Thích</h2>
            
            <div class="company-listings">
                <div class="company-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">H</div>
                    </div>
                    <div class="company-info">
                        <h4>HEINEKEN Vietnam</h4>
                        <p class="followers">2458 lượt theo dõi</p>
                        <p class="jobs">14 việc làm</p>
                    </div>
                </div>

                <div class="company-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">G</div>
                    </div>
                    <div class="company-info">
                        <h4>Công ty Cổ phần Tập đoà...</h4>
                        <p class="followers">787 lượt theo dõi</p>
                        <p class="jobs">24 việc làm</p>
                    </div>
                </div>

                <div class="company-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">T</div>
                    </div>
                    <div class="company-info">
                        <h4>Techcombank</h4>
                        <p class="followers">4901 lượt theo dõi</p>
                        <p class="jobs">44 việc làm</p>
                    </div>
                </div>
            </div>

            <!-- Zalo Chat Icon -->
            <div class="zalo-chat">
                <i class="fab fa-facebook-messenger"></i>
            </div>
        </aside>
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

    </div><!-- Close main-container -->

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

        // ========== Toggle CV Search Function ==========
        function toggleCVSearch(checkbox, cvID) {
            const isActive = checkbox.checked ? 1 : 0;
            
            console.log('Toggling CV search for CV ID:', cvID, 'New isActive:', isActive);
            
            // Gửi request đến servlet
            fetch(contextPath + '/ToggleCVSearchServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'cvID=' + cvID + '&isActive=' + isActive
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const statusText = isActive === 1 ? 'cho phép' : 'không cho phép';
                    showNotification('Đã ' + statusText + ' nhà tuyển dụng tìm kiếm CV này', 'success');
                    console.log('Toggle successful:', data);
                } else {
                    // Revert checkbox nếu có lỗi
                    checkbox.checked = !checkbox.checked;
                    showNotification('Có lỗi xảy ra: ' + (data.message || 'Vui lòng thử lại'), 'error');
                    console.error('Toggle failed:', data);
                }
            })
            .catch(error => {
                // Revert checkbox nếu có lỗi
                checkbox.checked = !checkbox.checked;
                showNotification('Không thể kết nối đến server', 'error');
                console.error('Error:', error);
            });
        }

        // ========== Confirm Delete CV Function ==========
        function confirmDeleteCV(event, cvID, cvTitle) {
            event.preventDefault();
            
            // Tạo modal xác nhận xóa
            const confirmed = confirm('Bạn có chắc chắn muốn xóa CV "' + cvTitle + '"?\n\nHành động này không thể hoàn tác!');
            
            if (confirmed) {
                deleteCV(cvID);
            }
        }

        // ========== Delete CV Function ==========
        function deleteCV(cvID) {
            console.log('Deleting CV ID:', cvID);
            
            // Gửi request đến servlet
            fetch(contextPath + '/DeleteCVServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'cvID=' + cvID
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showNotification('Đã xóa CV thành công', 'success');
                    console.log('Delete successful:', data);
                    
                    // Reload trang sau 1 giây để cập nhật danh sách CV
                    setTimeout(() => {
                        window.location.reload();
                    }, 1000);
                } else {
                    showNotification('Có lỗi xảy ra: ' + (data.message || 'Không thể xóa CV'), 'error');
                    console.error('Delete failed:', data);
                }
            })
            .catch(error => {
                showNotification('Không thể kết nối đến server', 'error');
                console.error('Error:', error);
            });
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

        // ========== Application Status Pie Chart ==========
        const ctx = document.getElementById('applicationStatusChart');
        if (ctx) {
            // Get data from JSP variables
            const pendingCount = ${pendingCount != null ? pendingCount : 0};
            const acceptedCount = ${acceptedCount != null ? acceptedCount : 0};
            const interviewCount = ${interviewCount != null ? interviewCount : 0};
            const rejectedCount = ${rejectedCount != null ? rejectedCount : 0};
            
            const applicationChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Đang chờ', 'Chấp thuận', 'Phỏng vấn', 'Từ chối'],
                    datasets: [{
                        label: 'Trạng thái ứng tuyển',
                        data: [pendingCount, acceptedCount, interviewCount, rejectedCount],
                        backgroundColor: [
                            '#FFA500',  // Orange - Đang chờ
                            '#4CAF50',  // Green - Chấp thuận
                            '#2196F3',  // Blue - Phỏng vấn
                            '#F44336'   // Red - Từ chối
                        ],
                        borderColor: [
                            '#fff',
                            '#fff',
                            '#fff',
                            '#fff'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    label += context.parsed + ' đơn';
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((context.parsed / total) * 100).toFixed(1);
                                    label += ' (' + percentage + '%)';
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        }
    });

</script>
</body>
</html>

