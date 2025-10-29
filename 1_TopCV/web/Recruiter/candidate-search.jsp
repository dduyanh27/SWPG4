<%-- 
    Document   : candidate-search
    Created on : Oct 15, 2025, 5:31:59 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm Kiếm Ứng Viên - RecruitPro</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Recruiter/styles.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Pagination Styles */
            .pagination-container {
                margin-top: 40px;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 15px;
                padding: 20px 0;
            }
            
            .pagination-info {
                color: #666;
                font-size: 14px;
                font-weight: 500;
                text-align: center;
            }
            
            .pagination {
                display: flex;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .pagination-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 14px;
                min-width: 40px;
                height: 40px;
                border: 1px solid #e1e5e9;
                border-radius: 8px;
                background: #fff;
                color: #374151;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.2s ease;
                cursor: pointer;
            }
            
            .pagination-btn:hover {
                background: #f8fafc;
                border-color: #3b82f6;
                color: #3b82f6;
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(59, 130, 246, 0.15);
            }
            
            .pagination-btn.active {
                background: #3b82f6;
                border-color: #3b82f6;
                color: #fff;
                box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
            }
            
            .pagination-btn.active:hover {
                background: #2563eb;
                border-color: #2563eb;
                transform: translateY(-1px);
            }
            
            .pagination-btn.prev-btn,
            .pagination-btn.next-btn {
                gap: 6px;
                font-weight: 600;
                padding: 10px 16px;
            }
            
            .pagination-dots {
                padding: 10px 6px;
                color: #9ca3af;
                font-weight: 500;
            }
            
            /* Responsive */
            @media (max-width: 768px) {
                .pagination-container {
                    margin-top: 30px;
                    padding: 15px 0;
                }
                
                .pagination {
                    gap: 6px;
                }
                
                .pagination-btn {
                    min-width: 36px;
                    height: 36px;
                    padding: 8px 12px;
                    font-size: 13px;
                }
                
                .pagination-btn.prev-btn,
                .pagination-btn.next-btn {
                    padding: 8px 14px;
                }
            }
        </style>
    </head>
    <body class="candidate-search-page">
        <!-- Top Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="index.html">Dashboard</a></li>
                        <li><a href="job-management.html">Việc Làm</a></li>
                        <li><a href="#" class="active">Ứng viên</a></li>
                        <li><a href="#">Onboarding</a></li>
                        <li><a href="#">Đơn hàng</a></li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="company-info.jsp">Công ty</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-buttons">
                        <div class="dropdown">
                            <button class="btn btn-orange">
                                Đăng Tuyển Dụng <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a href="job-posting.html">Tạo tin tuyển dụng mới</a>
                                <a href="job-management.html">Quản lý tin đã đăng</a>
                            </div>
                        </div>
                        <button class="btn btn-blue">Tìm Ứng Viên</button>
                        <button class="btn btn-white">Mua</button>
                    </div>
                    <div class="nav-icons">
                        <i class="fas fa-shopping-cart"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                            <div class="dropdown-content user-menu">
                                <div class="user-header">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-info">
                                        <div class="user-name">Nguyen Phuoc</div>
                                    </div>
                                    <i class="fas fa-times close-menu"></i>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Thành viên</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-users"></i>
                                        <span>Thành viên</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Thiết lập tài khoản</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Quản lý tài khoản</span>
                                    </a>
                                    <a href="#" class="menu-item highlighted">
                                        <i class="fas fa-building"></i>
                                        <span>Thông tin công ty</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-shield-alt"></i>
                                        <span>Quản lý quyền truy cập</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-tasks"></i>
                                        <span>Quản lý yêu cầu</span>
                                    </a>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-history"></i>
                                        <span>Lịch sử hoạt động</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Liên hệ mua</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-phone"></i>
                                        <span>Liên hệ mua</span>
                                    </a>
                                </div>

                                <div class="menu-section">
                                    <div class="section-title">Hỏi đáp</div>
                                    <a href="#" class="menu-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>Hỏi đáp</span>
                                    </a>
                                </div>

                                <div class="menu-footer">
                                    <a href="/LogoutServlet" class="logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Thoát</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="candidate-search-main">
            <div class="search-container">
                <!-- Search Section -->
                <div class="search-section">
                    <div class="search-header">
                        <div class="search-input-group">
                            <form method="get" action="${pageContext.request.contextPath}/candidate-search" style="display:flex;gap:8px;width:100%">
                                <input type="text" name="q" class="search-input" placeholder="Tìm kiếm" value="${q}">
                                <select class="search-category">
                                    <option>Tất cả</option>
                                    <option>Ứng viên</option>
                                    <option>Việc làm</option>
                                    <option>Công ty</option>
                                </select>
                                <button class="btn btn-filter" type="button">Bộ lọc</button>
                                <button class="btn btn-search" type="submit">Tìm kiếm</button>
                            </form>
                        </div>
                    </div>

                    <!-- Saved Searches -->
                    <div class="saved-searches">
                        <div class="saved-searches-header">
                            <span class="saved-searches-label">Lưu Tìm Kiếm</span>
                            <i class="fas fa-chevron-left"></i>
                        </div>
                        <div class="search-tags">
                            <span class="search-tag">System Integration Engineer</span>
                            <span class="search-tag">Trường Nhóm Marketing</span>
                            <span class="search-tag">"typescript" AND "backend"</span>
                            <span class="search-tag">Quản Lý Khách Hàng</span>
                            <span class="search-tag">"AI" AND "Pytorch"</span>
                            <span class="search-tag">flutter</span>
                            <i class="fas fa-chevron-right"></i>
                        </div>
                    </div>
                </div>

                <!-- Results Section -->
                <div class="results-section">
                    <div class="results-content">
                        <div class="results-header">
                            <div class="results-count">
                                <c:choose>
                                    <c:when test="${not empty total}">
                                        <span class="count-badge">${total} kết quả tìm kiếm</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="count-badge">Kết quả</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="view-controls">
                                <button class="view-btn active" data-view="list">
                                    <i class="fas fa-list"></i>
                                </button>
                                <button class="view-btn" data-view="grid">
                                    <i class="fas fa-th"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Active Seeking Explanation -->
                        <div class="active-seeking-explanation">
                            <div class="explanation-content">
                                <span class="active-seeking-tag">Active Seeking</span>
                                <span class="explanation-text">Hồ sơ có nhãn "Active Seeking" thể hiện ứng viên đang tích cực tìm việc gần đây</span>
                            </div>
                        </div>

                        <!-- Candidate List -->
                        <div class="candidate-list">
                            <c:choose>
                                <c:when test="${empty candidates}">
                                    <div class="candidate-card">
                                        <div class="candidate-info">
                                            <div class="candidate-name">Không có ứng viên phù hợp</div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${candidates}">
                                        <div class="candidate-card">
                                            <div class="candidate-avatar">
                                                <div class="avatar-placeholder">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                            </div>
                                            <div class="candidate-info">
                                                <div class="candidate-name">${c.fullName}</div>
                                                <div class="candidate-title">${c.headline}</div>
                                                <div class="candidate-details">
                                                    <div class="detail-item"><span class="location">${c.address}</span></div>
                                                </div>
                                            </div>
                                            <div class="candidate-actions">
                                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/candidate-profile?id=${c.jobSeekerId}">Hồ sơ chi tiết</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Pagination Controls -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    <span>Trang ${page} / ${totalPages} (${total} kết quả)</span>
                                </div>
                                
                                <div class="pagination">
                                    <!-- Previous Button -->
                                    <c:if test="${page > 1}">
                                        <a href="${pageContext.request.contextPath}/candidate-search?page=${page-1}&q=${q}&locationId=${locationId}&levelId=${levelId}&gender=${gender}&fullName=${fullName}&address=${address}&title=${title}" 
                                           class="pagination-btn prev-btn">
                                            <i class="fas fa-chevron-left"></i> Trước
                                        </a>
                                    </c:if>
                                    
                                    <!-- Page Numbers -->
                                    <c:set var="startPage" value="${page - 2 > 1 ? page - 2 : 1}" />
                                    <c:set var="endPage" value="${page + 2 < totalPages ? page + 2 : totalPages}" />
                                    
                                    <c:if test="${startPage > 1}">
                                        <a href="${pageContext.request.contextPath}/candidate-search?page=1&q=${q}&locationId=${locationId}&levelId=${levelId}&gender=${gender}&fullName=${fullName}&address=${address}&title=${title}" 
                                           class="pagination-btn">1</a>
                                        <c:if test="${startPage > 2}">
                                            <span class="pagination-dots">...</span>
                                        </c:if>
                                    </c:if>
                                    
                                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                        <a href="${pageContext.request.contextPath}/candidate-search?page=${i}&q=${q}&locationId=${locationId}&levelId=${levelId}&gender=${gender}&fullName=${fullName}&address=${address}&title=${title}" 
                                           class="pagination-btn ${i == page ? 'active' : ''}">${i}</a>
                                    </c:forEach>
                                    
                                    <c:if test="${endPage < totalPages}">
                                        <c:if test="${endPage < totalPages - 1}">
                                            <span class="pagination-dots">...</span>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/candidate-search?page=${totalPages}&q=${q}&locationId=${locationId}&levelId=${levelId}&gender=${gender}&fullName=${fullName}&address=${address}&title=${title}" 
                                           class="pagination-btn">${totalPages}</a>
                                    </c:if>
                                    
                                    <!-- Next Button -->
                                    <c:if test="${page < totalPages}">
                                        <a href="${pageContext.request.contextPath}/candidate-search?page=${page+1}&q=${q}&locationId=${locationId}&levelId=${levelId}&gender=${gender}&fullName=${fullName}&address=${address}&title=${title}" 
                                           class="pagination-btn next-btn">
                                            Sau <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>

        <!-- Filter Modal -->
        <div id="filterModal" class="filter-modal">
            <div class="filter-modal-content">
                <div class="filter-header">
                    <h2>Bộ lọc</h2>
                    <button class="close-filter" id="closeFilter">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/candidate-search" id="filterForm">
                    <div class="filter-body">
                    <!-- General Filters -->
                    <div class="filter-section">
                        <div class="filter-checkbox">
                            <input type="checkbox" id="filterByJob">
                            <label for="filterByJob">Lọc theo công việc đang đăng tuyển</label>
                        </div>
                        <div class="filter-input">
                            <input type="text" placeholder="Chọn công việc" class="job-select">
                        </div>
                    </div>

                    <!-- Last Updated Section -->
                    <div class="filter-section">
                        <h3>Lần cuối cập nhật hồ sơ</h3>
                        <div class="filter-tabs">
                            <button class="filter-tab active" data-value="any">Bất kỳ</button>
                            <button class="filter-tab" data-value="today">Hôm nay</button>
                            <button class="filter-tab" data-value="yesterday">Hôm qua</button>
                            <button class="filter-tab" data-value="3days">3 Ngày trước</button>
                            <button class="filter-tab" data-value="1week">1 Tuần</button>
                            <button class="filter-tab" data-value="2weeks">2 Tuần</button>
                            <button class="filter-tab" data-value="1month">1 Tháng</button>
                            <button class="filter-tab" data-value="2months">2 Tháng</button>
                            <button class="filter-tab" data-value="6months">6 Tháng</button>
                            <button class="filter-tab" data-value="12months">12 Tháng</button>
                        </div>
                    </div>

                    <!-- Desired Job Section -->
                    <div class="filter-section">
                        <h3>Công việc mong muốn</h3>
                        <div class="filter-grid">
                            <div class="filter-item">
                                <label>Nơi làm việc</label>
                                <select name="locationId">
                                    <option value="">Chọn địa điểm...</option>
                                    <option value="1" ${locationId == 1 ? 'selected' : ''}>Hà Nội</option>
                                    <option value="2" ${locationId == 2 ? 'selected' : ''}>Hồ Chí Minh</option>
                                    <option value="3" ${locationId == 3 ? 'selected' : ''}>Đà Nẵng</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Lĩnh vực</label>
                                <select>
                                    <option>Chọn lĩnh vực</option>
                                    <option>Công nghệ thông tin</option>
                                    <option>Kinh doanh</option>
                                    <option>Marketing</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Mức lương</label>
                                <div class="salary-range">
                                    <input type="number" placeholder="Từ">
                                    <span>-</span>
                                    <input type="number" placeholder="Đến">
                                    <select class="currency">
                                        <option>USD</option>
                                        <option>VND</option>
                                    </select>
                                </div>
                            </div>
                            <div class="filter-item">
                                <label>Cấp bậc</label>
                                <select name="levelId">
                                    <option value="">Bất kỳ</option>
                                    <option value="1" ${levelId == 1 ? 'selected' : ''}>Intern</option>
                                    <option value="2" ${levelId == 2 ? 'selected' : ''}>Junior</option>
                                    <option value="3" ${levelId == 3 ? 'selected' : ''}>Senior</option>
                                    <option value="4" ${levelId == 4 ? 'selected' : ''}>Manager</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Ngành nghề/Trình độ</label>
                                <input type="text" name="title" placeholder="Nhập trình độ/chức vụ" value="${title}">
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information Section -->
                    <div class="filter-section">
                        <h3>Thông tin cơ bản</h3>
                        <div class="filter-grid">
                            <div class="filter-item">
                                <label>Ngoại ngữ</label>
                                <select>
                                    <option>Bất kỳ</option>
                                    <option>Tiếng Anh</option>
                                    <option>Tiếng Nhật</option>
                                    <option>Tiếng Hàn</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Trình độ ngoại ngữ</label>
                                <select>
                                    <option>Bất kỳ</option>
                                    <option>Cơ bản</option>
                                    <option>Trung bình</option>
                                    <option>Nâng cao</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Trình độ học vấn</label>
                                <select>
                                    <option>Bất kỳ</option>
                                    <option>Trung cấp</option>
                                    <option>Cao đẳng</option>
                                    <option>Đại học</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Số năm kinh nghiệm tối thiểu</label>
                                <div class="experience-counter">
                                    <button class="counter-btn minus">-</button>
                                    <input type="number" value="0" min="0">
                                    <button class="counter-btn plus">+</button>
                                </div>
                            </div>
                            <div class="filter-item">
                                <label>Tên ứng viên</label>
                                <input type="text" name="fullName" placeholder="Nhập tên ứng viên" value="${fullName}">
                            </div>
                            <div class="filter-item">
                                <label>Địa chỉ</label>
                                <input type="text" name="address" placeholder="Nhập địa chỉ" value="${address}">
                            </div>
                            <div class="filter-item">
                                <label>Giới tính</label>
                                <div class="radio-group">
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="" ${empty gender ? 'checked' : ''}>
                                        <span>Bất kỳ</span>
                                    </label>
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="Male" ${gender == 'Male' ? 'checked' : ''}>
                                        <span>Nam</span>
                                    </label>
                                    <label class="radio-item">
                                        <input type="radio" name="gender" value="Female" ${gender == 'Female' ? 'checked' : ''}>
                                        <span>Nữ</span>
                                    </label>
                                </div>
                            </div>
                            <div class="filter-item">
                                <label>Quốc tịch</label>
                                <select>
                                    <option>Bất kỳ</option>
                                    <option>Việt Nam</option>
                                    <option>Hàn Quốc</option>
                                    <option>Nhật Bản</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Tuổi</label>
                                <div class="age-range">
                                    <input type="number" placeholder="Từ" min="18" max="65">
                                    <span>-</span>
                                    <input type="number" placeholder="Đến" min="18" max="65">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                    <div class="filter-footer">
                        <button class="btn btn-save-search" type="button">Lưu tìm kiếm</button>
                        <button class="btn btn-reset" type="button" onclick="resetFilterForm()">Cài đặt lại</button>
                        <button class="btn btn-search-filter" type="submit">Tìm kiếm</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/Recruiter/script.js"></script>
        <script>
            // Filter form functionality
            function resetFilterForm() {
                document.getElementById('filterForm').reset();
                // Reset radio buttons to default
                document.querySelector('input[name="gender"][value=""]').checked = true;
            }
            
            // Close filter modal when clicking outside
            document.getElementById('filterModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    this.style.display = 'none';
                }
            });
            
            // Close filter modal when clicking close button
            document.getElementById('closeFilter').addEventListener('click', function() {
                document.getElementById('filterModal').style.display = 'none';
            });
            
            // Open filter modal when clicking filter button
            document.querySelector('.btn-filter').addEventListener('click', function() {
                document.getElementById('filterModal').style.display = 'flex';
            });
        </script>
    </body>
</html>

