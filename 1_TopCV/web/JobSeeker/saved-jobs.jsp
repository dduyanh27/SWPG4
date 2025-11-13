<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách công việc đã lưu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
    <style>
        /* CSS Variables */
        :root {
            --bg-left: #061f3b;
            --bg-right: #0a67ff;
            --text-light: rgba(255,255,255,0.92);
            --text-light-muted: rgba(255,255,255,0.75);
            --text-dark: #21323b;
            --blue: #0a67ff;
            --blue-dark: #0b5bdf;
            --white: #ffffff;
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.1);
            --shadow-md: 0 8px 25px rgba(0,0,0,0.15);
            --shadow-lg: 0 15px 35px rgba(0,0,0,0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, var(--bg-left) 0%, var(--bg-right) 100%);
            color: var(--white);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }

        /* ========== HEADER ========== */
        .header {
            position: sticky;
            top: 0;
            z-index: 1200;
            background: rgba(6, 31, 59, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 16px 32px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Logo Section */
        .logo-section .logo h1 {
            margin: 0;
            font-weight: 700;
            color: var(--white);
            font-size: 28px;
        }

        .logo-section .tagline {
            display: block;
            font-size: 11px;
            color: #e8f0ff;
            opacity: 0.85;
            margin-top: 2px;
        }

        /* Search Section */
        .search-section {
            flex: 1;
            max-width: 600px;
        }

        .search-bar {
            width: 100%;
            background: var(--white);
            border-radius: 30px;
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            transition: all 0.3s ease;
        }

        .search-bar:focus-within {
            box-shadow: 0 6px 20px rgba(10,103,255,0.3);
            transform: translateY(-1px);
        }

        .search-bar input {
            flex: 1;
            border: none;
            background: transparent;
            outline: none;
            font-size: 15px;
            color: #0f172a;
            padding: 10px;
        }

        .search-bar input::placeholder {
            color: #94a3b8;
        }

        .search-btn {
            border: none;
            background: linear-gradient(135deg, var(--blue-dark), var(--blue));
            color: var(--white);
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(10,103,255,0.3);
        }

        .search-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 18px rgba(10,103,255,0.5);
        }

        /* Header Right */
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .menu-toggle {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--white);
            cursor: pointer;
            padding: 10px 16px;
            border-radius: 10px;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.1);
        }

        .menu-toggle:hover {
            background: rgba(255,255,255,0.2);
        }

        .recruiter-btn {
            background: linear-gradient(135deg, #10b981, #059669);
            color: var(--white);
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(16,185,129,0.3);
        }

        .recruiter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(16,185,129,0.4);
        }

        .user-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-actions > a,
        .user-actions > div {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            background: rgba(255,255,255,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            font-size: 18px;
        }

        .user-actions > a:hover,
        .user-actions > div:hover {
            background: rgba(255,255,255,0.2);
            transform: scale(1.1);
        }

        .logout-icon:hover {
            background: rgba(239,68,68,0.2) !important;
            color: #ef4444 !important;
        }

        /* ========== MEGA MENU ========== */
        .mega-menu {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            top: 78px;
            width: 92%;
            max-width: 1100px;
            background: var(--white);
            color: #0f172a;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 28px;
            display: none;
            z-index: 1300;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateX(-50%) translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(-50%) translateY(0);
            }
        }

        .mega-menu.open {
            display: block;
        }

        .mega-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 32px;
        }

        .mega-col h4 {
            margin: 0 0 16px 0;
            color: var(--blue-dark);
            font-weight: 700;
            font-size: 16px;
        }

        .mega-col a {
            display: block;
            padding: 12px 16px;
            margin: 6px 0;
            color: #334155;
            border-radius: 10px;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .mega-col a:hover {
            color: var(--blue);
            background: rgba(10,103,255,0.08);
            transform: translateX(5px);
        }

        /* ========== MAIN CONTENT ========== */
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }

        h2 {
            text-align: center;
            color: var(--white);
            margin-bottom: 40px;
            font-size: 36px;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            position: relative;
            padding-bottom: 15px;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--blue-dark), var(--blue));
            border-radius: 2px;
        }

        /* ========== JOB CARDS ========== */
        .job-card {
            background: var(--white);
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .job-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #ef4444, #f59e0b, #10b981);
        }

        .job-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-lg);
        }

        .job-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--blue);
            margin-bottom: 12px;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .job-title:hover {
            color: var(--blue-dark);
        }

        .company {
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .company::before {
            content: '🏢';
            font-size: 18px;
        }

        .job-info {
            font-size: 14px;
            margin: 10px 0;
            color: #475569;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            line-height: 1.6;
        }

        .job-info strong {
            color: var(--blue-dark);
            min-width: 130px;
            font-weight: 600;
        }

        /* ========== ACTION BUTTONS ========== */
        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 13px 28px;
            background: linear-gradient(135deg, var(--blue-dark), var(--blue));
            color: var(--white);
            border-radius: 30px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(10,103,255,0.3);
            border: none;
            cursor: pointer;
        }

        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(10,103,255,0.5);
        }

        .unsave-btn {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            box-shadow: 0 4px 15px rgba(239,68,68,0.3);
        }

        .unsave-btn:hover {
            box-shadow: 0 8px 25px rgba(239,68,68,0.5);
        }

        /* ========== EMPTY STATE ========== */
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 2px dashed rgba(255,255,255,0.3);
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 24px;
            color: rgba(255,255,255,0.6);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .empty-state p {
            font-size: 20px;
            color: var(--text-light-muted);
            margin-bottom: 10px;
        }

        /* ========== RESPONSIVE ========== */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                padding: 12px 20px;
                gap: 15px;
            }

            .search-section {
                width: 100%;
                max-width: 100%;
            }

            .header-right {
                width: 100%;
                justify-content: space-between;
            }

            .mega-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .container {
                width: 95%;
                margin: 30px auto;
            }

            h2 {
                font-size: 26px;
            }

            .job-card {
                padding: 20px;
            }

            .job-info {
                flex-direction: column;
                gap: 5px;
            }

            .job-info strong {
                min-width: auto;
            }

            .action-buttons {
                flex-direction: column;
            }
        }

        @media (max-width: 480px) {
            .menu-toggle span {
                display: none;
            }

            .recruiter-btn {
                padding: 10px 15px;
                font-size: 13px;
            }

            .user-actions > a,
            .user-actions > div {
                width: 38px;
                height: 38px;
                font-size: 16px;
            }
        }
    </style>
</head>
<body>

    <!-- ========== HEADER ========== -->
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
                    <input type="text" name="keyword" placeholder="Tìm kiếm việc làm, công ty...">
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>
            
            <div class="header-right">
                <div class="menu-toggle" id="menuToggle">
                    <i class="fas fa-bars"></i>
                    <span>Danh mục</span>
                </div>
                
                <a class="recruiter-btn" href="../Recruiter/recruiter-login.jsp">Nhà tuyển dụng</a>
                
                <div class="user-actions">
                    <a class="profile-icon" href="${pageContext.request.contextPath}/jobseekerprofile" title="Tài khoản">
                        <i class="fas fa-user"></i>
                    </a>
                    <%@ include file="/shared/notification-dropdown.jsp" %>
                    <div class="message-icon" title="Tin nhắn">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <a class="logout-icon" href="${pageContext.request.contextPath}/LogoutServlet" title="Đăng xuất">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- ========== MEGA MENU ========== -->
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
                <a href="#">Top công ty</a>
                <a href="#">Đánh giá công ty</a>
            </div>
        </div>
    </div>

    <!-- ========== MAIN CONTENT ========== -->
    <div class="container">
        <h2>Danh sách công việc đã lưu</h2>

        <!-- Empty State -->
        <c:if test="${empty savedJobs}">
            <div class="empty-state">
                <i class="fas fa-heart"></i>
                <p>Bạn chưa lưu công việc nào</p>
                <p style="font-size: 14px; color: rgba(255,255,255,0.6);">
                    Hãy lưu các công việc yêu thích để dễ dàng theo dõi!
                </p>
                <a href="${pageContext.request.contextPath}/job-list" class="action-btn" style="margin-top: 25px;">
                    <i class="fas fa-search"></i> Tìm việc làm ngay
                </a>
            </div>
        </c:if>

        <!-- Job Cards -->
        <div id="savedJobsList">
            <c:forEach var="saved" items="${savedJobs}" varStatus="loop">
                <div class="job-card" data-job-id="${saved.jobID}" data-index="${loop.index}">
                    <div class="job-title">${saved.jobTitle}</div>
                    <div class="company">${saved.companyName}</div>
                    <div class="job-info">
                        <strong><i class="fas fa-map-marker-alt"></i> Địa điểm:</strong>
                        <span>${saved.locationName}</span>
                    </div>
                    <div class="job-info">
                        <strong><i class="fas fa-money-bill-wave"></i> Mức lương:</strong>
                        <span>${saved.salaryRange}</span>
                    </div>
                    <div class="job-info">
                        <strong><i class="fas fa-briefcase"></i> Ngành nghề:</strong>
                        <span>${saved.industry}</span>
                    </div>
                    <div class="job-info">
                        <strong><i class="fas fa-calendar-alt"></i> Ngày đăng:</strong>
                        <span>${saved.postingDate}</span>
                    </div>
                    <div class="job-info">
                        <strong><i class="fas fa-heart"></i> Ngày lưu:</strong>
                        <span>${saved.formattedSavedDate}</span>
                    </div>
                    <div class="action-buttons">
                        <a href="job-detail?jobId=${saved.jobID}" class="action-btn">
                            <i class="fas fa-eye"></i> Xem chi tiết
                        </a>
                        <button class="action-btn unsave-btn" onclick="unsaveJob(${saved.jobID})">
                            <i class="fas fa-heart-broken"></i> Bỏ lưu
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>
        <!-- Pagination (JS) -->
        <div id="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:1.5rem; align-items:center;">
            <button id="prevPage" class="action-btn"><i class="fas fa-chevron-left"></i></button>
            <span id="pageInfo" style="color:#fff; min-width:48px; text-align:center;"></span>
            <button id="nextPage" class="action-btn"><i class="fas fa-chevron-right"></i></button>
        </div>
    </div>

    <!-- ========== JAVASCRIPT ========== -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- Simple JS Pagination for saved jobs ---
            const jobsList = document.getElementById('savedJobsList');
            const cards = Array.from(jobsList.querySelectorAll('.job-card'));
            const pageInfo = document.getElementById('pageInfo');
            const prevBtn = document.getElementById('prevPage');
            const nextBtn = document.getElementById('nextPage');
            const JOBS_PER_PAGE = 10;
            let currentPage = 1;
            const totalPages = Math.max(1, Math.ceil(cards.length / JOBS_PER_PAGE));

            function renderPage(page) {
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;
                currentPage = page;
                cards.forEach((card, idx) => {
                    card.style.display = (idx >= (currentPage-1)*JOBS_PER_PAGE && idx < currentPage*JOBS_PER_PAGE) ? '' : 'none';
                });
                pageInfo.textContent = currentPage + ' / ' + totalPages;
                prevBtn.disabled = (currentPage === 1);
                nextBtn.disabled = (currentPage === totalPages);
            }
            prevBtn.addEventListener('click', () => renderPage(currentPage-1));
            nextBtn.addEventListener('click', () => renderPage(currentPage+1));
            renderPage(1);

            // --- Mega menu toggle (giữ nguyên code cũ) ---
            const menuToggle = document.getElementById('menuToggle');
            const megaMenu = document.getElementById('megaMenu');
            menuToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                megaMenu.classList.toggle('open');
            });
            
            // Close mega menu when clicking outside
            document.addEventListener('click', function(event) {
                if (!menuToggle.contains(event.target) && !megaMenu.contains(event.target)) {
                    megaMenu.classList.remove('open');
                }
            });

            // Fade-in animation cho job cards
            const jobCards = document.querySelectorAll('.job-card');
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach((entry, index) => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }, index * 100);
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            jobCards.forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                observer.observe(card);
            });
        });

        // Function to unsave a job
        function unsaveJob(jobId) {
            if (!confirm('Bạn có chắc muốn bỏ lưu công việc này?')) {
                return;
            }

            fetch('${pageContext.request.contextPath}/saved-jobs', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=unsave&jobId=' + jobId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove the job card with animation
                    const jobCard = document.querySelector('[data-job-id="' + jobId + '"]');
                    if (jobCard) {
                        jobCard.style.transform = 'translateX(-100%)';
                        jobCard.style.opacity = '0';
                        setTimeout(() => {
                            jobCard.remove();
                            // Check if there are no more jobs
                            if (document.querySelectorAll('.job-card').length === 0) {
                                location.reload();
                            }
                        }, 500);
                    }
                    alert(data.message);
                } else {
                    alert(data.message || 'Có lỗi xảy ra khi bỏ lưu công việc');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra khi bỏ lưu công việc');
            });
        }
    </script>

</body>
</html>
