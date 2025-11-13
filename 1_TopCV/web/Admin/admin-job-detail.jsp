<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="dal.JobDetailDAO, model.JobDetail, model.Role" %>

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
    
    // Load job detail from database if jobId parameter exists
    JobDetail job = null;
    String jobIdStr = request.getParameter("jobId");
    if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
        try {
            int jobId = Integer.parseInt(jobIdStr);
            JobDetailDAO jobDetailDAO = new JobDetailDAO();
            job = jobDetailDAO.getJobDetailById(jobId);
            request.setAttribute("job", job);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Chi tiết công việc</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/ad-jobpos.css">
    <style>
        .job-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: var(--card-dark);
            border-radius: 12px;
            margin-top: 20px;
        }
        
        .job-header {
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .job-title {
            font-size: 28px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 10px;
        }
        
        .job-company {
            font-size: 18px;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        .job-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--muted);
        }
        
        .meta-icon {
            font-size: 16px;
        }
        
        .job-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        .content-section {
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 15px;
            border-bottom: 2px solid var(--primary);
            padding-bottom: 8px;
        }
        
        .section-content {
            color: var(--muted);
            line-height: 1.6;
        }
        
        .back-button {
            background: var(--primary);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-bottom: 20px;
            transition: background 0.3s ease;
        }
        
        .back-button:hover {
            background: var(--primary-hover);
        }
        
        .company-info {
            background: rgba(255,255,255,0.05);
            border-radius: 8px;
            padding: 20px;
        }
        
        .company-logo {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            margin-bottom: 15px;
            object-fit: cover;
        }
        
        .company-name {
            font-size: 18px;
            font-weight: 600;
            color: #ffffff;
            margin-bottom: 10px;
        }
        
        .company-description {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.5;
        }
        
        @media (max-width: 768px) {
            .job-content {
                grid-template-columns: 1fr;
            }
            
            .job-meta {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="job-detail-container">
        <button class="back-button" onclick="history.back()">← Quay lại</button>
        
        <c:choose>
            <c:when test="${empty job}">
                <div style="text-align: center; padding: 40px;">
                    <div style="color: #ff6b6b; font-size: 18px;">Không tìm thấy thông tin công việc</div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="job-header">
                    <h1 class="job-title">${job.jobTitle}</h1>
                    <div class="job-company">${job.recruiter.companyName}</div>
                    
                    <div class="job-meta">
                        <div class="meta-item">
                            <span class="meta-icon">📍</span>
                            <span>${job.location.locationName}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-icon">💰</span>
                            <span>${job.salaryRange}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-icon">📅</span>
                            <span><fmt:formatDate value="${job.postingDate}" pattern="dd/MM/yyyy"/></span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-icon">👥</span>
                            <span>Tuyển ${job.hiringCount} người</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-icon">📊</span>
                            <span>${job.status}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-icon">👁️</span>
                            <span>${job.views} lượt xem</span>
                        </div>
                    </div>
                </div>
                
                <div class="job-content">
                    <div class="main-content">
                        <div class="content-section">
                            <h3 class="section-title">📝 Mô tả công việc</h3>
                            <div class="section-content">${job.description}</div>
                        </div>
                        
                        <div class="content-section">
                            <h3 class="section-title">✅ Yêu cầu ứng viên</h3>
                            <div class="section-content">${job.requirements}</div>
                        </div>
                    </div>
                    
                    <div class="sidebar">
                        <div class="company-info">
                            <h3 class="section-title">🏢 Thông tin công ty</h3>
                            <c:if test="${not empty job.recruiter.companyLogoURL}">
                                <img src="${pageContext.request.contextPath}/assets/img/company/${job.recruiter.companyLogoURL}" 
                                     alt="Company Logo" class="company-logo">
                            </c:if>
                            <div class="company-name">${job.recruiter.companyName}</div>
                            <div class="company-description">${job.recruiter.companyDescription}</div>
                            
                            <c:if test="${not empty job.recruiter.website}">
                                <div style="margin-top: 15px;">
                                    <strong>Website:</strong> 
                                    <a href="${job.recruiter.website}" target="_blank" style="color: var(--primary);">
                                        ${job.recruiter.website}
                                    </a>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty job.recruiter.companyAddress}">
                                <div style="margin-top: 10px;">
                                    <strong>Địa chỉ:</strong> ${job.recruiter.companyAddress}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
