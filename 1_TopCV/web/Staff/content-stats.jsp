<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Role" %>
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
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê nội dung Marketing</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --info-gradient: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            --dark-gradient: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            --shadow-light: 0 10px 30px rgba(0,0,0,0.1);
            --shadow-hover: 0 15px 40px rgba(0,0,0,0.15);
            --border-radius: 20px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        .container-fluid {
            padding: 2rem;
        }

        h1 {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stats-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--shadow-light);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--primary-gradient);
        }

        .stats-card:nth-child(1)::before { background: var(--primary-gradient); }
        .stats-card:nth-child(2)::before { background: var(--success-gradient); }
        .stats-card:nth-child(3)::before { background: var(--warning-gradient); }
        .stats-card:nth-child(4)::before { background: var(--info-gradient); }

        .stats-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }

        .stats-card h3 {
            font-size: 3rem;
            font-weight: 900;
            margin-bottom: 0.5rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stats-card p {
            font-size: 1.1rem;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .stats-card small {
            color: #94a3b8;
            font-size: 0.9rem;
        }

        .card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-light);
            transition: var(--transition);
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            border-radius: var(--border-radius) var(--border-radius) 0 0 !important;
            padding: 1.5rem;
        }

        .card-header h5 {
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }

        .content-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: var(--transition);
            border: 1px solid #f1f5f9;
        }

        .content-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            border-color: #e2e8f0;
        }

        .content-card h5 {
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 1rem;
            line-height: 1.4;
        }

        .view-count {
            background: linear-gradient(135deg, #e0f2fe 0%, #b3e5fc 100%);
            color: #0277bd;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 700;
            font-size: 0.9rem;
            border: 1px solid #81d4fa;
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-published {
            background: linear-gradient(135deg, #e8f5e8 0%, #c8e6c9 100%);
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }

        .status-draft {
            background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
            color: #f57c00;
            border: 1px solid #ffcc02;
        }

        .status-archived {
            background: linear-gradient(135deg, #fce4ec 0%, #f8bbd9 100%);
            color: #c2185b;
            border: 1px solid #f48fb1;
        }

        .platform-badge {
            background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%);
            color: #7b1fa2;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            border: 1px solid #ce93d8;
        }

        .section-title {
            color: #1e293b;
            font-weight: 800;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 3px solid transparent;
            background: var(--primary-gradient);
            background-clip: padding-box;
            border-image: var(--primary-gradient) 1;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary-gradient);
            border-radius: 2px;
        }

        .badge {
            font-size: 0.8rem;
            font-weight: 700;
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }

        .no-content {
            text-align: center;
            color: #64748b;
            font-style: italic;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-light);
        }

        .no-content i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .alert {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-light);
        }

        .btn {
            border-radius: 25px;
            font-weight: 600;
            padding: 0.75rem 2rem;
            transition: var(--transition);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .text-center h4 {
            font-weight: 900;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .text-success { color: #059669 !important; }
        .text-warning { color: #d97706 !important; }
        .text-danger { color: #dc2626 !important; }
        .text-info { color: #0891b2 !important; }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container-fluid {
                padding: 1rem;
            }
            
            h1 {
                font-size: 2rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .stats-card {
                padding: 1.5rem;
            }
            
            .stats-card h3 {
                font-size: 2.5rem;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stats-card, .content-card, .card {
            animation: fadeInUp 0.6s ease-out;
        }

        .stats-card:nth-child(1) { animation-delay: 0.1s; }
        .stats-card:nth-child(2) { animation-delay: 0.2s; }
        .stats-card:nth-child(3) { animation-delay: 0.3s; }
        .stats-card:nth-child(4) { animation-delay: 0.4s; }

        /* Progress Bar Styling */
        .progress {
            background-color: #f1f5f9;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar {
            border-radius: 10px;
            transition: width 1s ease-in-out;
            background: linear-gradient(90deg, currentColor 0%, rgba(255,255,255,0.3) 100%);
        }

        .progress-bar.bg-success {
            background: linear-gradient(90deg, #059669 0%, #10b981 100%);
        }

        .progress-bar.bg-warning {
            background: linear-gradient(90deg, #d97706 0%, #f59e0b 100%);
        }

        .progress-bar.bg-danger {
            background: linear-gradient(90deg, #dc2626 0%, #ef4444 100%);
        }

        /* Icon Hover Effects */
        .fa-3x {
            transition: var(--transition);
        }

        .text-center:hover .fa-3x {
            transform: scale(1.1);
        }

        /* Enhanced Badge Styling */
        .badge.bg-success {
            background: linear-gradient(135deg, #059669 0%, #10b981 100%) !important;
        }

        .badge.bg-warning {
            background: linear-gradient(135deg, #d97706 0%, #f59e0b 100%) !important;
        }

        /* Loading Animation */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .stats-card:hover {
            animation: pulse 2s infinite;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">
                    <i class="fas fa-chart-line text-primary"></i>
                    Thống kê nội dung Marketing
                    <c:if test="${not empty currentStaffName}">
                        <small class="text-muted d-block mt-2">
                            <i class="fas fa-user"></i> ${currentStaffName}
                        </small>
                    </c:if>
                </h1>
                
                <!-- Statistics Overview -->
                <div class="stats-grid">
                    <div class="stats-card">
                        <h3><i class="fas fa-eye"></i> ${totalViews}</h3>
                        <p>Tổng lượt xem</p>
                    </div>
                    <div class="stats-card">
                        <h3><i class="fas fa-file-alt"></i> ${totalContent}</h3>
                        <p>Tổng số bài viết</p>
                    </div>
                    <div class="stats-card">
                        <h3><i class="fas fa-check-circle"></i> ${publishedCount}</h3>
                        <p>Bài đã xuất bản</p>
                        <small class="d-block mt-1">${publishedViews} lượt xem</small>
                    </div>
                    <div class="stats-card">
                        <h3><i class="fas fa-edit"></i> ${draftCount}</h3>
                        <p>Bài nháp</p>
                        <small class="d-block mt-1">${draftViews} lượt xem</small>
                    </div>
                </div>
                
                <!-- Detailed Statistics -->
                <c:if test="${totalViews > 0}">
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="fas fa-chart-pie text-info"></i>
                                        Phân tích chi tiết lượt xem
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="text-center p-4">
                                                <div class="mb-3">
                                                    <i class="fas fa-check-circle fa-3x text-success"></i>
                                                </div>
                                                <h2 class="text-success fw-bold">${publishedViews}</h2>
                                                <p class="mb-2 fw-semibold">Lượt xem bài đã xuất bản</p>
                                                <div class="progress mb-2" style="height: 8px;">
                                                    <div class="progress-bar bg-success" role="progressbar" 
                                                         style="width: <c:if test="${totalViews > 0}"><fmt:formatNumber value="${(publishedViews * 100) / totalViews}" maxFractionDigits="1"/></c:if>%">
                                                    </div>
                                                </div>
                                                <small class="text-muted">
                                                    <c:if test="${totalViews > 0}">
                                                        <fmt:formatNumber value="${(publishedViews * 100) / totalViews}" maxFractionDigits="1"/>%
                                                    </c:if>
                                                </small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center p-4">
                                                <div class="mb-3">
                                                    <i class="fas fa-edit fa-3x text-warning"></i>
                                                </div>
                                                <h2 class="text-warning fw-bold">${draftViews}</h2>
                                                <p class="mb-2 fw-semibold">Lượt xem bài nháp</p>
                                                <div class="progress mb-2" style="height: 8px;">
                                                    <div class="progress-bar bg-warning" role="progressbar" 
                                                         style="width: <c:if test="${totalViews > 0}"><fmt:formatNumber value="${(draftViews * 100) / totalViews}" maxFractionDigits="1"/></c:if>%">
                                                    </div>
                                                </div>
                                                <small class="text-muted">
                                                    <c:if test="${totalViews > 0}">
                                                        <fmt:formatNumber value="${(draftViews * 100) / totalViews}" maxFractionDigits="1"/>%
                                                    </c:if>
                                                </small>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="text-center p-4">
                                                <div class="mb-3">
                                                    <i class="fas fa-archive fa-3x text-danger"></i>
                                                </div>
                                                <h2 class="text-danger fw-bold">${archivedViews}</h2>
                                                <p class="mb-2 fw-semibold">Lượt xem bài đã lưu trữ</p>
                                                <div class="progress mb-2" style="height: 8px;">
                                                    <div class="progress-bar bg-danger" role="progressbar" 
                                                         style="width: <c:if test="${totalViews > 0}"><fmt:formatNumber value="${(archivedViews * 100) / totalViews}" maxFractionDigits="1"/></c:if>%">
                                                    </div>
                                                </div>
                                                <small class="text-muted">
                                                    <c:if test="${totalViews > 0}">
                                                        <fmt:formatNumber value="${(archivedViews * 100) / totalViews}" maxFractionDigits="1"/>%
                                                    </c:if>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>
                
                <!-- Published Content (Most Important) -->
                <div class="row">
                    <div class="col-12">
                        <h2 class="section-title">
                            <i class="fas fa-star text-warning"></i>
                            Nội dung đã xuất bản của tôi (${publishedCount} bài)
                            <c:if test="${publishedViews > 0}">
                                <span class="badge bg-success ms-2">${publishedViews} lượt xem</span>
                            </c:if>
                        </h2>
                        
                        <c:choose>
                            <c:when test="${not empty publishedContent}">
                                <c:forEach var="content" items="${publishedContent}">
                                    <div class="content-card">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <h5 class="mb-2">${content.title}</h5>
                                                <div class="mb-2">
                                                    <span class="platform-badge">${content.platform}</span>
                                                    <span class="status-badge status-published">${content.status}</span>
                                                </div>
                                                <c:if test="${not empty content.postDate}">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar"></i>
                                                        <fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </c:if>
                                            </div>
                                            <div class="col-md-4 text-md-end">
                                                <div class="view-count">
                                                    <i class="fas fa-eye"></i>
                                                    ${content.viewCount} lượt xem
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-content">
                                    <i class="fas fa-newspaper fa-3x mb-3 text-muted"></i>
                                    <p>Chưa có nội dung nào được xuất bản.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Draft Content -->
                <div class="row mt-5">
                    <div class="col-12">
                        <h2 class="section-title">
                            <i class="fas fa-edit text-info"></i>
                            Nội dung nháp của tôi (${draftCount} bài)
                            <c:if test="${draftViews > 0}">
                                <span class="badge bg-warning ms-2">${draftViews} lượt xem</span>
                            </c:if>
                        </h2>
                        
                        <c:choose>
                            <c:when test="${not empty draftContent}">
                                <c:forEach var="content" items="${draftContent}">
                                    <div class="content-card">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <h5 class="mb-2">${content.title}</h5>
                                                <div class="mb-2">
                                                    <span class="platform-badge">${content.platform}</span>
                                                    <span class="status-badge status-draft">${content.status}</span>
                                                </div>
                                                <c:if test="${not empty content.postDate}">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar"></i>
                                                        <fmt:formatDate value="${content.postDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </c:if>
                                            </div>
                                            <div class="col-md-4 text-md-end">
                                                <div class="view-count">
                                                    <i class="fas fa-eye"></i>
                                                    ${content.viewCount} lượt xem
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-content">
                                    <i class="fas fa-file-alt fa-3x mb-3 text-muted"></i>
                                    <p>Chưa có nội dung nháp nào.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Back Button -->
                <div class="row mt-4">
                    <div class="col-12">
                        <a href="${pageContext.request.contextPath}/Staff/content.jsp" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại quản lý nội dung
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
