<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Recruiter, model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Authentication check - chỉ Admin mới được truy cập
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
    
    if (adminRole == null || !"Admin".equals(adminRole.getName())) {
        response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
        return;
    }
    
    Recruiter recruiter = (Recruiter) request.getAttribute("recruiter");
    if (recruiter == null) {
        response.sendRedirect(request.getContextPath() + "/Admin/admin-manage-account.jsp");
        return;
    }
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Admin - Thông tin công ty</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/mana-acc.css">
        <style>
            .company-info-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }
            
            .company-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }
            
            .company-logo-section {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 20px;
            }
            
            .company-logo {
                width: 80px;
                height: 80px;
                border-radius: 15px;
                object-fit: cover;
                border: 3px solid rgba(255,255,255,0.3);
            }
            
            .logo-placeholder {
                width: 80px;
                height: 80px;
                background: rgba(255,255,255,0.2);
                border-radius: 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                font-weight: bold;
                color: white;
            }
            
            .company-basic-info h1 {
                margin: 0 0 10px 0;
                font-size: 28px;
                font-weight: 700;
            }
            
            .company-basic-info p {
                margin: 5px 0;
                opacity: 0.9;
                font-size: 16px;
            }
            
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .info-card {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                border: 1px solid #e1e5e9;
            }
            
            .info-card h3 {
                margin: 0 0 15px 0;
                color: #2d3748;
                font-size: 18px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
            .info-item {
                margin-bottom: 12px;
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }
            
            .info-label {
                font-weight: 600;
                color: #4a5568;
                min-width: 120px;
            }
            
            .info-value {
                color: #2d3748;
                flex: 1;
            }
            
            .status-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
            }
            
            .status-active {
                background: #d4edda;
                color: #155724;
            }
            
            .status-inactive {
                background: #f8d7da;
                color: #721c24;
            }
            
            .back-button {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                background: #6c757d;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
                margin-bottom: 20px;
            }
            
            .back-button:hover {
                background: #5a6268;
                color: white;
                text-decoration: none;
                transform: translateY(-2px);
            }
            
            .company-description {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                border-left: 4px solid #007bff;
                margin: 20px 0;
            }
            
            .company-description h4 {
                margin: 0 0 10px 0;
                color: #495057;
            }
            
            .company-description p {
                margin: 0;
                color: #6c757d;
                line-height: 1.6;
            }
            
            .empty-state {
                text-align: center;
                color: #6c757d;
                font-style: italic;
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <div class="company-info-container">
            <!-- Back Button -->
            <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="back-button">
                ← Quay lại danh sách
            </a>
            
            <!-- Company Header -->
            <div class="company-header">
                <div class="company-logo-section">
                    <c:choose>
                        <c:when test="${not empty recruiter.companyLogoURL}">
                            <!-- Resolve absolute vs relative logo URL and add onerror fallback -->
                            <c:set var="logoPath" value="${recruiter.companyLogoURL}" />
                            <c:choose>
                                <c:when test="${fn:startsWith(logoPath, 'http://') || fn:startsWith(logoPath, 'https://')}">
                                    <c:set var="resolvedLogo" value="${logoPath}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="resolvedLogo" value="${pageContext.request.contextPath}${fn:startsWith(logoPath, '/') ? logoPath : '/'.concat(logoPath)}" />
                                </c:otherwise>
                            </c:choose>
                            <img src="${resolvedLogo}" 
                                 alt="${recruiter.companyName}" 
                                 class="company-logo"
                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/logo/logo.png'">
                        </c:when>
                        <c:otherwise>
                            <div class="logo-placeholder">
                                ${fn:substring(recruiter.companyName, 0, 2)}
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="company-basic-info">
                        <h1>${recruiter.companyName}</h1>
                        <p><strong>Người liên hệ:</strong> ${recruiter.contactPerson}</p>
                        <p><strong>Email:</strong> ${recruiter.email}</p>
                        <p><strong>Trạng thái:</strong> 
                            <span class="status-badge status-${recruiter.status}">${recruiter.status}</span>
                        </p>
                    </div>
                </div>
            </div>
            
            <!-- Company Description -->
            <c:if test="${not empty recruiter.companyDescription}">
                <div class="company-description">
                    <h4>📝 Mô tả công ty</h4>
                    <p>${recruiter.companyDescription}</p>
                </div>
            </c:if>
            
            <!-- Information Grid -->
            <div class="info-grid">
                <!-- Contact Information -->
                <div class="info-card">
                    <h3>📞 Thông tin liên hệ</h3>
                    <div class="info-item">
                        <span class="info-label">Điện thoại:</span>
                        <span class="info-value">${recruiter.phone}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span>
                        <span class="info-value">${recruiter.email}</span>
                    </div>
                    <c:if test="${not empty recruiter.website}">
                        <div class="info-item">
                            <span class="info-label">Website:</span>
                            <span class="info-value">
                                <a href="${recruiter.website}" target="_blank" style="color: #007bff;">
                                    ${recruiter.website}
                                </a>
                            </span>
                        </div>
                    </c:if>
                </div>
                
                <!-- Company Details -->
                <div class="info-card">
                    <h3>🏢 Chi tiết công ty</h3>
                    <div class="info-item">
                        <span class="info-label">Tên công ty:</span>
                        <span class="info-value">${recruiter.companyName}</span>
                    </div>
                    <c:if test="${not empty recruiter.companySize}">
                        <div class="info-item">
                            <span class="info-label">Quy mô:</span>
                            <span class="info-value">${recruiter.companySize}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty recruiter.companyAddress}">
                        <div class="info-item">
                            <span class="info-label">Địa chỉ:</span>
                            <span class="info-value">${recruiter.companyAddress}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty recruiter.taxcode}">
                        <div class="info-item">
                            <span class="info-label">Mã số thuế:</span>
                            <span class="info-value">${recruiter.taxcode}</span>
                        </div>
                    </c:if>
                </div>
                
                <!-- Account Information -->
                <div class="info-card">
                    <h3>👤 Thông tin tài khoản</h3>
                    <div class="info-item">
                        <span class="info-label">ID:</span>
                        <span class="info-value">${recruiter.recruiterID}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Người liên hệ:</span>
                        <span class="info-value">${recruiter.contactPerson}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Trạng thái:</span>
                        <span class="info-value">
                            <span class="status-badge status-${recruiter.status}">${recruiter.status}</span>
                        </span>
                    </div>
                </div>
                
                <!-- Additional Information -->
                <div class="info-card">
                    <h3>ℹ️ Thông tin bổ sung</h3>
                    <c:if test="${not empty recruiter.companyBenefits}">
                        <div class="info-item">
                            <span class="info-label">Phúc lợi:</span>
                            <span class="info-value">${recruiter.companyBenefits}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty recruiter.companyVideoURL}">
                        <div class="info-item">
                            <span class="info-label">Video giới thiệu:</span>
                            <span class="info-value">
                                <a href="${recruiter.companyVideoURL}" target="_blank" style="color: #007bff;">
                                    Xem video
                                </a>
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${not empty recruiter.registrationCert}">
                        <div class="info-item">
                            <span class="info-label">Giấy phép:</span>
                            <span class="info-value">
                                <a href="${pageContext.request.contextPath}/assets/img/certificates/${recruiter.registrationCert}" 
                                   target="_blank" style="color: #007bff;">
                                    Xem giấy phép
                                </a>
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Empty states for missing information -->
            <c:if test="${empty recruiter.companyDescription && empty recruiter.companyBenefits && empty recruiter.companyVideoURL}">
                <div class="info-card">
                    <div class="empty-state">
                        <p>📝 Công ty này chưa cập nhật thông tin bổ sung</p>
                    </div>
                </div>
            </c:if>
        </div>
    </body>
</html>
