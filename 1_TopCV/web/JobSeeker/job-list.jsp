<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Set, java.util.HashSet" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dal.CategoryDAO"%>
<%@page import="dal.LocationDAO"%>
<%@page import="model.Category"%>
<%@page import="model.Location"%>
<%@page import="java.util.List"%>
<%
    CategoryDAO cdao = new CategoryDAO();
    List<Category> categories = cdao.getAllCategories();
    String selectedLocation = request.getParameter("locationId");
    LocationDAO ldao = new LocationDAO();
    List<Location> locations = ldao.getAllLocations();

    String[] selectedParam = request.getParameterValues("categoryIds");
    Set<Integer> selectedSet = new HashSet<>();
    if (selectedParam != null) {
        for (String s : selectedParam) {
            try { selectedSet.add(Integer.parseInt(s)); } catch(Exception ex){}
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TopFinder - Tìm việc làm</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/JobSeeker/styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Page-scoped helpers so it looks decent without touching global styles */
            .filters-wrapper {
                max-width: 1280px;
                margin: 0.75rem auto;
                padding: 0;
            }
            .filters-box {
                background: #fff;
                border: 1px solid #eef1f5;
                border-radius: 12px;
                box-shadow: 0 2px 14px rgba(0,0,0,0.04);
                position: relative;
            }
            .filters-bar {
                padding: 0.75rem 1rem;
                display: flex;
                gap: 0.75rem;
                align-items: center;
                flex-wrap: wrap;
            }
            .filter-pill {
                background: #fff;
                border: 1px solid #e9ecef;
                border-radius: 999px;
                padding: 0.5rem 0.75rem;
                color: #444;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                cursor: pointer;
            }
            .filter-pill i {
                color: #6b7280;
            }
            .filter-pill .chev {
                color: #6b7280;
                margin-left: 0.25rem;
            }
            .chips {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            .chip {
                background: #f8fafc;
                color: #3157d6;
                border: 1px solid #e6ecff;
                padding: 0.4rem 0.6rem;
                border-radius: 999px;
                font-size: 0.85rem;
                cursor: pointer;
                transition: background 0.2s, color 0.2s, border 0.2s;
            }
            .chip.selected {
                background: #3157d6;
                color: #fff;
                border: 1px solid #3157d6;
            }
            .chip:hover {
                background: #e6ecff;
                color: #1d3bb8;
            }
            
            .filter-dropdown {
                position: absolute;
                left: 12px;
                right: 12px;
                top: calc(100% + 8px);
                background: #fff;
                border: 1px solid #e5e7eb;
                border-radius: 12px;
                box-shadow: 0 10px 24px rgba(0,0,0,0.06);
                display: none;
                z-index: 30;
                max-width: 820px;
            }
            .filter-dropdown.narrow {
                max-width: 420px;
            }
            .filter-dropdown.show {
                display: block;
            }
            .filter-dropdown .header {
                display: none;
            }
            .filter-dropdown .search {
                padding: 0 1rem 0.75rem;
            }
            .filter-dropdown .search input {
                width: 100%;
                padding: 0.6rem 0.75rem;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
            }
            .filter-dropdown .body {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
                padding: 0 1rem 1rem;
                max-height: 300px;
                overflow: auto;
            }
            .filter-list {
                border-right: 1px solid #f1f5f9;
                padding-right: 0.5rem;
            }
            .filter-item-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 0.5rem;
                padding: 0.45rem 0.5rem;
                border-radius: 8px;
                cursor: pointer;
            }
            .count {
                color: #ef4444;
                font-size: 0.85rem;
            }
            .summary-wrapper {
                max-width: 1280px;
                margin: 0.15rem auto 0.15rem;
            }
            .summary-box {
                background: #fff;
                border: 1px solid #eef1f5;
                border-radius: 12px;
                padding: 0.75rem 1rem;
                box-shadow: 0 2px 14px rgba(0,0,0,0.04);
                margin-bottom: 1rem;
            }
            .summary-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 0.5rem;
            }
            .summary-count {
                color: #111827;
                font-weight: 600;
            }
            .summary-right {
                color: #6b7280;
            }
            .jobs-container {
                display: grid;
                grid-template-columns: 1fr 320px;
                gap: 1rem;
                padding: 0 1rem 1rem;
                max-width: 1280px;
                margin: 0 auto;
            }
            .jobs-results, .jobs-right {
                background: transparent;
            }
            .jobs-results {
                margin-top: 0;
                position: relative;
            }
            .jobs-right {
                margin-top: 73px; /* đẩy cột phải xuống dưới thanh tab để thẳng hàng với bảng */
            }
            .result-card, .right-card {
                background: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 10px;
            }
            .toolbar {
                display: flex;
                justify-content: flex-start;
                align-items: center;
                gap: 0.5rem;
                margin: 0;
                /* trở lại luồng bình thường để không đẩy filter lên */
            }
            .toolbar .tabs {
                display: flex;
                gap: 0.5rem;
            }
            .toolbar .tab-btn {
                background: #fff;
                border: 1px solid #e9ecef;
                color: #1f2937;
                padding: 0.65rem 1rem;
                border-radius: 999px;
                cursor: pointer;
                font-weight: 600;
                font-size: 1rem;
            }
            .toolbar .tab-btn.active {
                border-color: #3157d6;
                color: #3157d6;
                box-shadow: 0 0 0 3px rgba(49,87,214,0.12);
            }
            .result-card {
                padding: 1rem;
                display: grid;
                grid-template-columns: 64px 1fr auto;
                gap: 0.75rem;
                align-items: start;
            }
            .logo-square {
                width: 64px;
                height: 64px;
                background: #f3f3f3;
                border-radius: 8px;
                display: grid;
                place-items: center;
                color: #666;
                font-weight: 700;
            }
            .job-title {
                margin: 0;
                font-size: 1.05rem;
                color: #222;
            }
            .company {
                color: #666;
                margin-top: 0.25rem;
                font-size: 0.95rem;
            }
            .meta {
                display: flex;
                gap: 0.75rem;
                margin-top: 0.5rem;
                color: #555;
                font-size: 0.9rem;
            }
            .actions {
                display: flex;
                gap: 0.5rem;
            }
            .btn-outline {
                background: #fff;
                border: 1px solid #e9ecef;
                padding: 0.5rem 0.75rem;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .btn-outline:hover {
                border-color: #ef4444;
                color: #ef4444;
            }
            .btn-outline.saved {
                background: #ef4444;
                border-color: #ef4444;
                color: #fff;
            }
            .btn-outline.saved i {
                font-weight: 900;
            }
            .btn-primary {
                background: #0066cc;
                color: #fff;
                border: none;
                padding: 0.5rem 0.75rem;
                border-radius: 8px;
                cursor: pointer;
            }
            .right-card {
                padding: 1rem;
                background: #ffffff;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
                position: sticky;
                top: 1rem;
            }
            
            .silver-header {
                margin-bottom: 1rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e2e8f0;
            }
            
            .silver-header h3 {
                margin: 0;
                font-size: 1.1rem;
                color: #1e293b;
                font-weight: 600;
            }
            
            .right-list {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 0.75rem;
                max-height: 715px;
                overflow-y: auto;
                padding-right: 0.5rem;
            }
            
            .right-list::-webkit-scrollbar {
                width: 6px;
            }
            
            .right-list::-webkit-scrollbar-track {
                background: #f1f5f9;
                border-radius: 10px;
            }
            
            .right-list::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 10px;
            }
            
            .right-list::-webkit-scrollbar-thumb:hover {
                background: #94a3b8;
            }
            
            .right-job {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
                padding: 0.75rem;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                background: #fff;
                transition: all 0.2s ease;
            }
            
            .right-job:hover {
                border-color: #0a67ff;
                box-shadow: 0 2px 8px rgba(10, 103, 255, 0.1);
                transform: translateY(-2px);
            }
            
            .right-job h4 {
                margin: 0;
                font-size: 0.9rem;
                color: #1e293b;
                font-weight: 600;
                line-height: 1.3;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }
            
            .right-job .company {
                margin: 0;
                font-size: 0.8rem;
                color: #64748b;
            }
            
            .right-job .meta {
                display: flex;
                flex-direction: column;
                gap: 0.25rem;
                margin-top: 0.25rem;
                font-size: 0.75rem;
                color: #64748b;
            }
            
            .right-job .meta-item {
                display: flex;
                align-items: center;
                gap: 0.35rem;
            }
            
            .right-job .meta-item i {
                color: #0a67ff;
                font-size: 0.7rem;
                width: 12px;
            }
            
            .right-job .btn-mini {
                background: #0a67ff;
                color: #fff;
                border: none;
                border-radius: 6px;
                padding: 0.45rem 0.75rem;
                cursor: pointer;
                font-size: 0.8rem;
                font-weight: 600;
                text-align: center;
                text-decoration: none;
                transition: all 0.2s ease;
                display: block;
                margin-top: 0.25rem;
            }
            
            .right-job .btn-mini:hover {
                background: #0052cc;
                transform: translateY(-1px);
            }
            .results-grid {
                display: grid;
                gap: 0.5rem;
                margin-top: 0;
            }
            /* Table list styles */
            .jobs-table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 10px;
                overflow: hidden;
            }
            .jobs-table thead th {
                background: #f9fafb;
                color: #374151;
                text-align: left;
                font-weight: 600;
                padding: 0.75rem 0.75rem;
                border-bottom: 1px solid #eef1f5;
            }
            .jobs-table tbody td {
                padding: 0.75rem 0.75rem;
                border-bottom: 1px solid #f3f4f6;
                color: #111827;
                vertical-align: top;
            }
            .jobs-table tbody tr:hover {
                background: #fafbff;
            }
            .jobs-table .job-title {
                font-size: 1rem;
                margin: 0;
                color: #111827;
            }
            .jobs-table .company {
                color: #6b7280;
                font-size: 0.9rem;
                margin-top: 0.15rem;
            }
            .jobs-table .actions {
                display: flex;
                gap: 0.5rem;
                justify-content: flex-end;
            }
            @media (max-width: 1100px) {
                .jobs-container {
                    grid-template-columns: 1fr;
                }
            }

            .filter-dropdown.active {
                display: block;
            }

            /* Mega Menu Styles */
            .mega-menu {
                position: fixed;
                top: 72px; /* Height of header */
                left: 0;
                right: 0;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0,0,0,0.16);
                border-top: 1px solid rgba(0, 0, 0, 0.1);
                z-index: 999;
                transform: translateY(-100%);
                opacity: 0;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                padding: 2rem;
            }

            .mega-menu.open {
                transform: translateY(0);
                opacity: 1;
            }

            .mega-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }

            .mega-col h4 {
                color: #333;
                font-size: 1.1rem;
                font-weight: 600;
                margin-bottom: 1rem;
                padding-bottom: 0.5rem;
                border-bottom: 2px solid #0a67ff;
            }

            .mega-col a {
                display: block;
                color: #666;
                text-decoration: none;
                padding: 0.5rem 0;
                transition: color 0.2s;
            }

            .mega-col a:hover {
                color: #0a67ff;
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
    </head>
    <body>
        <!-- Header (shared topbar reused across pages) -->
        <header class="header">
            <div class="header-content">
                <div class="logo-section">
                    <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="logo">
                        <h1>Top</h1>
                        <span class="tagline">Empower growth</span>
                    </a>
                </div>
                <div class="search-section">
                    <form action="job-list" method="get" class="search-bar">
                        <input type="text" name="keyword" placeholder="Tìm kiếm việc làm, công ty"
                               value="${param.keyword != null ? param.keyword : ''}">
                        <c:forEach var="cid" items="${paramValues.categoryIds}">
                            <input type="hidden" name="categoryIds" value="${cid}">
                        </c:forEach>
                        <c:if test="${not empty param.locationId}">
                            <input type="hidden" name="locationId" value="${param.locationId}">
                        </c:if>
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
                    <a class="recruiter-btn" href="../Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
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
                    <a href="${pageContext.request.contextPath}/company-culture">Tất cả công ty</a>
                </div>
            </div>
        </div>

        <form action="job-list" method="get">
            <c:if test="${not empty param.keyword}">
                <input type="hidden" name="keyword" value="${param.keyword}">
            </c:if>
            <!-- Horizontal filters on top -->
            <div class="filters-wrapper">
                <div class="filters-box">
                    <div class="filters-bar">
                        <div class="filter-pill" id="industryFilter">
                            <i class="fas fa-briefcase"></i> Ngành nghề 
                            <i class="fas fa-angle-down chev"></i>
                        </div>
                        <div class="filter-pill" id="locationFilter">
                            <i class="fas fa-map-marker-alt"></i> Địa điểm 
                            <i class="fas fa-angle-down chev"></i>
                        </div>
                        <div style="flex:1"></div>
                        <!-- nút lọc -->
                        <button type="button" class="btn btn-outline" id="resetFilter">Reset</button>
                        <button type="submit" class="btn btn-primary">Lọc</button>
                    </div>

                    <!-- Dropdown ngành nghề -->
                    <div class="filter-dropdown" id="industryDropdown">
                        <div class="header">Ngành nghề</div>
                        <div class="body">
                            <div class="filter-list" id="industryLeft">
                                <%
                                for (Category cat : categories) {
                                %>
                                <div class="filter-item-row">
                                    <label>
                                        <input type="checkbox" name="categoryIds" value="<%=cat.getCategoryID()%>"
                                               <%= selectedSet.contains(cat.getCategoryID()) ? "checked" : "" %> />
                                        <%=cat.getCategoryName()%>
                                    </label>
                                </div>
                                <%
                                }
                                %>

                            </div>
                        </div>
                    </div>
                    <!-- Dropdown địa điểm -->
                    <div class="filter-dropdown" id="locationDropdown">
                        <div class="header">Địa điểm</div>
                        <div class="body">
                            <div class="filter-list">
                                <%
                                    for (Location loc : locations) {
                                %>
                                <div class="filter-item-row">
                                    <label>
                                        <input type="radio" name="locationId" value="<%=loc.getLocationID()%>" 
                                               <%= (loc.getLocationID()+"").equals(selectedLocation) ? "checked" : "" %> />
                                        <%=loc.getLocationName()%>
                                    </label>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>


        <!-- Summary with count and keyword chips -->
        <div class="summary-wrapper">
            <div class="summary-box">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.35rem;">
                    <div class="summary-count" id="jobCount">${totalJobs} việc làm phù hợp</div>
                    <i class="fas fa-angle-down summary-right"></i>
                </div>
                <!-- Keyword filter chips -->
                <div class="chips" id="keywordChips">
                    <span class="chip" data-keyword="Kinh Doanh">Kinh Doanh</span>
                    <span class="chip" data-keyword="AutoCAD">AutoCAD</span>
                    <span class="chip" data-keyword="Tiếng Anh">Tiếng Anh</span>
                    <span class="chip" data-keyword="Giao Tiếp">Giao Tiếp</span>
                    <span class="chip" data-keyword="Communication Skills">Communication Skills</span>
                    <span class="chip" data-keyword="Tài Chính">Tài Chính</span>
                    <span class="chip" data-keyword="Kế Toán">Kế Toán</span>
                    <span class="chip" data-keyword="Chăm Sóc Khách Hàng">Chăm Sóc Khách Hàng</span>
                    <span class="chip" data-keyword="Business Development">Business Development</span>
                    <span class="chip" data-keyword="Sales">Sales</span>
                    <span class="chip" data-keyword="Project Management">Project Management</span>
                    <span class="chip" data-keyword="Quản Lý Dự Án">Quản Lý Dự Án</span>
                    <span class="chip" data-keyword="Communication">Communication</span>
                    <span class="chip" data-keyword="Data Analysis">Data Analysis</span>
                    <span class="chip" data-keyword="Cơ Khí">Cơ Khí</span>
                </div>
            </div>

            <div class="jobs-container">

                <!-- Results -->
                <main class="jobs-results">
                    <div class="toolbar">
                        <div class="tabs">
                            <button type="button" class="tab-btn" id="sortAll">Tất cả</button>
                            <button type="button" class="tab-btn" id="sortSalary">Lương cao</button>
                            <button type="button" class="tab-btn" id="sortDate">Ngày đăng mới</button>
                        </div>

                    </div>

                    <div class="results-grid">
                        <table class="jobs-table">
                            <thead>
                                <tr>
                                    <th>Công việc</th>
                                    <th>Công ty</th>
                                    <th>Địa điểm</th>
                                    <th>Lương</th>
                                    <th>Ngày đăng</th>
                                    <th style="text-align:right;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="jobsTableBody">
                                <c:forEach var="job" items="${jobList}" varStatus="loop">
                                    <tr class="job-row" data-index="${loop.index}">
                                        <td>
                                            <h3 class="job-title">${job.jobTitle}</h3>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/company-profile?id=${job.recruiterID}" class="company" style="color: inherit; text-decoration: none; transition: color 0.2s;" onmouseover="this.style.color='#0b5bd3'" onmouseout="this.style.color='inherit'">${job.companyName}</a>
                                        </td>
                                        <td>
                                            <span class="location">${job.locationName}</span>
                                        </td>
                                        <td>
                                            <span class="salary">${job.salaryRange}</span>
                                        </td>
                                        <td>
                                            <span class="posted">
                                                <c:choose>
                                                    <c:when test="${job.postingDate != null}">
                                                        ${job.postingDate}
                                                    </c:when>
                                                    <c:otherwise>Chưa có</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" class="btn-primary">Xem chi tiết</a>
                                                <button class="btn-outline save-job-btn" data-job-id="${job.jobID}" title="Lưu công việc">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination (JS) -->
                    <div id="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:1rem; align-items:center;">
                        <button id="prevPage" class="btn-outline"><i class="fas fa-chevron-left"></i></button>
                        <span id="pageInfo" style="color:#666; min-width:48px; text-align:center;"></span>
                        <button id="nextPage" class="btn-outline"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </main>
                <aside class="jobs-right">
                    <div class="right-card">
                        <div class="silver-header">
                            <h3>Việc làm bạn sẽ thích</h3>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty featuredSilverJobs}">
                                <div class="right-list">
                                    <c:forEach var="job" items="${featuredSilverJobs}" varStatus="status">
                                        <div class="right-job">
                                            <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" style="text-decoration: none; color: inherit;">
                                                <h4>${job.jobTitle}</h4>
                                            </a>
                                            <p class="company">${job.companyName}</p>
                                            <div class="meta">
                                                <div class="meta-item">
                                                    <i class="fas fa-map-marker-alt"></i>
                                                    <span>${job.locationName}</span>
                                                </div>
                                                <c:if test="${not empty job.salaryRange}">
                                                    <div class="meta-item">
                                                        <i class="fas fa-money-bill-wave"></i>
                                                        <span>${job.salaryRange}</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" class="btn-mini">Xem chi tiết</a>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: #94a3b8;">
                                    <i class="fas fa-briefcase" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
                                    <p style="margin: 0; font-size: 0.9rem;">Chưa có việc làm nổi bật</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </aside>

            </div>

        </div>
        <script src="${pageContext.request.contextPath}/JobSeeker/script.js"></script>
        <script>
        // --- Keyword filter ---
        document.addEventListener('DOMContentLoaded', function () {
            const chips = document.querySelectorAll('#keywordChips .chip');
            const jobRows = document.querySelectorAll('tr.job-row');
            const jobCount = document.getElementById('jobCount');
            let selectedKeywords = [];

            chips.forEach(chip => {
                chip.addEventListener('click', function () {
                    const keyword = chip.getAttribute('data-keyword');
                    chip.classList.toggle('selected');
                    // Cập nhật danh sách keyword đã chọn
                    selectedKeywords = Array.from(chips)
                        .filter(c => c.classList.contains('selected'))
                        .map(c => c.getAttribute('data-keyword'));
                    filterJobsByKeywords();
                });
            });

            function filterJobsByKeywords() {
                let visibleCount = 0;
                jobRows.forEach(row => {
                    // Lấy text để search
                    const text = (
                        row.querySelector('.job-title')?.textContent + ' ' +
                        row.querySelector('.company')?.textContent + ' ' +
                        row.querySelector('.location')?.textContent + ' ' +
                        row.querySelector('.salary')?.textContent
                    ).toLowerCase();
                    // Nếu không chọn keyword nào thì hiện tất cả
                    if (selectedKeywords.length === 0 || selectedKeywords.some(kw => text.includes(kw.toLowerCase()))) {
                        row.style.display = '';
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });
                jobCount.textContent = visibleCount + ' việc làm phù hợp';
            }
        });
        // --- Simple JS Pagination ---
            document.addEventListener('DOMContentLoaded', function () {
                const jobsGrid = document.getElementById('jobsTableBody');
                const rows = Array.from(jobsGrid.querySelectorAll('tr.job-row'));
                const pageInfo = document.getElementById('pageInfo');
                const prevBtn = document.getElementById('prevPage');
                const nextBtn = document.getElementById('nextPage');
                const JOBS_PER_PAGE = 10; // Số job mỗi trang
                let currentPage = 1;
                const totalPages = Math.max(1, Math.ceil(rows.length / JOBS_PER_PAGE));

                function renderPage(page) {
                    // Giới hạn trang
                    if (page < 1)
                        page = 1;
                    if (page > totalPages)
                        page = totalPages;
                    currentPage = page;
                    // Ẩn/hiện các dòng job
                    rows.forEach((row, idx) => {
                        row.style.display = (idx >= (currentPage - 1) * JOBS_PER_PAGE && idx < currentPage * JOBS_PER_PAGE) ? '' : 'none';
                    });
                    // Cập nhật số trang
                    pageInfo.textContent = currentPage + ' / ' + totalPages;
                    // Disable nút nếu ở đầu/cuối
                    prevBtn.disabled = (currentPage === 1);
                    nextBtn.disabled = (currentPage === totalPages);
                }
                // Sự kiện nút
                prevBtn.addEventListener('click', () => renderPage(currentPage - 1));
                nextBtn.addEventListener('click', () => renderPage(currentPage + 1));
                // Khởi tạo
                renderPage(1);
            });
        // Lấy DOM
            const industryFilter = document.getElementById("industryFilter");
            const locationFilter = document.getElementById("locationFilter");
            const industryDropdown = document.getElementById("industryDropdown");
            const locationDropdown = document.getElementById("locationDropdown");
            const jobsGrid = document.querySelector('#jobsTableBody');
            const resetFilterBtn = document.getElementById("resetFilter");

        // Thêm data-index cho mỗi hàng (nếu chưa có) để reset thứ tự gốc
            Array.from(jobsGrid.querySelectorAll('tr.job-row')).forEach((row, idx) => {
                if (!row.dataset.index)
                    row.dataset.index = idx;
            });

        // --- Dropdown ---
            industryFilter.addEventListener("click", function (e) {
                e.stopPropagation();
                industryDropdown.classList.toggle("active");
                locationDropdown.classList.remove("active");
            });

            locationFilter.addEventListener("click", function (e) {
                e.stopPropagation();
                locationDropdown.classList.toggle("active");
                industryDropdown.classList.remove("active");
            });

            industryDropdown.addEventListener("click", e => e.stopPropagation());
            locationDropdown.addEventListener("click", e => e.stopPropagation());

            document.addEventListener("click", () => {
                industryDropdown.classList.remove("active");
                locationDropdown.classList.remove("active");
            });

        // --- Reset Filter ---
            resetFilterBtn.addEventListener("click", () => {
                const form = resetFilterBtn.closest("form");
                form.querySelectorAll("input[type=checkbox], input[type=radio]").forEach(el => el.checked = false);
                form.submit();
            });

        // --- Sorting Tabs ---
            const sortAllBtn = document.getElementById('sortAll');
            const sortSalaryBtn = document.getElementById('sortSalary');
            const sortDateBtn = document.getElementById('sortDate');

        // Hàm để set active tab
            function setActiveTab(activeBtn) {
                [sortAllBtn, sortSalaryBtn, sortDateBtn].forEach(btn => btn.classList.remove('active'));
                activeBtn.classList.add('active');
            }

        // Hàm lấy job-cards hiện tại
            function getJobCards() {
                return Array.from(jobsGrid.querySelectorAll('tr.job-row'));
            }

        // Hàm parse date từ string format YYYY-MM-DD
            function parseDate(dateString) {
                // Nếu dateString là "Chưa có" hoặc empty, return date rất cũ để đẩy xuống cuối
                if (!dateString || dateString.trim() === "Chưa có" || dateString.trim() === "" || dateString.trim() === "null") {
                    return new Date(0); // 1/1/1970
                }

                const trimmed = dateString.trim();
                console.log('Parsing date string:', `"${trimmed}"`);

                // Parse format YYYY-MM-DD (ISO format)
                let date = new Date(trimmed + 'T00:00:00'); // Thêm time để đảm bảo parse đúng timezone

                // Kiểm tra xem date có hợp lệ không
                if (isNaN(date.getTime())) {
                    console.warn('Could not parse date:', dateString);
                    return new Date(0); // Return date cũ để đẩy xuống cuối
                }

                console.log('Parsed date result:', date);
                return date;
            }

            sortAllBtn.addEventListener('click', () => {
                console.log('Sorting by: All (original order)');
                setActiveTab(sortAllBtn);

                getJobCards()
                        .sort((a, b) => parseInt(a.dataset.index) - parseInt(b.dataset.index))
                        .forEach(card => jobsGrid.appendChild(card));
            });

            sortSalaryBtn.addEventListener('click', () => {
                console.log('Sorting by: Salary');
                setActiveTab(sortSalaryBtn);

                getJobCards()
                        .sort((a, b) => {
                            const salaryElementA = a.querySelector('.salary');
                            const salaryElementB = b.querySelector('.salary');

                            if (!salaryElementA || !salaryElementB)
                                return 0;

                            const salA = parseInt(salaryElementA.textContent.replace(/\D/g, '') || '0');
                            const salB = parseInt(salaryElementB.textContent.replace(/\D/g, '') || '0');

                            return salB - salA; // Cao xuống thấp
                        })
                        .forEach(card => jobsGrid.appendChild(card));
            });

            sortDateBtn.addEventListener('click', () => {
                console.log('Sorting by: Date');
                setActiveTab(sortDateBtn);

                getJobCards()
                        .sort((a, b) => {
                            const dateElementA = a.querySelector('.posted');
                            const dateElementB = b.querySelector('.posted');

                            if (!dateElementA || !dateElementB) {
                                console.warn('Date element not found');
                                return 0;
                            }

                            const dateTextA = dateElementA.textContent;
                            const dateTextB = dateElementB.textContent;
                            const dateA = parseDate(dateTextA);
                            const dateB = parseDate(dateTextB);

                            console.log('Comparing dates:', dateTextA, 'vs', dateTextB);
                            console.log('Parsed dates:', dateA, 'vs', dateB);

                            // So sánh ngày
                            const timeDiff = dateB.getTime() - dateA.getTime();

                            // Nếu ngày giống nhau, sắp xếp theo index gốc để đảm bảo thứ tự ổn định
                            if (timeDiff === 0) {
                                return parseInt(a.dataset.index) - parseInt(b.dataset.index);
                            }

                            return timeDiff; // Mới nhất trước (số dương nếu B mới hơn A)
                        })
                        .forEach(card => jobsGrid.appendChild(card));
            });

        // Set tab "Tất cả" làm active mặc định
            setActiveTab(sortAllBtn);

        // --- Save Job Functionality ---
            document.querySelectorAll('.save-job-btn').forEach(btn => {
                const jobId = btn.getAttribute('data-job-id');

                // Check if job is already saved
                checkIfSaved(jobId, btn);

                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    toggleSaveJob(jobId, btn);
                });
            });

            function checkIfSaved(jobId, btn) {
                fetch('${pageContext.request.contextPath}/saved-jobs', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=check&jobId=' + jobId
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success && data.isSaved) {
                                btn.classList.add('saved');
                                btn.querySelector('i').classList.remove('far');
                                btn.querySelector('i').classList.add('fas');
                                btn.title = 'Bỏ lưu công việc';
                            }
                        })
                        .catch(error => console.error('Error:', error));
            }

            function toggleSaveJob(jobId, btn) {
                const isSaved = btn.classList.contains('saved');
                const action = isSaved ? 'unsave' : 'save';

                fetch('${pageContext.request.contextPath}/saved-jobs', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=' + action + '&jobId=' + jobId
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                if (action === 'save') {
                                    btn.classList.add('saved');
                                    btn.querySelector('i').classList.remove('far');
                                    btn.querySelector('i').classList.add('fas');
                                    btn.title = 'Bỏ lưu công việc';
                                } else {
                                    btn.classList.remove('saved');
                                    btn.querySelector('i').classList.remove('fas');
                                    btn.querySelector('i').classList.add('far');
                                    btn.title = 'Lưu công việc';
                                }

                                // Optional: show a subtle notification
                                const notification = document.createElement('div');
                                notification.textContent = data.message;
                                notification.style.cssText = 'position:fixed;top:80px;right:20px;background:#10b981;color:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);z-index:9999;animation:slideIn 0.3s ease;';
                                document.body.appendChild(notification);

                                setTimeout(() => {
                                    notification.style.animation = 'slideOut 0.3s ease';
                                    setTimeout(() => notification.remove(), 300);
                                }, 2000);
                            } else {
                                alert(data.message || 'Có lỗi xảy ra');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi lưu công việc');
                        });
            }
        </script>
        <style>
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
        </style>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const toggle = document.getElementById('menuToggle');
                const panel = document.getElementById('megaMenu');

                console.log('Toggle element:', toggle);
                console.log('Panel element:', panel);

                if (!toggle || !panel) {
                    console.error('Menu elements not found!');
                    return;
                }

                function closeOnOutside(e) {
                    if (!panel.contains(e.target) && !toggle.contains(e.target)) {
                        panel.classList.remove('open');
                        document.removeEventListener('click', closeOnOutside);
                    }
                }

                toggle.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    console.log('Menu toggle clicked!');
                    panel.classList.toggle('open');
                    console.log('Panel classes:', panel.className);
                    if (panel.classList.contains('open')) {
                        document.addEventListener('click', closeOnOutside);
                    }
                });
            });
        </script>


        <!-- Reuses the same topbar markup as other pages like profile-overview.html and job-detail.html -->
    </body>
</html>

