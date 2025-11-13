<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Recruiter"%>
<%@page import="model.Job"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is logged in
    HttpSession userSession = request.getSession(false);
    boolean isLoggedIn = (userSession != null && userSession.getAttribute("user") != null);
    String userType = isLoggedIn ? (String) userSession.getAttribute("userType") : null;
    boolean isJobSeeker = "jobseeker".equals(userType);
    request.setAttribute("isLoggedIn", isLoggedIn);
    request.setAttribute("isJobSeeker", isJobSeeker);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TopFinder - Hồ sơ công ty</title>
    
    <!-- CSS here -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Global theme colors */
        :root {
            --bg-left: #061f3b;
            --bg-right: #0a67ff;
            --text-light: rgba(255,255,255,0.92);
            --text-light-muted: rgba(255,255,255,0.75);
            --text-dark: #21323b;
            --link: #a6c8ff;
            --link-hover: #d7e6ff;
            --blue: #0a67ff;
            --blue-dark: #0b5bdf;
        }
        
        body {
            background: linear-gradient(90deg, var(--bg-left) 0%, var(--bg-right) 100%) !important;
            color: #ffffff;
        }
        
        /* Header Styles from index.jsp */
        .header-area {
            position: fixed;
            left: 0;
            right: 0;
            width: 100%;
            z-index: 999;
            background: rgba(6, 31, 59, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .header-content { 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            gap: 24px; 
            padding: 14px 28px; 
        }
        .logo-section .logo h1 { 
            margin: 0; 
            font-weight: 700; 
            color: #ffffff; 
        }
        .logo-section .tagline { 
            display: block; 
            font-size: 12px; 
            color: #e8f0ff; 
            opacity: 0.9; 
        }
        .search-section { 
            flex: 1; 
            display: flex; 
            justify-content: center; 
        }
        .search-bar { 
            width: 100%; 
            max-width: 820px; 
            background: #ffffff; 
            border-radius: 28px; 
            padding: 10px 12px; 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            box-shadow: 0 6px 18px rgba(2,10,30,0.18); 
            border: 1px solid rgba(17,24,39,0.06); 
        }
        .search-bar input { 
            flex: 1; 
            border: none; 
            background: transparent; 
            outline: none; 
            font-size: 15px; 
            color: #0f172a; 
            padding: 8px 10px; 
        }
        .search-bar input::placeholder { 
            color: #475569; 
        }
        .location-selector { 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            color: #1f2937; 
            background: rgba(2,10,30,0.04); 
            padding: 6px 10px; 
            border-radius: 14px; 
        }
        .search-btn { 
            border: none; 
            background: linear-gradient(90deg, #0b5bdf, #0a67ff); 
            color: #fff; 
            width: 40px; 
            height: 40px; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            cursor: pointer; 
            box-shadow: 0 6px 16px rgba(10,103,255,0.35); 
        }
        .search-btn:hover { 
            filter: brightness(1.05); 
            box-shadow: 0 8px 20px rgba(10,103,255,0.45); 
        }
        .header-right { 
            display: flex; 
            align-items: center; 
            gap: 18px; 
            flex-shrink: 0; 
        }
        .menu-toggle { 
            display: flex; 
            align-items: center; 
            gap: 8px; 
            color: #e8f0ff; 
            cursor: pointer; 
            white-space: nowrap; 
            font-size: 14px; 
        }
        .recruiter-btn { 
            background: transparent; 
            color: #e8f0ff; 
            border: 1px solid rgba(255,255,255,0.6); 
            padding: 8px 14px; 
            border-radius: 10px; 
            cursor: pointer; 
            backdrop-filter: blur(2px); 
            text-decoration: none; 
            white-space: nowrap; 
            font-size: 14px; 
        }
        .recruiter-btn:hover { 
            background: rgba(255,255,255,0.1); 
            color: #e8f0ff; 
        }
        .user-actions { 
            display: flex; 
            align-items: center; 
            gap: 12px; 
        }
        .user-actions > a, .user-actions > div { 
            width: 40px; 
            height: 40px; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            color: #e8f0ff; 
            border: 1px solid rgba(255,255,255,0.35); 
            transition: all 0.3s ease; 
            text-decoration: none; 
        }
        .user-actions > a:hover, .user-actions > div:hover { 
            background: rgba(255,255,255,0.1); 
            border-color: rgba(255,255,255,0.6); 
        }
        .user-actions > a.head-btn2 { 
            width: auto; 
            border-radius: 8px; 
            padding: 10px 20px; 
            white-space: nowrap; 
            font-size: 14px; 
        }
        .logout-icon:hover { 
            background: rgba(255,107,107,0.2) !important; 
            border-color: rgba(255,107,107,0.6) !important; 
            color: #ff6b6b !important; 
        }
        
        /* Mega menu */
        .mega-menu { 
            position: absolute; 
            left: 50%; 
            transform: translateX(-50%); 
            top: 72px; 
            width: 92%; 
            max-width: 1100px; 
            background: #ffffff; 
            color: #0f172a; 
            border-radius: 16px; 
            box-shadow: 0 24px 60px rgba(2,10,30,0.28); 
            padding: 24px; 
            display: none; 
            z-index: 1300; 
            border: 1px solid rgba(17,24,39,0.08); 
            overflow: hidden; 
        }
        .mega-menu::before { 
            content: ""; 
            position: absolute; 
            left: 0; 
            top: 0; 
            right: 0; 
            height: 6px; 
            background: linear-gradient(90deg, #0b5bdf, #0a67ff); 
        }
        .mega-menu.open { 
            display: block; 
        }
        .mega-grid { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 28px; 
        }
        .mega-col { 
            padding: 4px 12px; 
        }
        .mega-col + .mega-col { 
            border-left: 1px solid rgba(17,24,39,0.06); 
        }
        .mega-col h4 { 
            margin: 0 0 12px 0; 
            color: #0b5bdf; 
            font-weight: 700; 
            letter-spacing: .2px; 
        }
        .mega-col a { 
            display: block; 
            padding: 10px 12px; 
            margin: 4px 0; 
            color: #0f172a; 
            border-radius: 10px; 
            transition: all .2s ease; 
            border: 1px solid transparent; 
            text-decoration: none;
        }
        .mega-col a:hover { 
            color: #0b5bdf; 
            background: rgba(10,103,255,0.06); 
            border-color: rgba(10,103,255,0.15); 
        }
        
        /* Main content area */
        main {
            padding-top: 80px;
            min-height: 100vh;
            background: #f8f9fa;
        }
        
        /* Company Page Specific Styles */
        .company-container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 1.5rem 1rem 2rem; 
            background: #ffffff;
            border-radius: 0;
            box-shadow: none;
        }
        
        /* Override theme text colors for company page */
        .company-container h1,
        .company-container h2,
        .company-container h3,
        .company-container h4,
        .company-container h5,
        .company-container h6 {
            color: #111827 !important;
        }
        
        .company-container p,
        .company-container span,
        .company-container div {
            color: #374151 !important;
        }
        
        .company-container a {
            color: #0b5bd3 !important;
        }
        
        .company-hero { display: none; }
        .company-card { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
            margin-top: 1rem;
            background: #fff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #e5e7eb;
        }
        .company-logo { 
            width: 96px; 
            height: 96px; 
            background: #fff; 
            border: 1px solid #eef1f5; 
            border-radius: 12px; 
            display: grid; 
            place-items: center; 
            font-weight: 800; 
            color: #0b5bd3; 
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .company-title { display: flex; align-items: center; gap: 0.75rem; }
        .follow-btn { 
            background: #ff6b35; 
            color: #fff; 
            border: none; 
            border-radius: 8px; 
            padding: 0.5rem 1rem; 
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s;
        }
        .follow-btn:hover {
            background: #e55a2b;
        }
        
        /* Company card text colors */
        .company-card h2 {
            color: #111827 !important;
        }
        .company-card div {
            color: #6b7280 !important;
        }
        
        .company-tabs { display: flex; gap: 1.25rem; border-bottom: 1px solid #eef1f5; margin-top: 1rem; }
        .company-tab { 
            padding: 0.75rem 0; 
            cursor: pointer; 
            color: #4b5563; 
            position: relative;
            font-weight: 500;
        }
        .company-tab.active { color: #0b5bd3; }
        .company-tab.active::after { content: ""; position: absolute; left: 0; right: 0; bottom: -1px; height: 3px; background: #0b5bd3; border-radius: 2px; }
        .section { 
            margin-top: 1.5rem;
            background: #fff;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #e5e7eb;
        }
        .section h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #111827;
            margin: 0 0 1rem 0;
        }
        .benefits { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; }
        .benefit-card { 
            background: #f4f7ff; 
            border: 1px solid #e6ecff; 
            border-radius: 12px; 
            padding: 1.25rem; 
            text-align: center; 
            color: #1f2937;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .benefit-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(11, 91, 211, 0.1);
        }
        .benefit-card .icon { 
            font-size: 28px; 
            color: #0b5bd3;
            margin-bottom: 0.5rem;
        }
        .benefit-card h4 {
            font-size: 1rem;
            font-weight: 600;
            margin: 0.5rem 0 0.25rem;
            color: #111827;
        }
        .benefit-card div {
            font-size: 0.9rem;
            color: #6b7280 !important;
            line-height: 1.5;
        }
        
        /* Ensure video placeholder text is dark */
        .video-placeholder {
            color: #6b7280 !important;
        }
        .video-placeholder-content div {
            color: #6b7280 !important;
        }
        
        .job-list { margin-top: 1rem; }
        .job-item { 
            background: #fff; 
            border: 1px solid #e9ecef; 
            border-radius: 12px; 
            padding: 1rem; 
            display: grid; 
            grid-template-columns: 64px 1fr auto; 
            gap: 0.75rem; 
            align-items: center;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .job-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transform: translateY(-1px);
        }
        .job-item .logo { 
            width: 64px; 
            height: 64px; 
            border-radius: 8px; 
            background: #f3f3f3; 
            display: grid; 
            place-items: center; 
            font-weight: 700; 
            color: #666;
            font-size: 0.9rem;
        }
        .job-item .meta { 
            display: flex; 
            gap: 0.75rem; 
            color: #6b7280 !important; 
            font-size: 0.9rem; 
            margin-top: 0.5rem;
            flex-wrap: wrap;
        }
        .job-item .meta span {
            color: #6b7280 !important;
        }
        .job-item .meta i {
            color: #9ca3af !important;
        }
        .select-menu { position: relative; }
        .select-menu .menu { position: absolute; right: 0; top: calc(100% + 6px); background:#fff; border:1px solid #e5e7eb; border-radius:10px; box-shadow:0 10px 24px rgba(0,0,0,0.06); display:none; min-width: 180px; z-index:20; }
        .select-menu .menu.show { display:block; }
        .select-menu .option { padding:0.55rem 0.75rem; cursor:pointer; }
        .select-menu .option:hover { background:#f8fafc; }
        
        /* Video Styles */
        .video-container { 
            position: relative; 
            width: 100%; 
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0; 
            overflow: hidden; 
            border-radius: 12px; 
            background: #000; 
        }
        .video-container iframe { 
            position: absolute; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            border-radius: 12px; 
        }
        .video-placeholder {
            background: #f5f7fb;
            border: 1px solid #eef1f5;
            border-radius: 12px;
            height: 220px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6b7280;
        }
        .video-placeholder-content {
            text-align: center;
        }
        .video-placeholder-icon {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: #e6ecff;
            display: inline-grid;
            place-items: center;
            color: #3157d6;
            margin-bottom: 8px;
        }
        
        /* Chip styles */
        .chip {
            display: inline-block;
            padding: 0.25rem 0.6rem;
            background: #e6f2ff;
            color: #0066cc;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        /* Button styles */
        .btn {
            background: #007bff !important;
            color: #fff !important;
            border: none;
            padding: 12px 28px;
            cursor: pointer;
            text-decoration: none !important;
            display: inline-block;
            font-size: 16px;
            font-weight: 600;
            border-radius: 6px;
        }
        .btn:hover {
            background: #0056b3 !important;
            color: #fff !important;
        }
        .btn-outline {
            background: #fff;
            color: #4b5563;
            border: 1px solid #e5e7eb;
            cursor: pointer;
            transition: all 0.2s;
            border-radius: 8px;
            padding: 0.5rem 0.75rem;
        }
        .btn-outline:hover {
            background: #f9fafb;
            border-color: #d1d5db;
        }
        
        /* Job Item additional styles */
        .job-item .meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .job-item h4 {
            margin: 0;
            font-size: 1rem;
            font-weight: 600;
            color: #111827;
            line-height: 1.4;
        }
        .job-list .job-item + .job-item {
            margin-top: 0.75rem;
        }
        
        @media (max-width: 900px) { 
            .benefits { grid-template-columns: 1fr; }
            .video-container { padding-bottom: 75%; /* 4:3 for mobile */ }
            .job-item {
                grid-template-columns: 48px 1fr;
                gap: 0.5rem;
            }
            .job-item .logo {
                width: 48px;
                height: 48px;
                font-size: 0.75rem;
            }
            .job-item > div:last-child {
                grid-column: 1 / -1;
                margin-top: 0.5rem;
                display: flex;
                gap: 0.5rem;
                justify-content: flex-start;
            }
            .header-content {
                flex-wrap: wrap;
            }
            .search-section {
                order: 3;
                width: 100%;
            }
        }
        
        @media (max-width: 768px) {
            .company-card {
                flex-direction: column;
                text-align: center;
            }
            .benefits {
                grid-template-columns: 1fr;
            }
            .benefit-card h4 {
                font-size: 1rem;
                margin: 0.5rem 0 0.25rem;
            }
        }
    </style>
    
</head>
<body>
    <!-- Header from index.jsp -->
    <header class="header-area">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" style="text-decoration: none; color: inherit;">
                        <h1>Top</h1>
                        <span class="tagline">Empower growth</span>
                    </a>
                </div>
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
                <a class="recruiter-btn" href="${pageContext.request.contextPath}/Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user && sessionScope.userType == 'jobseeker'}">
                        <div class="user-actions">
                            <a class="profile-icon" href="${pageContext.request.contextPath}/jobseekerprofile" title="Tài khoản">
                                <i class="fas fa-user"></i>
                            </a>
                            <%@ include file="/shared/notification-dropdown.jsp" %>
                            <div class="message-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                                <i class="fas fa-sign-out-alt"></i>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="user-actions">
                            <a class="head-btn2" href="${pageContext.request.contextPath}/JobSeeker/jobseeker-login.jsp">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>
    
    <!-- Mega menu panel -->
    <div class="mega-menu" id="megaMenu">
        <div class="mega-grid">
            <div class="mega-col">
                <h4>Việc làm</h4>
                <a href="${pageContext.request.contextPath}/job-list">Tìm việc làm</a>
                <a href="#">Việc làm mới nhất</a>
                <a href="#">Việc làm quản lý</a>
            </div>
            <c:if test="${not empty sessionScope.user && sessionScope.userType == 'jobseeker'}">
                <div class="mega-col">
                    <h4>Việc của tôi</h4>
                    <a href="${pageContext.request.contextPath}/saved-jobs">Việc đã lưu</a>
                    <a href="${pageContext.request.contextPath}/applied-jobs">Việc đã ứng tuyển</a>
                    <a href="#">Thông báo việc làm</a>
                </div>
            </c:if>
            <div class="mega-col">
                <h4>Công ty</h4>
                <a href="${pageContext.request.contextPath}/company-culture">Tất cả công ty</a>
            </div>
        </div>
    </div>

    <%
        Recruiter company = (Recruiter) request.getAttribute("company");
        String companyLogoText = (String) request.getAttribute("companyLogoText");
        String companyName = (String) request.getAttribute("companyName");
        String companyDescription = (String) request.getAttribute("companyDescription");
        String companyWebsite = (String) request.getAttribute("companyWebsite");
        String[] companyBenefits = (String[]) request.getAttribute("companyBenefits");
        List<Job> jobs = (List<Job>) request.getAttribute("jobs");
        Integer jobCount = (Integer) request.getAttribute("jobCount");
        Map<Integer, String> locationMap = (Map<Integer, String>) request.getAttribute("locationMap");
        Map<Integer, String> categoryMap = (Map<Integer, String>) request.getAttribute("categoryMap");
        
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    %>
    
    <main>
    <div class="company-container">
        <div class="company-hero"></div>
        <div class="company-card">
            <% if (company.getCompanyLogoURL() != null && !company.getCompanyLogoURL().isEmpty()) { %>
                <img src="<%= company.getCompanyLogoURL() %>" alt="<%= companyName %>" class="company-logo" style="object-fit:cover;">
            <% } else { %>
                <div class="company-logo"><%= companyLogoText != null ? companyLogoText : "COM" %></div>
            <% } %>
            <div style="flex:1">
                <div class="company-title">
                    <h2 style="margin:0; color:#111827;"><%= companyName != null ? companyName : "Tên công ty" %></h2>
                </div>
                <div style="color:#6b7280; margin-top:2px;">
                    <% if (company.getCompanySize() != null) { %>
                        <%= company.getCompanySize() %> nhân viên
                    <% } %>
                </div>
            </div>
<!--            <button class="follow-btn">Theo dõi</button>-->
        </div>

        <%-- <div class="company-tabs">
            <div class="company-tab active">Về chúng tôi</div>
            <div class="company-tab">Vị trí đang tuyển dụng</div>
        </div> --%>

        <div class="section">
            <h3 style="margin:0 0 0.5rem; color:#111827;">Về chúng tôi</h3>
            <div style="color:#374151; line-height:1.6;">
                <%= companyDescription != null ? companyDescription : "Công ty chưa cập nhật mô tả." %>
                <% if (companyWebsite != null && !companyWebsite.isEmpty()) { %>
                    <br><br>
                    <strong>Website:</strong> <a href="<%= companyWebsite %>" target="_blank" style="color:#0b5bd3;"><%= companyWebsite %></a>
                <% } %>
                <% if (company.getCompanyAddress() != null && !company.getCompanyAddress().isEmpty()) { %>
                    <br><br>
                    <strong>Địa chỉ:</strong> <%= company.getCompanyAddress() %>
                <% } %>
            </div>
        </div>

        <div class="section">
            <h3 style="margin:0 0 0.5rem; color:#111827;">Video</h3>
            <%
                String videoURL = (String) request.getAttribute("companyVideoURL");
                String embedURL = null;
                
                // Xử lý URL YouTube
                if (videoURL != null && !videoURL.trim().isEmpty()) {
                    try {
                        // Xử lý youtube.com/watch?v=
                        if (videoURL.contains("youtube.com/watch?v=")) {
                            String videoId = videoURL.split("v=")[1];
                            if (videoId.contains("&")) {
                                videoId = videoId.split("&")[0];
                            }
                            embedURL = "https://www.youtube.com/embed/" + videoId;
                        } 
                        // Xử lý youtu.be/
                        else if (videoURL.contains("youtu.be/")) {
                            String videoId = videoURL.substring(videoURL.lastIndexOf("/") + 1);
                            if (videoId.contains("?")) {
                                videoId = videoId.split("\\?")[0];
                            }
                            embedURL = "https://www.youtube.com/embed/" + videoId;
                        }
                        // Xử lý youtube.com/embed/
                        else if (videoURL.contains("youtube.com/embed/")) {
                            embedURL = videoURL;
                        }
                    } catch (Exception e) {
                        embedURL = null; // Nếu có lỗi khi parse URL
                    }
                }
                
                // Hiển thị video hoặc placeholder
                if (embedURL != null && !embedURL.isEmpty()) {
            %>
                    <div class="video-container">
                        <iframe 
                            src="<%= embedURL %>" 
                            frameborder="0" 
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                            allowfullscreen>
                        </iframe>
                    </div>
            <%
                } else {
            %>
                    <div class="video-placeholder">
                        <div class="video-placeholder-content">
                            <div class="video-placeholder-icon">
                                <i class="fas fa-play"></i>
                            </div>
                            <div>Công ty chưa cập nhật video giới thiệu.</div>
                        </div>
                    </div>
            <%
                }
            %>
        </div>

        <div class="section">
            <h3 style="margin:0 0 0.5rem; color:#111827;">Phúc lợi</h3>
            <% if (companyBenefits != null && companyBenefits.length > 0) { %>
                <div class="benefits">
                    <% 
                    String[] benefitIcons = {"fa-coins", "fa-user-nurse", "fa-swimmer", "fa-gift", "fa-utensils", "fa-car"};
                    for (int i = 0; i < companyBenefits.length && i < 6; i++) { 
                        String benefit = companyBenefits[i].trim();
                        if (!benefit.isEmpty()) {
                            String icon = benefitIcons[i % benefitIcons.length];
                    %>
                        <div class="benefit-card">
                            <div class="icon"><i class="fas <%= icon %>"></i></div>
                            <div><%= benefit %></div>
                        </div>
                    <% 
                        }
                    } 
                    %>
                </div>
            <% } else { %>
                <div style="color:#6b7280; padding:1rem; background:#f9fafb; border-radius:8px; text-align:center;">
                    Công ty chưa cập nhật thông tin phúc lợi
                </div>
            <% } %>
        </div>

        <div class="section">
            <div style="display:flex; align-items:center; justify-content:space-between;">
                <h3 style="margin:0; color:#111827;">Vị trí đang tuyển dụng <span style="color:#6b7280; font-weight:400;">(<%= jobCount != null ? jobCount : 0 %> việc làm)</span></h3>
            </div>
            
            <% if (jobs != null && !jobs.isEmpty()) { %>
                <div class="job-list" id="jobList" style="margin-top:1rem;">
                    <% for (Job job : jobs) { 
                        String locationName = locationMap.get(job.getLocationID());
                        String categoryName = categoryMap.get(job.getCategoryID());
                        String postingDate = job.getPostingDate() != null ? job.getPostingDate().format(dateFormatter) : "";
                    %>
                        <div class="job-item">
                            <% if (company.getCompanyLogoURL() != null && !company.getCompanyLogoURL().isEmpty()) { %>
                                <img src="<%= company.getCompanyLogoURL() %>" alt="<%= companyName %>" class="logo" style="object-fit:cover;">
                            <% } else { %>
                                <div class="logo"><%= companyLogoText %></div>
                            <% } %>
                            <div>
                                <h4 style="margin:0; color:#111827;"><%= job.getJobTitle() %></h4>
                                <div style="color:#6b7280; margin-top:2px;"><%= companyName %></div>
                                <div class="meta">
                                    <span><i class="fas fa-dollar-sign" style="margin-right:4px;"></i><%= job.getSalaryRange() != null ? job.getSalaryRange() : "Thỏa thuận" %></span>
                                    <% if (locationName != null) { %>
                                        <span><i class="fas fa-map-marker-alt" style="margin-right:4px;"></i><%= locationName %></span>
                                    <% } %>
                                </div>
                                <% if (categoryName != null) { %>
                                    <div style="display:flex; gap:0.4rem; margin-top:0.4rem; flex-wrap:wrap;">
                                        <span class="chip"><%= categoryName %></span>
                                    </div>
                                <% } %>
                                <div style="color:#6b7280; margin-top:0.4rem; font-size:0.85rem;">
                                    <i class="far fa-clock" style="margin-right:4px;"></i>Cập nhật: <%= postingDate %>
                                </div>
                            </div>
                            <div>
                                <a href="<%= request.getContextPath() %>/job-detail?jobId=<%= job.getJobID() %>" 
                                   style="background: #007bff !important; color: #ffffff !important; padding: 12px 28px; text-decoration: none !important; display: inline-block; font-size: 16px; font-weight: 600; border-radius: 6px;">
                                   Xem chi tiết
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div style="text-align:center; padding:3rem 1rem; color:#6b7280;">
                    <i class="fas fa-briefcase" style="font-size:48px; margin-bottom:1rem; opacity:0.3;"></i>
                    <p style="font-size:1.1rem;">Công ty hiện không có vị trí tuyển dụng nào</p>
                </div>
            <% } %>
        </div>
    </main>

    <!-- JS here -->
    <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.scrollUp.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    
    <script>
        // Mega menu toggle
        const menuToggle = document.getElementById('menuToggle');
        const megaMenu = document.getElementById('megaMenu');
        
        if (menuToggle && megaMenu) {
            menuToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                megaMenu.classList.toggle('open');
            });
            
            document.addEventListener('click', function(e) {
                if (!megaMenu.contains(e.target) && !menuToggle.contains(e.target)) {
                    megaMenu.classList.remove('open');
                }
            });
        }
    </script>
</body>
</html>



