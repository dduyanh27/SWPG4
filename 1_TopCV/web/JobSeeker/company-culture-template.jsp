<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám Phá Văn Hoá Công Ty - VietnamWorks</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/JobSeeker/company-culture.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header copied from JobSeeker/index.jsp -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <div class="logo">
                    <a class="logo-link" href="${pageContext.request.contextPath}/index.jsp" title="Trang chủ">
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
    <!-- Mega menu panel (copied) -->
    <div class="mega-menu" id="megaMenu">
        <div class="mega-grid">
            <div class="mega-col">
                <h4>Việc làm</h4>
                <a href="#">Việc làm mới nhất</a>
                <a href="${pageContext.request.contextPath}/job-list">Tìm việc làm</a>
                <a href="#">Việc làm quản lý</a>
            </div>
            <c:if test="${not empty sessionScope.user && sessionScope.userType == 'jobseeker'}">
                <div class="mega-col">
                    <h4>Việc của tôi</h4>
                    <a href="${pageContext.request.contextPath}/saved-jobs">Việc đã lưu</a>
                    <a href="${pageContext.request.contextPath}/applied-jobs">Việc đã ứng tuyển</a>
                    <a href="#">Thông báo việc làm</a>
                    <a href="#">Việc dành cho bạn</a>
                </div>
            </c:if>
            <div class="mega-col">
                <h4>Công ty</h4>
                <a href="${pageContext.request.contextPath}/company-culture">Tất cả công ty</a>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <h1 class="main-title">Khám Phá Văn Hoá Công Ty</h1>
                <p class="subtitle">Tìm hiểu văn hoá công ty và chọn cho bạn nơi làm việc phù hợp nhất.</p>
                
                <!-- Company Search Bar -->
                <form action="${pageContext.request.contextPath}/company-culture" method="get" class="company-search-bar">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" name="search" class="company-search-input" 
                           placeholder="Nhập tên công ty" value="${searchQuery}">
                    <button type="submit" class="search-company-btn">Tìm</button>
                </form>
            </div>
        </section>

        <!-- Featured Companies Section -->
        <section class="featured-companies">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Công ty nổi bật <span class="count">(${totalCompanies})</span></h2>
                    <form action="${pageContext.request.contextPath}/company-culture" method="get" style="display: inline;">
                        <input type="hidden" name="search" value="${searchQuery}">
                        <select name="category" class="filter-dropdown" onchange="this.form.submit()">
                            <option value="0" ${categoryFilter == null || categoryFilter == '0' ? 'selected' : ''}>Tất cả lĩnh vực</option>
                            <option value="1" ${categoryFilter == '1' ? 'selected' : ''}>Công nghệ thông tin</option>
                            <option value="2" ${categoryFilter == '2' ? 'selected' : ''}>Tài chính</option>
                            <option value="3" ${categoryFilter == '3' ? 'selected' : ''}>Ngân hàng</option>
                            <option value="4" ${categoryFilter == '4' ? 'selected' : ''}>Khác</option>
                        </select>
                    </form>
                </div>

                <!-- Company Cards Grid -->
                <div class="companies-grid">
                    <c:forEach var="company" items="${companies}">
                        <!-- Company Card -->
                        <div class="company-card">
                            <!-- Company Banner với Logo to -->
                            <a href="${pageContext.request.contextPath}/company-profile?id=${company.recruiterID}" style="text-decoration: none; color: inherit;">
                                <div class="company-banner">
                                    <c:choose>
                                        <c:when test="${not empty company.companyLogoURL}">
                                            <!-- Resolve absolute vs relative logo URL and add onerror fallback -->
                                            <c:set var="logoPath" value="${company.companyLogoURL}" />
                                            <c:choose>
                                                <c:when test="${fn:startsWith(logoPath, 'http://') || fn:startsWith(logoPath, 'https://')}">
                                                    <c:set var="resolvedLogo" value="${logoPath}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="resolvedLogo" value="${pageContext.request.contextPath}${fn:startsWith(logoPath, '/') ? logoPath : '/'.concat(logoPath)}" />
                                                </c:otherwise>
                                            </c:choose>
                                            <img src="${resolvedLogo}"
                                                 alt="${company.companyName}"
                                                 class="banner-logo"
                                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/img/logo/logo.png'">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="banner-logo-placeholder">
                                                ${company.companyName.substring(0, 1).toUpperCase()}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </a>
                            
                            <!-- Company Content -->
                            <div class="company-content">
                                <!-- Company Name -->
                                <a href="${pageContext.request.contextPath}/company-profile?id=${company.recruiterID}" style="text-decoration: none; color: inherit;">
                                    <h3 class="company-name" style="transition: color 0.2s;" onmouseover="this.style.color='#0b5bd3'" onmouseout="this.style.color='inherit'">
                                        ${company.companyName.length() > 30 ? 
                                          company.companyName.substring(0, 30).concat('...') : 
                                          company.companyName}
                                    </h3>
                                </a>
                                
                                <!-- Company Description -->
                                <c:if test="${not empty company.companyDescription}">
                                    <p class="company-description">
                                        ${company.companyDescription.length() > 80 ? 
                                          company.companyDescription.substring(0, 80).concat('...') : 
                                          company.companyDescription}
                                    </p>
                                </c:if>
                                
                                <!-- Job Opening Count -->
                                <div class="job-opening-count">
                                    <i class="fas fa-briefcase"></i>
                                    <span>Đang tuyển <strong>${not empty company.jobCount ? company.jobCount : 0}</strong> việc làm</span>
                                </div>
                                
                                <!-- Company Info -->
                                <div class="job-listings">
                                    <div class="company-info-item">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span>
                                            ${not empty company.companyAddress ? company.companyAddress : 'Chưa cập nhật'}
                                        </span>
                                    </div>
                                    
                                    <c:if test="${not empty company.companySize}">
                                        <div class="company-info-item">
                                            <i class="fas fa-users"></i>
                                            <span>Quy mô: ${company.companySize}</span>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty company.website}">
                                        <div class="company-info-item">
                                            <i class="fas fa-globe"></i>
                                            <a href="${company.website}" 
                                               target="_blank" 
                                               class="website-link">
                                                ${company.website.length() > 30 ? 
                                                  company.website.substring(0, 30).concat('...') : 
                                                  company.website}
                                            </a>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty company.phone}">
                                        <div class="company-info-item">
                                            <i class="fas fa-phone"></i>
                                            <span>${company.phone}</span>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- View Company Button -->
                                <a href="${pageContext.request.contextPath}/company-profile?id=${company.recruiterID}" class="view-company-btn">
                                    Xem công ty
                                </a>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Hiển thị thông báo nếu không có công ty -->
                    <c:if test="${empty companies}">
                        <div class="no-results">
                            <i class="fas fa-building" style="font-size: 48px; color: #ccc; margin-bottom: 20px;"></i>
                            <p>Không tìm thấy công ty phù hợp</p>
                            <c:if test="${not empty searchQuery}">
                                <p style="margin-top: 10px;">
                                    <a href="${pageContext.request.contextPath}/company-culture" style="color: #00b14f;">Xem tất cả công ty</a>
                                </p>
                            </c:if>
                        </div>
                    </c:if>
                </div>

                <!-- Pagination -->
                <c:if test="${not empty companies}">
                    <div id="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:2rem; align-items:center;">
                        <button id="prevPage" class="btn-outline">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <span id="pageInfo" style="color:#666; min-width:80px; text-align:center; font-size:14px;"></span>
                        <button id="nextPage" class="btn-outline">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </c:if>
            </div>
        </section>

        <%-- <!-- Footer -->
        <footer class="page-footer">
            <div class="footer-links">
                <a href="#">tìm việc làm</a>
                <a href="#">tuyển dụng</a>
                <a href="#">thần số học</a>
                <a href="#">cv xin việc</a>
                <a href="#">mẫu cv</a>
                <a href="#">việc làm bắc giang</a>
                <a href="#">việc làm hưng yên</a>
                <a href="#">việc làm bà rịa vũng tàu</a>
                <a href="#">việc làm quảng ngãi</a>
                <a href="#">việc làm nam định</a>
                <a href="#">việc làm huế</a>
            </div>
        </footer> --%>
    </main>

    <%-- <!-- Floating Action Buttons -->
    <div class="floating-buttons">
        <button class="floating-btn zalo-btn">
            <span>Zalo</span>
        </button>
        <button class="floating-btn scroll-top-btn">
            <i class="fas fa-arrow-up"></i>
        </button>
        <button class="floating-btn chat-btn">
            <i class="fas fa-smile"></i>
        </button>
    </div> --%>

    <style>
        /* Pagination Button Styles */
        .btn-outline {
            background: #fff;
            border: 1px solid #e9ecef;
            padding: 0.5rem 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #444;
        }
        .btn-outline:hover:not(:disabled) {
            border-color: #3157d6;
            color: #3157d6;
        }
        .btn-outline:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
    </style>

    <script>
        // Header mega menu toggle
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

        // Simple JS Pagination for Companies
        document.addEventListener('DOMContentLoaded', function () {
            const companiesGrid = document.querySelector('.companies-grid');
            if (!companiesGrid) return;
            
            const companyCards = Array.from(companiesGrid.querySelectorAll('.company-card'));
            const pageInfo = document.getElementById('pageInfo');
            const prevBtn = document.getElementById('prevPage');
            const nextBtn = document.getElementById('nextPage');
            const paginationContainer = document.getElementById('pagination');
            
            const COMPANIES_PER_PAGE = 12; // 4 hàng x 3 cột
            let currentPage = 1;
            const totalPages = Math.max(1, Math.ceil(companyCards.length / COMPANIES_PER_PAGE));

            function renderPage(page) {
                // Giới hạn trang
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;
                currentPage = page;
                
                // Ẩn/hiện các company card
                companyCards.forEach((card, idx) => {
                    card.style.display = (idx >= (currentPage - 1) * COMPANIES_PER_PAGE && idx < currentPage * COMPANIES_PER_PAGE) ? '' : 'none';
                });
                
                // Cập nhật số trang
                if (pageInfo) {
                    pageInfo.textContent = currentPage + ' / ' + totalPages;
                }
                
                // Disable nút nếu ở đầu/cuối
                if (prevBtn) prevBtn.disabled = (currentPage === 1);
                if (nextBtn) nextBtn.disabled = (currentPage === totalPages);
                
                // Scroll to top of companies section khi chuyển trang
                if (currentPage > 1) {
                    const featuredSection = document.querySelector('.featured-companies');
                    if (featuredSection) {
                        featuredSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                }
            }
            
            // Sự kiện nút
            if (prevBtn) prevBtn.addEventListener('click', () => renderPage(currentPage - 1));
            if (nextBtn) nextBtn.addEventListener('click', () => renderPage(currentPage + 1));
            
            // Khởi tạo
            renderPage(1);
        });
    </script>
    <script src="${pageContext.request.contextPath}/JobSeeker/company-culture.js"></script>
</body>
</html>

