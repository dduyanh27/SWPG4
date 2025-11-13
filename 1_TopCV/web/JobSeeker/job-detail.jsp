<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VietnamWorks - Chi tiết việc làm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/price_rangs.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/JobSeeker/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const isLoggedIn = ${isLoggedIn};
    </script>
    <script>
    // Save Job on job-detail: sync behavior with job-list
    document.addEventListener('DOMContentLoaded', function () {
        const saveButtons = document.querySelectorAll('.save-btn[data-job-id]');

        saveButtons.forEach(btn => {
            const jobId = btn.getAttribute('data-job-id');
            checkIfSaved(jobId, btn);
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                toggleSaveJob(jobId, btn);
            });
        });

        function setSavedUI(btn, saved) {
            const icon = btn.querySelector('i');
            const textSpan = btn.querySelector('span');
            if (saved) {
                btn.classList.add('saved');
                if (icon) { icon.classList.remove('far'); icon.classList.add('fas'); }
                if (textSpan) { textSpan.textContent = 'Đã lưu'; }
                btn.title = 'Bỏ lưu công việc';
            } else {
                btn.classList.remove('saved');
                if (icon) { icon.classList.remove('fas'); icon.classList.add('far'); }
                if (textSpan) { textSpan.textContent = 'Chưa lưu'; }
                btn.title = 'Lưu công việc';
            }
        }

        function setSavedUIForAll(jobId, saved) {
            document.querySelectorAll('.save-btn[data-job-id="' + jobId + '"]').forEach(b => setSavedUI(b, saved));
        }

        function showNotification(message, isError) {
            const notification = document.createElement('div');
            notification.textContent = message;
            notification.style.cssText = 'position:fixed;top:80px;right:20px;'
                + (isError ? 'background:#ef4444;' : 'background:#10b981;')
                + 'color:#fff;padding:12px 24px;border-radius:8px;box-shadow:0 4px 12px rgba(0,0,0,0.15);z-index:9999;animation:slideIn 0.3s ease;';
            document.body.appendChild(notification);
            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }, 2000);
        }

        function parseJsonSafe(response) {
            const contentType = response.headers.get('content-type') || '';
            if (!contentType.includes('application/json')) {
                return Promise.resolve({ success: false, message: 'NOT_JSON', status: response.status });
            }
            return response.json().catch(() => ({ success: false, message: 'INVALID_JSON', status: response.status }));
        }

        function checkIfSaved(jobId, btn) {
            fetch(contextPath + '/saved-jobs', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'same-origin',
                body: 'action=check&jobId=' + encodeURIComponent(jobId)
            })
                .then(r => parseJsonSafe(r))
                .then(data => {
                    if (data.success && data.isSaved) {
                        setSavedUI(btn, true);
                    }
                })
                .catch(err => console.error('Error:', err));
        }

        function toggleSaveJob(jobId, btn, oneRetry) {
            if (btn.dataset.loading === '1') return; // chặn spam
            btn.dataset.loading = '1';
            // B1: hỏi trạng thái thật từ server
            fetch(contextPath + '/saved-jobs', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'same-origin',
                body: 'action=check&jobId=' + encodeURIComponent(jobId)
            })
            .then(r => parseJsonSafe(r))
            .then(checkData => {
                if (checkData && (checkData.status === 401 || checkData.message === 'NOT_JSON' || checkData.message === 'INVALID_JSON')) {
                    window.location.href = contextPath + '/JobSeeker/jobseeker-login.jsp';
                    return Promise.reject('AUTH');
                }
                const serverSaysSaved = !!(checkData && checkData.isSaved);
                const action = serverSaysSaved ? 'unsave' : 'save';
                // B2: gửi hành động ngược với trạng thái hiện tại để toggle
                return fetch(contextPath + '/saved-jobs', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'same-origin',
                body: 'action=' + action + '&jobId=' + encodeURIComponent(jobId)
                }).then(r => parseJsonSafe(r));
            })
            .then(data => {
                    if (data && data.success) {
                        const nextSaved = (typeof data.isSaved === 'boolean') ? data.isSaved : undefined;
                        if (typeof nextSaved === 'boolean') {
                            setSavedUIForAll(jobId, nextSaved);
                        } else {
                            // Nếu server không trả isSaved, hỏi lại để đồng bộ tuyệt đối
                            checkIfSaved(jobId, btn);
                        }
                        showNotification(data.message || (nextSaved ? 'Đã lưu công việc' : 'Đã bỏ lưu công việc'), false);
                    } else if (data && (data.status === 401 || data.message === 'NOT_JSON' || data.message === 'INVALID_JSON')) {
                        // Có thể bị redirect về trang login hoặc không đăng nhập
                        window.location.href = contextPath + '/JobSeeker/jobseeker-login.jsp';
                    } else {
                        const msg = (data && data.message ? String(data.message) : '').toLowerCase();
                        const alreadySaved = msg.includes('đã được lưu trước đó');
                        const alreadyUnsaved = msg.includes('đã được bỏ lưu trước đó') || msg.includes('chưa lưu trước đó');
                        // Với flow mới (check trước), các thông điệp này hiếm khi xảy ra, nhưng nếu có thì đồng bộ lại
                        // Thông báo lỗi nhẹ và đồng bộ lại UI theo server
                        showNotification(data && data.message ? data.message : 'Có lỗi xảy ra', true);
                        checkIfSaved(jobId, btn);
                    }
            })
            .catch(err => {
                    console.error('Error:', err);
                    showNotification('Có lỗi xảy ra khi lưu công việc', true);
                    checkIfSaved(jobId, btn);
            })
            .finally(() => {
                    delete btn.dataset.loading;
            });
        }
    });
    </script>
    <style>
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
<body data-logged-in="${isLoggedIn}">
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo-section">
                <a href="${pageContext.request.contextPath}/JobSeeker/index.jsp" class="logo">
                    <h1>Top</h1>
                    <span class="tagline">Empower growth</span>
                </a>
            </div>
            
            <div class="search-section">
                <div class="search-bar">
                    <input type="text" placeholder="Tìm kiếm việc làm, công ty">
                    <button class="search-btn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
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

    <div class="job-detail-container">
    <!-- Main Content -->
    <main class="job-detail-content">
            <!-- Job Header -->
            <div class="job-header">
                <div class="job-title-section">
                    <h1>${job.jobTitle}</h1>
                    <div class="job-meta">
                        <span class="salary">${job.salaryRange}</span>
                        <span class="expiry">Hết hạn: <fmt:formatDate value="${job.expirationDate}" pattern="dd/MM/yyyy"/></span>
                        <span class="views">${job.views != null ? job.views : 0} lượt xem</span>
                        <span class="location">${job.location.locationName}</span>
                        <div class="job-actions">
                            <c:choose>
                                <c:when test="${isLoggedIn}">
                                    <button class="apply-btn">Nộp đơn</button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/JobSeeker/jobseeker-login.jsp" class="apply-btn">Đăng nhập để ứng tuyển</a>
                                </c:otherwise>
                            </c:choose>
                            <button class="save-btn" data-job-id="${job.jobID}">
                                <i class="far fa-heart"></i>
                                <span>Chưa lưu</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Job Description Section -->
            <div class="job-description-section">
                <h2>Mô tả công việc</h2>
                <div class="job-description-content">
                    ${job.description}
                </div>
            </div>

            <!-- Job Requirements Section -->
            <div class="job-requirements-section">
                <h2>Yêu cầu công việc</h2>
                <div class="job-requirements-content">
                    ${job.requirements}
                </div>
<!--                <button class="view-full-description-btn">Xem đầy đủ mô tả công việc</button>-->
            </div>

            <!-- Benefits Section -->
            <div class="benefits-section">
                <h2>Các phúc lợi dành cho bạn</h2>
                <div class="benefits-grid">
                    <c:if test="${job.recruiter.companyBenefits != null}">
                        <c:forTokens var="benefit" items="${job.recruiter.companyBenefits}" delims="|">
                            <div class="benefit-item">
                                <div class="benefit-icon">
                                    <i class="fas fa-gift"></i>
                                </div>
                                <div class="benefit-content">
                                    <h3>Phúc lợi</h3>
                                    <p>${benefit}</p>
                                </div>
                            </div>
                        </c:forTokens>
                    </c:if>
                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div class="benefit-content">
                            <h3>Lương thưởng</h3>
                            <p>Mức lương: ${job.salaryRange}</p>
                        </div>
                    </div>
<!--                    <div class="benefit-item">
                        <div class="benefit-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="benefit-content">
                            <h3>Văn hóa công ty</h3>
                            <p>Môi trường làm việc chuyên nghiệp và thân thiện</p>
                        </div>
                    </div>-->
                </div>
            </div>

            <!-- Job Information Section -->
            <div class="job-info-section">
                <h2>Thông tin việc làm</h2>
                <div class="job-info-grid">
                    <div class="info-column">
                        <div class="info-item">
                            <i class="fas fa-calendar"></i>
                            <div class="info-content">
                                <span class="info-label">NGÀY ĐĂNG</span>
                                <span class="info-value"><fmt:formatDate value="${job.postingDate}" pattern="dd/MM/yyyy"/></span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-briefcase"></i>
                            <div class="info-content">
                                <span class="info-label">NGÀNH NGHỀ</span>
                                <span class="info-value">${job.category.categoryName}</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-th-large"></i>
                            <div class="info-content">
                                <span class="info-label">LOẠI CÔNG VIỆC</span>
                                <span class="info-value">${job.jobType.typeName}</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-user"></i>
                            <div class="info-content">
                                <span class="info-label">YÊU CẦU ĐỘ TUỔI</span>
                                <span class="info-value">${job.ageRequirement} tuổi trở lên</span>
                            </div>
                        </div>
                    </div>
                    <div class="info-column">
                        <div class="info-item">
                            <i class="fas fa-user-tie"></i>
                            <div class="info-content">
                                <span class="info-label">CẤP BẬC</span>
                                <span class="info-value">${job.jobLevel.typeName}</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-graduation-cap"></i>
                            <div class="info-content">
                                <span class="info-label">BẰNG CẤP</span>
                                <span class="info-value">${job.certificates.typeName}</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-users"></i>
                            <div class="info-content">
                                <span class="info-label">SỐ LƯỢNG TUYỂN</span>
                                <span class="info-value">${job.hiringCount} người</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <div class="info-content">
                                <span class="info-label">ĐỊA ĐIỂM</span>
                                <span class="info-value">${job.location.locationName}</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-building"></i>
                            <div class="info-content">
                                <span class="info-label">QUY MÔ CÔNG TY</span>
                                <span class="info-value">${job.recruiter.companySize != null ? job.recruiter.companySize : 'Không xác định'}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/company-profile?id=${job.recruiter.recruiterID}" class="view-more-link" style="display: inline-flex; align-items: center; gap: 6px;">
                    <i class="fas fa-building"></i> Xem thông tin công ty
                </a>
            </div>

            <!-- Work Location Section -->
            <div class="work-location-section">
                <h2>Địa điểm làm việc</h2>
                <div class="location-info">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>${job.recruiter.companyAddress != null ? job.recruiter.companyAddress : job.location.locationName}</span>
                </div>
            </div>

            <!-- Keywords Section -->
<!--            <div class="keywords-section">
                <h2>Từ khoá</h2>
                <div class="keywords-list">
                    <span class="keyword-tag">Kinh Doanh</span>
                    <span class="keyword-tag">Bán Hàng/Phát Triển Kinh Doanh</span>
                    <span class="keyword-tag">Bán lẻ/Bán sỉ</span>
                    <span class="keyword-tag">Chăm Sóc Khách Hàng</span>
                    <span class="keyword-tag">Lập Kế Hoạch Kinh Doanh</span>
                    <span class="keyword-tag">Phát Triển Thị Trường</span>
                    <span class="keyword-tag">Kinh Doanh Thực Phẩm</span>
                    <span class="keyword-tag">Thương Mại</span>
                    <span class="keyword-tag">Công Ty Cổ Phần Hóa Chất Thực Phẩm Châu Á</span>
                    <span class="keyword-tag">Hà Nội</span>
                </div>
            </div>-->
        </main>

<!-- Right Sidebar -->
        <aside class="job-detail-sidebar">
            <!-- Company Info -->
            <div class="company-card">
                <a href="${pageContext.request.contextPath}/company-profile?id=${job.recruiter.recruiterID}" style="text-decoration: none; color: inherit;">
                    <div class="company-logo">
                        <c:choose>
                            <c:when test="${not empty job.recruiter.companyLogoURL}">
                                <img src="${job.recruiter.companyLogoURL}" alt="${job.recruiter.companyName}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;">
                            </c:when>
                            <c:otherwise>
                                <div class="logo-placeholder">
                                    ${job.recruiter.companyName.substring(0, job.recruiter.companyName.length() >= 3 ? 3 : job.recruiter.companyName.length()).toUpperCase()}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </a>
                <div class="company-info">
                    <a href="${pageContext.request.contextPath}/company-profile?id=${job.recruiter.recruiterID}" style="text-decoration: none; color: inherit;">
                        <h3 style="transition: color 0.2s;" onmouseover="this.style.color='#0b5bd3'" onmouseout="this.style.color=''">${job.recruiter.companyName}</h3>
                    </a>
                    <p class="company-address">${job.location.locationName}</p>
                    <a href="#" class="view-map-link" id="viewMapLink">Xem bản đồ</a>
                    <div class="recruitment-contact">
                        <i class="fas fa-phone"></i>
                        <span>${job.recruiter.phone}</span>
                    </div>
                </div>
            </div>

            <!-- Similar Jobs -->
            <div class="similar-jobs">
                <h3>Việc làm tương tự</h3>
                <div class="job-listings">
                    <div class="job-card">
                        <div class="company-logo">
                            <div class="logo-placeholder">CHL</div>
                        </div>
                        <div class="job-info">
                            <h4>Chuyên Viên Thực T...</h4>
                            <p class="company">Công Ty Cổ Phần Chuỗi Th...</p>
                            <p class="salary">Thương lượng</p>
                            <p class="location">Hà Nội</p>
                        </div>
                    </div>

                    <div class="job-card">
                        <div class="company-logo">
                            <div class="logo-placeholder">HEINEKEN</div>
                        </div>
                        <div class="job-info">
                            <h4>[HEINEKEN Hà Nội]...</h4>
                            <p class="company">HEINEKEN Vietnam</p>
                            <p class="salary">Thương lượng</p>
                            <p class="location">Hà Nội</p>
                        </div>
                    </div>

                    <div class="job-card">
                        <div class="company-logo">
                            <div class="logo-placeholder">CapitalHouse</div>
                        </div>
                        <div class="job-info">
                            <h4>Kiến Trúc Sư Phát Tr...</h4>
                            <p class="company">Capital House Group</p>
                            <p class="salary">Thương lượng</p>
                            <p class="location">Hà Nội</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Same Company Jobs -->
            <div class="same-company-jobs">
                <h3>Việc làm cùng công ty</h3>
                <div class="job-card">
                    <div class="company-logo">
                        <div class="logo-placeholder">AFCHEM</div>
                    </div>
                    <div class="job-info">
                        <h4>Purchasing Officer (...</h4>
                        <p class="company">Công Ty Cổ Phần Hóa Chất...</p>
                        <p class="salary">10tr-20tr đ/tháng</p>
                        <p class="location">Hà Nội</p>
                    </div>
                </div>
            </div>
        </aside>
    </div>

    <!-- Sticky Footer -->
    <div class="sticky-footer">
        <div class="footer-content">
            <div class="footer-job-info">
                <div class="company-logo">
                    <div class="logo-placeholder">${job.recruiter.companyName.substring(0, job.recruiter.companyName.length() > 6 ? 6 : job.recruiter.companyName.length())}</div>
                </div>
                <div class="job-summary">
                    <h4>${job.jobTitle}</h4>
                    <div class="job-meta">
                        <span class="salary">${job.salaryRange}</span>
                        <span class="expiry">Hết hạn: <fmt:formatDate value="${job.expirationDate}" pattern="dd/MM/yyyy"/></span>
                        <span class="location">${job.location.locationName}</span>
                    </div>
                </div>
            </div>
            <div class="footer-actions">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <button class="apply-btn">Nộp đơn</button>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/JobSeeker/jobseeker-login.jsp" class="apply-btn">Đăng nhập để ứng tuyển</a>
                    </c:otherwise>
                </c:choose>
                <button class="save-btn" data-job-id="${job.jobID}">
                    <i class="far fa-heart"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Floating Action Buttons -->
    <div class="floating-actions">
        <div class="floating-btn zalo-btn">
            <i class="fab fa-facebook-messenger"></i>
        </div>
        <div class="floating-btn message-btn">
            <i class="fas fa-envelope"></i>
        </div>
        <div class="floating-btn chat-btn">
            <i class="fas fa-smile"></i>
        </div>
    </div>

    <!-- Job Application Modal -->
    <div class="application-modal" id="applicationModal">
        <div class="modal-overlay"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h2>Ứng tuyển công việc</h2>
                <button class="modal-close" id="modalClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="modal-body">
                <!-- Job Summary -->
                <div class="job-summary-card">
                    <div class="company-info">
                        <div class="company-logo">
                            <div class="logo-placeholder">${job.recruiter.companyName.substring(0, job.recruiter.companyName.length() > 6 ? 6 : job.recruiter.companyName.length())}</div>
                        </div>
                        <div class="company-details">
                            <h3>${job.recruiter.companyName}</h3>
                            <h4>${job.jobTitle}</h4>
                            <div class="job-meta">
                                <span class="salary">${job.salaryRange}</span>
                                <span class="location">${job.location.locationName}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Application Form -->
                <form id="applicationForm" enctype="multipart/form-data">
                    <input type="hidden" name="jobId" value="${job.jobID}"/>
                    <div class="application-form">
                        <div class="form-section">
                            <h3>Chọn CV để ứng tuyển</h3>
                            <c:choose>
                                <c:when test="${not empty cvList}">
                                    <div class="form-row">
                                        <div class="form-group full-width">
                                            <label>CV đã tải lên</label>
                                            <select name="cvId" id="cvSelect">
                                                <option value="">-- Chọn CV --</option>
                                                <c:forEach var="cv" items="${cvList}">
                                                    <option value="${cv.cvId}">${cv.cvTitle}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group full-width">
                                            <label>Hoặc tải lên CV mới</label>
                                            <input type="file" name="newCV" id="newCVFile" accept=".pdf,.doc,.docx">
                                            <small style="color: #666; font-size: 12px;">
                                                <i class="fas fa-info-circle"></i> 
                                                Nếu bạn chọn cả CV có sẵn và tải lên CV mới, hệ thống sẽ ưu tiên sử dụng CV mới.
                                            </small>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="form-row">
                                        <div class="form-group full-width">
                                            <label>Tải lên CV để ứng tuyển</label>
                                            <input type="file" name="newCV" id="newCVFile" accept=".pdf,.doc,.docx" required>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                    <div class="privacy-checkbox">
                        <label class="checkbox-label">
                            <input type="checkbox" id="privacyCheck" required>
                            <span class="checkmark"></span>
                            Tôi đồng ý với Quy định bảo mật của nhà tuyển dụng này. (*)
                        </label>
                    </div>
                    <button type="submit" class="apply-submit-btn" id="submitApplication">Ứng tuyển</button>
            </div>
        </div>
    </div>
    <!-- JS Files -->
    <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/JobSeeker/script.js"></script>
    
    <!-- View map: open Google Maps with work location -->
    <script>
    (function() {
        const workAddress = '${job.recruiter.companyAddress != null ? job.recruiter.companyAddress : job.location.locationName}';
        document.addEventListener('DOMContentLoaded', function () {
            var link = document.getElementById('viewMapLink');
            if (!link) return;
            var mapsUrl = 'https://www.google.com/maps/search/?api=1&query=' + encodeURIComponent(workAddress || '');
            // Set real href so user can copy/open in new tab
            link.setAttribute('href', mapsUrl);
            link.setAttribute('target', '_blank');
            link.setAttribute('rel', 'noopener');
            link.addEventListener('click', function (e) {
                // In case some browsers block without target
                e.preventDefault();
                window.open(mapsUrl, '_blank');
            });
        });
    })();
    </script>
    
    <!-- Mega menu JavaScript -->
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
</body>
</html>
