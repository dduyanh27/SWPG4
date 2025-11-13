<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dal.AdminDAO, dal.ApplicationDAO, dal.RecruiterDAO, dal.JobSeekerDAO, java.util.List, model.Admin, model.Application, model.Recruiter, model.JobSeeker, model.Role" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.AdminJobDAO" %>
<%@ page import="model.Job" %>
<%@ page import="model.AdminJobDetail" %>

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
    
    // Only load data if not already loaded by controller
    if (request.getAttribute("jobList") == null) {
        AdminJobDAO ajd = new AdminJobDAO();
        List<Job> jobList = ajd.getAllJobs();
        request.setAttribute("jobList", jobList);
        List<Job> publishedJobs = ajd.getJobsByStatus("Published");
        request.setAttribute("publishedJobs", publishedJobs);
        
        AdminJobDAO dao = new AdminJobDAO();
        List<AdminJobDetail> jobDetails = dao.getAllDetailJob();
        request.setAttribute("jobDetails", jobDetails);
    }
    
    ApplicationDAO appDAO = new ApplicationDAO();
    List<Application> appList = appDAO.getAllApplications();
    int totalApplications = appList.size();
    request.setAttribute("totalApplications",totalApplications);

%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Jobs Admin - Quản lý tin tuyển dụng</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Admin/ad-jobpos.css">
    </head>
    <body>
        <button class="mobile-menu-toggle" onclick="toggleSidebar()" style="display: none;">
            ☰
        </button>

        <div class="container">
            <div class="unified-sidebar" id="unifiedSidebar">
                <div class="sidebar-brand">
                    <h1 class="brand-title">JOBs</h1>
                    <p class="brand-subtitle">Admin Dashboard</p>
                </div>

                <div class="sidebar-profile">
                    <div class="sidebar-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.admin.avatarUrl}">
                                <img src="${pageContext.request.contextPath}/assets/img/admin/${sessionScope.admin.avatarUrl}" alt="Avatar">
                            </c:when>
                            <c:otherwise>
                                <div class="sidebar-avatar-placeholder">${fn:substring(sessionScope.admin.fullName, 0, 1)}</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-admin-name">${sessionScope.admin.fullName}</div>
                    <div class="sidebar-admin-role">🛡️ Quản trị viên</div>
                    <span class="sidebar-status">Hoạt động</span>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-title">Menu chính</div>
                    <a href="${pageContext.request.contextPath}/Admin/admin-dashboard.jsp" class="nav-item">📊 Bảng thống kê</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-jobposting-management.jsp" class="nav-item active">💼 Tin tuyển dụng</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-manage-account.jsp" class="nav-item">👥 Quản lý tài khoản</a>
                    <a href="${pageContext.request.contextPath}/Admin/admin-cv-management.jsp" class="nav-item">📁 Quản lý CV</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-staff.jsp" class="nav-item">🏢  Quản lý nhân sự</a>
                    <a href="${pageContext.request.contextPath}/Admin/ad-payment.jsp" class="nav-item">💳 Quản lý thanh toán</a>
                </nav>

                <div class="sidebar-actions">
                    <a href="${pageContext.request.contextPath}/Admin/admin-profile.jsp" class="action-btn">👤 Hồ sơ cá nhân</a>
                    <a href="#" class="action-btn logout">🚪 Đăng xuất</a>
                </div>
            </div>

            <div class="main">
                <header class="topbar">
                    <div class="title">Quản lý công việc</div>
                </header>

                <main class="content">
                    <!-- Thống kê -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">💼</div>
                                <div class="stat-trend trend-up">↗️ +12%</div>
                            </div>
                            <div class="stat-value">${fn:length(jobList)}</div>
                            <div class="stat-label">Tổng tin tuyển dụng</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">✅</div>
                                <div class="stat-trend trend-up">↗️ +8%</div>
                            </div>
                            <div class="stat-value">${fn:length(publishedJobs)}</div>
                            <div class="stat-label">Đã duyệt</div>
                        </div>


                        <div class="stat-card">
                            <div class="stat-header">
                                <div class="stat-icon">📊</div>
                                <div class="stat-trend trend-up">↗️ +23%</div>
                            </div>
                            <div class="stat-value">${totalApplications}</div>
                            <div class="stat-label">Lượt ứng tuyển</div>
                        </div>
                    </div>

                    <!-- Bộ lọc -->
                    <div class="controls-section">
                        <div class="controls-header">
                            <div class="section-title">🔍 Tìm kiếm & Bộ lọc</div>
                            <div class="filter-actions">
                                <button type="button" class="btn btn-ghost btn-sm" onclick="resetFilters()">↺ Đặt lại</button>
                                <button type="button" class="btn btn-ghost btn-sm" onclick="toggleFilterCollapse()">
                                    <span id="filterToggleText">Thu gọn</span> <span id="filterToggleIcon">▲</span>
                                </button>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/adminjobfilter" method="post" id="filterForm" class="filters-container">
                            <div class="filters-row">
                                <div class="filter-group filter-search">
                                    <label class="filter-label">🔍 Tìm kiếm</label>
                                    <input type="text" class="filter-input" name="search"
                                           placeholder="Tên công việc, công ty..."
                                           value="${search != null ? search : ''}">
                                </div>
                                
                                <div class="filter-group">
                                    <label class="filter-label">📍 Địa điểm</label>
                                    <select class="filter-input" name="location">
                                        <option value="" ${empty location ? "selected" : ""}>Tất cả địa điểm</option>
                                        <option value="hanoi" ${location eq 'hanoi' ? "selected" : ""}>Hà Nội</option>
                                        <option value="hcm" ${location eq 'hcm' ? "selected" : ""}>TP. Hồ Chí Minh</option>
                                        <option value="danang" ${location eq 'danang' ? "selected" : ""}>Đà Nẵng</option>
                                        <option value="other" ${location eq 'other' ? "selected" : ""}>Khác</option>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">💼 Loại hình</label>
                                    <select class="filter-input" name="type">
                                        <option value="" ${empty type ? "selected" : ""}>Tất cả loại hình</option>
                                        <option value="fulltime" ${type eq 'fulltime' ? "selected" : ""}>Toàn thời gian</option>
                                        <option value="parttime" ${type eq 'parttime' ? "selected" : ""}>Bán thời gian</option>
                                        <option value="contract" ${type eq 'contract' ? "selected" : ""}>Hợp đồng</option>
                                        <option value="internship" ${type eq 'internship' ? "selected" : ""}>Thực tập</option>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">📊 Trạng thái</label>
                                    <select class="filter-input" name="status">
                                        <option value="" ${empty status ? "selected" : ""}>Tất cả trạng thái</option>
                                        <option value="Published" ${status eq 'Published' ? "selected" : ""}>Đã xuất bản</option>
                                        <option value="Closed" ${status eq 'Closed' ? "selected" : ""}>Đã đóng</option>
                                        <option value="Draft" ${status eq 'Draft' ? "selected" : ""}>Bản nháp</option>
                                    </select>
                                </div>
                            </div>

                            <div class="filters-row filters-row-collapsible" id="collapsibleFilters">
                                <div class="filter-group">
                                    <label class="filter-label">📂 Danh mục</label>
                                    <select class="filter-input" name="category">
                                        <option value="" ${empty category ? "selected" : ""}>Tất cả danh mục</option>
                                        <option value="it" ${category eq 'it' ? "selected" : ""}>Công nghệ thông tin</option>
                                        <option value="marketing" ${category eq 'marketing' ? "selected" : ""}>Marketing</option>
                                        <option value="sales" ${category eq 'sales' ? "selected" : ""}>Kinh doanh</option>
                                        <option value="hr" ${category eq 'hr' ? "selected" : ""}>Nhân sự</option>
                                        <option value="finance" ${category eq 'finance' ? "selected" : ""}>Tài chính</option>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">💰 Mức lương</label>
                                    <select class="filter-input" name="salary">
                                        <option value="" ${empty salary ? "selected" : ""}>Tất cả mức lương</option>
                                        <option value="0-10" ${salary eq '0-10' ? "selected" : ""}>Dưới 10 triệu</option>
                                        <option value="10-20" ${salary eq '10-20' ? "selected" : ""}>10-20 triệu</option>
                                        <option value="20-30" ${salary eq '20-30' ? "selected" : ""}>20-30 triệu</option>
                                        <option value="30+" ${salary eq '30+' ? "selected" : ""}>Trên 30 triệu</option>
                                    </select>
                                </div>

                                <div class="filter-group filter-actions-group">
                                    <label class="filter-label">&nbsp;</label>
                                    <div class="filter-buttons">
                                        <button type="submit" class="btn btn-primary">🔍 Lọc</button>
                                        <button type="button" class="btn btn-ghost" onclick="resetFilters()">↺ Đặt lại</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Bảng danh sách công việc -->
                    <div class="data-table-container">
                        <div class="table-header">
                            <div class="table-title">📋 Danh sách công việc</div>
                            <div class="table-actions">
                                <a class="btn btn-ghost btn-sm" href="adminjobfilter">📋 Tất cả</a>
                            </div>
                        </div>

                        <div class="table-wrapper">
                            <table id="jobsTable">
                                <thead>
                                    <tr>
                                        <th><input type="checkbox" id="selectAll"></th>
                                        <th>Công việc</th>
                                        <th>Công ty</th>
                                        <th>Danh mục</th>
                                        <th>Mức lương</th>
                                        <th>Địa điểm</th>
                                        <th>Ứng viên</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="jobsTableBody">
                                    <c:choose>
                                        <c:when test="${empty jobDetails}">
                                            <tr>
                                                <td colspan="10" style="text-align: center; padding: 20px;">
                                                    <div style="color: #666;">Không có dữ liệu công việc phù hợp.</div>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="jobDetail" items="${jobDetails}">
                                                <tr>
                                                    <td><input type="checkbox" class="row-select" value="${jobDetail.jobId}"></td>
                                                    <td>
                                                        <div class="job-info">
                                                            <div class="job-title">${jobDetail.jobTitle}</div>
                                                            <div class="job-meta">${jobDetail.requirements}</div>
                                                        </div>
                                                    </td>
                                                    <td>${jobDetail.recruiterName}</td>
                                                    <td>${jobDetail.categoryName}</td>
                                                    <td>${jobDetail.salaryRange}</td>
                                                    <td>${jobDetail.locationName}</td>
                                                    <td>-</td>
                                                    <td>${jobDetail.status}</td>
                                                    <td>-</td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <form action="${pageContext.request.contextPath}/adminviewjob" method="get" style="display:inline-block;">
                                                                <input type="hidden" name="jobId" value="${jobDetail.jobId}">
                                                                <button type="submit" class="btn btn-ghost btn-sm">👁️</button>
                                                            </form>
                                                            <button class="btn btn-danger btn-sm" onclick="deleteJob('${jobDetail.jobId}')">🗑️</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <form id="deleteJobForm" action="${pageContext.request.contextPath}/adminclosejobpost" method="post" style="display:none;">
                        <input type="hidden" name="jobId" id="deleteJobId">
                    </form>
                </main>
            </div>

        </div>

        <!-- Job Detail Modal -->
        <div id="jobDetailModal" class="modal-overlay" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title">📋 Chi tiết tin tuyển dụng</div>
                    <button class="modal-close" onclick="closeModal('jobDetailModal')">&times;</button>
                </div>
                <div id="jobDetailContent">
                    <!-- Job details will be loaded here -->
                </div>
            </div>
        </div>

        <!-- Create/Edit Job Modal -->
        <div id="createJobModal" class="modal-overlay" style="display: none;">
            <div class="modal-content" style="max-width: 1000px;">
                <div class="modal-header">
                    <div class="modal-title">➕ Tạo tin tuyển dụng mới</div>
                    <button class="modal-close" onclick="closeModal('createJobModal')">&times;</button>
                </div>
                <div id="createJobForm">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                        <div class="filter-group">
                            <label class="filter-label">Tiêu đề công việc *</label>
                            <input type="text" class="filter-input" placeholder="VD: Senior Frontend Developer">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Công ty *</label>
                            <select class="filter-input">
                                <option>Chọn công ty</option>
                                <option>TechGlobal Solutions</option>
                                <option>Digital Marketing Pro</option>
                                <option>StartupTech Vietnam</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Danh mục *</label>
                            <select class="filter-input">
                                <option>Chọn danh mục</option>
                                <option>Công nghệ thông tin</option>
                                <option>Marketing</option>
                                <option>Thiết kế</option>
                                <option>Dữ liệu</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Loại hình *</label>
                            <select class="filter-input">
                                <option>Toàn thời gian</option>
                                <option>Bán thời gian</option>
                                <option>Hợp đồng</option>
                                <option>Thực tập</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Mức lương tối thiểu (VND)</label>
                            <input type="number" class="filter-input" placeholder="15000000">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Mức lương tối đa (VND)</label>
                            <input type="number" class="filter-input" placeholder="25000000">
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Địa điểm *</label>
                            <select class="filter-input">
                                <option>Hà Nội</option>
                                <option>TP. Hồ Chí Minh</option>
                                <option>Đà Nẵng</option>
                                <option>Khác</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Kinh nghiệm yêu cầu</label>
                            <select class="filter-input">
                                <option>Chưa có kinh nghiệm</option>
                                <option>Dưới 1 năm</option>
                                <option>1-2 năm</option>
                                <option>3-5 năm</option>
                                <option>Trên 5 năm</option>
                            </select>
                        </div>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Mô tả công việc *</label>
                        <textarea class="filter-input" rows="5" placeholder="Mô tả chi tiết về công việc, trách nhiệm, yêu cầu..."></textarea>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Yêu cầu ứng viên</label>
                        <textarea class="filter-input" rows="4" placeholder="Các yêu cầu về kỹ năng, trình độ, kinh nghiệm..."></textarea>
                    </div>

                    <div class="filter-group" style="margin-bottom: 20px;">
                        <label class="filter-label">Quyền lợi</label>
                        <textarea class="filter-input" rows="3" placeholder="Các quyền lợi, phúc lợi cho ứng viên..."></textarea>
                    </div>

                    <div style="display: flex; gap: 10px; justify-content: flex-end;">
                        <button class="btn btn-ghost" onclick="closeModal('createJobModal')">Hủy</button>
                        <button class="btn btn-primary">Lưu nháp</button>
                        <button class="btn btn-success">Đăng ngay</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script>
        (function () {
            var selectAll = document.getElementById('selectAll');
            if (selectAll) {
                selectAll.addEventListener('change', function () {
                    var checks = document.querySelectorAll('.row-select');
                    for (var i = 0; i < checks.length; i++) {
                        checks[i].checked = this.checked;
                    }
                });
            }
        })();


        function deleteJob(jobId) {
            if (!jobId)
                return;
            var confirmMsg = 'Bạn có chắc chắn muốn xóa/đóng tin tuyển dụng này?';
            if (!confirm(confirmMsg))
                return;
            var input = document.getElementById('deleteJobId');
            if (!input)
                return;
            input.value = jobId;
            var form = document.getElementById('deleteJobForm');
            if (form)
                form.submit();
        }



        function resetFilters() {
            document.querySelectorAll('input[name="search"], select').forEach(el => el.value = '');
            // Submit form để reset
            document.getElementById('filterForm').submit();
        }

        // Auto-submit form when filter values change
        document.addEventListener('DOMContentLoaded', function() {
            const filterInputs = document.querySelectorAll('#filterForm input, #filterForm select');
            filterInputs.forEach(input => {
                input.addEventListener('change', function() {
                    // Auto-submit form when filter changes
                    document.getElementById('filterForm').submit();
                });
            });
        });

        function toggleFilterCollapse() {
            const collapsibleFilters = document.getElementById('collapsibleFilters');
            const toggleText = document.getElementById('filterToggleText');
            const toggleIcon = document.getElementById('filterToggleIcon');
            
            if (collapsibleFilters.style.display === 'none') {
                collapsibleFilters.style.display = 'flex';
                toggleText.textContent = 'Thu gọn';
                toggleIcon.textContent = '▲';
            } else {
                collapsibleFilters.style.display = 'none';
                toggleText.textContent = 'Mở rộng';
                toggleIcon.textContent = '▼';
            }
        }
    </script>
</html>
