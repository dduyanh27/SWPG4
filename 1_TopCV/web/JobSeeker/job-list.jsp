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
                padding: 0.5rem;
            }
            .right-list {
                display: grid;
                gap: 0.5rem;
            }
            .right-job {
                display: grid;
                grid-template-columns: 48px 1fr auto;
                gap: 0.5rem;
                align-items: center;
                padding: 0.6rem;
                border: 1px solid #f3f3f3;
                border-radius: 10px;
                background:#fff;
            }
            .right-job .logo-square {
                width: 48px;
                height: 48px;
                font-size: 0.85rem;
            }
            .right-job h4 {
                margin: 0;
                font-size: 0.98rem;
                color: #111827;
            }
            .right-job .company {
                margin: 0.15rem 0 0;
                font-size: 0.85rem;
                color:#6b7280;
            }
            .right-job .meta {
                display:flex;
                gap:0.5rem;
                margin-top:0.25rem;
                font-size:0.8rem;
                color:#374151;
            }
            .right-job .meta .pill {
                background:#f3f4f6;
                border-radius:999px;
                padding:0.15rem 0.5rem;
            }
            .right-job .btn-mini {
                background:#0066cc;
                color:#fff;
                border:none;
                border-radius:8px;
                padding:0.4rem 0.55rem;
                cursor:pointer;
                font-size:0.85rem;
            }
            .results-grid {
                display: grid;
                gap: 0.5rem;
                margin-top: -20px;
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
                    <a href="#">Việc đã lưu</a>
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
                    <div class="summary-count">${totalJobs} việc làm phù hợp</div>
                    <i class="fas fa-angle-down summary-right"></i>
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
                        <c:forEach var="job" items="${jobList}">
                            <div class="result-card">
                                <!-- Tạm thời logo-square hiển thị JobID -->
                                <div class="logo-square">${job.jobID}</div>
                                <div>
                                    <h3 class="job-title">${job.jobTitle}</h3>
                                    <div class="company">${job.companyName}</div>
                                    <div class="meta">
                                        <span class="salary">${job.salaryRange}</span>
                                        <span class="location">${job.locationName}</span>
                                        <span class="posted">
                                            <c:choose>
                                                <c:when test="${job.postingDate != null}">
                                                    ${job.postingDate}
                                                </c:when>
                                                <c:otherwise>Chưa có</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/job-detail?jobId=${job.jobID}" class="btn-primary">Xem chi tiết</a>
                                    <button class="btn-outline"><i class="far fa-heart"></i></button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination-->
                    <div style="display:flex; justify-content:center; gap:0.5rem; margin-top:1rem;">
                        <button class="btn-outline" disabled><i class="fas fa-chevron-left"></i></button>
                        <span style="display:flex; align-items:center; color:#666;">1/50</span>
                        <button class="btn-outline"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </main>
            </div>
        </div>
            <script src="${pageContext.request.contextPath}/JobSeeker/script.js"></script>
<script>
// Lấy DOM
const industryFilter = document.getElementById("industryFilter");
const locationFilter = document.getElementById("locationFilter");
const industryDropdown = document.getElementById("industryDropdown");
const locationDropdown = document.getElementById("locationDropdown");
const jobsGrid = document.querySelector('.results-grid');
const resetFilterBtn = document.getElementById("resetFilter");

// Thêm data-index cho mỗi job-card để reset thứ tự gốc
Array.from(jobsGrid.children).forEach((card, idx) => card.dataset.index = idx);

// --- Dropdown ---
industryFilter.addEventListener("click", function(e) {
    e.stopPropagation();
    industryDropdown.classList.toggle("active");
    locationDropdown.classList.remove("active");
});

locationFilter.addEventListener("click", function(e) {
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
    return Array.from(jobsGrid.children);
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
            
            if (!salaryElementA || !salaryElementB) return 0;
            
            const salA = parseInt(salaryElementA.textContent.replace(/\D/g,'') || '0');
            const salB = parseInt(salaryElementB.textContent.replace(/\D/g,'') || '0');
            
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
</script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const toggle = document.getElementById('menuToggle');
    const panel = document.getElementById('megaMenu');
    
    console.log('Toggle element:', toggle);
    console.log('Panel element:', panel);
    
    if(!toggle || !panel) {
        console.error('Menu elements not found!');
        return;
    }
    
    function closeOnOutside(e){
        if(!panel.contains(e.target) && !toggle.contains(e.target)){
            panel.classList.remove('open');
            document.removeEventListener('click', closeOnOutside);
        }
    }
    
    toggle.addEventListener('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        console.log('Menu toggle clicked!');
        panel.classList.toggle('open');
        console.log('Panel classes:', panel.className);
        if(panel.classList.contains('open')){
            document.addEventListener('click', closeOnOutside);
        }
    });
});
</script>


            <!-- Reuses the same topbar markup as other pages like profile-overview.html and job-detail.html -->
    </body>
</html>

